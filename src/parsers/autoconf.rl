// autoconf.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_AUTOCONF_PARSER_H
#define OHCOUNT_AUTOCONF_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *AC_LANG = LANG_AUTOCONF;

// the languages entities
const char *ac_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  AC_SPACE = 0, AC_COMMENT, AC_STRING, AC_ANY
};

/*****************************************************************************/

%%{
  machine autoconf;
  write data;
  include common "common.rl";

  # Line counting machine

  action ac_ccallback {
    switch(entity) {
    case AC_SPACE:
      ls
      break;
    case AC_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(AC_LANG)
      break;
    case NEWLINE:
      std_newline(AC_LANG)
    }
  }

  action ac_str_nc_res { nest_count = 0; }
  action ac_str_nc_inc { nest_count++; }
  action ac_str_nc_dec { nest_count--; }

  ac_comment = 'dnl' @comment (ws+ nonnewline+)?;

  ac_string =
    '[' >ac_str_nc_res @code (
      newline %{ entity = INTERNAL_NL; } %ac_ccallback
      |
      ws
      |
      '[' @ac_str_nc_inc @code
      |
      ']' @ac_str_nc_dec @code
      |
      (nonnewline - ws - [\[\]]) @code
    )* :>> (']' when { nest_count == 0 });

  ac_line := |*
    spaces      ${ entity = AC_SPACE; } => ac_ccallback;
    ac_comment;
    ac_string;
    newline     ${ entity = NEWLINE;  } => ac_ccallback;
    ^space      ${ entity = AC_ANY;   } => ac_ccallback;
  *|;

  # Entity machine

  action ac_ecallback {
    callback(AC_LANG, ac_entities[entity], cint(ts), cint(te), userdata);
  }

  ac_comment_entity = 'dnl' ws+ nonnewline*;

  ac_entity := |*
    space+            ${ entity = AC_SPACE;   } => ac_ecallback;
    ac_comment_entity ${ entity = AC_COMMENT; } => ac_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Autoconf code.
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
void parse_autoconf(char *buffer, int length, int count,
                    void (*callback) (const char *lang, const char *entity,
                                      int s, int e, void *udata),
                    void *userdata
  ) {
  init

  int nest_count = 0;

  %% write init;
  cs = (count) ? autoconf_en_ac_line : autoconf_en_ac_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(AC_LANG) }
}

#endif

/*****************************************************************************/
