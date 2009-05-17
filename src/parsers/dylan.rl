// dylan.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_DYLAN_PARSER_H
#define OHCOUNT_DYLAN_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *DYLAN_LANG = LANG_DYLAN;

// the languages entities
const char *dylan_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  DYLAN_SPACE = 0, DYLAN_COMMENT, DYLAN_STRING, DYLAN_ANY
};

/*****************************************************************************/

%%{
  machine dylan;
  write data;
  include common "common.rl";

  # Line counting machine

  action dylan_ccallback {
    switch(entity) {
    case DYLAN_SPACE:
      ls
      break;
    case DYLAN_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(DYLAN_LANG)
      break;
    case NEWLINE:
      std_newline(DYLAN_LANG)
    }
  }

  dylan_line_comment = '//' @comment nonnewline*;
  dylan_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %dylan_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  dylan_comment = dylan_line_comment | dylan_block_comment;

  dylan_char = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline) '\'';
  dylan_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  dylan_string = dylan_char | dylan_dq_str;

  dylan_line := |*
    spaces         ${ entity = DYLAN_SPACE; } => dylan_ccallback;
    dylan_comment;
    dylan_string;
    newline        ${ entity = NEWLINE;     } => dylan_ccallback;
    ^space         ${ entity = DYLAN_ANY;   } => dylan_ccallback;
  *|;

  # Entity machine

  action dylan_ecallback {
    callback(DYLAN_LANG, dylan_entities[entity], cint(ts), cint(te), userdata);
  }

  dylan_line_comment_entity = '//' nonnewline*;
  dylan_block_comment_entity = '/*' any* :>> '*/';
  dylan_comment_entity = dylan_line_comment_entity | dylan_block_comment_entity;

  dylan_entity := |*
    space+               ${ entity = DYLAN_SPACE;   } => dylan_ecallback;
    dylan_comment_entity ${ entity = DYLAN_COMMENT; } => dylan_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Dylan code.
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
void parse_dylan(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? dylan_en_dylan_line : dylan_en_dylan_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(DYLAN_LANG) }
}

#endif

/*****************************************************************************/
