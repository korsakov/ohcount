// haxe.rl patched by Niel Drummond from actionscript version written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_HAXE_PARSER_H
#define OHCOUNT_HAXE_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *HX_LANG = LANG_HAXE;

// the languages entities
const char *hx_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  HX_SPACE = 0, HX_COMMENT, HX_STRING, HX_ANY
};

/*****************************************************************************/

%%{
  machine haxe;
  write data;
  include common "common.rl";

  # Line counting machine

  action hx_ccallback {
    switch(entity) {
    case HX_SPACE:
      ls
      break;
    case HX_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(HX_LANG)
      break;
    case NEWLINE:
      std_newline(HX_LANG)
    }
  }

  hx_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %hx_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;

		hx_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %hx_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  hx_comment = hx_line_comment | hx_block_comment;

  hx_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  hx_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  hx_string = hx_sq_str | hx_dq_str;

  hx_line := |*
    spaces      ${ entity = HX_SPACE; } => hx_ccallback;
    hx_comment;
    hx_string;
    newline     ${ entity = NEWLINE;  } => hx_ccallback;
    ^space      ${ entity = HX_ANY;   } => hx_ccallback;
  *|;

  # Entity machine

  action hx_ecallback {
    callback(HX_LANG, hx_entities[entity], cint(ts), cint(te), userdata);
  }
  hx_line_comment_entity = '//' nonnewline*;
  hx_block_comment_entity = '/*' any* :>> '*/';
  hx_comment_entity = hx_line_comment_entity | hx_block_comment_entity;

  hx_entity := |*
    space+            ${ entity = HX_SPACE;   } => hx_ecallback;
    hx_comment_entity ${ entity = HX_COMMENT; } => hx_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Haxe code.
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
void parse_haxe(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? haxe_en_hx_line : haxe_en_hx_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(HX_LANG) }
}

#endif

/*****************************************************************************/
