// unrealscript.rl derived from code written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_UNREALSCRIPT_PARSER_H
#define OHCOUNT_UNREALSCRIPT_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *UNREALSCRIPT_LANG = LANG_UNREALSCRIPT;

// the languages entities
const char *unrealscript_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  UNREALSCRIPT_SPACE = 0, UNREALSCRIPT_COMMENT, UNREALSCRIPT_STRING, UNREALSCRIPT_ANY
};

/*****************************************************************************/

%%{
  machine unrealscript;
  write data;
  include common "common.rl";

  # Line counting machine

  action unrealscript_ccallback {
    switch(entity) {
    case UNREALSCRIPT_SPACE:
      ls
      break;
    case UNREALSCRIPT_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(UNREALSCRIPT_LANG)
      break;
    case NEWLINE:
      std_newline(UNREALSCRIPT_LANG)
    }
  }

  unrealscript_line_comment = '//' @comment nonnewline*;
  unrealscript_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %unrealscript_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  unrealscript_comment = unrealscript_line_comment | unrealscript_block_comment;

  unrealscript_sq_str =
    '\'' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %unrealscript_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  unrealscript_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %unrealscript_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  unrealscript_string = unrealscript_sq_str | unrealscript_dq_str;

  unrealscript_line := |*
    spaces     ${ entity = UNREALSCRIPT_SPACE; } => unrealscript_ccallback;
    unrealscript_comment;
    unrealscript_string;
    newline    ${ entity = NEWLINE;            } => unrealscript_ccallback;
    ^space     ${ entity = UNREALSCRIPT_ANY;   } => unrealscript_ccallback;
  *|;

  # Entity machine

  action unrealscript_ecallback {
    callback(UNREALSCRIPT_LANG, unrealscript_entities[entity], cint(ts), cint(te), userdata);
  }

  unrealscript_line_comment_entity = '//' nonnewline*;
  unrealscript_block_comment_entity = '/*' any* :>> '*/';
  unrealscript_comment_entity = unrealscript_line_comment_entity | unrealscript_block_comment_entity;

  unrealscript_entity := |*
    space+                      ${ entity = UNREALSCRIPT_SPACE;   } => unrealscript_ecallback;
    unrealscript_comment_entity ${ entity = UNREALSCRIPT_COMMENT; } => unrealscript_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with UnrealScript code.
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
void parse_unrealscript(char *buffer, int length, int count,
             void (*callback) (const char *lang, const char *entity, int s,
                               int e, void *udata),
             void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? unrealscript_en_unrealscript_line : unrealscript_en_unrealscript_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(UNREALSCRIPT_LANG) }
}

#endif

/*****************************************************************************/
