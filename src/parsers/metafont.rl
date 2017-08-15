// metafont.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_METAFONT_PARSER_H
#define OHCOUNT_METAFONT_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *METAFONT_LANG = LANG_METAFONT;

// the languages entities
const char *metafont_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  METAFONT_SPACE = 0, METAFONT_COMMENT, METAFONT_STRING, METAFONT_ANY
};

/*****************************************************************************/

%%{
  machine metafont;
  write data;
  include common "common.rl";

  # Line counting machine

  action metafont_ccallback {
    switch(entity) {
    case METAFONT_SPACE:
      ls
      break;
    case METAFONT_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(METAFONT_LANG)
      break;
    case NEWLINE:
      std_newline(METAFONT_LANG)
    }
  }

  metafont_comment = '%' @{ fhold; } @comment nonnewline*;

  metafont_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  metafont_line := |*
    spaces            ${ entity = METAFONT_SPACE; } => metafont_ccallback;
    metafont_comment;
    metafont_string;
    newline           ${ entity = NEWLINE;        } => metafont_ccallback;
    ^space            ${ entity = METAFONT_ANY;   } => metafont_ccallback;
  *|;

  # Entity machine

  action metafont_ecallback {
    callback(METAFONT_LANG, metafont_entities[entity], cint(ts), cint(te),
             userdata);
  }

  metafont_comment_entity = '%' nonnewline*;

  metafont_entity := |*
    space+                  ${ entity = METAFONT_SPACE;   } => metafont_ecallback;
    metafont_comment_entity ${ entity = METAFONT_COMMENT; } => metafont_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Metafont code.
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
void parse_metafont(char *buffer, int length, int count,
                    void (*callback) (const char *lang, const char *entity,
                                      int s, int e, void *udata),
                    void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? metafont_en_metafont_line : metafont_en_metafont_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(METAFONT_LANG) }
}

#endif

/*****************************************************************************/
