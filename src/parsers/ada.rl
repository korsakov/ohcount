// ada.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_ADA_PARSER_H
#define OHCOUNT_ADA_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *ADA_LANG = LANG_ADA;

// the languages entities
const char *ada_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  ADA_SPACE = 0, ADA_COMMENT, ADA_STRING, ADA_ANY
};

/*****************************************************************************/

%%{
  machine ada;
  write data;
  include common "common.rl";

  # Line counting machine

  action ada_ccallback {
    switch(entity) {
    case ADA_SPACE:
      ls
      break;
    case ADA_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(ADA_LANG)
      break;
    case NEWLINE:
      std_newline(ADA_LANG)
    }
  }

  ada_comment = '--' @comment nonnewline*;

  ada_string = '"' @code [^\r\n\f"]* '"';

  ada_line := |*
    spaces      ${ entity = ADA_SPACE; } => ada_ccallback;
    ada_comment;
    ada_string;
    newline     ${ entity = NEWLINE;   } => ada_ccallback;
    ^space      ${ entity = ADA_ANY;   } => ada_ccallback;
  *|;

  # Entity machine

  action ada_ecallback {
    callback(ADA_LANG, ada_entities[entity], cint(ts), cint(te), userdata);
  }

  ada_comment_entity = '--' nonnewline*;

  ada_entity := |*
    space+             ${ entity = ADA_SPACE;   } => ada_ecallback;
    ada_comment_entity ${ entity = ADA_COMMENT; } => ada_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Ada code.
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
void parse_ada(char *buffer, int length, int count,
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? ada_en_ada_line : ada_en_ada_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(ADA_LANG) }
}

#endif

/*****************************************************************************/
