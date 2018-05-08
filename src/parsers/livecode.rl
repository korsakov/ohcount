// livecode.rl written by Monte Goulding. monte<att>goulding<dott>ws.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_LIVECODE_PARSER_H
#define OHCOUNT_LIVECODE_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *LIVECODE_LANG = LANG_LIVECODE;

// the languages entities
const char *livecode_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  LIVECODE_SPACE = 0, LIVECODE_COMMENT, LIVECODE_STRING, LIVECODE_ANY
};

/*****************************************************************************/

%%{
  machine livecode;
  write data;
  include common "common.rl";

  # Line counting machine

  action livecode_ccallback {
    switch(entity) {
    case LIVECODE_SPACE:
      ls
      break;
    case LIVECODE_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(LIVECODE_LANG)
      break;
    case NEWLINE:
      std_newline(LIVECODE_LANG)
    }
  }

  livecode_line_comment = ('--' | '#' | '//') @comment nonnewline*;
  livecode_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %livecode_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
	  
  livecode_comment = livecode_line_comment | livecode_block_comment;

  livecode_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  
  livecode_line := |*
    spaces       ${ entity = LIVECODE_SPACE; } => livecode_ccallback;
    livecode_comment;
    livecode_string;
    newline      ${ entity = NEWLINE;   } => livecode_ccallback;
    ^space       ${ entity = LIVECODE_ANY;   } => livecode_ccallback;
  *|;

  # Entity machine

  action livecode_ecallback {
    callback(LIVECODE_LANG, livecode_entities[entity], cint(ts), cint(te), userdata);
  }

  livecode_line_comment_entity = ('--' | '#' | '//') nonnewline*;
  livecode_block_comment_entity = '/*' any* :>> '*/';
  livecode_comment_entity = livecode_line_comment_entity | livecode_block_comment_entity;

  livecode_entity := |*
    space+             ${ entity = LIVECODE_SPACE;   } => livecode_ecallback;
    livecode_comment_entity ${ entity = LIVECODE_COMMENT; } => livecode_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with LiveCode code.
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
void parse_livecode(char *buffer, int length, int count,
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? livecode_en_livecode_line : livecode_en_livecode_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(LIVECODE_LANG) }
}

#endif

/*****************************************************************************/
