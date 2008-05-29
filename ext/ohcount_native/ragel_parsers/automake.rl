// automake.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef RAGEL_AUTOMAKE_PARSER
#define RAGEL_AUTOMAKE_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *AM_LANG = "automake";

// the languages entities
const char *am_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  AM_SPACE = 0, AM_COMMENT, AM_STRING, AM_ANY
};

/*****************************************************************************/

%%{
  machine automake;
  write data;
  include common "common.rl";

  # Line counting machine

  action am_ccallback {
    switch(entity) {
    case AM_SPACE:
      ls
      break;
    case AM_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(AM_LANG)
      break;
    case NEWLINE:
      std_newline(AM_LANG)
    }
  }

  am_comment = '#' @comment nonnewline*;

  am_sq_str = '\'' @code ([^'\\] | '\\' nonnewline)* '\'';
  am_dq_str = '"' @code ([^"\\] | '\\' nonnewline)* '"';
  am_string = am_sq_str | am_dq_str;

  am_line := |*
    spaces      ${ entity = AM_SPACE; } => am_ccallback;
    am_comment;
    am_string;
    newline     ${ entity = NEWLINE;  } => am_ccallback;
    ^space      ${ entity = AM_ANY;   } => am_ccallback;
  *|;

  # Entity machine

  action am_ecallback {
    callback(AM_LANG, am_entities[entity], cint(ts), cint(te));
  }

  am_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Automake code.
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
void parse_automake(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  init

  %% write init;
  cs = (count) ? automake_en_am_line : automake_en_am_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(AM_LANG) }
}

#endif

/*****************************************************************************/
