// boo.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef RAGEL_BOO_PARSER
#define RAGEL_BOO_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *BOO_LANG = "boo";

// the languages entities
const char *boo_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  BOO_SPACE = 0, BOO_COMMENT, BOO_STRING, BOO_ANY
};

/*****************************************************************************/

%%{
  machine boo;
  write data;
  include common "common.rl";

  # Line counting machine

  action boo_ccallback {
    switch(entity) {
    case BOO_SPACE:
      ls
      break;
    case BOO_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(BOO_LANG)
      break;
    case NEWLINE:
      std_newline(BOO_LANG)
    }
  }

  boo_line_comment = ('#' | '//') @comment nonnewline*;
  boo_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %boo_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  boo_comment = boo_line_comment | boo_block_comment;

  boo_char = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline) '\'';
  boo_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  boo_tq_str =
    '"""' @code (
      newline %{ entity = INTERNAL_NL; } %boo_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> '"""' @code;
  boo_regex = '/' @code ([^\r\n\f/\\] | '\\' nonnewline)* '/';
  boo_string = boo_char | boo_dq_str | boo_tq_str | boo_regex;

  boo_line := |*
    spaces       ${ entity = BOO_SPACE; } => boo_ccallback;
    boo_comment;
    boo_string;
    newline      ${ entity = NEWLINE;   } => boo_ccallback;
    ^space       ${ entity = BOO_ANY;   } => boo_ccallback;
  *|;

  # Entity machine

  action boo_ecallback {
    callback(BOO_LANG, entity, cint(ts), cint(te));
  }

  boo_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Boo code.
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
void parse_boo(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  init

  %% write init;
  cs = (count) ? boo_en_boo_line : boo_en_boo_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(BOO_LANG) }
}

#endif

/*****************************************************************************/
