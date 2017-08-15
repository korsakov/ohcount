// smalltalk.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_SMALLTALK_PARSER_H
#define OHCOUNT_SMALLTALK_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *SMALLTALK_LANG = LANG_SMALLTALK;

// the languages entities
const char *smalltalk_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  SMALLTALK_SPACE = 0, SMALLTALK_COMMENT, SMALLTALK_STRING, SMALLTALK_ANY
};

/*****************************************************************************/

%%{
  machine smalltalk;
  write data;
  include common "common.rl";

  # Line counting machine

  action smalltalk_ccallback {
    switch(entity) {
    case SMALLTALK_SPACE:
      ls
      break;
    case SMALLTALK_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(SMALLTALK_LANG)
      break;
    case NEWLINE:
      std_newline(SMALLTALK_LANG)
    }
  }

  smalltalk_comment =
    '"' @comment (
      newline %{ entity = INTERNAL_NL; } %smalltalk_ccallback
      |
      ws
      |
      [^\r\n\f\t "] @comment
    )* '"';

  smalltalk_string = '\'' @code [^\r\n\f']* '\'';

  smalltalk_line := |*
    spaces             ${ entity = SMALLTALK_SPACE; } => smalltalk_ccallback;
    smalltalk_comment;
    smalltalk_string;
    newline            ${ entity = NEWLINE;         } => smalltalk_ccallback;
    ^space             ${ entity = SMALLTALK_ANY;   } => smalltalk_ccallback;
  *|;

  # Entity machine

  action smalltalk_ecallback {
    callback(SMALLTALK_LANG, smalltalk_entities[entity], cint(ts), cint(te),
             userdata);
  }

  smalltalk_comment_entity = '"' any* :>> '"';

  smalltalk_entity := |*
    space+                   ${ entity = SMALLTALK_SPACE;   } => smalltalk_ecallback;
    smalltalk_comment_entity ${ entity = SMALLTALK_COMMENT; } => smalltalk_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Smalltalk code.
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
void parse_smalltalk(char *buffer, int length, int count,
                     void (*callback) (const char *lang, const char *entity,
                                       int s, int e, void *udata),
                     void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? smalltalk_en_smalltalk_line : smalltalk_en_smalltalk_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(SMALLTALK_LANG) }
}

#endif

/*****************************************************************************/
