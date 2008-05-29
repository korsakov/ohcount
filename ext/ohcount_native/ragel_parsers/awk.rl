// awk.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef RAGEL_AWK_PARSER
#define RAGEL_AWK_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *AWK_LANG = "awk";

// the languages entities
const char *awk_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  AWK_SPACE = 0, AWK_COMMENT, AWK_STRING, AWK_ANY
};

/*****************************************************************************/

%%{
  machine awk;
  write data;
  include common "common.rl";

  # Line counting machine

  action awk_ccallback {
    switch(entity) {
    case AWK_SPACE:
      ls
      break;
    case AWK_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(AWK_LANG)
      break;
    case NEWLINE:
      std_newline(AWK_LANG)
    }
  }

  awk_comment = '#' @comment nonnewline*;

  awk_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  awk_regex = '/' @code ([^\r\n\f/\\] | '\\' nonnewline)* '/';
  awk_string = awk_dq_str | awk_regex;

  awk_line := |*
    spaces       ${ entity = AWK_SPACE; } => awk_ccallback;
    awk_comment;
    awk_string;
    newline      ${ entity = NEWLINE;   } => awk_ccallback;
    ^space       ${ entity = AWK_ANY;   } => awk_ccallback;
  *|;

  # Entity machine

  action awk_ecallback {
    callback(AWK_LANG, entity, cint(ts), cint(te));
  }

  awk_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Awk code.
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
void parse_awk(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  init

  %% write init;
  cs = (count) ? awk_en_awk_line : awk_en_awk_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(AWK_LANG) }
}

#endif

/*****************************************************************************/
