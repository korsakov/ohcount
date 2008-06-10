// tcl.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef RAGEL_TCL_PARSER
#define RAGEL_TCL_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *TCL_LANG = "tcl";

// the languages entities
const char *tcl_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  TCL_SPACE = 0, TCL_COMMENT, TCL_STRING, TCL_ANY
};

/*****************************************************************************/

%%{
  machine tcl;
  write data;
  include common "common.rl";

  # Line counting machine

  action tcl_ccallback {
    switch(entity) {
    case TCL_SPACE:
      ls
      break;
    case TCL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(TCL_LANG)
      break;
    case NEWLINE:
      std_newline(TCL_LANG)
    }
  }

  tcl_comment =
    '#' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %tcl_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;

  tcl_string =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %tcl_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';

  tcl_line := |*
    spaces       ${ entity = TCL_SPACE; } => tcl_ccallback;
    tcl_comment;
    tcl_string;
    newline      ${ entity = NEWLINE;   } => tcl_ccallback;
    ^space       ${ entity = TCL_ANY;   } => tcl_ccallback;
  *|;

  # Entity machine

  action tcl_ecallback {
    callback(TCL_LANG, tcl_entities[entity], cint(ts), cint(te));
  }

  tcl_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Tcl code.
 *
 * @param *buffer The string to parse.
 * @param length The length of the string to parse.
 * @param count Integer flag specifying whether or not to count lines. If yes,
 *   uses the Ragel machine optimized for counting. Otherwise uses the Ragel
 *   machine optimized for returning entity positions.
 * @param *callback Callback function. If count is set, callback is called for
 *   every line of code, comment, or blank with 'lcode', 'lcomment', and
 *   'lblank' respectively. Otherwise callback is called for each entity found.
 */
void parse_tcl(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  init

  %% write init;
  cs = (count) ? tcl_en_tcl_line : tcl_en_tcl_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(TCL_LANG) }
}

#endif

/*****************************************************************************/
