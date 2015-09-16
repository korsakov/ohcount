/************************* Required for every parser *************************/
#ifndef OHCOUNT_EIFFEL_PARSER_H
#define OHCOUNT_EIFFEL_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *EIFFEL_LANG = LANG_EIFFEL;

// the languages entities
const char *eiffel_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  EIFFEL_SPACE = 0, EIFFEL_COMMENT, EIFFEL_STRING, EIFFEL_ANY
};

/*****************************************************************************/

%%{
  machine eiffel;
  write data;
  include common "common.rl";

  # Line counting machine

  action eiffel_ccallback {
    switch(entity) {
    case EIFFEL_SPACE:
      ls
      break;
    case EIFFEL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(EIFFEL_LANG)
      break;
    case NEWLINE:
      std_newline(EIFFEL_LANG)
    }
  }

  eiffel_comment = '--' @comment nonnewline*;

  eiffel_string = '"' @code [^\r\n\f"]* '"';

  eiffel_line := |*
    spaces      ${ entity = EIFFEL_SPACE; } => eiffel_ccallback;
    eiffel_comment;
    eiffel_string;
    newline     ${ entity = NEWLINE;   } => eiffel_ccallback;
    ^space      ${ entity = EIFFEL_ANY;   } => eiffel_ccallback;
  *|;

  # Entity machine

  action eiffel_ecallback {
    callback(EIFFEL_LANG, eiffel_entities[entity], cint(ts), cint(te),
             userdata);
  }

  eiffel_comment_entity = '--' nonnewline*;

  eiffel_entity := |*
    space+                ${ entity = EIFFEL_SPACE;   } => eiffel_ecallback;
    eiffel_comment_entity ${ entity = EIFFEL_COMMENT; } => eiffel_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Eiffel code.
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
void parse_eiffel(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? eiffel_en_eiffel_line : eiffel_en_eiffel_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(EIFFEL_LANG) }
}

#endif

/*****************************************************************************/
