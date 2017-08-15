// tex.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_TEX_PARSER_H
#define OHCOUNT_TEX_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *TEX_LANG = LANG_TEX;

// the languages entities
const char *tex_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  TEX_SPACE = 0, TEX_COMMENT, TEX_STRING, TEX_ANY
};

/*****************************************************************************/

%%{
  machine tex;
  write data;
  include common "common.rl";

  # Line counting machine

  action tex_ccallback {
    switch(entity) {
    case TEX_SPACE:
      ls
      break;
    case TEX_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(TEX_LANG)
      break;
    case NEWLINE:
      std_newline(TEX_LANG)
    }
  }

  tex_comment = '%' @comment nonnewline*;

  tex_line := |*
    spaces       ${ entity = TEX_SPACE; } => tex_ccallback;
    tex_comment;
    newline      ${ entity = NEWLINE;   } => tex_ccallback;
    ^space       ${ entity = TEX_ANY;   } => tex_ccallback;
  *|;

  # Entity machine

  action tex_ecallback {
    callback(TEX_LANG, tex_entities[entity], cint(ts), cint(te), userdata);
  }

  tex_comment_entity = '%' nonnewline*;

  tex_entity := |*
    space+             ${ entity = TEX_SPACE;   } => tex_ecallback;
    tex_comment_entity ${ entity = TEX_COMMENT; } => tex_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Tex markup.
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
void parse_tex(char *buffer, int length, int count,
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? tex_en_tex_line : tex_en_tex_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(TEX_LANG) }
}

#endif

/*****************************************************************************/
