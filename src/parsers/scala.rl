// scala.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_SCALA_PARSER_H
#define OHCOUNT_SCALA_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *SCALA_LANG = LANG_SCALA;

// the languages entities
const char *scala_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  SCALA_SPACE = 0, SCALA_COMMENT, SCALA_STRING, SCALA_ANY
};

/*****************************************************************************/

%%{
  machine scala;
  write data;
  include common "common.rl";

  # Line counting machine

  action scala_ccallback {
    switch(entity) {
    case SCALA_SPACE:
      ls
      break;
    case SCALA_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(SCALA_LANG)
      break;
    case NEWLINE:
      std_newline(SCALA_LANG)
    }
  }

  scala_line_comment = '//' @comment nonnewline*;
  scala_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %scala_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  scala_comment = scala_line_comment | scala_block_comment;

  scala_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  scala_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  scala_string = scala_sq_str | scala_dq_str;

  scala_line := |*
    spaces         ${ entity = SCALA_SPACE; } => scala_ccallback;
    scala_comment;
    scala_string;
    newline        ${ entity = NEWLINE;     } => scala_ccallback;
    ^space         ${ entity = SCALA_ANY;   } => scala_ccallback;
  *|;

  # Entity machine

  action scala_ecallback {
    callback(SCALA_LANG, scala_entities[entity], cint(ts), cint(te), userdata);
  }

  scala_line_comment_entity = '//' nonnewline*;
  scala_block_comment_entity = '/*' any* :>> '*/';
  scala_comment_entity = scala_line_comment_entity | scala_block_comment_entity;

  scala_entity := |*
    space+               ${ entity = SCALA_SPACE;   } => scala_ecallback;
    scala_comment_entity ${ entity = SCALA_COMMENT; } => scala_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Scala code.
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
void parse_scala(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? scala_en_scala_line : scala_en_scala_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(SCALA_LANG) }
}

#endif

/*****************************************************************************/
