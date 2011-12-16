// bat.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_BAT_PARSER_H
#define OHCOUNT_BAT_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *BAT_LANG = LANG_BAT;

// the languages entities
const char *bat_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  BAT_SPACE = 0, BAT_COMMENT, BAT_STRING, BAT_ANY
};

/*****************************************************************************/

%%{
  machine bat;
  write data;
  include common "common.rl";

  # Line counting machine

  action bat_ccallback {
    switch(entity) {
    case BAT_SPACE:
      ls
      break;
    case BAT_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(BAT_LANG)
      break;
    case NEWLINE:
      std_newline(BAT_LANG)
    }
  }

  bat_comment = ( /rem/i | /@rem/i | '::' ) @comment nonnewline*;

  bat_line := |*
    spaces       ${ entity = BAT_SPACE; } => bat_ccallback;
    bat_comment;
    newline      ${ entity = NEWLINE;   } => bat_ccallback;
    ^space       ${ entity = BAT_ANY;   } => bat_ccallback;
  *|;

  # Entity machine

  action bat_ecallback {
    callback(BAT_LANG, bat_entities[entity], cint(ts), cint(te), userdata);
  }

  bat_comment_entity = ( /rem/i | /@rem/i | '::' ) nonnewline*;

  bat_entity := |*
    space+             ${ entity = BAT_SPACE;   } => bat_ecallback;
    bat_comment_entity ${ entity = BAT_COMMENT; } => bat_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Batch code.
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
void parse_bat(char *buffer, int length, int count,
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? bat_en_bat_line : bat_en_bat_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(BAT_LANG) }
}

#endif

/*****************************************************************************/
