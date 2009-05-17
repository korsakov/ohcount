// matlab.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_MATLAB_PARSER_H
#define OHCOUNT_MATLAB_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *MATLAB_LANG = LANG_MATLAB;

// the languages entities
const char *matlab_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  MATLAB_SPACE = 0, MATLAB_COMMENT, MATLAB_STRING, MATLAB_ANY
};

/*****************************************************************************/

%%{
  machine matlab;
  write data;
  include common "common.rl";

  # Line counting machine

  action matlab_ccallback {
    switch(entity) {
    case MATLAB_SPACE:
      ls
      break;
    case MATLAB_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(MATLAB_LANG)
      break;
    case NEWLINE:
      std_newline(MATLAB_LANG)
    }
  }

  # Matlab(TM) comments also may begin with the line-continuing sequence ...
  matlab_line_comment = (('%' | '...') [^{] @{ fhold; }) @comment nonnewline*;
  matlab_block_comment =
    '%{' @comment (
      newline %{ entity = INTERNAL_NL; } %matlab_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> '%}';
  matlab_comment = matlab_line_comment | matlab_block_comment;

  # The detector is not smart enough to detect GNU Octave's double
  # quotes around strings, so accept it here.
  matlab_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  matlab_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  matlab_string = matlab_sq_str | matlab_dq_str;

  matlab_line := |*
    spaces          ${ entity = MATLAB_SPACE; } => matlab_ccallback;
    matlab_comment;
    matlab_string;
    newline         ${ entity = NEWLINE;      } => matlab_ccallback;
    ^space          ${ entity = MATLAB_ANY;   } => matlab_ccallback;
  *|;

  # Entity machine

  action matlab_ecallback {
    callback(MATLAB_LANG, matlab_entities[entity], cint(ts), cint(te),
             userdata);
  }

  matlab_line_comment_entity = (('%' | '...') [^{] @{ fhold; }) nonnewline*;
  matlab_block_comment_entity = '%{' any* :>> '%}';
  matlab_comment_entity =
    matlab_line_comment_entity | matlab_block_comment_entity;

  matlab_entity := |*
    space+                ${ entity = MATLAB_SPACE;   } => matlab_ecallback;
    matlab_comment_entity ${ entity = MATLAB_COMMENT; } => matlab_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with MATLAB code.
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
void parse_matlab(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? matlab_en_matlab_line : matlab_en_matlab_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(MATLAB_LANG) }
}

#endif

/*****************************************************************************/
