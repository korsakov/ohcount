// mp_with_tex.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_MPTEX_PARSER_H
#define OHCOUNT_MPTEX_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *MPTEX_LANG = LANG_METAPOST;

// the languages entities
const char *mptex_entities[] = {
  "space", "comment", "string", "any"
};


// constants associated with the entities
enum {
  MPTEX_SPACE = 0, MPTEX_COMMENT, MPTEX_STRING, MPTEX_ANY
};

/*****************************************************************************/

#include "tex.h"

%%{
  machine mptex;
  write data;
  include common "common.rl";
  #EMBED(tex)

  # Line counting machine

  action mptex_ccallback {
    switch(entity) {
    case MPTEX_SPACE:
      ls
      break;
    case MPTEX_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(MPTEX_LANG)
      break;
    case NEWLINE:
      std_newline(MPTEX_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(MPTEX_LANG)
    }
  }

  mptex_comment = '%' @{ fhold; } @comment nonnewline*;

  mptex_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  mptex_tex_entry = ('verbatimtex' | 'btex') @code;
  mptex_tex_outry = 'etex' @check_blank_outry @code;
  mptex_tex_line := |*
    mptex_tex_outry @{ p = ts; fret; };
    # unmodified Tex patterns
    spaces       ${ entity = TEX_SPACE; } => tex_ccallback;
    tex_comment;
    newline      ${ entity = NEWLINE;   } => tex_ccallback;
    ^space       ${ entity = TEX_ANY;   } => tex_ccallback;
  *|;

  mptex_line := |*
    mptex_tex_entry @{ entity = CHECK_BLANK_ENTRY; } @mptex_ccallback
      @{ saw(TEX_LANG); } => { fcall mptex_tex_line; };
    # standard Metapost patterns
    spaces            ${ entity = MPTEX_SPACE; } => mptex_ccallback;
    mptex_comment;
    mptex_string;
    newline           ${ entity = NEWLINE;        } => mptex_ccallback;
    ^space            ${ entity = MPTEX_ANY;   } => mptex_ccallback;
  *|;

  # Entity machine

  action mptex_ecallback {
    callback(MPTEX_LANG, mptex_entities[entity], cint(ts), cint(te), userdata);
  }

  mptex_tex_entry_entity = 'verbatimtex' | 'btex';
  mptex_tex_outry_entity = 'etex';
  mptex_tex_entity := |*
    mptex_tex_outry_entity @{ fret; };
    # unmodified Tex patterns
    space+             ${ entity = TEX_SPACE;   } => tex_ecallback;
    tex_comment_entity ${ entity = TEX_COMMENT; } => tex_ecallback;
    # TODO:
    ^space;
  *|;

  mptex_comment_entity = '%' nonnewline*;

  mptex_entity := |*
    # TODO: mptex_ecallback for mptex_*_{entry,outry}_entity
    mptex_tex_entry_entity => { fcall mptex_tex_entity; };
    # standard mptex patterns
    space+               ${ entity = MPTEX_SPACE;   } => mptex_ecallback;
    mptex_comment_entity ${ entity = MPTEX_COMMENT; } => mptex_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Metapost code.
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
void parse_mptex(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? mptex_en_mptex_line : mptex_en_mptex_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(MPTEX_LANG) }
}

#endif

/*****************************************************************************/
