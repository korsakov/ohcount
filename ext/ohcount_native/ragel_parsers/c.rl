#include "common.h"

const char *LANG = "c";
const char *c_entities[] = {
  "space", "comment", "string", "number", "preproc",
  "keyword", "identifier", "operator", "newline", "any"
};
enum {
  SPACE = 0, COMMENT, STRING, NUMBER, PREPROC,
  KEYWORD, IDENTIFIER, OPERATOR, NEWLINE, ANY
};

#define cint(c) ((int) (c - buffer_start))

%%{
  machine c;
  write data;
  include common "common.rl";

  c_comment = c_style_line_comment_with_esc | c_style_block_comment;
  c_string = sq_str_with_esc | dq_str_with_esc;
  c_number = float | integer;
  c_preproc_word =
    'define' | 'elif' | 'else' | 'endif' | 'error' | 'if' | 'ifdef' |
    'ifndef' | 'import' | 'include' | 'line' | 'pragma' | 'undef' |
    'using';
  c_preproc = ('#' when starts_line) [\t ]* c_preproc_word
    (spaces (escaped_newline | nonnewline)*)?;
  c_keyword =
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
  c_identifier = (alpha | '_') (alnum | '_')*;
  c_operator = [+\-/*%<>!=&|?:;.,()\[\]{}];

  action c_callback {
    switch(entity) {
    case SPACE:
    case ANY:
      if (!line_start) line_start = ts;
      break;
    case COMMENT:
      if (!line_contains_code) {
        whole_line_comment = 1;
        if (!line_start) line_start = ts;
      }
      break;
    case STRING:
    case NUMBER:
    case PREPROC:
    case KEYWORD:
    case IDENTIFIER:
    case OPERATOR:
      if (!line_contains_code && !line_start) line_start = ts;
      line_contains_code = 1;
      break;
    case NEWLINE:
      if (c_callback) {
        if (line_contains_code)
          c_callback(LANG, "lcode", cint(line_start), cint(te));
        else if (whole_line_comment)
          c_callback(LANG, "lcomment", cint(line_start), cint(te));
        else if (!line_start)
          c_callback(LANG, "lblank", cint(ts), cint(te));
      }
      whole_line_comment = 0;
      line_contains_code = 0;
      line_start = 0;
    }
    if (c_callback) c_callback(LANG, c_entities[entity], cint(ts), cint(te));
  }

  c_line := |*
    spaces            ${ entity = SPACE;      } => c_callback;
    c_comment         ${ entity = COMMENT;    } => c_callback;
    c_string          ${ entity = STRING;     } => c_callback;
    c_number          ${ entity = NUMBER;     } => c_callback;
    c_preproc         ${ entity = PREPROC;    } => c_callback;
    c_keyword         ${ entity = KEYWORD;    } => c_callback;
    c_identifier      ${ entity = IDENTIFIER; } => c_callback;
    c_operator        ${ entity = OPERATOR;   } => c_callback;
    escaped_newline                                          ;
    newline           ${ entity = NEWLINE;    } => c_callback;
    nonprintable_char ${ entity = ANY;        } => c_callback;
  *|;
}%%

/* Parses a string buffer with C/C++ code.
 *
 * @param *buffer The string to parse.
 * @param length The length of the string to parse.
 * @param *c_callback Callback function called for each entity. Entities are
 *   the ones defined in the lexer as well as 3 additional entities used by
 *   Ohcount for counting lines: lcode, lcomment, lblank.
 */
void parse_c(char *buffer, int length,
  void (*c_callback) (const char *lang, const char *entity, int start, int end)
  ) {
  int cs;
  buffer[length] = '\0';
  char *p = buffer, *pe = buffer + length;
  char *eof = pe;
  char *ts, *te; int act;

  // used for calculating offsets from buffer start for start and end positions
  char *buffer_start = buffer;

  // state flags for line and comment counting
  int whole_line_comment = 0;
  int line_contains_code = 0;

  // the beginning of a line marker for line and comment counting
  char *line_start = 0;

  // state variable for the current entity being matched
  int entity = 0;

  %% write init;
  %% write exec;

  // no newline at EOF; get contents of last line
  if ((whole_line_comment || line_contains_code) && c_callback) {
    if (line_contains_code)
      c_callback(LANG, "lcode", cint(line_start), cint(pe));
    else if (whole_line_comment)
      c_callback(LANG, "lcomment", cint(line_start), cint(pe));
  }
}
