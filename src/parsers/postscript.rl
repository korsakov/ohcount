/************************* Required for every parser *************************/
#ifndef OHCOUNT_PS_PARSER_H
#define OHCOUNT_PS_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *POSTSCRIPT_LANG = LANG_POSTSCRIPT;

// the languages entities
const char *postscript_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  POSTSCRIPT_SPACE = 0, POSTSCRIPT_COMMENT, POSTSCRIPT_STRING, POSTSCRIPT_ANY
};

/*****************************************************************************/

%%{
  machine postscript;
  write data;
  include common "common.rl";

  # Line counting
  
  action postscript_ccallback {
  switch(entity) {
    case POSTSCRIPT_SPACE:
      ls
      break;
    case POSTSCRIPT_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(POSTSCRIPT_LANG)
      break;
    case NEWLINE:
      std_newline(POSTSCRIPT_LANG)
  }
  }
  
  postscript_comment = '%' @comment nonnewline*;
  
  postscript_string = '(' @code ([^\r\n\f])* ')';
  
  postscript_line := |*
    spaces ${ entity = POSTSCRIPT_SPACE; } => postscript_ccallback;
    postscript_comment;
    postscript_string;
    newline ${ entity = NEWLINE;         } => postscript_ccallback;
    ^space ${ entity = POSTSCRIPT_ANY; } => postscript_ccallback;
  *|;
  
  # Entity Machine
  
  action postscript_ecallback {
    callback(POSTSCRIPT_LANG, postscript_entities[entity], cint(ts), cint(te),
             userdata);
  }
  
  postscript_comment_entity = '%' nonnewline*;
  
  postscript_entity := |*
    space+ ${ entity = POSTSCRIPT_SPACE; } => postscript_ecallback;
    postscript_comment_entity ${ entity = POSTSCRIPT_COMMENT; } => postscript_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with PostScript code.
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
void parse_postscript(char *buffer, int length, int count,
             void (*callback) (const char *lang, const char *entity, int s,
                               int e, void *udata),
             void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? postscript_en_postscript_line : postscript_en_postscript_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(POSTSCRIPT_LANG) }
}

#endif

/*****************************************************************************/
