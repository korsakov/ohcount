// fortranfixed.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_FORTRANFIXED_PARSER_H
#define OHCOUNT_FORTRANFIXED_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *FORTRANFIXED_LANG = LANG_FORTRANFIXED;

// the languages entities
const char *ffixed_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  FFIXED_SPACE = 0, FFIXED_COMMENT, FFIXED_STRING, FFIXED_ANY
};

/*****************************************************************************/

%%{
  machine fortranfixed;
  write data;
  include common "common.rl";

  # Line counting machine

  action ffixed_ccallback {
    switch(entity) {
    case FFIXED_SPACE:
      ls
      break;
    case FFIXED_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(FORTRANFIXED_LANG)
      break;
    case NEWLINE:
      std_newline(FORTRANFIXED_LANG)
    }
  }

  ffixed_comment = 'C' @comment nonnewline*;

  ffixed_sq_str = '\'' @code nonnewline* '\'';
  ffixed_dq_str = '"' @code nonnewline* '"';
  ffixed_string = ffixed_sq_str | ffixed_dq_str;

  ffixed_line := |*
    spaces          ${ entity = FFIXED_SPACE; } => ffixed_ccallback;
    ffixed_comment;
    ffixed_string;
    newline         ${ entity = NEWLINE;      } => ffixed_ccallback;
    ^space          ${ entity = FFIXED_ANY;   } => ffixed_ccallback;
  *|;

  # Entity machine

  action ffixed_ecallback {
    callback(FORTRANFIXED_LANG, ffixed_entities[entity], cint(ts), cint(te),
             userdata);
  }

  ffixed_comment_entity = 'C' nonnewline*;

  ffixed_entity := |*
    space+                ${ entity = FFIXED_SPACE;   } => ffixed_ecallback;
    ffixed_comment_entity ${ entity = FFIXED_COMMENT; } => ffixed_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/* Parses a string buffer with Fortran Fixedform code.
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
void parse_fortranfixed(char *buffer, int length, int count,
                        void (*callback) (const char *lang, const char *entity,
                                          int s, int e, void *udata),
                        void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? fortranfixed_en_ffixed_line : fortranfixed_en_ffixed_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(FORTRANFIXED_LANG) }
}

#endif
