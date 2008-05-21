/************************* Required for every parser *************************/
#include "ragel_parser_defines.h"

// the name of the language
const char *C_LANG = "c";

// the languages entities
const char *c_entities[] = {
  "space", "comment", "string", "number", "preproc",
  "identifier", "operator", "escaped_newline", "newline"
};

// constants associated with the entities
enum {
  C_SPACE = 0, C_COMMENT, C_STRING, C_NUMBER, C_PREPROC,
  C_IDENTIFIER, C_OPERATOR, C_ESCAPED_NL, C_NEWLINE
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
    case C_SPACE:
      ls
      break;
    //case C_COMMENT:
    //case C_STRING:
    case C_NUMBER:
    //case C_PREPROC:
    case C_IDENTIFIER:
    case C_OPERATOR:
      code
      break;
    case C_ESCAPED_NL:
    case INTERNAL_NL:
      std_internal_newline(C_LANG)
      break;
    case C_NEWLINE:
      std_newline(C_LANG)
    }
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

  c_preproc =
    ('#' when no_code) @code ws* (c_block_comment ws*)? alpha+
    (
      escaped_newline %{ entity = INTERNAL_NL; } %c_callback
      |
      ws
      |
      (nonnewline - ws) @code
    )*;

  c_identifier = (alpha | '_') (alnum | '_')*;

  c_operator = [+\-/*%<>!=^&|?~:;.,()\[\]{}@];

  c_line := |*
    spaces          ${ entity = C_SPACE;      } => c_callback;
    c_comment       ${ entity = C_COMMENT;    } => c_callback;
    c_string        ${ entity = C_STRING;     } => c_callback;
    c_number        ${ entity = C_NUMBER;     } => c_callback;
    c_preproc       ${ entity = C_PREPROC;    } => c_callback;
    c_identifier    ${ entity = C_IDENTIFIER; } => c_callback;
    c_operator      ${ entity = C_OPERATOR;   } => c_callback;
    escaped_newline ${ entity = C_ESCAPED_NL; } => c_callback;
    newline         ${ entity = C_NEWLINE;    } => c_callback;
  *|;
}%%

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
void parse_c(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
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
  if (count)
    %% write exec c_line;

  // if no newline at EOF; callback contents of last line
  process_last_line(C_LANG)
}
