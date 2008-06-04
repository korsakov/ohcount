// erlang.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef RAGEL_ERLANG_PARSER
#define RAGEL_ERLANG_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *ERLANG_LANG = "erlang";

// the languages entities
const char *erlang_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  ERLANG_SPACE = 0, ERLANG_COMMENT, ERLANG_STRING, ERLANG_ANY
};

/*****************************************************************************/

%%{
  machine erlang;
  write data;
  include common "common.rl";

  # Line counting machine

  action erlang_ccallback {
    switch(entity) {
    case ERLANG_SPACE:
      ls
      break;
    case ERLANG_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(ERLANG_LANG)
      break;
    case NEWLINE:
      std_newline(ERLANG_LANG)
    }
  }

  erlang_comment = '%%' @comment nonnewline*;

  erlang_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  erlang_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  erlang_string = erlang_sq_str | erlang_dq_str;

  erlang_line := |*
    spaces      ${ entity = ERLANG_SPACE; } => erlang_ccallback;
    erlang_comment;
    erlang_string;
    newline     ${ entity = NEWLINE;   } => erlang_ccallback;
    ^space      ${ entity = ERLANG_ANY;   } => erlang_ccallback;
  *|;

  # Entity machine

  action erlang_ecallback {
    callback(ERLANG_LANG, entity, cint(ts), cint(te));
  }

  erlang_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Erlang code.
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
void parse_erlang(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  init

  %% write init;
  cs = (count) ? erlang_en_erlang_line : erlang_en_erlang_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(ERLANG_LANG) }
}

#endif

/*****************************************************************************/
