// prolog.rl written by Paulo Moura. pmoura<att>prolog<dott>org.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_PROLOG_PARSER_H
#define OHCOUNT_PROLOG_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *PROLOG_LANG = LANG_PROLOG;

// the languages entities
const char *prolog_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  PROLOG_SPACE = 0, PROLOG_COMMENT, PROLOG_STRING, PROLOG_ANY
};

/*****************************************************************************/

%%{
  machine prolog;
  write data;
  include common "common.rl";

  # Line counting machine

  action prolog_ccallback {
    switch(entity) {
    case PROLOG_SPACE:
      ls
      break;
    case PROLOG_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(PROLOG_LANG)
      break;
    case NEWLINE:
      std_newline(PROLOG_LANG)
    }
  }

  prolog_line_comment = '%' @comment nonnewline*;
  prolog_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %prolog_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  prolog_comment = prolog_line_comment | prolog_block_comment;

  prolog_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  prolog_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  prolog_string = prolog_sq_str | prolog_dq_str;

  prolog_line := |*
    spaces      ${ entity = PROLOG_SPACE; } => prolog_ccallback;
    prolog_comment;
    prolog_string;
    newline     ${ entity = NEWLINE;   } => prolog_ccallback;
    ^space      ${ entity = PROLOG_ANY;   } => prolog_ccallback;
  *|;

  # Entity machine

  action prolog_ecallback {
    callback(PROLOG_LANG, prolog_entities[entity], cint(ts), cint(te),
             userdata);
  }

  prolog_line_comment_entity = '%' nonnewline*;
  prolog_block_comment_entity = '/*' any* :>> '*/';
  prolog_comment_entity = prolog_line_comment_entity | prolog_block_comment_entity;

  prolog_entity := |*
    space+                ${ entity = PROLOG_SPACE;   } => prolog_ecallback;
    prolog_comment_entity ${ entity = PROLOG_COMMENT; } => prolog_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Prolog code.
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
void parse_prolog(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? prolog_en_prolog_line : prolog_en_prolog_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(PROLOG_LANG) }
}

#endif

/*****************************************************************************/
