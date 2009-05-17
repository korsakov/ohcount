// objective_j.rl written by Francisco tolmasky. francisco<att>280north<dott>com.
// Modified from file by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_OBJECTIVE_J_PARSER_H
#define OHCOUNT_OBJECTIVE_J_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *OBJJ_LANG = LANG_OBJECTIVE_J;

// the languages entities
const char *objj_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  OBJJ_SPACE = 0, OBJJ_COMMENT, OBJJ_STRING, OBJJ_ANY,
};

/*****************************************************************************/

%%{
  machine objective_j;
  write data;
  include common "common.rl";

  # Line counting machine

  action objj_ccallback {
    switch(entity) {
    case OBJJ_SPACE:
      ls
      break;
    case OBJJ_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(OBJJ_LANG)
      break;
    case NEWLINE:
      std_newline(OBJJ_LANG)
    }
  }

  objj_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %objj_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;
    objj_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %objj_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  objj_comment = objj_line_comment | objj_block_comment;

  objj_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  objj_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  objj_string = objj_sq_str | objj_dq_str;

  objj_line := |*
    spaces        ${ entity = OBJJ_SPACE; } => objj_ccallback;
    objj_comment;
    objj_string;
    newline       ${ entity = NEWLINE;    } => objj_ccallback;
    ^space        ${ entity = OBJJ_ANY;   } => objj_ccallback;
  *|;

  # Entity machine

  action objj_ecallback {
    callback(OBJJ_LANG, objj_entities[entity], cint(ts), cint(te), userdata);
  }

  objj_line_comment_entity = '//' (escaped_newline | nonnewline)*;
  objj_block_comment_entity = '/*' any* :>> '*/';
  objj_comment_entity = objj_line_comment_entity | objj_block_comment_entity;

  objj_entity := |*
    space+              ${ entity = OBJJ_SPACE;   } => objj_ecallback;
    objj_comment_entity ${ entity = OBJJ_COMMENT; } => objj_ecallback;
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
void parse_objective_j(char *buffer, int length, int count,
                       void (*callback) (const char *lang, const char *entity,
                                         int s, int e, void *udata),
                       void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? objective_j_en_objj_line : objective_j_en_objj_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(OBJJ_LANG) }
}

#endif

/*****************************************************************************/
