// objective_c.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#include "ragel_parser_macros.h"

// the name of the language
const char *OBJC_LANG = "objective c";

// the languages entities
const char *objc_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  OBJC_SPACE = 0, OBJC_COMMENT, OBJC_STRING, OBJC_ANY,
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
  machine objective_c;
  write data;
  include common "common.rl";

  # Line counting machine

  action objc_ccallback {
    switch(entity) {
    case OBJC_SPACE:
      ls
      break;
    case OBJC_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(OBJC_LANG)
      break;
    case NEWLINE:
      std_newline(OBJC_LANG)
    }
  }

  objc_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %objc_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;
    objc_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %objc_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  objc_comment = objc_line_comment | objc_block_comment;

  objc_sq_str = '\'' @code ([^'\\] | '\\' nonnewline)* '\'';
  objc_dq_str = '"' @code ([^"\\] | '\\' nonnewline)* '"';
  objc_string = objc_sq_str | objc_dq_str;

  objc_line := |*
    spaces        ${ entity = OBJC_SPACE; } => objc_ccallback;
    objc_comment;
    objc_string;
    newline       ${ entity = NEWLINE;    } => objc_ccallback;
    ^space        ${ entity = OBJC_ANY;   } => objc_ccallback;
  *|;

  # Entity machine

  action objc_ecallback {
    callback(OBJC_LANG, objc_entities[entity], cint(ts), cint(te));
  }

  objc_entity := 'TODO:';
}%%

/* Parses a string buffer with Objective C code.
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
void parse_objective_c(char *buffer, int length, int count,
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
  cs = (count) ? objective_c_en_objc_line : objective_c_en_objc_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(OBJC_LANG) }
}
