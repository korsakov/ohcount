// vhdl.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_VHDL_PARSER_H
#define OHCOUNT_VHDL_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *VHDL_LANG = LANG_VHDL;

// the languages entities
const char *vhdl_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  VHDL_SPACE = 0, VHDL_COMMENT, VHDL_STRING, VHDL_ANY
};

/*****************************************************************************/

%%{
  machine vhdl;
  write data;
  include common "common.rl";

  # Line counting machine

  action vhdl_ccallback {
    switch(entity) {
    case VHDL_SPACE:
      ls
      break;
    case VHDL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(VHDL_LANG)
      break;
    case NEWLINE:
      std_newline(VHDL_LANG)
    }
  }

  vhdl_comment = '--' @comment nonnewline*;

  vhdl_char = '\'' @code [^\r\n\f'] '\'';
  vhdl_dq_str = '"' @code [^\r\n\f"]* '"';
  vhdl_string = vhdl_char | vhdl_dq_str;

  vhdl_line := |*
    spaces        ${ entity = VHDL_SPACE; } => vhdl_ccallback;
    vhdl_comment;
    vhdl_string;
    newline       ${ entity = NEWLINE;    } => vhdl_ccallback;
    ^space        ${ entity = VHDL_ANY;   } => vhdl_ccallback;
  *|;

  # Entity machine

  action vhdl_ecallback {
    callback(VHDL_LANG, vhdl_entities[entity], cint(ts), cint(te), userdata);
  }

  vhdl_comment_entity = '--' nonnewline*;

  vhdl_entity := |*
    space+ ${ entity = VHDL_SPACE; } => vhdl_ecallback;
    vhdl_comment_entity ${ entity = VHDL_COMMENT; } => vhdl_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with VHDL code.
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
void parse_vhdl(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? vhdl_en_vhdl_line : vhdl_en_vhdl_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(VHDL_LANG) }
}

#endif

/*****************************************************************************/
