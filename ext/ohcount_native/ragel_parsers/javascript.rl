// Javascript.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#include "ragel_parser_macros.h"

// the name of the language
const char *JS_LANG = "javascript";

// the languages entities
const char *js_entities[] = {
  "space", "comment", "string", "number", "keyword",
  "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  JS_SPACE = 0, JS_COMMENT, JS_STRING, JS_NUMBER, JS_KEYWORD,
  JS_IDENTIFIER, JS_OPERATOR, JS_ANY
};

// do not change the following variables

// used for newlines
#define NEWLINE -1

// used for newlines inside patterns like strings and comments that can have
// newlines in them
#define INTERNAL_NL -2

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
  machine javascript;
  write data;
  include common "common.rl";

  # Line counting machine

  action js_ccallback {
    switch(entity) {
    case JS_SPACE:
      ls
      break;
    case JS_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(JS_LANG)
      break;
    case NEWLINE:
      std_newline(JS_LANG)
    }
  }

  js_line_comment = '//' @comment nonnewline*;
  js_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %js_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  js_comment = js_line_comment | js_block_comment;

  # Does Javascript allow newlines inside strings?
  # I can't find a definitive answer.
  js_sq_str =
    '\'' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %js_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  js_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %js_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  js_string = js_sq_str | js_dq_str;

  js_line := |*
    spaces     ${ entity = JS_SPACE; } => js_ccallback;
    js_comment;
    js_string;
    newline    ${ entity = NEWLINE;  } => js_ccallback;
    ^space     ${ entity = JS_ANY;   } => js_ccallback;
  *|;

  # Entity machine

  action js_ecallback {
    callback(JS_LANG, entity, cint(ts), cint(te));
  }

  js_entity := 'TODO:';
}%%

/* Parses a string buffer with Javascript code.
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
void parse_javascript(char *buffer, int length, int count,
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
  cs = (count) ? javascript_en_js_line : javascript_en_js_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(JS_LANG) }
}

