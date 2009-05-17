// scilab.rl written by Sylvestre Ledru based on matlab Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef RAGEL_SCILAB_PARSER
#define RAGEL_SCILAB_PARSER

#include "../parser_macros.h"

// the name of the language
const char *SCILAB_LANG = "scilab";

// the languages entities
const char *scilab_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  SCILAB_SPACE = 0, SCILAB_COMMENT, SCILAB_STRING, SCILAB_ANY
};

/*****************************************************************************/

%%{
  machine scilab;
  write data;
  include common "common.rl";

  # Line counting machine

  action scilab_ccallback {
    switch(entity) {
    case SCILAB_SPACE:
      ls
      break;
    case SCILAB_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(SCILAB_LANG)
      break;
    case NEWLINE:
      std_newline(SCILAB_LANG)
    }
  }

  scilab_comment = ('//') @comment nonnewline*;

  # The detector is not smart enough to detect GNU Octave's double
  # quotes around strings, so accept it here.
  scilab_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  scilab_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  scilab_string = scilab_sq_str | scilab_dq_str;

  scilab_line := |*
    spaces          ${ entity = SCILAB_SPACE; } => scilab_ccallback;
    scilab_comment;
    scilab_string;
    newline         ${ entity = NEWLINE;      } => scilab_ccallback;
    ^space          ${ entity = SCILAB_ANY;   } => scilab_ccallback;
  *|;

  # Entity machine

  action scilab_ecallback {
    callback(SCILAB_LANG, scilab_entities[entity], cint(ts), cint(te),
             userdata);
  }

  scilab_comment_entity = ('//') @comment nonnewline*;

  scilab_entity := |*
    space+                ${ entity = SCILAB_SPACE;   } => scilab_ecallback;
    scilab_comment_entity ${ entity = SCILAB_COMMENT; } => scilab_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with SCILAB code.
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
void parse_scilab(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? scilab_en_scilab_line : scilab_en_scilab_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(SCILAB_LANG) }
}

#endif

/*****************************************************************************/
