// metapost.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_METAPOST_PARSER_H
#define OHCOUNT_METAPOST_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *METAPOST_LANG = LANG_METAPOST;

// the languages entities
const char *metapost_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  METAPOST_SPACE = 0, METAPOST_COMMENT, METAPOST_STRING, METAPOST_ANY
};

/*****************************************************************************/

%%{
  machine metapost;
  write data;
  include common "common.rl";

  # Line counting machine

  action metapost_ccallback {
    switch(entity) {
    case METAPOST_SPACE:
      ls
      break;
    case METAPOST_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(METAPOST_LANG)
      break;
    case NEWLINE:
      std_newline(METAPOST_LANG)
    }
  }

  metapost_comment = '%' @{ fhold; } @comment nonnewline*;

  metapost_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  metapost_line := |*
    spaces            ${ entity = METAPOST_SPACE; } => metapost_ccallback;
    metapost_comment;
    metapost_string;
    newline           ${ entity = NEWLINE;        } => metapost_ccallback;
    ^space            ${ entity = METAPOST_ANY;   } => metapost_ccallback;
  *|;

  # Entity machine

  action metapost_ecallback {
    callback(METAPOST_LANG, metapost_entities[entity], cint(ts), cint(te),
             userdata);
  }

  metapost_comment_entity = '%' nonnewline*;

  metapost_entity := |*
    space+                  ${ entity = METAPOST_SPACE;   } => metapost_ecallback;
    metapost_comment_entity ${ entity = METAPOST_COMMENT; } => metapost_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Metapost code.
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
void parse_metapost(char *buffer, int length, int count,
                    void (*callback) (const char *lang, const char *entity,
                                      int s, int e, void *udata),
                    void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? metapost_en_metapost_line : metapost_en_metapost_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(METAPOST_LANG) }
}

#endif

/*****************************************************************************/
