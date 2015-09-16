// pike.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_PIKE_PARSER_H
#define OHCOUNT_PIKE_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *PIKE_LANG = LANG_PIKE;

// the languages entities
const char *pike_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  PIKE_SPACE = 0, PIKE_COMMENT, PIKE_STRING, PIKE_ANY
};

/*****************************************************************************/

%%{
  machine pike;
  write data;
  include common "common.rl";

  # Line counting machine

  action pike_ccallback {
    switch(entity) {
    case PIKE_SPACE:
      ls
      break;
    case PIKE_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(PIKE_LANG)
      break;
    case NEWLINE:
      std_newline(PIKE_LANG)
    }
  }

  pike_line_comment = '//' @comment nonnewline*;
  pike_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %pike_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  pike_comment = pike_line_comment | pike_block_comment;

  pike_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  pike_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  pike_string = pike_sq_str | pike_dq_str;

  pike_line := |*
    spaces        ${ entity = PIKE_SPACE; } => pike_ccallback;
    pike_comment;
    pike_string;
    newline       ${ entity = NEWLINE;    } => pike_ccallback;
    ^space        ${ entity = PIKE_ANY;   } => pike_ccallback;
  *|;

  # Entity machine

  action pike_ecallback {
    callback(PIKE_LANG, pike_entities[entity], cint(ts), cint(te), userdata);
  }

  pike_line_comment_entity = '//' nonnewline*;
  pike_block_comment_entity = '/*' any* :>> '*/';
  pike_comment_entity = pike_line_comment_entity | pike_block_comment_entity;

  pike_entity := |*
    space+              ${ entity = PIKE_SPACE;   } => pike_ecallback;
    pike_comment_entity ${ entity = PIKE_COMMENT; } => pike_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Pike code.
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
void parse_pike(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? pike_en_pike_line : pike_en_pike_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(PIKE_LANG) }
}

#endif

/*****************************************************************************/
