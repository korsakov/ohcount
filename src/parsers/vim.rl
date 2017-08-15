// vim.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_VIM_PARSER_H
#define OHCOUNT_VIM_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *VIM_LANG = LANG_VIM;

// the languages entities
const char *vim_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  VIM_SPACE = 0, VIM_COMMENT, VIM_STRING, VIM_ANY
};

/*****************************************************************************/

%%{
  machine vim;
  write data;
  include common "common.rl";

  # Line counting machine

  action vim_ccallback {
    switch(entity) {
    case VIM_SPACE:
      ls
      break;
    case VIM_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(VIM_LANG)
      break;
    case NEWLINE:
      std_newline(VIM_LANG)
    }
  }

  vim_comment = '"' when no_code  @comment nonnewline*;

  vim_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' any)* '\'';
  vim_dq_str = '"' when !no_code @code ([^\r\n\f"\\] | '\\' any)* '"';
  vim_string = vim_sq_str | vim_dq_str;

  vim_line := |*
    spaces         ${ entity = VIM_SPACE; } => vim_ccallback;
    vim_comment;
    vim_string;
    newline        ${ entity = NEWLINE;   } => vim_ccallback;
    #'"';
    ^(space | '"') ${ entity = VIM_ANY;   } => vim_ccallback;

  *|;

  # Entity machine

  action vim_ecallback {
    callback(VIM_LANG, vim_entities[entity], cint(ts), cint(te), userdata);
  }

  vim_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Vim code.
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
void parse_vim(char *buffer, int length, int count,
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? vim_en_vim_line : vim_en_vim_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(VIM_LANG) }
}

#endif

/*****************************************************************************/
