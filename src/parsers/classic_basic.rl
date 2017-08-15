/************************* Required for every parser *************************/
#ifndef OHCOUNT_CLASSIC_BASIC_PARSER_H
#define OHCOUNT_CLASSIC_BASIC_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *CB_LANG = LANG_CLASSIC_BASIC;

// the languages entities
const char *cb_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  CB_SPACE = 0, CB_COMMENT, CB_STRING, CB_ANY,
};

/*****************************************************************************/

%%{
  machine classic_basic;
  write data;
  include common "common.rl";

  # Line counting machine

  action cb_ccallback {
    switch(entity) {
    case CB_SPACE:
      ls
      break;
    case CB_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(CB_LANG)
      break;
    case NEWLINE:
      std_newline(CB_LANG)
    }
  }

  cb_comment = dec_num spaces ("'" | /rem/i) @comment nonnewline*;

  cb_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  cb_line := |*
    spaces      ${ entity = CB_SPACE; } => cb_ccallback;
    cb_comment;
    cb_string;
    newline     ${ entity = NEWLINE;  } => cb_ccallback;
    ^space      ${ entity = CB_ANY;   } => cb_ccallback;
  *|;

  # Entity machine

  action cb_ecallback {
    callback(CB_LANG, cb_entities[entity], cint(ts), cint(te), userdata);
  }

  cb_comment_entity = ("'" | /rem/i ws+) nonnewline*;

  cb_entity := |*
    space+            ${ entity = CB_SPACE;   } => cb_ecallback;
    cb_comment_entity ${ entity = CB_COMMENT; } => cb_ecallback;
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
void parse_classic_basic(char *buffer, int length, int count,
                         void (*callback) (const char *lang, const char *entity,
                                           int s, int e, void *udata),
                         void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? classic_basic_en_cb_line : classic_basic_en_cb_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(CB_LANG) }
}

#endif

/*****************************************************************************/
