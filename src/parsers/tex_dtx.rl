// tex_dtx.rl written by Raphael Pinson,
// based on tex.rl by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_TEX_DTX_PARSER_H
#define OHCOUNT_TEX_DTX_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *TEX_DTX_LANG = LANG_TEX_DTX;

// the languages entities
const char *tex_dtx_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  TEX_DTX_SPACE = 0, TEX_DTX_COMMENT, TEX_DTX_STRING, TEX_DTX_ANY
};

/*****************************************************************************/

%%{
  machine tex_dtx;
  write data;
  include common "common.rl";

  # Line counting machine

  action tex_dtx_ccallback {
    switch(entity) {
    case TEX_DTX_SPACE:
      ls
      break;
    case TEX_DTX_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(TEX_DTX_LANG)
      break;
    case NEWLINE:
      std_newline(TEX_DTX_LANG)
    }
  }

  tex_dtx_comment = '%%' @comment nonnewline*;

  tex_dtx_line := |*
    spaces       ${ entity = TEX_DTX_SPACE; } => tex_dtx_ccallback;
    tex_dtx_comment;
    newline      ${ entity = NEWLINE;   } => tex_dtx_ccallback;
    ^space       ${ entity = TEX_DTX_ANY;   } => tex_dtx_ccallback;
  *|;

  # Entity machine

  action tex_dtx_ecallback {
    callback(TEX_DTX_LANG, tex_dtx_entities[entity], cint(ts), cint(te), userdata);
  }

  tex_dtx_comment_entity = '%%' nonnewline*;

  tex_dtx_entity := |*
    space+             ${ entity = TEX_DTX_SPACE;   } => tex_dtx_ecallback;
    tex_dtx_comment_entity ${ entity = TEX_DTX_COMMENT; } => tex_dtx_ecallback;
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
void parse_tex_dtx(char *buffer, int length, int count,
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? tex_dtx_en_tex_dtx_line : tex_dtx_en_tex_dtx_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(TEX_DTX_LANG) }
}

#endif

/*****************************************************************************/
