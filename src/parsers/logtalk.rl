// logtalk.rl written by Paulo Moura. pmoura<att>logtalk<dott>org.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_LOGTALK_PARSER_H
#define OHCOUNT_LOGTALK_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *LOGTALK_LANG = LANG_LOGTALK;

// the languages entities
const char *logtalk_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  LOGTALK_SPACE = 0, LOGTALK_COMMENT, LOGTALK_STRING, LOGTALK_ANY
};

/*****************************************************************************/

%%{
  machine logtalk;
  write data;
  include common "common.rl";

  # Line counting machine

  action logtalk_ccallback {
    switch(entity) {
    case LOGTALK_SPACE:
      ls
      break;
    case LOGTALK_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(LOGTALK_LANG)
      break;
    case NEWLINE:
      std_newline(LOGTALK_LANG)
    }
  }

  logtalk_line_comment = '%' @comment nonnewline*;
  logtalk_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %logtalk_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  logtalk_comment = logtalk_line_comment | logtalk_block_comment;

  logtalk_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  logtalk_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  logtalk_string = logtalk_sq_str | logtalk_dq_str;

  logtalk_line := |*
    spaces      ${ entity = LOGTALK_SPACE; } => logtalk_ccallback;
    logtalk_comment;
    logtalk_string;
    newline     ${ entity = NEWLINE;   } => logtalk_ccallback;
    ^space      ${ entity = LOGTALK_ANY;   } => logtalk_ccallback;
  *|;

  # Entity machine

  action logtalk_ecallback {
    callback(LOGTALK_LANG, logtalk_entities[entity], cint(ts), cint(te),
             userdata);
  }

  logtalk_line_comment_entity = '%' nonnewline*;
  logtalk_block_comment_entity = '/*' any* :>> '*/';
  logtalk_comment_entity = logtalk_line_comment_entity | logtalk_block_comment_entity;

  logtalk_entity := |*
    space+                ${ entity = LOGTALK_SPACE;   } => logtalk_ecallback;
    logtalk_comment_entity ${ entity = LOGTALK_COMMENT; } => logtalk_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Logtalk code.
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
void parse_logtalk(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? logtalk_en_logtalk_line : logtalk_en_logtalk_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(LOGTALK_LANG) }
}

#endif

/*****************************************************************************/
