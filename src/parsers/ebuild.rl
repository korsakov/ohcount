// ebuild.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_EBUILD_PARSER_H
#define OHCOUNT_EBUILD_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *EBUILD_LANG = LANG_EBUILD;

// the languages entities
const char *ebuild_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  EBUILD_SPACE = 0, EBUILD_COMMENT, EBUILD_STRING, EBUILD_ANY
};

/*****************************************************************************/

%%{
  machine ebuild;
  write data;
  include common "common.rl";

  # Line counting machine

  action ebuild_ccallback {
    switch(entity) {
    case EBUILD_SPACE:
      ls
      break;
    case EBUILD_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(EBUILD_LANG)
      break;
    case NEWLINE:
      std_newline(EBUILD_LANG)
    }
  }

  ebuild_comment = '#' @comment nonnewline*;

  ebuild_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  ebuild_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  ebuild_string = ebuild_sq_str | ebuild_dq_str;

  ebuild_line := |*
    spaces          ${ entity = EBUILD_SPACE; } => ebuild_ccallback;
    ebuild_comment;
    ebuild_string;
    newline         ${ entity = NEWLINE;      } => ebuild_ccallback;
    ^space          ${ entity = EBUILD_ANY;   } => ebuild_ccallback;
  *|;

  # Entity machine

  action ebuild_ecallback {
    callback(EBUILD_LANG, ebuild_entities[entity], cint(ts), cint(te),
             userdata);
  }

  ebuild_comment_entity = '#' nonnewline*;

  ebuild_entity := |*
    space+                ${ entity = EBUILD_SPACE;   } => ebuild_ecallback;
    ebuild_comment_entity ${ entity = EBUILD_COMMENT; } => ebuild_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with ebuild code.
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
void parse_ebuild(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? ebuild_en_ebuild_line : ebuild_en_ebuild_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(EBUILD_LANG) }
}

#endif

/*****************************************************************************/
