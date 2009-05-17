// makefile.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_MAKEFILE_PARSER_H
#define OHCOUNT_MAKEFILE_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *MAKE_LANG = LANG_MAKE;

// the languages entities
const char *make_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  MAKE_SPACE = 0, MAKE_COMMENT, MAKE_STRING, MAKE_ANY
};

/*****************************************************************************/

%%{
  machine makefile;
  write data;
  include common "common.rl";

  # Line counting machine

  action make_ccallback {
    switch(entity) {
    case MAKE_SPACE:
      ls
      break;
    case MAKE_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(MAKE_LANG)
      break;
    case NEWLINE:
      std_newline(MAKE_LANG)
    }
  }

  make_comment = '#' @comment nonnewline*;

  make_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  make_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  make_string = make_sq_str | make_dq_str;

  make_line := |*
    spaces        ${ entity = MAKE_SPACE; } => make_ccallback;
    make_comment;
    make_string;
    newline       ${ entity = NEWLINE;    } => make_ccallback;
    ^space        ${ entity = MAKE_ANY;   } => make_ccallback;
  *|;

  # Entity machine

  action make_ecallback {
    callback(MAKE_LANG, make_entities[entity], cint(ts), cint(te), userdata);
  }

  make_comment_entity = '#' nonnewline*;

  make_entity := |*
    space+              ${ entity = MAKE_SPACE;   } => make_ecallback;
    make_comment_entity ${ entity = MAKE_COMMENT; } => make_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Makefile code.
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
void parse_makefile(char *buffer, int length, int count,
                    void (*callback) (const char *lang, const char *entity,
                                      int s, int e, void *udata),
                    void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? makefile_en_make_line : makefile_en_make_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(MAKE_LANG) }
}

#endif

/*****************************************************************************/
