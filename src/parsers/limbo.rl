// limbo.rl
// http://www.vitanuova.com/inferno/papers/limbo.html

/************************* Required for every parser *************************/
#ifndef RAGEL_LIMBO_PARSER
#define RAGEL_LIMBO_PARSER

#include "../parser_macros.h"

// the name of the language
const char *LIMBO_LANG = "limbo";

// the languages entities
const char *limbo_entities[] = {
  "space", "comment", "string", "number",
  "keyword", "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  LIMBO_SPACE = 0, LIMBO_COMMENT, LIMBO_STRING, LIMBO_NUMBER,
  LIMBO_KEYWORD, LIMBO_IDENTIFIER, LIMBO_OPERATOR, LIMBO_ANY
};

/*****************************************************************************/

%%{
  machine limbo;
  write data;
  include common "common.rl";

  # Line counting machine

  action limbo_ccallback {
    switch(entity) {
    case LIMBO_SPACE:
      ls
      break;
    case LIMBO_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(LIMBO_LANG)
      break;
    case NEWLINE:
      std_newline(LIMBO_LANG)
    }
  }

  limbo_comment = '#' @comment nonnewline*;

  limbo_sq_str =
    '\'' @code (
      [^\r\n\f\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'' @commit;
  limbo_dq_str =
    '"' @enqueue @code (
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"' @commit;
  limbo_string = limbo_sq_str | limbo_dq_str;

  limbo_line := |*
    spaces         ${ entity = LIMBO_SPACE; } => limbo_ccallback;
    limbo_comment;
    limbo_string;
    newline        ${ entity = NEWLINE;     } => limbo_ccallback;
    ^space         ${ entity = LIMBO_ANY;   } => limbo_ccallback;
  *|;

  # Entity machine

  action limbo_ecallback {
    callback(LIMBO_LANG, limbo_entities[entity], cint(ts), cint(te), userdata);
  }

  limbo_comment_entity = '#' nonnewline*;

  # todo: this probably allows multi-line strings too, which limbo doesn't allow?
  limbo_string_entity = sq_str_with_escapes | dq_str_with_escapes;

  # todo: support numbers with specified radix?  e.g. 16rFF, 8r666, 2b10101
  limbo_number_entity = float | integer;

  # todo: support utf-8 identifiers
  limbo_identifier_entity = (alpha | '_') (alnum | '_')*;

  limbo_keyword_entity =
    'alt' | 'break' | 'continue' | 'exit' | 'return' | 'spawn' | 'implement' | 'import' | 'load' | 'raise' | 'raises'
    'include' | 'array' | 'big' | 'byte' | 'chan' | 'con' | 'int' | 'list' | 'real' | 'string' | 'fn' |
    'adt' | 'pick' | 'module' |
    'for' | 'while' | 'do' |
    'if' | 'else' | 'case' | 'or' | 'to' |
    '=>' |
    'ref' | 'self' | 'cyclic' | 'type' | 'of' |
    'tl' | 'hd' | 'len' | 'tagof' |
    'nil';

  limbo_operator_entity = [+\-/*%!=^&|~:;.,()\[\]{}>];

  limbo_entity := |*
    space+               ${ entity = LIMBO_SPACE;   } => limbo_ecallback;
    limbo_comment_entity ${ entity = LIMBO_COMMENT; } => limbo_ecallback;
    limbo_string_entity  ${ entity = LIMBO_STRING;  } => limbo_ecallback;
    limbo_number_entity  ${ entity = LIMBO_NUMBER;  } => limbo_ecallback;
    limbo_keyword_entity ${ entity = LIMBO_KEYWORD; } => limbo_ecallback;
    limbo_identifier_entity ${ entity = LIMBO_IDENTIFIER; } => limbo_ecallback;
    limbo_operator_entity ${ entity = LIMBO_OPERATOR; } => limbo_ecallback;
    ^(space | digit)     ${ entity = C_ANY;         } => limbo_ecallback;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Limbo code.
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
void parse_limbo(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? limbo_en_limbo_line : limbo_en_limbo_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(LIMBO_LANG) }
}

#endif

/*****************************************************************************/
