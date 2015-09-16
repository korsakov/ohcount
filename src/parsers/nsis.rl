// nsis.rl written by Chris Morgan.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_NSIS_PARSER_H
#define OHCOUNT_NSIS_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *NSIS_LANG = LANG_NSIS;

// the languages entities
const char *nsis_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  NSIS_SPACE = 0, NSIS_COMMENT, NSIS_STRING, NSIS_ANY
};

/*****************************************************************************/

%%{
  machine nsis;
  write data;
  include common "common.rl";

  # Line counting machine

  action nsis_ccallback {
    switch(entity) {
    case NSIS_SPACE:
      ls
      break;
    case NSIS_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(NSIS_LANG)
      break;
    case NEWLINE:
      std_newline(NSIS_LANG)
    }
  }

  nsis_line_comment = ('#' | ';') @comment nonnewline*;
  nsis_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %nsis_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  nsis_comment = nsis_line_comment | nsis_block_comment;

  nsis_bt_str = '`' @code ([^\r\n\f`\\] | '\\' nonnewline)* '`';
  nsis_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  nsis_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  nsis_string = nsis_bt_str | nsis_sq_str | nsis_dq_str;

  nsis_line := |*
    spaces        ${ entity = NSIS_SPACE; } => nsis_ccallback;
    nsis_comment;
    nsis_string;
    newline       ${ entity = NEWLINE;    } => nsis_ccallback;
    ^space        ${ entity = NSIS_ANY;   } => nsis_ccallback;
  *|;

  # Entity machine

  action nsis_ecallback {
    callback(NSIS_LANG, nsis_entities[entity], cint(ts), cint(te), userdata);
  }

  nsis_line_comment_entity = ('#' | '//') nonnewline*;
  nsis_block_comment_entity = '/*' any* :>> '*/';
  nsis_comment_entity = nsis_line_comment_entity | nsis_block_comment_entity;

  nsis_entity := |*
    space+              ${ entity = NSIS_SPACE;   } => nsis_ecallback;
    nsis_comment_entity ${ entity = NSIS_COMMENT; } => nsis_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with NSIS code.
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
void parse_nsis(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? nsis_en_nsis_line : nsis_en_nsis_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(NSIS_LANG) }
}

#endif

/*****************************************************************************/
