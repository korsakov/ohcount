// oberon.rl, 
// derived from code written by Mitchell Foral. mitchell<att>caladbolg<dott>net


/************************* Required for every parser *************************/
#ifndef OHCOUNT_OBERON_PARSER_H
#define OHCOUNT_OBERON_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *OBERON_LANG = LANG_OBERON;

// the languages entities
const char *oberon_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  OBERON_SPACE = 0, OBERON_COMMENT, OBERON_STRING, OBERON_ANY
};

/*****************************************************************************/

%%{
  machine oberon;
  write data;
  include common "common.rl";

  # Line counting machine

  action oberon_ccallback {
    switch(entity) {
    case OBERON_SPACE:
      ls
      break;
    case OBERON_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(OBERON_LANG)
      break;
    case NEWLINE:
      std_newline(OBERON_LANG)
    }
  }


  # Oberon comments

  action oberon_comment_nc_res { nest_count = 0; }
  action oberon_comment_nc_inc { nest_count++; }
  action oberon_comment_nc_dec { nest_count--; }

  oberon_comment =
    '(*' >oberon_comment_nc_res @comment (
      newline %{ entity = INTERNAL_NL; } %oberon_ccallback
      |
      ws
      |
      '(*' @oberon_comment_nc_inc @comment
      |
      '*)' @oberon_comment_nc_dec @comment
      |
      ^space @comment
    )* :>> ('*)' when { nest_count == 0 }) @comment;


  # Oberon string literals

  oberon_singlequoted_string = '\'' @code [^\r\n\f"]* '\'';
  oberon_doublequoted_string = '"' @code [^\r\n\f"]* '"';

  oberon_string = oberon_singlequoted_string | oberon_doublequoted_string;


  # Line counter

  oberon_line := |*
    spaces          ${ entity = OBERON_SPACE; } => oberon_ccallback;
    oberon_comment;
    oberon_string;
    newline         ${ entity = NEWLINE;      } => oberon_ccallback;
    ^space          ${ entity = OBERON_ANY;   } => oberon_ccallback;
  *|;


  # Entity machine

  action oberon_ecallback {
    callback(OBERON_LANG, oberon_entities[entity], cint(ts), cint(te),
             userdata);
  }

  oberon_comment_entity = '(*' >oberon_comment_nc_res (
    '(*' @oberon_comment_nc_inc
    |
    '*)' @oberon_comment_nc_dec
    |
    any
  )* :>> ('*)' when { nest_count == 0 });

  oberon_string_entity = sq_str | dq_str;

  oberon_entity := |*
    space+                ${ entity = OBERON_SPACE;   } => oberon_ecallback;
    oberon_comment_entity ${ entity = OBERON_COMMENT; } => oberon_ecallback;
    oberon_string_entity  ${ entity = OBERON_STRING;  } => oberon_ecallback;
    # TODO: detecting other entities may be useful to differentiate dialects
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Oberon code.
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
void parse_oberon(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  int nest_count = 0;

  %% write init;
  cs = (count) ? oberon_en_oberon_line : oberon_en_oberon_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(OBERON_LANG) }
}

#endif

/*****************************************************************************/
