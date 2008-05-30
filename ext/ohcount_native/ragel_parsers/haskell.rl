// haskell.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef RAGEL_HASKELL_PARSER
#define RAGEL_HASKELL_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *HASKELL_LANG = "haskell";

// the languages entities
const char *haskell_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  HASKELL_SPACE = 0, HASKELL_COMMENT, HASKELL_STRING, HASKELL_ANY
};

/*****************************************************************************/

%%{
  machine haskell;
  write data;
  include common "common.rl";

  # Line counting machine

  action haskell_ccallback {
    switch(entity) {
    case HASKELL_SPACE:
      ls
      break;
    case HASKELL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(HASKELL_LANG)
      break;
    case NEWLINE:
      std_newline(HASKELL_LANG)
    }
  }

  # TODO: |-- is not a comment
  haskell_line_comment = '--' [^>] @{ fhold; } @comment nonnewline*;
  haskell_block_comment =
    '{-' @comment (
      newline %{ entity = INTERNAL_NL; } %haskell_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '-}';
  haskell_comment = haskell_line_comment | haskell_block_comment;

  haskell_char = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline) '\'';
  haskell_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %haskell_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  haskell_string = haskell_char | haskell_dq_str;

  haskell_line := |*
    spaces           ${ entity = HASKELL_SPACE; } => haskell_ccallback;
    haskell_comment;
    haskell_string;
    newline          ${ entity = NEWLINE;       } => haskell_ccallback;
    ^space           ${ entity = HASKELL_ANY;   } => haskell_ccallback;
  *|;

  # Entity machine

  action haskell_ecallback {
    callback(HASKELL_LANG, entity, cint(ts), cint(te));
  }

  haskell_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Haskell code.
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
void parse_haskell(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  init

  %% write init;
  cs = (count) ? haskell_en_haskell_line : haskell_en_haskell_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(HASKELL_LANG) }
}

#endif

/*****************************************************************************/
