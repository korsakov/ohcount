// sql.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#include "ragel_parser_macros.h"

// the name of the language
const char *SQL_LANG = "sql";

// the languages entities
const char *sql_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  SQL_SPACE = 0, SQL_COMMENT, SQL_STRING, SQL_ANY
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
  machine sql;
  write data;
  include common "common.rl";

  # Line counting machine

  action sql_ccallback {
    switch(entity) {
    case SQL_SPACE:
      ls
      break;
    case SQL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(SQL_LANG)
      break;
    case NEWLINE:
      std_newline(SQL_LANG)
    }
  }

  sql_line_comment = ('--' | '#' | '//') @comment nonnewline*;
  sql_c_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %sql_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  sql_block_comment =
    '{' @comment (
      newline %{ entity = INTERNAL_NL; } %sql_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '}';
  sql_comment = sql_line_comment | sql_c_block_comment | sql_block_comment;

  sql_sq_str = '\'' @code ([^'\\] | '\\' nonnewline)* '\'';
  sql_dq_str = '"' @code ([^"\\] | '\\' nonnewline)* '"';
  sql_string = sql_sq_str | sql_dq_str;

  sql_line := |*
    spaces       ${ entity = SQL_SPACE; } => sql_ccallback;
    sql_comment;
    sql_string;
    newline      ${ entity = NEWLINE;   } => sql_ccallback;
    ^space       ${ entity = SQL_ANY;   } => sql_ccallback;
  *|;

  # Entity machine

  action sql_ecallback {
    callback(SQL_LANG, sql_entities[entity], cint(ts), cint(te));
  }

  sql_entity := 'TODO:';
}%%

/* Parses a string buffer with SQL code.
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
void parse_sql(char *buffer, int length, int count,
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
  cs = (count) ? sql_en_sql_line : sql_en_sql_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(SQL_LANG) }
}
