// mxml.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_MXML_PARSER_H
#define OHCOUNT_MXML_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *MXML_LANG = LANG_MXML;

// the languages entities
const char *mxml_entities[] = {
  "space", "comment", "doctype",
  "tag", "entity", "any"
};

// constants associated with the entities
enum {
  MXML_SPACE = 0, MXML_COMMENT, MXML_DOCTYPE,
  MXML_TAG, MXML_ENTITY, MXML_ANY
};

/*****************************************************************************/

#include "css.h"
#include "actionscript.h"

%%{
  machine mxml;
  write data;
  include common "common.rl";
  #EMBED(css)
  #EMBED(actionscript)

  # Line counting machine

  action mxml_ccallback {
    switch(entity) {
    case MXML_SPACE:
      ls
      break;
    case MXML_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(MXML_LANG)
      break;
    case NEWLINE:
      std_newline(MXML_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(MXML_LANG)
    }
  }

  mxml_comment =
    '<!--' @comment (
      newline %{ entity = INTERNAL_NL; } %mxml_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '-->';

  mxml_sq_str =
    '\'' @code (
      newline %{ entity = INTERNAL_NL; } %mxml_ccallback
      |
      ws
      |
      [^\r\n\f\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  mxml_dq_str =
    '"' @code (
      newline %{ entity = INTERNAL_NL; } %mxml_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  mxml_string = mxml_sq_str | mxml_dq_str;

  ws_or_inl = (ws | newline @{ entity = INTERNAL_NL; } %mxml_ccallback);

  mxml_css_entry = '<mx:Style>' @code;
  mxml_css_outry = '</mx:Style>' @check_blank_outry @code;
  mxml_css_line := |*
    mxml_css_outry @{ p = ts; fret; };
    # unmodified CSS patterns
    spaces      ${ entity = CSS_SPACE; } => css_ccallback;
    css_comment;
    css_string;
    newline     ${ entity = NEWLINE;   } => css_ccallback;
    ^space      ${ entity = CSS_ANY;   } => css_ccallback;
  *|;

  mxml_as_entry = '<mx:Script>' @code;
  mxml_as_outry = '</mx:Script>' @check_blank_outry @code;
  mxml_as_line := |*
    mxml_as_outry @{ p = ts; fret; };
    # unmodified Actionscript patterns
    spaces      ${ entity = AS_SPACE; } => as_ccallback;
    as_comment;
    as_string;
    newline     ${ entity = NEWLINE;  } => as_ccallback;
    ^space      ${ entity = AS_ANY;   } => as_ccallback;
  *|;

  mxml_line := |*
    mxml_css_entry @{ entity = CHECK_BLANK_ENTRY; } @mxml_ccallback
      @{ saw(CSS_LANG); } => { fcall mxml_css_line; };
    mxml_as_entry @{ entity = CHECK_BLANK_ENTRY; } @mxml_ccallback
      @{ saw(AS_LANG); } => { fcall mxml_as_line; };
    # standard MXML patterns
    spaces        ${ entity = MXML_SPACE; } => mxml_ccallback;
    mxml_comment;
    mxml_string;
    newline       ${ entity = NEWLINE;    } => mxml_ccallback;
    ^space        ${ entity = MXML_ANY;   } => mxml_ccallback;
  *|;

  # Entity machine

  action mxml_ecallback {
    callback(MXML_LANG, mxml_entities[entity], cint(ts), cint(te), userdata);
  }

  mxml_css_entry_entity = '<mx:Style>';
  mxml_css_outry_entity = '</mx:Style>';
  mxml_css_entity := |*
    mxml_css_outry_entity @{ fret; };
    # unmodified CSS patterns
    space+             ${ entity = CSS_SPACE;   } => css_ecallback;
    css_comment_entity ${ entity = CSS_COMMENT; } => css_ecallback;
    # TODO:
    ^space;
  *|;

  mxml_as_entry_entity = '<mx:Script>';
  mxml_as_outry_entity = '</mx:Script>';
  mxml_as_entity := |*
    mxml_as_outry_entity @{ fret; };
    # unmodified Actionscript patterns
    space+            ${ entity = AS_SPACE;   } => as_ecallback;
    as_comment_entity ${ entity = AS_COMMENT; } => as_ecallback;
    # TODO:
    ^space;
  *|;

  mxml_comment_entity = '<!--' any* :>> '-->';

  mxml_entity := |*
    # TODO: mxml_ecallback for mxml_*_{entry,outry}_entity
    mxml_css_entry_entity => { fcall mxml_css_entity; };
    mxml_as_entry_entity  => { fcall mxml_as_entity;  };
    # standard MXML patterns
    space+              ${ entity = MXML_SPACE;   } => mxml_ecallback;
    mxml_comment_entity ${ entity = MXML_COMMENT; } => mxml_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with MXML markup.
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
void parse_mxml(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? mxml_en_mxml_line : mxml_en_mxml_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(MXML_LANG) }
}

#endif

/*****************************************************************************/
