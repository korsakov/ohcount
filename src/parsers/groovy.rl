// groovy.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_GROOVY_PARSER_H
#define OHCOUNT_GROOVY_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *GROOVY_LANG = LANG_GROOVY;

// the languages entities
const char *groovy_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  GROOVY_SPACE = 0, GROOVY_COMMENT, GROOVY_STRING, GROOVY_ANY
};

/*****************************************************************************/

%%{
  machine groovy;
  write data;
  include common "common.rl";

  # Line counting machine

  action groovy_ccallback {
    switch(entity) {
    case GROOVY_SPACE:
      ls
      break;
    case GROOVY_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(GROOVY_LANG)
      break;
    case NEWLINE:
      std_newline(GROOVY_LANG)
    }
  }

  groovy_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %groovy_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;
  groovy_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %groovy_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  groovy_comment = groovy_line_comment | groovy_block_comment;

  groovy_sq_str =
    '\'' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %groovy_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  groovy_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %groovy_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  groovy_string = groovy_sq_str | groovy_dq_str;

  groovy_line := |*
    spaces          ${ entity = GROOVY_SPACE; } => groovy_ccallback;
    groovy_comment;
    groovy_string;
    newline         ${ entity = NEWLINE;      } => groovy_ccallback;
    ^space          ${ entity = GROOVY_ANY;   } => groovy_ccallback;
  *|;

  # Entity machine

  action groovy_ecallback {
    callback(GROOVY_LANG, groovy_entities[entity], cint(ts), cint(te),
             userdata);
  }

  groovy_line_comment_entity = '//' (escaped_newline | nonnewline)*;
  groovy_block_comment_entity = '/*' any* :>> '*/';
  groovy_comment_entity =
    groovy_line_comment_entity | groovy_block_comment_entity;

  groovy_entity := |*
    space+                ${ entity = GROOVY_SPACE;   } => groovy_ecallback;
    groovy_comment_entity ${ entity = GROOVY_COMMENT; } => groovy_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/* Parses a string buffer with Groovy code.
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
void parse_groovy(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? groovy_en_groovy_line : groovy_en_groovy_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(GROOVY_LANG) }
}

#endif
