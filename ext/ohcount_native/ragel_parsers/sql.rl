// sql.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef RAGEL_SQL_PARSER
#define RAGEL_SQL_PARSER

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

/************************* Required for every parser *************************/

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
  init

  %% write init;
  cs = (count) ? sql_en_sql_line : sql_en_sql_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(SQL_LANG) }
}

#endif

/*****************************************************************************/
