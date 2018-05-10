/************************* Required for every parser *************************/
#ifndef OHCOUNT_COFFEESCRIPT_PARSER_H
#define OHCOUNT_COFFEESCRIPT_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *COFFEESCRIPT_LANG = LANG_COFFEESCRIPT;

// the languages entities
const char *coffeescript_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  COFFEESCRIPT_SPACE = 0, COFFEESCRIPT_COMMENT, COFFEESCRIPT_STRING, COFFEESCRIPT_ANY
};

/*****************************************************************************/

#include "javascript.h"

%%{
  machine coffeescript;
  write data;
  include common "common.rl";
  #EMBED(javascript)

  # Line counting machine

  action coffeescript_ccallback {
    switch(entity) {
    case COFFEESCRIPT_SPACE:
      ls
      break;
    case COFFEESCRIPT_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(COFFEESCRIPT_LANG)
      break;
    case NEWLINE:
      std_newline(COFFEESCRIPT_LANG)
    }
  }

  coffeescript_line_comment = ('#') @comment nonnewline*;
  coffeescript_block_comment =
    '###' @comment (
      newline %{ entity = INTERNAL_NL; } %coffeescript_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '###';
  coffeescript_comment = coffeescript_line_comment | coffeescript_block_comment;

  coffeescript_sq_str =
    '\'' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %coffeescript_ccallback
      |
      ws
      |
      [^\r\n\f\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'' @commit @code;
  coffeescript_dq_str =
    '"' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %coffeescript_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"' @commit @code;
  coffeescript_sq_here_doc =
    '\'\'\'' @code (
      newline %{ entity = INTERNAL_NL; } %coffeescript_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> '\'\'\'' @code;
  coffeescript_dq_here_doc =
    '"""' @code (
      newline %{ entity = INTERNAL_NL; } %coffeescript_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> '"""' @code;
  coffeescript_string = (coffeescript_sq_str | coffeescript_dq_str |
		coffeescript_sq_here_doc | coffeescript_dq_here_doc) @code;

  coffeescript_js_entry = '`' @code;
  coffeescript_js_outry = '`' @check_blank_outry @code;
	coffeescript_js_line := |*
    coffeescript_js_outry @{ p = ts; fret; };
    # unmodified JavaScript patterns
    spaces        ${ entity = JS_SPACE; } => js_ccallback;
    js_comment;
    js_string;
    newline       ${ entity = NEWLINE;    } => js_ccallback;
    ^space        ${ entity = JS_ANY;   } => js_ccallback;
  *|;

  coffeescript_line := |*
		coffeescript_js_entry @coffeescript_ccallback
			@{ saw(JS_LANG); } => { fcall coffeescript_js_line; };
    spaces          ${ entity = COFFEESCRIPT_SPACE; } => coffeescript_ccallback;
    coffeescript_comment;
    coffeescript_string;
    newline         ${ entity = NEWLINE;      } => coffeescript_ccallback;
    ^space          ${ entity = COFFEESCRIPT_ANY;   } => coffeescript_ccallback;
  *|;

  # Entity machine

  action coffeescript_ecallback {
    callback(COFFEESCRIPT_LANG, coffeescript_entities[entity], cint(ts), cint(te),
             userdata);
  }

  coffeescript_line_comment_entity = ('#') nonnewline*;
  coffeescript_block_comment_entity = '###' any* :>> '###';
  coffeescript_comment_entity = coffeescript_line_comment_entity |
    coffeescript_block_comment_entity;

  coffeescript_entity := |*
    space+                ${ entity = COFFEESCRIPT_SPACE;   } => coffeescript_ecallback;
    coffeescript_comment_entity ${ entity = COFFEESCRIPT_COMMENT; } => coffeescript_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with CoffeeScript code.
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
void parse_coffeescript(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? coffeescript_en_coffeescript_line : coffeescript_en_coffeescript_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(COFFEESCRIPT_LANG) }
}

#endif

/*****************************************************************************/
