// r.rl copied from matlabl.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.
// adapted by Mark Hoebeke mark@<att>hoebeke<dot>eu
/************************* Required for every parser *************************/
#ifndef OHCOUNT_R_PARSER_H
#define OHCOUNT_R_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *R_LANG = LANG_R;

// the languages entities
const char *r_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  R_SPACE = 0, R_COMMENT, R_STRING, R_ANY
};

/*****************************************************************************/

%%{
  machine r;
  write data;
  include common "common.rl";

  # Line counting machine

  action r_ccallback {
    switch(entity) {
    case R_SPACE:
      ls
      break;
    case R_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(R_LANG)
      break;
    case NEWLINE:
      std_newline(R_LANG)
    }
  }

  r_line_comment = ( '#') @comment nonnewline*;
  r_comment = r_line_comment;

  r_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  r_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  r_string = r_sq_str | r_dq_str;

  r_line := |*
    spaces          ${ entity = R_SPACE; } => r_ccallback;
    r_comment;
    r_string;
    newline         ${ entity = NEWLINE;      } => r_ccallback;
    ^space          ${ entity = R_ANY;   } => r_ccallback;
  *|;

  # Entity machine

  action r_ecallback {
    callback(R_LANG, r_entities[entity], cint(ts), cint(te), userdata);
  }

  r_line_comment_entity = ('#') nonnewline*;
  r_comment_entity = r_line_comment_entity;

  r_entity := |*
    space+                ${ entity = R_SPACE;   } => r_ecallback;
    r_comment_entity ${ entity = R_COMMENT; } => r_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with R code.
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
void parse_r(char *buffer, int length, int count,
             void (*callback) (const char *lang, const char *entity, int s,
                               int e, void *udata),
             void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? r_en_r_line : r_en_r_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(R_LANG) }
}

#endif

/*****************************************************************************/
