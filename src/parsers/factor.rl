// factor.rl written by Alfredo Beaumont <alfredo.beaumont@gmail.com>
// Based on lisp.rl

/************************* Required for every parser *************************/
#ifndef OHCOUNT_FACTOR_PARSER_H
#define OHCOUNT_FACTOR_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *FACTOR_LANG = LANG_FACTOR;

// the languages entities
const char *factor_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  FACTOR_SPACE = 0, FACTOR_COMMENT, FACTOR_STRING, FACTOR_ANY
};

/*****************************************************************************/

%%{
  machine factor;
  write data;
  include common "common.rl";

  # Line counting machine

  action factor_ccallback {
    switch(entity) {
    case FACTOR_SPACE:
      ls
      break;
    case FACTOR_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(FACTOR_LANG)
      break;
    case NEWLINE:
      std_newline(FACTOR_LANG)
    }
  }

  factor_comment = '!' @comment nonnewline*;

  factor_string =
    '"' @code (
      newline %{ entity = INTERNAL_NL; } %factor_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';

  factor_line := |*
    spaces        ${ entity = FACTOR_SPACE; } => factor_ccallback;
    factor_comment;
    factor_string;
    newline       ${ entity = NEWLINE;    } => factor_ccallback;
    ^space        ${ entity = FACTOR_ANY;   } => factor_ccallback;
  *|;

  # Entity machine

  action factor_ecallback {
    callback(FACTOR_LANG, factor_entities[entity], cint(ts), cint(te),
             userdata);
  }

  factor_entity := 'TODO:';
}%%

/* Parses a string buffer with Factor code.
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
void parse_factor(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? factor_en_factor_line : factor_en_factor_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(FACTOR_LANG) }
}

#endif
