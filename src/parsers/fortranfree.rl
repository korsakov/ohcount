// fortranfree.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_FORTRANFREE_PARSER_H
#define OHCOUNT_FORTRANFREE_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *FORTRANFREE_LANG = LANG_FORTRANFREE;

// the languages entities
const char *ffree_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  FFREE_SPACE = 0, FFREE_COMMENT, FFREE_STRING, FFREE_ANY
};

/*****************************************************************************/

%%{
  machine fortranfree;
  write data;
  include common "common.rl";

  # Line counting machine

  action ffree_ccallback {
    switch(entity) {
    case FFREE_SPACE:
      ls
      break;
    case FFREE_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(FORTRANFREE_LANG)
      break;
    case NEWLINE:
      std_newline(FORTRANFREE_LANG)
    }
  }

  ffree_comment = '!' @comment nonnewline*;

  ffree_sq_str =
    '\'' @code (
      newline %{ entity = INTERNAL_NL; } %ffree_ccallback
      |
      ws
      |
      [^\r\n\f\t '] @code
    )* '\'';
  ffree_dq_str =
    '"' @code (
      newline %{ entity = INTERNAL_NL; } %ffree_ccallback
      |
      ws
      |
      [^\r\n\f\t "] @code
    )* '"';
  ffree_string = ffree_sq_str | ffree_dq_str;

  ffree_line := |*
    spaces         ${ entity = FFREE_SPACE; } => ffree_ccallback;
    ffree_comment;
    ffree_string;
    newline        ${ entity = NEWLINE;     } => ffree_ccallback;
    ^space         ${ entity = FFREE_ANY;   } => ffree_ccallback;
  *|;

  # Entity machine

  action ffree_ecallback {
    callback(FORTRANFREE_LANG, ffree_entities[entity], cint(ts), cint(te),
             userdata);
  }

  ffree_comment_entity = '!' nonnewline*;

  ffree_entity := |*
    space+               ${ entity = FFREE_SPACE;   } => ffree_ecallback;
    ffree_comment_entity ${ entity = FFREE_COMMENT; } => ffree_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/* Parses a string buffer with Fortran Freeform code.
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
void parse_fortranfree(char *buffer, int length, int count,
                       void (*callback) (const char *lang, const char *entity,
                                         int s, int e, void *udata),
                       void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? fortranfree_en_ffree_line : fortranfree_en_ffree_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(FORTRANFREE_LANG) }
}

#endif
