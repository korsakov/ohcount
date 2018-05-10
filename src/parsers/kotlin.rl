// kotlin.rl written by Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
// Inspired by rust.rl, python.rl and haskell.rl

/************************* Required for every parser *************************/
#ifndef OHCOUNT_KOTLIN_PARSER_H
#define OHCOUNT_KOTLIN_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *KOTLIN_LANG = LANG_KOTLIN;

// the languages entities
const char *kotlin_entities[] = {
  "space", "comment", "string", "number",
  "keyword", "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  KOTLIN_SPACE = 0, KOTLIN_COMMENT, KOTLIN_STRING, KOTLIN_NUMBER,
  KOTLIN_KEYWORD, KOTLIN_IDENTIFIER, KOTLIN_OPERATOR, KOTLIN_ANY
};

/*****************************************************************************/

%%{
  machine kotlin;
  write data;
  include common "common.rl";

  # Line counting machine

  action kotlin_ccallback {
    switch(entity) {
    case KOTLIN_SPACE:
      ls
      break;
    case KOTLIN_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(KOTLIN_LANG)
      break;
    case NEWLINE:
      std_newline(KOTLIN_LANG)
    }
  }

  action kotlin_comment_nc_res { kotlin_comment_nest_count = 0; }
  action kotlin_comment_nc_inc { kotlin_comment_nest_count++; }
  action kotlin_comment_nc_dec { kotlin_comment_nest_count--; }

  kotlin_line_comment = '//' @comment nonnewline*;
  kotlin_block_comment =
    '/*' >kotlin_comment_nc_res @comment (
      newline %{ entity = INTERNAL_NL; } %kotlin_ccallback
      |
      ws
      |
      '/*' @kotlin_comment_nc_inc @comment
      |
      '*/' @kotlin_comment_nc_dec @comment
      |
      (nonnewline - ws) @comment
    )* :>> ('*/' when { kotlin_comment_nest_count == 0 }) @comment;
  kotlin_comment = kotlin_line_comment | kotlin_block_comment;

  kotlin_dq_str =
    '"' @code ([^"] | '"' [^"] @{ fhold; }) @{ fhold; } # make sure it's not """
      ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  kotlin_raw_str =
    '"""' @code (
      newline %{ entity = INTERNAL_NL; } %kotlin_ccallback
      |
      ws
      |
      [^\t ] @code
    )* '"""';
  kotlin_string = kotlin_dq_str | kotlin_raw_str;

  kotlin_line := |*
    spaces    ${ entity = KOTLIN_SPACE; } => kotlin_ccallback;
    kotlin_comment;
    kotlin_string;
    newline   ${ entity = NEWLINE;      } => kotlin_ccallback;
    ^space    ${ entity = KOTLIN_ANY;   } => kotlin_ccallback;
  *|;

  # Entity machine

  action kotlin_ecallback {
    callback(KOTLIN_LANG, kotlin_entities[entity], cint(ts), cint(te), userdata);
  }

  kotlin_line_comment_entity = '//' nonnewline*;
  kotlin_block_comment_entity = '/*' any* :>> '*/';
  kotlin_comment_entity = kotlin_line_comment_entity | kotlin_block_comment_entity;

  kotlin_raw_string_entity = '"""' any* :>> '"""';
  kotlin_string_entity = dq_str_with_escapes | kotlin_raw_string_entity;

  kotlin_float_suffix_ty = [fF];
  kotlin_long_suffix = 'L';
  kotlin_hex_suffix = kotlin_long_suffix
                    | '.' [0-9A-Fa-f]* kotlin_float_suffix_ty?;

  kotlin_dec_lit = [0-9]+;
  kotlin_exponent = [Ee] [\-+]? kotlin_dec_lit;
  kotlin_float_suffix = (kotlin_exponent | '.' kotlin_dec_lit kotlin_exponent?)?
                      kotlin_float_suffix_ty?;

  kotlin_num_suffix = kotlin_long_suffix | kotlin_float_suffix;

  kotlin_number_entity = [1-9]   [0-9]*       kotlin_num_suffix?
                     | '0' (     [0-9]*       kotlin_num_suffix?
                           | 'b' [01]+        kotlin_long_suffix?
                           | 'x' [0-9A-Fa-f]+ kotlin_hex_suffix?);

  kotlin_plain_identifier = (alpha | '_') (alnum | '_')*;
  kotlin_identifier_entity = kotlin_plain_identifier | '`' kotlin_plain_identifier '`';

  kotlin_keyword_entity =
    'as' | 'break' | 'class' | 'continue' | 'do' | 'else' | 'false' | 'for' |
    'fun' | 'if' | 'in' | 'is' | 'null' | 'object' | 'package' | 'return' |
    'super' | 'this' | 'This' | 'throw' | 'trait' | 'true' | 'try' | 'type' |
    'val' | 'var' | 'when' | 'while';

  kotlin_operator_entity = [+\-/*%<>!=^&|?~:;.,()\[\]{}];

  kotlin_entity := |*
    space+                   ${ entity = KOTLIN_SPACE;      } => kotlin_ecallback;
    kotlin_comment_entity    ${ entity = KOTLIN_COMMENT;    } => kotlin_ecallback;
    kotlin_string_entity     ${ entity = KOTLIN_STRING;     } => kotlin_ecallback;
    kotlin_number_entity     ${ entity = KOTLIN_NUMBER;     } => kotlin_ecallback;
    kotlin_identifier_entity ${ entity = KOTLIN_IDENTIFIER; } => kotlin_ecallback;
    kotlin_keyword_entity    ${ entity = KOTLIN_KEYWORD;    } => kotlin_ecallback;
    kotlin_operator_entity   ${ entity = KOTLIN_OPERATOR;   } => kotlin_ecallback;
    ^(space | digit)         ${ entity = KOTLIN_ANY;        } => kotlin_ecallback;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with C/C++ code.
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
void parse_kotlin(char *buffer, int length, int count,
             void (*callback) (const char *lang, const char *entity, int s,
                               int e, void *udata),
             void *userdata
  ) {
  init

  int kotlin_comment_nest_count = 0;

  %% write init;
  cs = (count) ? kotlin_en_kotlin_line : kotlin_en_kotlin_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(KOTLIN_LANG) }
}

const char *ORIG_KOTLIN_LANG = LANG_KOTLIN;

#endif

/*****************************************************************************/
