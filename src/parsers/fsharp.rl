// fsharp.rl written by Pavel Shiryaev. Hill30  http://www.hill30.com
// based on c.rl

/************************* Required for every parser *************************/
#ifndef OHCOUNT_FSHARP_PARSER_H
#define OHCOUNT_FSHARP_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *FSHARP_LANG = LANG_FSHARP;

// the languages entities
const char *fsharp_entities[] = {
  "space", "comment", "string", "number", "preproc",
  "keyword", "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  FSHARP_SPACE = 0, FSHARP_COMMENT, FSHARP_STRING, FSHARP_NUMBER, FSHARP_PREPROC,
  FSHARP_KEYWORD, FSHARP_IDENTIFIER, FSHARP_OPERATOR, FSHARP_ANY
};

/*****************************************************************************/

%%{
  machine fsharp;
  write data;
  include common "common.rl";

  # Line counting machine

  action fsharp_ccallback {
    switch(entity) {
    case FSHARP_SPACE:
      ls
      break;
    case FSHARP_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(FSHARP_LANG)
      break;
    case NEWLINE:
      std_newline(FSHARP_LANG)
    }
  }

  fsharp_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %fsharp_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;
  fsharp_block_comment =
    '(*' @comment (
      newline %{ entity = INTERNAL_NL; } %fsharp_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*)';
  fsharp_comment = fsharp_line_comment | fsharp_block_comment;

  fsharp_sq_str =
    '\'' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %fsharp_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  fsharp_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %fsharp_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  fsharp_string = fsharp_sq_str | fsharp_dq_str;

  fsharp_line := |*
    spaces    ${ entity = FSHARP_SPACE; } => fsharp_ccallback;
    fsharp_comment;
    fsharp_string;
    newline   ${ entity = NEWLINE; } => fsharp_ccallback;
    ^space    ${ entity = FSHARP_ANY;   } => fsharp_ccallback;
  *|;

  # Entity machine

  action fsharp_ecallback {
    callback(FSHARP_LANG, fsharp_entities[entity], cint(ts), cint(te), userdata);
  }

  fsharp_line_comment_entity = '//' (escaped_newline | nonnewline)*;
  fsharp_block_comment_entity = '(*' any* :>> '*)';
  fsharp_comment_entity = fsharp_line_comment_entity | fsharp_block_comment_entity;

  fsharp_string_entity = sq_str_with_escapes | dq_str_with_escapes;

  fsharp_number_entity = float | integer;

  fsharp_preproc_word =
    'define' | 'elif' | 'else' | 'endif' | 'error' | 'if' | 'ifdef' |
    'ifndef' | 'import' | 'include' | 'line' | 'pragma' | 'undef' |
    'using' | 'warning';
  # TODO: find some way of making preproc match the beginning of a line.
  # Putting a 'when starts_line' conditional throws an assertion error.
  fsharp_preproc_entity =
    '#' space* (fsharp_block_comment_entity space*)?
      fsharp_preproc_word (escaped_newline | nonnewline)*;

  fsharp_identifier_entity = (alpha | '_') (alnum | '_')*;

  fsharp_keyword_entity =
    'and' | 'and_eq' | 'asm' | 'auto' | 'bitand' | 'bitor' | 'bool' |
    'break' | 'case' | 'catch' | 'char' | 'class' | 'compl' | 'const' |
    'const_cast' | 'continue' | 'default' | 'delete' | 'do' | 'double' |
    'dynamic_cast' | 'else' | 'enum' | 'explicit' | 'export' | 'extern' |
    'false' | 'float' | 'for' | 'friend' | 'goto' | 'if' | 'inline' | 'int' |
    'long' | 'mutable' | 'namespace' | 'new' | 'not' | 'not_eq' |
    'operator' | 'or' | 'or_eq' | 'private' | 'protected' | 'public' |
    'register' | 'reinterpret_cast' | 'return' | 'short' | 'signed' |
    'sizeof' | 'static' | 'static_cast' | 'struct' | 'switch' |
    'template' | 'this' | 'throw' | 'true' | 'try' | 'typedef' | 'typeid' |
    'typename' | 'union' | 'unsigned' | 'using' | 'virtual' | 'void' |
    'volatile' | 'wchar_t' | 'while' | 'xor' | 'xor_eq';

  fsharp_operator_entity = [+\-/*%<>!=^&|?~:;.,()\[\]{}];

  fsharp_entity := |*
    space+              ${ entity = FSHARP_SPACE;      } => fsharp_ecallback;
    fsharp_comment_entity    ${ entity = FSHARP_COMMENT;    } => fsharp_ecallback;
    fsharp_string_entity     ${ entity = FSHARP_STRING;     } => fsharp_ecallback;
    fsharp_number_entity     ${ entity = FSHARP_NUMBER;     } => fsharp_ecallback;
    fsharp_preproc_entity    ${ entity = FSHARP_PREPROC;    } => fsharp_ecallback;
    fsharp_identifier_entity ${ entity = FSHARP_IDENTIFIER; } => fsharp_ecallback;
    fsharp_keyword_entity    ${ entity = FSHARP_KEYWORD;    } => fsharp_ecallback;
    fsharp_operator_entity   ${ entity = FSHARP_OPERATOR;   } => fsharp_ecallback;
    ^(space | digit)    ${ entity = FSHARP_ANY;        } => fsharp_ecallback;
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
void parse_fsharp(char *buffer, int length, int count,
             void (*callback) (const char *lang, const char *entity, int s,
                               int e, void *udata),
             void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? fsharp_en_fsharp_line : fsharp_en_fsharp_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(FSHARP_LANG) }
}

#endif

/*****************************************************************************/
