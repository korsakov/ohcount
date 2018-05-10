// objective_c.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_OBJECTIVE_C_PARSER_H
#define OHCOUNT_OBJECTIVE_C_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *OBJC_LANG = LANG_OBJECTIVE_C;

// the languages entities
const char *objc_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  OBJC_SPACE = 0, OBJC_COMMENT, OBJC_STRING, OBJC_ANY,
};

/*****************************************************************************/

%%{
  machine objective_c;
  write data;
  include common "common.rl";

  # Line counting machine

  action objc_ccallback {
    switch(entity) {
    case OBJC_SPACE:
      ls
      break;
    case OBJC_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(OBJC_LANG)
      break;
    case NEWLINE:
      std_newline(OBJC_LANG)
    }
  }

  objc_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %objc_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;
    objc_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %objc_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  objc_comment = objc_line_comment | objc_block_comment;

  objc_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  objc_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  objc_string = objc_sq_str | objc_dq_str;

  objc_line := |*
    spaces        ${ entity = OBJC_SPACE; } => objc_ccallback;
    objc_comment;
    objc_string;
    newline       ${ entity = NEWLINE;    } => objc_ccallback;
    ^space        ${ entity = OBJC_ANY;   } => objc_ccallback;
  *|;

  # Entity machine

  action objc_ecallback {
    callback(OBJC_LANG, objc_entities[entity], cint(ts), cint(te), userdata);
  }

  objc_line_comment_entity = '//' (escaped_newline | nonnewline)*;
  objc_block_comment_entity = '/*' any* :>> '*/';
  objc_comment_entity = objc_line_comment_entity | objc_block_comment_entity;

  objc_entity := |*
    space+              ${ entity = OBJC_SPACE;   } => objc_ecallback;
    objc_comment_entity ${ entity = OBJC_COMMENT; } => objc_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Objective C code.
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
void parse_objective_c(char *buffer, int length, int count,
                       void (*callback) (const char *lang, const char *entity,
                                         int s, int e, void *udata),
                       void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? objective_c_en_objc_line : objective_c_en_objc_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(OBJC_LANG) }
}

#endif

/*****************************************************************************/
