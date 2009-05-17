// dcl.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_DCL_PARSER_H
#define OHCOUNT_DCL_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *DCL_LANG = LANG_DCL;

// the languages entities
const char *dcl_entities[] = {
  "space", "line_start", "comment", "string", "any"
};

// constants associated with the entities
enum {
  DCL_SPACE = 0, DCL_LINE_START, DCL_COMMENT, DCL_STRING, DCL_ANY
};

/*****************************************************************************/

%%{
  machine dcl;
  write data;
  include common "common.rl";

  # Line counting machine

  action dcl_ccallback {
    switch(entity) {
    case DCL_SPACE:
    case DCL_LINE_START:
      ls
      break;
    case DCL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(DCL_LANG)
      break;
    case NEWLINE:
      std_newline(DCL_LANG)
    }
  }

  dcl_comment = '!' @comment nonnewline*;

  dcl_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  dcl_line := |*
    '$'            ${ entity = DCL_LINE_START; } => dcl_ccallback;
    spaces         ${ entity = DCL_SPACE;      } => dcl_ccallback;
    dcl_comment;
    dcl_string;
    newline        ${ entity = NEWLINE;        } => dcl_ccallback;
    ^(space | '$') ${ entity = DCL_ANY;        } => dcl_ccallback;
  *|;

  # Entity machine

  action dcl_ecallback {
    callback(DCL_LANG, dcl_entities[entity], cint(ts), cint(te), userdata);
  }

  dcl_comment_entity = '!' nonnewline*;

  dcl_entity := |*
    space+             ${ entity = DCL_SPACE;   } => dcl_ecallback;
    dcl_comment_entity ${ entity = DCL_COMMENT; } => dcl_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with DCL code.
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
void parse_dcl(char *buffer, int length, int count,
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? dcl_en_dcl_line : dcl_en_dcl_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(DCL_LANG) }
}

#endif

/*****************************************************************************/
