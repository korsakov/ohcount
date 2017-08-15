// d.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_D_PARSER_H
#define OHCOUNT_D_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *D_LANG = LANG_DMD;

// the languages entities
const char *d_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  D_SPACE = 0, D_COMMENT, D_STRING, D_ANY
};

/*****************************************************************************/

%%{
  machine d;
  write data;
  include common "common.rl";

  # Line counting machine

  action d_ccallback {
    switch(entity) {
    case D_SPACE:
      ls
      break;
    case D_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(D_LANG)
      break;
    case NEWLINE:
      std_newline(D_LANG)
    }
  }

  action d_comment_nc_res { nest_count = 0; }
  action d_comment_nc_inc { nest_count++; }
  action d_comment_nc_dec { nest_count--; }

  d_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %d_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;
  d_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %d_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  d_nested_comment =
    '/+' >d_comment_nc_res @comment (
      newline %{ entity = INTERNAL_NL; } %d_ccallback
      |
      ws
      |
      '/+' @d_comment_nc_inc @comment
      |
      '+/' @d_comment_nc_dec @comment
      |
      ^space @comment
    )* :>> ('+/' when { nest_count == 0 }) @comment;
  d_comment = d_line_comment | d_block_comment | d_nested_comment;

  d_sq_str =
    '\'' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %d_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  d_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %d_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  d_bt_str =
    '`' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %d_ccallback
      |
      ws
      |
      [^\t `\\] @code
      |
      '\\' nonnewline @code
    )* '`';
  d_string = d_sq_str | d_dq_str | d_bt_str;

  d_line := |*
    spaces    ${ entity = D_SPACE; } => d_ccallback;
    d_comment;
    d_string;
    newline   ${ entity = NEWLINE; } => d_ccallback;
    ^space    ${ entity = D_ANY;   } => d_ccallback;
  *|;

  # Entity machine

  action d_ecallback {
    callback(D_LANG, d_entities[entity], cint(ts), cint(te), userdata);
  }

  d_line_comment_entity = '//' (escaped_newline | nonnewline)*;
  d_block_comment_entity = '/*' any* :>> '*/';
  d_nested_comment_entity = '/+' >d_comment_nc_res (
    '/+' @d_comment_nc_inc
    |
    '+/' @d_comment_nc_dec
    |
    any
  )* :>> ('+/' when { nest_count == 0 });
  d_comment_entity = d_line_comment_entity | d_block_comment_entity |
    d_nested_comment_entity;

  d_entity := |*
    space+           ${ entity = D_SPACE;   } => d_ecallback;
    d_comment_entity ${ entity = D_COMMENT; } => d_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with D code.
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
void parse_d(char *buffer, int length, int count,
             void (*callback) (const char *lang, const char *entity, int s,
                               int e, void *udata),
             void *userdata
  ) {
  init

  int nest_count = 0;

  %% write init;
  cs = (count) ? d_en_d_line : d_en_d_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(D_LANG) }
}

#endif

/*****************************************************************************/
