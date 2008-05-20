/************************* Required for every parser *************************/

// the name of the language
const char *LANG = "c";

// the languages entities
const char *c_entities[] = {
  "space", "comment", "string", "number", "preproc", "keyword",
  "identifier", "operator", "escaped_newline", "newline", "any"
};

// constants associated with the entities
enum {
  SPACE = 0, COMMENT, STRING, NUMBER, PREPROC, KEYWORD,
  IDENTIFIER, OPERATOR, ESCAPED_NL, NEWLINE, ANY
};

// do not change the following variables

// used for newlines inside patterns like strings and comments that can have
// newlines in them
#define INTERNAL_NL -1

// required by Ragel
int cs, act;
char *p, *pe, *eof, *ts, *te;

// used for calculating offsets from buffer start for start and end positions
char *buffer_start;
#define cint(c) ((int) (c - buffer_start))

// state flags for line and comment counting
int whole_line_comment;
int line_contains_code;

// the beginning of a line in the buffer for line and comment counting
char *line_start;

// state variable for the current entity being matched
int entity;

/*****************************************************************************/

%%{
  machine c;
  write data;
  include common "common.rl";

  action c_callback {
    switch(entity) {
    case SPACE:
    case ANY:
      if (!line_start) line_start = ts;
      break;
    //case COMMENT:
    //case STRING:
    case NUMBER:
    //case PREPROC:
    case KEYWORD:
    case IDENTIFIER:
    case OPERATOR:
      if (!line_contains_code && !line_start) line_start = ts;
      line_contains_code = 1;
      break;
    case ESCAPED_NL:
    case INTERNAL_NL:
      if (c_callback && p > line_start) {
        if (line_contains_code)
          c_callback(LANG, "lcode", cint(line_start), cint(p));
        else if (whole_line_comment)
          c_callback(LANG, "lcomment", cint(line_start), cint(p));
        else
          c_callback(LANG, "lblank", cint(line_start), cint(p));
        whole_line_comment = 0;
        line_contains_code = 0;
        line_start = p;
      }
      break;
    case NEWLINE:
      if (c_callback && te > line_start) {
        if (line_contains_code)
          c_callback(LANG, "lcode", cint(line_start), cint(te));
        else if (whole_line_comment)
          c_callback(LANG, "lcomment", cint(line_start), cint(te));
        else
          c_callback(LANG, "lblank", cint(ts), cint(te));
      }
      whole_line_comment = 0;
      line_contains_code = 0;
      line_start = 0;
    }
    if (c_callback && entity != INTERNAL_NL)
      c_callback(LANG, c_entities[entity], cint(ts), cint(te));
  }

  c_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %c_callback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;
  c_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %c_callback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  c_comment = c_line_comment | c_block_comment;

  c_sq_str =
    '\'' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %c_callback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  c_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %c_callback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  c_string = c_sq_str | c_dq_str;

  c_number = float | integer;

  c_preproc_word =
    'define' | 'elif' | 'else' | 'endif' | 'error' | 'if' | 'ifdef' |
    'ifndef' | 'import' | 'include' | 'line' | 'pragma' | 'undef' |
    'using';
  c_preproc =
    ('#' when no_code) @code ws* (c_block_comment ws*)? c_preproc_word
    (
      escaped_newline %{ entity = INTERNAL_NL; } %c_callback
      |
      ws
      |
      (nonnewline - ws) @code
    )*;

  c_identifier = (alpha | '_') (alnum | '_')*;

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

  c_operator = [+\-/*%<>!=^&|?~:;.,()\[\]{}@];

  c_line := |*
    spaces            ${ entity = SPACE;       } => c_callback;
    c_comment         ${ entity = COMMENT;     } => c_callback;
    c_string          ${ entity = STRING;      } => c_callback;
    c_number          ${ entity = NUMBER;      } => c_callback;
    c_preproc         ${ entity = PREPROC;     } => c_callback;
    c_identifier      ${ entity = IDENTIFIER;  } => c_callback;
    c_keyword         ${ entity = KEYWORD;     } => c_callback;
    c_operator        ${ entity = OPERATOR;    } => c_callback;
    escaped_newline   ${ entity = ESCAPED_NL;  } => c_callback;
    newline           ${ entity = NEWLINE;     } => c_callback;
    nonprintable_char ${ entity = ANY;         } => c_callback;
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
  p = buffer;
  pe = buffer + length;
  eof = pe;

  buffer_start = buffer;
  whole_line_comment = 0;
  line_contains_code = 0;
  line_start = 0;
  entity = 0;

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
