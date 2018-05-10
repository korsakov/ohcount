// lua.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_LUA_PARSER_H
#define OHCOUNT_LUA_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *LUA_LANG = LANG_LUA;

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
    '--' ('[' >lua_long_ec_res '='* $lua_long_ec_inc '[') @enqueue @comment (
      newline %{ entity = INTERNAL_NL; } %lua_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> (']' '='* $lua_long_ec_dec ']' when { equal_count == 0 }) @commit;
  lua_line_comment = '--' @comment nonnewline*;
  lua_comment = lua_long_comment | lua_line_comment;

  lua_long_string =
    ('[' >lua_long_ec_res '='* $lua_long_ec_inc '[') @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %lua_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> (']' '='* $lua_long_ec_dec ']' when { equal_count == 0 }) @commit;
  lua_sq_str =
    '\'' @code (
      newline %{ entity = INTERNAL_NL; } %lua_ccallback
      |
      ws
      |
      [^\r\n\f\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  lua_dq_str =
    '"' @code (
      newline %{ entity = INTERNAL_NL; } %lua_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
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
    callback(LUA_LANG, lua_entities[entity], cint(ts), cint(te), userdata);
  }

  lua_block_comment_entity =
    '--[' >lua_long_ec_res '='* $lua_long_ec_inc '[' any*
    :>> (']' '='* $lua_long_ec_dec ']' when { equal_count == 0 });
  lua_line_comment_entity = '--' (nonnewline)*;
  lua_comment_entity = lua_block_comment_entity | lua_line_comment_entity;

  lua_string_entity = sq_str_with_escapes | dq_str_with_escapes;

  lua_integer = '-'? (dec_num | hex_num);
  lua_number_entity = float | lua_integer;

  lua_keyword_entity =
    'and' | 'break' | 'do' | 'else' | 'elseif' | 'end' | 'false' | 'for' |
    'function' | 'if' | 'in' | 'local' | 'nil' | 'not' | 'or' | 'repeat' |
    'return' | 'then' | 'true' | 'until' | 'while';

  lua_identifier_entity = (alpha | '_') alnum*;

  lua_operator_entity = '~=' | [+\-*/%^#=<>;:,.{}\[\]()];

  lua_entity := |*
    space+                ${ entity = LUA_SPACE;      } => lua_ecallback;
    lua_comment_entity    ${ entity = LUA_COMMENT;    } => lua_ecallback;
    lua_string_entity     ${ entity = LUA_STRING;     } => lua_ecallback;
    lua_number_entity     ${ entity = LUA_NUMBER;     } => lua_ecallback;
    lua_identifier_entity ${ entity = LUA_IDENTIFIER; } => lua_ecallback;
    lua_keyword_entity    ${ entity = LUA_KEYWORD;    } => lua_ecallback;
    lua_operator_entity   ${ entity = LUA_OPERATOR;   } => lua_ecallback;
    ^space                ${ entity = LUA_ANY;        } => lua_ecallback;
  *|;
}%%

/************************* Required for every parser *************************/

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
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  int equal_count = 0;

  %% write init;
  cs = (count) ? lua_en_lua_line : lua_en_lua_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(LUA_LANG) }
}

#endif

/*****************************************************************************/
