// boo.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_BOO_PARSER_H
#define OHCOUNT_BOO_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *BOO_LANG = LANG_BOO;

// the languages entities
const char *boo_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  BOO_SPACE = 0, BOO_COMMENT, BOO_STRING, BOO_ANY
};

/*****************************************************************************/

%%{
  machine boo;
  write data;
  include common "common.rl";

  # Line counting machine

  action boo_ccallback {
    switch(entity) {
    case BOO_SPACE:
      ls
      break;
    case BOO_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(BOO_LANG)
      break;
    case NEWLINE:
      std_newline(BOO_LANG)
    }
  }

  action boo_comment_nc_res { nest_count = 0; }
  action boo_comment_nc_inc { nest_count++; }
  action boo_comment_nc_dec { nest_count--; }

  boo_line_comment = ('#' | '//') @comment nonnewline*;
  boo_block_comment =
    '/*' >boo_comment_nc_res @comment (
      newline %{ entity = INTERNAL_NL; } %boo_ccallback
      |
      ws
      |
      '/*' @boo_comment_nc_inc @comment
      |
      '*/' @boo_comment_nc_dec @comment
      |
      ^space @comment
    )* :>> ('*/' when { nest_count == 0 }) @comment;
  boo_doc_comment =
    '"""' @comment (
      newline %{ entity = INTERNAL_NL; } %boo_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '"""' @comment;
  boo_comment = boo_line_comment | boo_block_comment | boo_doc_comment;

  boo_char = '\'' ([^\r\n\f'\\] | '\\' nonnewline) '\'';
  boo_dq_str =
    '"' ([^"] | '"' [^"] @{ fhold; }) @{ fhold; } # make sure it's not """
      ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  boo_regex = '/' [^*/] @{ fhold; } ([^\r\n\f/\\] | '\\' nonnewline)* '/';
  boo_string = (boo_char | boo_dq_str | boo_regex) @code;

  boo_line := |*
    spaces       ${ entity = BOO_SPACE; } => boo_ccallback;
    boo_comment;
    boo_string;
    newline      ${ entity = NEWLINE;   } => boo_ccallback;
    ^space       ${ entity = BOO_ANY;   } => boo_ccallback;
  *|;

  # Entity machine

  action boo_ecallback {
    callback(BOO_LANG, boo_entities[entity], cint(ts), cint(te), userdata);
  }

  boo_line_comment_entity = ('#' | '//') nonnewline*;
  boo_block_comment_entity = '/*' >boo_comment_nc_res (
    '/*' @boo_comment_nc_inc
    |
    '*/' @boo_comment_nc_dec
    |
    any
  )* :>> ('*/' when { nest_count == 0 });
  boo_comment_entity = boo_line_comment_entity | boo_block_comment_entity;

  boo_entity := |*
    space+             ${ entity = BOO_SPACE;   } => boo_ecallback;
    boo_comment_entity ${ entity = BOO_COMMENT; } => boo_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Boo code.
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
void parse_boo(char *buffer, int length, int count,
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  int nest_count = 0;

  %% write init;
  cs = (count) ? boo_en_boo_line : boo_en_boo_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(BOO_LANG) }
}

#endif

/*****************************************************************************/
