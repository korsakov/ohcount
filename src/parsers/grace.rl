// grace.rl written by Michael Homer, based on shell.rl
// by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_GRACE_PARSER_H
#define OHCOUNT_GRACE_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *GRACE_LANG = LANG_GRACE;

// the languages entities
const char *grace_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  GRACE_SPACE = 0, GRACE_COMMENT, GRACE_STRING, GRACE_ANY
};

/*****************************************************************************/

%%{
  machine grace;
  write data;
  include common "common.rl";

  # Line counting machine

  action grace_ccallback {
    switch(entity) {
    case GRACE_SPACE:
      ls
      break;
    case GRACE_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(GRACE_LANG)
      break;
    case NEWLINE:
      std_newline(GRACE_LANG)
    }
  }

  grace_comment = '//' @comment nonnewline*;

  grace_string =
    '"' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %grace_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
    )* '"' @commit;

  grace_line := |*
    spaces         ${ entity = GRACE_SPACE; } => grace_ccallback;
    grace_comment;
    grace_string;
    newline        ${ entity = NEWLINE;     } => grace_ccallback;
    ^space         ${ entity = GRACE_ANY;   } => grace_ccallback;
  *|;

  # Entity machine

  action grace_ecallback {
    callback(GRACE_LANG, grace_entities[entity], cint(ts), cint(te), userdata);
  }

  grace_comment_entity = '//' nonnewline*;

  grace_entity := |*
    space+               ${ entity = GRACE_SPACE;   } => grace_ecallback;
    grace_comment_entity ${ entity = GRACE_COMMENT; } => grace_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Grace code.
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
void parse_grace(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? grace_en_grace_line : grace_en_grace_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(GRACE_LANG) }
}

#endif

/*****************************************************************************/
