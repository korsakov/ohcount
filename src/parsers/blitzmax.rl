// blitzmax.rl written by Bruce A Henderson (http://brucey.net)

/************************* Required for every parser *************************/
#ifndef OHCOUNT_BLITZMAX_PARSER_H
#define OHCOUNT_BLITZMAX_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *BLITZMAX_LANG = LANG_BLITZMAX;

// the languages entities
const char *blitzmax_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  BLITZMAX_SPACE = 0, BLITZMAX_COMMENT, BLITZMAX_STRING, BLITZMAX_ANY
};

/*****************************************************************************/

%%{
  machine blitzmax;
  write data;
  include common "common.rl";

  # Line counting machine

  action blitzmax_ccallback {
    switch(entity) {
    case BLITZMAX_SPACE:
      ls
      break;
    case BLITZMAX_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(BLITZMAX_LANG)
      break;
    case NEWLINE:
      std_newline(BLITZMAX_LANG)
    }
  }

  blitzmax_line_comment = '\'' @comment nonnewline*;
  blitzmax_rem_block_comment =
    /rem/i @comment (
      newline %{ entity = INTERNAL_NL; } %blitzmax_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> (/end rem/i | /endrem/i);

  blitzmax_comment = blitzmax_line_comment | blitzmax_rem_block_comment;

  blitzmax_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  blitzmax_line := |*
    spaces          ${ entity = BLITZMAX_SPACE; } => blitzmax_ccallback;
    blitzmax_comment;
    blitzmax_string;
    newline         ${ entity = NEWLINE;      } => blitzmax_ccallback;
    ^space          ${ entity = BLITZMAX_ANY;   } => blitzmax_ccallback;
  *|;

  # Entity machine

  action blitzmax_ecallback {
    callback(BLITZMAX_LANG, blitzmax_entities[entity], cint(ts), cint(te),
             userdata);
  }

  blitzmax_line_comment_entity = '\'' nonnewline*;
  blitzmax_rem_block_comment_entity =
    /rem/i (
      newline %{ entity = INTERNAL_NL; } %blitzmax_ecallback
      |
      ws
      |
      (nonnewline - ws)
    )* :>> (/end rem/i | /endrem/i);

  blitzmax_comment_entity = blitzmax_line_comment_entity | blitzmax_line_comment_entity;

  blitzmax_entity := |*
    space+                ${ entity = BLITZMAX_SPACE;   } => blitzmax_ecallback;
    blitzmax_comment_entity ${ entity = BLITZMAX_COMMENT; } => blitzmax_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with BlitzMax code.
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
void parse_blitzmax(char *buffer, int length, int count,
                    void (*callback) (const char *lang, const char *entity,
                                      int s, int e, void *udata),
                    void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? blitzmax_en_blitzmax_line : blitzmax_en_blitzmax_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(BLITZMAX_LANG) }
}

#endif

/*****************************************************************************/
