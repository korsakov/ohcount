// modula3.rl, 
// derived from code written by Mitchell Foral. mitchell<att>caladbolg<dott>net


/************************* Required for every parser *************************/
#ifndef OHCOUNT_MODULA3_PARSER_H
#define OHCOUNT_MODULA3_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *MODULA3_LANG = LANG_MODULA3;

// the languages entities
const char *modula3_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  MODULA3_SPACE = 0, MODULA3_COMMENT, MODULA3_STRING, MODULA3_ANY
};

/*****************************************************************************/

%%{
  machine modula3;
  write data;
  include common "common.rl";

  # Line counting machine

  action modula3_ccallback {
    switch(entity) {
    case MODULA3_SPACE:
      ls
      break;
    case MODULA3_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(MODULA3_LANG)
      break;
    case NEWLINE:
      std_newline(MODULA3_LANG)
    }
  }


  # Modula-3 comments

  action modula3_comment_nc_res { nest_count = 0; }
  action modula3_comment_nc_inc { nest_count++; }
  action modula3_comment_nc_dec { nest_count--; }

  modula3_comment =
    '(*' >modula3_comment_nc_res @comment (
      newline %{ entity = INTERNAL_NL; } %modula3_ccallback
      |
      ws
      |
      '(*' @modula3_comment_nc_inc @comment
      |
      '*)' @modula3_comment_nc_dec @comment
      |
      ^space @comment
    )* :>> ('*)' when { nest_count == 0 }) @comment;


  # Modula-3 string literals

  modula3_singlequoted_string =
    '\'' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %modula3_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  modula3_doublequoted_string =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %modula3_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  modula3_string = modula3_singlequoted_string | modula3_doublequoted_string;


  # Line counter

  modula3_line := |*
    spaces          ${ entity = MODULA3_SPACE; } => modula3_ccallback;
    modula3_comment;
    modula3_string;
    newline         ${ entity = NEWLINE;       } => modula3_ccallback;
    ^space          ${ entity = MODULA3_ANY;   } => modula3_ccallback;
  *|;


  # Entity machine

  action modula3_ecallback {
    callback(MODULA3_LANG, modula3_entities[entity], cint(ts), cint(te),
             userdata);
  }

  modula3_comment_entity = '(*' >modula3_comment_nc_res (
    '(*' @modula3_comment_nc_inc
    |
    '*)' @modula3_comment_nc_dec
    |
    any
  )* :>> ('*)' when { nest_count == 0 });

  modula3_string_entity = sq_str_with_escapes |
                          dq_str_with_escapes;

  modula3_entity := |*
    space+                 ${ entity = MODULA3_SPACE;   } => modula3_ecallback;
    modula3_comment_entity ${ entity = MODULA3_COMMENT; } => modula3_ecallback;
    modula3_string_entity  ${ entity = MODULA3_STRING;  } => modula3_ecallback;
    # TODO: detecting other entities may be useful to differentiate dialects
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Modula-3 code.
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
void parse_modula3(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  int nest_count = 0;

  %% write init;
  cs = (count) ? modula3_en_modula3_line : modula3_en_modula3_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(MODULA3_LANG) }
}

#endif

/*****************************************************************************/
