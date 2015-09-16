// shell.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_SHELL_PARSER_H
#define OHCOUNT_SHELL_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *SHELL_LANG = LANG_SHELL;

// the languages entities
const char *shell_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  SHELL_SPACE = 0, SHELL_COMMENT, SHELL_STRING, SHELL_ANY
};

/*****************************************************************************/

%%{
  machine shell;
  write data;
  include common "common.rl";

  # Line counting machine

  action shell_ccallback {
    switch(entity) {
    case SHELL_SPACE:
      ls
      break;
    case SHELL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(SHELL_LANG)
      break;
    case NEWLINE:
      std_newline(SHELL_LANG)
    }
  }

  shell_comment = '#' @comment nonnewline*;

  shell_sq_str =
    '\'' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %shell_ccallback
      |
      ws
      |
      [^\r\n\f\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'' @commit;
  shell_dq_str =
    '"' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %shell_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"' @commit;
  # TODO: heredocs; see ruby.rl for details
  shell_string = shell_sq_str | shell_dq_str;

  shell_line := |*
    spaces         ${ entity = SHELL_SPACE; } => shell_ccallback;
    shell_comment;
    shell_string;
    newline        ${ entity = NEWLINE;     } => shell_ccallback;
    ^space         ${ entity = SHELL_ANY;   } => shell_ccallback;
  *|;

  # Entity machine

  action shell_ecallback {
    callback(SHELL_LANG, shell_entities[entity], cint(ts), cint(te), userdata);
  }

  shell_comment_entity = '#' nonnewline*;

  shell_entity := |*
    space+               ${ entity = SHELL_SPACE;   } => shell_ecallback;
    shell_comment_entity ${ entity = SHELL_COMMENT; } => shell_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Shell code.
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
void parse_shell(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? shell_en_shell_line : shell_en_shell_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(SHELL_LANG) }
}

#endif

/*****************************************************************************/
