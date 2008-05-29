// lua.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#include "ragel_parser_macros.h"

// the name of the language
const char *LUA_LANG = "lua";

// the languages entities
const char *lua_entities[] = {
  "space", "comment", "string", "number", "keyword",
  "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  LUA_SPACE = 0, LUA_COMMENT, LUA_STRING, LUA_NUMBER, LUA_KEYWORD,
  LUA_IDENTIFIER, LUA_OPERATOR, LUA_ANY
};

/*****************************************************************************/

%%{
  machine lua;
  write data;
  include common "common.rl";

  # Line counting machine

  action lua_ccallback {
    switch(entity) {
    case LUA_SPACE:
      ls
      break;
    case LUA_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(LUA_LANG)
      break;
    case NEWLINE:
      std_newline(LUA_LANG)
    }
  }

  action lua_long_ec_res { equal_count = 0; }
  action lua_long_ec_inc { equal_count++; }
  action lua_long_ec_dec { equal_count--; }

  lua_long_comment =
    '--' @comment ('[' >lua_long_ec_res '='* $lua_long_ec_inc '[') (
      newline %{ entity = INTERNAL_NL; } %lua_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> (']' '='* $lua_long_ec_dec ']' when { equal_count == 0 });
  lua_line_comment = '--' @comment nonnewline*;
  lua_comment = lua_long_comment | lua_line_comment;

  lua_long_string =
    ('[' >lua_long_ec_res '='* $lua_long_ec_inc '[') @code (
      newline %{ entity = INTERNAL_NL; } %lua_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> (']' '='* $lua_long_ec_dec ']' when { equal_count == 0 });
  lua_sq_str =
    '\'' @code (
      newline %{ entity = INTERNAL_NL; } %lua_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  lua_dq_str =
    '"' @code (
      newline %{ entity = INTERNAL_NL; } %lua_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  lua_string = lua_sq_str | lua_dq_str | lua_long_string;

  lua_line := |*
    spaces      ${ entity = LUA_SPACE; } => lua_ccallback;
    lua_comment;
    lua_string;
    newline     ${ entity = NEWLINE;   } => lua_ccallback;
    ^space      ${ entity = LUA_ANY;   } => lua_ccallback;
  *|;

  # Entity machine

  action lua_ecallback {
    callback(LUA_LANG, entity, cint(ts), cint(te));
  }

  lua_entity := 'TODO:';
}%%

/* Parses a string buffer with Lua code.
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
void parse_lua(char *buffer, int length, int count,
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

  int equal_count = 0;

  %% write init;
  cs = (count) ? lua_en_lua_line : lua_en_lua_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(LUA_LANG) }
}
