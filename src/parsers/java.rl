// java.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_JAVA_PARSER_H
#define OHCOUNT_JAVA_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *JAVA_LANG = LANG_JAVA;

// the languages entities
const char *java_entities[] = {
  "space", "comment", "string", "number",
  "keyword", "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  JAVA_SPACE = 0, JAVA_COMMENT, JAVA_STRING, JAVA_NUMBER,
  JAVA_KEYWORD, JAVA_IDENTIFIER, JAVA_OPERATOR, JAVA_ANY
};

/*****************************************************************************/

%%{
  machine java;
  write data;
  include common "common.rl";

  # Line counting machine

  action java_ccallback {
    switch(entity) {
    case JAVA_SPACE:
      ls
      break;
    case JAVA_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(JAVA_LANG)
      break;
    case NEWLINE:
      std_newline(JAVA_LANG)
    }
  }

  java_line_comment = '//' @comment nonnewline*;
  java_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %java_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  java_comment = java_line_comment | java_block_comment;

  java_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  java_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  java_string = java_sq_str | java_dq_str;

  java_line := |*
    spaces        ${ entity = JAVA_SPACE; } => java_ccallback;
    java_comment;
    java_string;
    newline       ${ entity = NEWLINE;    } => java_ccallback;
    ^space        ${ entity = JAVA_ANY;   } => java_ccallback;
  *|;

  # Entity machine

  action java_ecallback {
    callback(JAVA_LANG, java_entities[entity], cint(ts), cint(te), userdata);
  }

  java_line_comment_entity = '//' nonnewline*;
  java_block_comment_entity = '/*' any* :>> '*/';
  java_comment_entity = java_line_comment_entity | java_block_comment_entity;

  java_entity := |*
    space+              ${ entity = JAVA_SPACE;   } => java_ecallback;
    java_comment_entity ${ entity = JAVA_COMMENT; } => java_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Java code.
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
void parse_java(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? java_en_java_line : java_en_java_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(JAVA_LANG) }
}

#endif

/*****************************************************************************/
