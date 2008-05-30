// rexx.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef RAGEL_REXX_PARSER
#define RAGEL_REXX_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *REXX_LANG = "rexx";

// the languages entities
const char *rexx_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  REXX_SPACE = 0, REXX_COMMENT, REXX_STRING, REXX_ANY
};

/*****************************************************************************/

%%{
  machine rexx;
  write data;
  include common "common.rl";

  # Line counting machine

  action rexx_ccallback {
    switch(entity) {
    case REXX_SPACE:
      ls
      break;
    case REXX_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(REXX_LANG)
      break;
    case NEWLINE:
      std_newline(REXX_LANG)
    }
  }

  rexx_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %rexx_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';

  rexx_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  rexx_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  rexx_string = rexx_sq_str | rexx_dq_str;

  rexx_line := |*
    spaces        ${ entity = REXX_SPACE; } => rexx_ccallback;
    rexx_comment;
    rexx_string;
    newline       ${ entity = NEWLINE;    } => rexx_ccallback;
    ^space        ${ entity = REXX_ANY;   } => rexx_ccallback;
  *|;

  # Entity machine

  action rexx_ecallback {
    callback(REXX_LANG, rexx_entities[entity], cint(ts), cint(te));
  }

  rexx_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Pike code.
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
void parse_rexx(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  init

  %% write init;
  cs = (count) ? rexx_en_rexx_line : rexx_en_rexx_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(REXX_LANG) }
}

#endif

/*****************************************************************************/
