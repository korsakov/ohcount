// scheme.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef RAGEL_SCHEME_PARSER
#define RAGEL_SCHEME_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *SCHEME_LANG = "scheme";

// the languages entities
const char *scheme_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  SCHEME_SPACE = 0, SCHEME_COMMENT, SCHEME_STRING, SCHEME_ANY
};

/*****************************************************************************/

%%{
  machine scheme;
  write data;
  include common "common.rl";

  # Line counting machine

  action scheme_ccallback {
    switch(entity) {
    case SCHEME_SPACE:
      ls
      break;
    case SCHEME_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(SCHEME_LANG)
      break;
    case NEWLINE:
      std_newline(SCHEME_LANG)
    }
  }

  scheme_comment = ';' @comment nonnewline*;

  scheme_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  scheme_line := |*
    spaces        ${ entity = SCHEME_SPACE; } => scheme_ccallback;
    scheme_comment;
    scheme_string;
    newline       ${ entity = NEWLINE;    } => scheme_ccallback;
    ^space        ${ entity = SCHEME_ANY;   } => scheme_ccallback;
  *|;

  # Entity machine

  action scheme_ecallback {
    callback(SCHEME_LANG, scheme_entities[entity], cint(ts), cint(te));
  }

  scheme_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Scheme code.
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
void parse_scheme(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  init

  %% write init;
  cs = (count) ? scheme_en_scheme_line : scheme_en_scheme_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(SCHEME_LANG) }
}

#endif

/*****************************************************************************/
