// modula2.rl, 
// derived from code written by Mitchell Foral. mitchell<att>caladbolg<dott>net


/************************* Required for every parser *************************/
#ifndef OHCOUNT_MODULA2_PARSER_H
#define OHCOUNT_MODULA2_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *MODULA2_LANG = LANG_MODULA2;

// the languages entities
const char *modula2_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  MODULA2_SPACE = 0, MODULA2_COMMENT, MODULA2_STRING, MODULA2_ANY
};

/*****************************************************************************/

%%{
  machine modula2;
  write data;
  include common "common.rl";

  # Line counting machine

  action modula2_ccallback {
    switch(entity) {
    case MODULA2_SPACE:
      ls
      break;
    case MODULA2_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(MODULA2_LANG)
      break;
    case NEWLINE:
      std_newline(MODULA2_LANG)
    }
  }


  # Modula-2 comments

  action modula2_comment_nc_res { nest_count = 0; }
  action modula2_comment_nc_inc { nest_count++; }
  action modula2_comment_nc_dec { nest_count--; }

  modula2_comment =
    '(*' >modula2_comment_nc_res @comment (
      newline %{ entity = INTERNAL_NL; } %modula2_ccallback
      |
      ws
      |
      '(*' @modula2_comment_nc_inc @comment
      |
      '*)' @modula2_comment_nc_dec @comment
      |
      ^space @comment
    )* :>> ('*)' when { nest_count == 0 }) @comment;


  # Modula-2 string literals

  modula2_singlequoted_string = '\'' @code [^\r\n\f"]* '\'';
  modula2_doublequoted_string = '"' @code [^\r\n\f"]* '"';

  modula2_string = modula2_singlequoted_string | modula2_doublequoted_string;


  # Line counter

  modula2_line := |*
    spaces          ${ entity = MODULA2_SPACE; } => modula2_ccallback;
    modula2_comment;
    modula2_string;
    newline         ${ entity = NEWLINE;       } => modula2_ccallback;
    ^space          ${ entity = MODULA2_ANY;   } => modula2_ccallback;
  *|;


  # Entity machine

  action modula2_ecallback {
    callback(MODULA2_LANG, modula2_entities[entity], cint(ts), cint(te),
             userdata);
  }

  modula2_comment_entity = '(*' >modula2_comment_nc_res (
    '(*' @modula2_comment_nc_inc
    |
    '*)' @modula2_comment_nc_dec
    |
    any
  )* :>> ('*)' when { nest_count == 0 });

  modula2_string_entity = sq_str | dq_str;

  modula2_entity := |*
    space+                 ${ entity = MODULA2_SPACE;   } => modula2_ecallback;
    modula2_comment_entity ${ entity = MODULA2_COMMENT; } => modula2_ecallback;
    modula2_string_entity  ${ entity = MODULA2_STRING;  } => modula2_ecallback;
    # TODO: detecting other entities may be useful to differentiate dialects
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Modula-2 code.
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
void parse_modula2(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  int nest_count = 0;

  %% write init;
  cs = (count) ? modula2_en_modula2_line : modula2_en_modula2_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(MODULA2_LANG) }
}

#endif

/*****************************************************************************/
