// css.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef RAGEL_CSS_PARSER
#define RAGEL_CSS_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *CSS_LANG = "css";

// the languages entities
const char *css_entities[] = {
  "space", "comment", "string", "at_rule", "selector",
  "value", "unit", "color", "url", "any"
};

// constants associated with the entities
enum {
  CSS_SPACE = 0, CSS_COMMENT, CSS_STRING, CSS_AT_RULE, CSS_SELECTOR,
  CSS_VALUE, CSS_UNIT, CSS_COLOR, CSS_URL, CSS_ANY
};

/*****************************************************************************/

%%{
  machine css;
  write data;
  include common "common.rl";

  # Line counting machine

  action css_ccallback {
    switch(entity) {
    case CSS_SPACE:
      ls
      break;
    case CSS_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(CSS_LANG)
      break;
    case NEWLINE:
      std_newline(CSS_LANG)
    }
  }

  css_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %css_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';

  css_sq_str =
    '\'' @code (
      newline %{ entity = INTERNAL_NL; } %css_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  css_dq_str =
    '"' @code (
      newline %{ entity = INTERNAL_NL; } %css_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  css_string = css_sq_str | css_dq_str;

  css_line := |*
    spaces      ${ entity = CSS_SPACE; } => css_ccallback;
    css_comment;
    css_string;
    newline     ${ entity = NEWLINE;   } => css_ccallback;
    ^space      ${ entity = CSS_ANY;   } => css_ccallback;
  *|;

  # Entity machine

  action css_ecallback {
    callback(CSS_LANG, entity, cint(ts), cint(te));
  }

  css_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with CSS code.
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
void parse_css(char *buffer, int length, int count,
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
  cs = (count) ? css_en_css_line : css_en_css_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(CSS_LANG) }
}

#endif

/*****************************************************************************/
