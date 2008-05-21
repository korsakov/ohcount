/************************* Required for every parser *************************/

// the name of the language
const char *LUA_LANG = "lua";

// the languages entities
const char *lua_entities[] = {
  "space", "comment", "string", "number",
  "identifier", "operator", "newline"
};

// constants associated with the entities
enum {
  LUA_SPACE = 0, LUA_COMMENT, LUA_STRING, LUA_NUMBER,
  LUA_IDENTIFIER, LUA_OPERATOR, LUA_NEWLINE
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
  machine lua;
  write data;
  include common "common.rl";

  action lua_callback {
    switch(entity) {
    case LUA_SPACE:
      if (!line_start) line_start = ts;
      break;
    //case LUA_COMMENT:
    //case LUA_STRING:
    case LUA_NUMBER:
    case LUA_IDENTIFIER:
    case LUA_OPERATOR:
      if (!line_contains_code && !line_start) line_start = ts;
      line_contains_code = 1;
      break;
    case INTERNAL_NL:
      if (callback && p > line_start) {
        if (line_contains_code)
          callback(LUA_LANG, "lcode", cint(line_start), cint(p));
        else if (whole_line_comment)
          callback(LUA_LANG, "lcomment", cint(line_start), cint(p));
        else
          callback(LUA_LANG, "lblank", cint(line_start), cint(p));
        whole_line_comment = 0;
        line_contains_code = 0;
        line_start = p;
      }
      break;
    case LUA_NEWLINE:
      if (callback && te > line_start) {
        if (line_contains_code)
          callback(LUA_LANG, "lcode", cint(line_start), cint(te));
        else if (whole_line_comment)
          callback(LUA_LANG, "lcomment", cint(line_start), cint(te));
        else
          callback(LUA_LANG, "lblank", cint(ts), cint(te));
      }
      whole_line_comment = 0;
      line_contains_code = 0;
      line_start = 0;
    }
  }

  action lua_long_ec_res { equal_count = 0; }
  action lua_long_ec_inc { equal_count++; }
  action lua_long_ec_dec { equal_count--; }

  lua_long_comment =
    '--' @comment ('[' >lua_long_ec_res '='* $lua_long_ec_inc '[') (
      newline %{ entity = INTERNAL_NL; } %lua_callback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> (']' '='* $lua_long_ec_dec ']' when { equal_count == 0 });
  lua_line_comment = '--' @comment nonnewline*;
  lua_comment = lua_long_comment | lua_line_comment;

  lua_long_string =
    ('[' >lua_long_ec_res '='* $lua_long_ec_inc '[') @code (
      newline %{ entity = INTERNAL_NL; } %lua_callback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> (']' '='* $lua_long_ec_dec ']' when { equal_count == 0 });
  lua_sq_str =
    '\'' @code (
      newline %{ entity = INTERNAL_NL; } %lua_callback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  lua_dq_str =
    '"' @code (
      newline %{ entity = INTERNAL_NL; } %lua_callback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  lua_string = lua_sq_str | lua_dq_str | lua_long_string;

  lua_integer = '-'? (hex_num | dec_num);
  lua_number = float | lua_integer;

  lua_identifier = ([a-zA-Z] | '_') (alnum + '_')*;

  lua_operator = '~=' | [+\-*/%^#=<>,;:,.{}\[\]()];

  lua_line := |*
    spaces         ${ entity = LUA_SPACE;      } => lua_callback;
    lua_comment    ${ entity = LUA_COMMENT;    } => lua_callback;
    lua_string     ${ entity = LUA_STRING;     } => lua_callback;
    lua_number     ${ entity = LUA_NUMBER;     } => lua_callback;
    lua_identifier ${ entity = LUA_IDENTIFIER; } => lua_callback;
    lua_operator   ${ entity = LUA_OPERATOR;   } => lua_callback;
    newline        ${ entity = LUA_NEWLINE;    } => lua_callback;
  *|;
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
  if (count) {
    %% write exec lua_line;
    // no newline at EOF; get contents of last line
    if ((whole_line_comment || line_contains_code) && callback) {
      if (line_contains_code)
        callback(LUA_LANG, "lcode", cint(line_start), cint(pe));
      else if (whole_line_comment)
        callback(LUA_LANG, "lcomment", cint(line_start), cint(pe));
    }
  }
}
