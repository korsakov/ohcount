// Chaiscript.rl written by Jason Turner. lefticus<att>gmail<dott>com
// based on Javascript.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_CHAISCRIPT_PARSER_H
#define OHCOUNT_CHAISCRIPT_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *CHAI_LANG = LANG_CHAISCRIPT;

// the languages entities
const char *chai_entities[] = {
  "space", "comment", "string", "number", "keyword",
  "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  CHAI_SPACE = 0, CHAI_COMMENT, CHAI_STRING, CHAI_NUMBER, CHAI_KEYWORD,
  CHAI_IDENTIFIER, CHAI_OPERATOR, CHAI_ANY
};

/*****************************************************************************/

%%{
  machine chaiscript;
  write data;
  include common "common.rl";

  # Line counting machine

  action chai_ccallback {
    switch(entity) {
    case CHAI_SPACE:
      ls
      break;
    case CHAI_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(CHAI_LANG)
      break;
    case NEWLINE:
      std_newline(CHAI_LANG)
    }
  }

  chai_line_comment = '//' @comment nonnewline*;
  chai_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %chai_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  chai_comment = chai_line_comment | chai_block_comment;

  # Does Javascript allow newlines inside strings?
  # I can't find a definitive answer.
  chai_sq_str =
    '\'' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %chai_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  chai_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %chai_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  chai_regex_str = '/' [^/*] ([^\r\n\f/\\] | '\\' nonnewline)* '/' @code;
  chai_string = chai_sq_str | chai_dq_str | chai_regex_str;

  chai_line := |*
    spaces     ${ entity = CHAI_SPACE; } => chai_ccallback;
    chai_comment;
    chai_string;
    newline    ${ entity = NEWLINE;  } => chai_ccallback;
    ^space     ${ entity = CHAI_ANY;   } => chai_ccallback;
  *|;

  # Entity machine

  action chai_ecallback {
    callback(CHAI_LANG, chai_entities[entity], cint(ts), cint(te), userdata);
  }

  chai_line_comment_entity = '//' nonnewline*;
  chai_block_comment_entity = '/*' any* :>> '*/';
  chai_comment_entity = chai_line_comment_entity | chai_block_comment_entity;

  chai_entity := |*
    space+            ${ entity = CHAI_SPACE;   } => chai_ecallback;
    chai_comment_entity ${ entity = CHAI_COMMENT; } => chai_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/* Parses a string buffer with Chaiscript code.
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
void parse_chaiscript(char *buffer, int length, int count,
                      void (*callback) (const char *lang, const char *entity,
                                        int s, int e, void *udata),
                      void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? chaiscript_en_chai_line : chaiscript_en_chai_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(CHAI_LANG) }
}

#endif
