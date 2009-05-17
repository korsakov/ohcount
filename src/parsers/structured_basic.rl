/************************* Required for every parser *************************/
#ifndef OHCOUNT_STRUCTURED_BASIC_PARSER_H
#define OHCOUNT_STRUCTURED_BASIC_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *SB_LANG = LANG_STRUCTURED_BASIC;

// the languages entities
const char *sb_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  SB_SPACE = 0, SB_COMMENT, SB_STRING, SB_ANY,
};

/*****************************************************************************/

%%{
  machine structured_basic;
  write data;
  include common "common.rl";

  # Line counting machine

  action sb_ccallback {
    switch(entity) {
    case SB_SPACE:
      ls
      break;
    case SB_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(SB_LANG)
      break;
    case NEWLINE:
      std_newline(SB_LANG)
    }
  }

  sb_comment = ('\'' | /rem/i) @comment nonnewline*;

  sb_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  sb_line := |*
    spaces      ${ entity = SB_SPACE; } => sb_ccallback;
    sb_comment;
    sb_string;
    newline     ${ entity = NEWLINE;  } => sb_ccallback;
    ^space      ${ entity = SB_ANY;   } => sb_ccallback;
  *|;

  # Entity machine

  action sb_ecallback {
    callback(SB_LANG, sb_entities[entity], cint(ts), cint(te), userdata);
  }

  sb_comment_entity = ('\'' | /rem/i) nonnewline*;

  sb_entity := |*
    space+            ${ entity = SB_SPACE;   } => sb_ecallback;
    sb_comment_entity ${ entity = SB_COMMENT; } => sb_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Structured BASIC code.
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
void parse_structured_basic(char *buffer, int length, int count,
                            void (*callback) (const char *lang,
                                              const char *entity, int s, int e,
                                              void *udata),
                            void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? structured_basic_en_sb_line : structured_basic_en_sb_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(SB_LANG) }
}

#endif

/*****************************************************************************/
