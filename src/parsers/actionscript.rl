// actionscript.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_ACTIONSCRIPT_PARSER_H
#define OHCOUNT_ACTIONSCRIPT_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *AS_LANG = LANG_ACTIONSCRIPT;

// the languages entities
const char *as_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  AS_SPACE = 0, AS_COMMENT, AS_STRING, AS_ANY
};

/*****************************************************************************/

%%{
  machine actionscript;
  write data;
  include common "common.rl";

  # Line counting machine

  action as_ccallback {
    switch(entity) {
    case AS_SPACE:
      ls
      break;
    case AS_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(AS_LANG)
      break;
    case NEWLINE:
      std_newline(AS_LANG)
    }
  }

  as_line_comment = '//' @comment nonnewline*;
  as_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %as_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  as_comment = as_line_comment | as_block_comment;

  as_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  as_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  as_ml_str = '<![CDATA[' @code (
    newline %{ entity = INTERNAL_NL; } %as_ccallback
    |
    ws
    |
    (nonnewline - ws) @code
  )* :>> ']]>';
  as_string = as_sq_str | as_dq_str | as_ml_str;

  as_line := |*
    spaces      ${ entity = AS_SPACE; } => as_ccallback;
    as_comment;
    as_string;
    newline     ${ entity = NEWLINE;  } => as_ccallback;
    ^space      ${ entity = AS_ANY;   } => as_ccallback;
  *|;

  # Entity machine

  action as_ecallback {
    callback(AS_LANG, as_entities[entity], cint(ts), cint(te), userdata);
  }

  as_line_comment_entity = '//' nonnewline*;
  as_block_comment_entity = '/*' any* :>> '*/';
  as_comment_entity = as_line_comment_entity | as_block_comment_entity;

  as_entity := |*
    space+            ${ entity = AS_SPACE;   } => as_ecallback;
    as_comment_entity ${ entity = AS_COMMENT; } => as_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Actionscript code.
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
void parse_actionscript(char *buffer, int length, int count,
                        void (*callback) (const char *lang, const char *entity,
                                          int s, int e, void *udata),
                        void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? actionscript_en_as_line : actionscript_en_as_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(AS_LANG) }
}

#endif

/*****************************************************************************/
