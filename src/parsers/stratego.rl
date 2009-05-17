/************************* Required for every parser *************************/
#ifndef OHCOUNT_STRATEGO_PARSER_H
#define OHCOUNT_STRATEGO_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *STRATEGO_LANG = LANG_STRATEGO;

// the languages entities
const char *stratego_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  STRATEGO_SPACE = 0, STRATEGO_COMMENT, STRATEGO_STRING, STRATEGO_ANY
};

/*****************************************************************************/

%%{
  machine stratego;
  write data;
  include common "common.rl";

  # Line counting machine

  action stratego_ccallback {
    switch(entity) {
    case STRATEGO_SPACE:
      ls
      break;
    case STRATEGO_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(STRATEGO_LANG)
      break;
    case NEWLINE:
      std_newline(STRATEGO_LANG)
    }
  }

  stratego_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %stratego_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;

  stratego_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %stratego_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';

  stratego_comment = stratego_line_comment | stratego_block_comment;

  stratego_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %stratego_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';

  stratego_char_str =
    '\'' (
      ('\\' [.] '\'') @code
      |
      ([^'\\] '\'') @code
    );

  stratego_string = stratego_dq_str | stratego_char_str;

  stratego_line := |*
    spaces    ${ entity = STRATEGO_SPACE; } => stratego_ccallback;
    stratego_comment;
    stratego_string;
    newline   ${ entity = NEWLINE; } => stratego_ccallback;
    ^space    ${ entity = STRATEGO_ANY;   } => stratego_ccallback;
  *|;

  # Entity machine

  action stratego_ecallback {
    callback(STRATEGO_LANG, stratego_entities[entity], cint(ts), cint(te),
             userdata);
  }

  stratego_line_comment_entity = '//' (escaped_newline | nonnewline)*;
  stratego_block_comment_entity = '/*' any* :>> '*/';
  stratego_comment_entity = stratego_line_comment_entity | stratego_block_comment_entity;
  stratego_string_entity = dq_str_with_escapes | ('\'' (('\\' [.] '\'') | ([^'\\] '\'')));

  stratego_entity := |*
    space+                  ${ entity = STRATEGO_SPACE;   } => stratego_ecallback;
    stratego_comment_entity ${ entity = STRATEGO_COMMENT; } => stratego_ecallback;
    stratego_string_entity  ${ entity = STRATEGO_STRING;   } => stratego_ecallback;
    # TODO;
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Stratego code.
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
void parse_stratego(char *buffer, int length, int count,
                    void (*callback) (const char *lang, const char *entity,
                                      int s, int e, void *udata),
                    void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? stratego_en_stratego_line : stratego_en_stratego_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(STRATEGO_LANG) }
}

#endif

/*****************************************************************************/
