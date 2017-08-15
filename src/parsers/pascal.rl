// pascal.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_PASCAL_PARSER_H
#define OHCOUNT_PASCAL_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *PASCAL_LANG = LANG_PASCAL;

// the languages entities
const char *pascal_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  PASCAL_SPACE = 0, PASCAL_COMMENT, PASCAL_STRING, PASCAL_ANY
};

/*****************************************************************************/

%%{
  machine pascal;
  write data;
  include common "common.rl";

  # Line counting machine

  action pascal_ccallback {
    switch(entity) {
    case PASCAL_SPACE:
      ls
      break;
    case PASCAL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(PASCAL_LANG)
      break;
    case NEWLINE:
      std_newline(PASCAL_LANG)
    }
  }

  pascal_line_comment = '//' @comment nonnewline*;
  pascal_old_block_comment =
    '(*' @comment (
      newline %{ entity = INTERNAL_NL; } %pascal_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> '*)';
  pascal_turbo_block_comment =
    '{' @comment (
      newline %{ entity = INTERNAL_NL; } %pascal_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '}';
  pascal_comment = pascal_line_comment | pascal_old_block_comment |
                   pascal_turbo_block_comment;

  pascal_string =
    '\'' @code (
      newline %{ entity = INTERNAL_NL; } %pascal_ccallback
      |
      ws
      |
      [^\r\n\f\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';

  pascal_line := |*
    spaces          ${ entity = PASCAL_SPACE; } => pascal_ccallback;
    pascal_comment;
    pascal_string;
    newline         ${ entity = NEWLINE;      } => pascal_ccallback;
    ^space          ${ entity = PASCAL_ANY;   } => pascal_ccallback;
  *|;

  # Entity machine

  action pascal_ecallback {
    callback(PASCAL_LANG, pascal_entities[entity], cint(ts), cint(te),
             userdata);
  }

  pascal_line_comment_entity = '//' nonnewline*;
  pascal_old_block_comment_entity = '(*' any* :>> '*)';
  pascal_turbo_block_comment_entity = '{' any* :>> '}';
  pascal_comment_entity = pascal_line_comment_entity |
    pascal_old_block_comment_entity | pascal_turbo_block_comment_entity;

  pascal_entity := |*
    space+                ${ entity = PASCAL_SPACE;   } => pascal_ecallback;
    pascal_comment_entity ${ entity = PASCAL_COMMENT; } => pascal_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Pascal code.
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
void parse_pascal(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? pascal_en_pascal_line : pascal_en_pascal_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(PASCAL_LANG) }
}

#endif

/*****************************************************************************/
