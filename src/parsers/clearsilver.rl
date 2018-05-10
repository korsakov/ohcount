// clearsilver.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_CS_PARSER_H
#define OHCOUNT_CS_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *CS_LANG = LANG_CLEARSILVER;

// the languages entities
const char *cs_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  CS_SPACE = 0, CS_COMMENT, CS_STRING, CS_ANY
};

/*****************************************************************************/

%%{
  machine clearsilver;
  write data;
  include common "common.rl";

  # Line counting machine

  action cs_ccallback {
    switch(entity) {
    case CS_SPACE:
      ls
      break;
    case CS_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(CS_LANG)
      break;
    case NEWLINE:
      std_newline(CS_LANG)
    }
  }

  cs_comment = '#' @comment nonnewline*;

  cs_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  cs_line := |*
    spaces      ${ entity = CS_SPACE; } => cs_ccallback;
    cs_comment;
    cs_string;
    newline     ${ entity = NEWLINE;  } => cs_ccallback;
    ^space      ${ entity = CS_ANY;   } => cs_ccallback;
  *|;

  # Entity machine

  action cs_ecallback {
    callback(CS_LANG, cs_entities[entity], cint(ts), cint(te), userdata);
  }

  cs_comment_entity = '#' nonnewline*;

  cs_entity := |*
    space+            ${ entity = CS_SPACE;   } => cs_ecallback;
    cs_comment_entity ${ entity = CS_COMMENT; } => cs_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Clearsilver code (not in HTML).
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
void parse_clearsilver(char *buffer, int length, int count,
                       void (*callback) (const char *lang, const char *entity,
                                         int s, int e, void *udata),
                       void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? clearsilver_en_cs_line : clearsilver_en_cs_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(CS_LANG) }
}

#endif

/*****************************************************************************/
