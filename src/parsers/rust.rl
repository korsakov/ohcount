// rust.rl written by Sébastien Crozet <developer@crozet.re>
// Inpired by golang.rl

/************************* Required for every parser *************************/
#ifndef OHCOUNT_RUST_PARSER_H
#define OHCOUNT_RUST_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *RUST_LANG = LANG_RUST;

// the languages entities
const char *rust_entities[] = {
  "space", "comment", "string", "number",
  "keyword", "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  RUST_SPACE = 0, RUST_COMMENT, RUST_STRING, RUST_NUMBER,
  RUST_KEYWORD, RUST_IDENTIFIER, RUST_OPERATOR, RUST_ANY
};

/*****************************************************************************/

%%{
  machine rust;
  write data;
  include common "common.rl";

  # Line counting machine

  action rust_ccallback {
    switch(entity) {
    case RUST_SPACE:
      ls
      break;
    case RUST_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(RUST_LANG)
      break;
    case NEWLINE:
      std_newline(RUST_LANG)
    }
  }

  rust_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %rust_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;
  rust_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %rust_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  rust_comment = rust_line_comment | rust_block_comment;

  rust_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %rust_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  rust_string = rust_dq_str;

  rust_line := |*
    spaces    ${ entity = RUST_SPACE; } => rust_ccallback;
    rust_comment;
    rust_string;
    newline   ${ entity = NEWLINE; } => rust_ccallback;
    ^space    ${ entity = RUST_ANY;   } => rust_ccallback;
  *|;

  # Entity machine

  action rust_ecallback {
    callback(RUST_LANG, rust_entities[entity], cint(ts), cint(te), userdata);
  }

  rust_line_comment_entity = '//' (escaped_newline | nonnewline)*;
  rust_block_comment_entity = '/*' any* :>> '*/';
  rust_comment_entity = rust_line_comment_entity | rust_block_comment_entity;

  rust_string_entity = dq_str_with_escapes;

  # Up to and including "the number entity" these are almost verbatim from the
  # "number literals" section of the Rust reference manual
  rust_int_suffix = [iu] ('8' | '16' | '32' | '64')?;

  rust_float_suffix_ty = 'f' ('32' | '64');
  rust_dec_lit = [0-9_]+;
  rust_exponent = [Ee] [\-+]? rust_dec_lit;
  rust_float_suffix = (rust_exponent | '.' rust_dec_lit rust_exponent?)?
                      rust_float_suffix_ty?;

  rust_num_suffix = rust_int_suffix | rust_float_suffix;

  rust_number_entity = [1-9]     [0-9_]*       rust_num_suffix?
                     | '0' (     [0-9_]*       rust_num_suffix?
                           | 'b' [01_]+        rust_int_suffix?
                           | 'o' [0-7_]+       rust_int_suffix?
                           | 'x' [0-9A-Fa-f_]+ rust_int_suffix?);

  rust_identifier_entity = (alpha | '_') (alnum | '_')*;

  rust_keyword_entity =
    'alignof' | 'as' | 'be' | 'break' | 'const' | 'continue' | 'do' | 'else' |
    'enum' | 'extern' | 'false' | 'fn' | 'for' | 'if' | 'impl' | 'impl' |
    'in' | 'let' | 'let' | 'log' | 'log' | 'loop' | 'match' | 'mod' | 'mod' |
    'mut' | 'offsetof' | 'once' | 'priv' | 'pub' | 'pure' | 'ref' | 'return' |
    'self' | 'sizeof' | 'static' | 'struct' | 'super' | 'trait' | 'true' |
    'type' | 'typeof' | 'unsafe' | 'use' | 'while' | 'yield';

  rust_operator_entity = [+\-/*%<>!=^&|?~:;.,()\[\]{}@];

  rust_entity := |*
    space+                 ${ entity = RUST_SPACE;      } => rust_ecallback;
    rust_comment_entity    ${ entity = RUST_COMMENT;    } => rust_ecallback;
    rust_string_entity     ${ entity = RUST_STRING;     } => rust_ecallback;
    rust_number_entity     ${ entity = RUST_NUMBER;     } => rust_ecallback;
    rust_identifier_entity ${ entity = RUST_IDENTIFIER; } => rust_ecallback;
    rust_keyword_entity    ${ entity = RUST_KEYWORD;    } => rust_ecallback;
    rust_operator_entity   ${ entity = RUST_OPERATOR;   } => rust_ecallback;
    ^(space | digit)       ${ entity = RUST_ANY;        } => rust_ecallback;
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
void parse_rust(char *buffer, int length, int count,
             void (*callback) (const char *lang, const char *entity, int s,
                               int e, void *udata),
             void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? rust_en_rust_line : rust_en_rust_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(RUST_LANG) }
}

const char *ORIG_RUST_LANG = LANG_RUST;

#endif

/*****************************************************************************/
