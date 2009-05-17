// exheres.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_EXHERES_PARSER_H
#define OHCOUNT_EXHERES_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *EXHERES_LANG = LANG_EXHERES;

// the languages entities
const char *exheres_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  EXHERES_SPACE = 0, EXHERES_COMMENT, EXHERES_STRING, EXHERES_ANY
};

/*****************************************************************************/

%%{
  machine exheres;
  write data;
  include common "common.rl";

  # Line counting machine

  action exheres_ccallback {
    switch(entity) {
    case EXHERES_SPACE:
      ls
      break;
    case EXHERES_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(EXHERES_LANG)
      break;
    case NEWLINE:
      std_newline(EXHERES_LANG)
    }
  }

  exheres_comment = '#' @comment nonnewline*;

  exheres_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  exheres_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  exheres_string = exheres_sq_str | exheres_dq_str;

  exheres_line := |*
    spaces           ${ entity = EXHERES_SPACE; } => exheres_ccallback;
    exheres_comment;
    exheres_string;
    newline          ${ entity = NEWLINE;       } => exheres_ccallback;
    ^space           ${ entity = EXHERES_ANY;   } => exheres_ccallback;
  *|;

  # Entity machine

  action exheres_ecallback {
    callback(EXHERES_LANG, exheres_entities[entity], cint(ts), cint(te),
             userdata);
  }

  exheres_comment_entity = '#' nonnewline*;

  exheres_entity := |*
    space+                 ${ entity = EXHERES_SPACE;   } => exheres_ecallback;
    exheres_comment_entity ${ entity = EXHERES_COMMENT; } => exheres_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with exheres code.
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
void parse_exheres(char *buffer, int length, int count,
                   void (*callback) (const char *lang, const char *entity,
                                     int s, int e, void *udata),
                   void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? exheres_en_exheres_line : exheres_en_exheres_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(EXHERES_LANG) }
}

#endif

/*****************************************************************************/
