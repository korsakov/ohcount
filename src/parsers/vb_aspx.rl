/************************* Required for every parser *************************/
#ifndef OHCOUNT_VB_ASPX_PARSER_H
#define OHCOUNT_VB_ASPX_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *VB_ASPX_LANG = LANG_HTML;

// the languages entities
const char *vb_aspx_entities[] = {
  "space", "comment", "doctype",
  "tag", "entity", "any"
};

// constants associated with the entities
enum {
  VB_ASPX_SPACE = 0, VB_ASPX_COMMENT, VB_ASPX_DOCTYPE,
  VB_ASPX_TAG, VB_ASPX_ENTITY, VB_ASPX_ANY
};

/*****************************************************************************/

#include "css.h"
#include "javascript.h"
#include "visual_basic.h"

%%{
  machine vb_aspx;
  write data;
  include common "common.rl";
  #EMBED(css)
  #EMBED(javascript)
  #EMBED(visual_basic)

  # Line counting machine

  action vb_aspx_ccallback {
    switch(entity) {
    case VB_ASPX_SPACE:
      ls
      break;
    case VB_ASPX_ANY:
      code
      break;
    case INTERNAL_NL:
      emb_internal_newline(VB_ASPX_LANG)
      break;
    case NEWLINE:
      emb_newline(VB_ASPX_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(VB_ASPX_LANG)
    }
  }

  vb_aspx_comment := (
    newline %{ entity = INTERNAL_NL; } %vb_aspx_ccallback
    |
    ws
    |
    ^(space | [\-<]) @comment
    |
    '<' '%' @{ saw(VB_LANG); fcall vb_aspx_cs_line; }
    |
    '<' !'%'
  )* :>> '-->' @comment @{ fgoto vb_aspx_line; };

  vb_aspx_sq_str := (
    newline %{ entity = INTERNAL_NL; } %vb_aspx_ccallback
    |
    ws
    |
    [^\r\n\f\t '\\<] @code
    |
    '\\' nonnewline @code
    |
    '<' '%' @{ saw(VB_LANG); fcall vb_aspx_cs_line; }
    |
    '<' !'%'
  )* '\'' @{ fgoto vb_aspx_line; };
  vb_aspx_dq_str := (
    newline %{ entity = INTERNAL_NL; } %vb_aspx_ccallback
    |
    ws
    |
    [^\r\n\f\t "\\<] @code
    |
    '\\' nonnewline @code
    |
    '<' '%' @{ saw(VB_LANG); fcall vb_aspx_cs_line; }
    |
    '<' !'%'
  )* '"' @{ fgoto vb_aspx_line; };

  ws_or_inl = (ws | newline @{ entity = INTERNAL_NL; } %vb_aspx_ccallback);

  vb_aspx_css_entry = '<' /style/i [^>]+ :>> 'text/css' [^>]+ '>' @code;
  vb_aspx_css_outry = '</' /style/i ws_or_inl* '>' @check_blank_outry @code;
  vb_aspx_css_line := |*
    vb_aspx_css_outry @{ p = ts; fret; };
    # unmodified CSS patterns
    spaces      ${ entity = CSS_SPACE; } => css_ccallback;
    css_comment;
    css_string;
    newline     ${ entity = NEWLINE;   } => css_ccallback;
    ^space      ${ entity = CSS_ANY;   } => css_ccallback;
  *|;

  vb_aspx_js_entry = '<' /script/i [^>]+ :>> 'text/javascript' [^>]+ '>' @code;
  vb_aspx_js_outry = '</' /script/i ws_or_inl* '>' @check_blank_outry @code;
  vb_aspx_js_line := |*
    vb_aspx_js_outry @{ p = ts; fret; };
    # unmodified Javascript patterns
    spaces     ${ entity = JS_SPACE; } => js_ccallback;
    js_comment;
    js_string;
    newline    ${ entity = NEWLINE;  } => js_ccallback;
    ^space     ${ entity = JS_ANY;   } => js_ccallback;
  *|;

  vb_aspx_cs_entry = ('<%' | '<' /script/i [^>]+ :>> 'server' [^>]+ '>') @code;
  vb_aspx_cs_outry = ('%>' | '</' /script/i ws_or_inl* '>' @check_blank_outry) @code;
  vb_aspx_cs_line := |*
    vb_aspx_cs_outry @{ p = ts; fret; };
    # unmodified VB patterns
    spaces        ${ entity = VB_SPACE; } => vb_ccallback;
    vb_comment;
    vb_string;
    newline       ${ entity = NEWLINE;    } => vb_ccallback;
    ^space        ${ entity = VB_ANY;   } => vb_ccallback;
  *|;

  vb_aspx_line := |*
    vb_aspx_css_entry @{ entity = CHECK_BLANK_ENTRY; } @vb_aspx_ccallback
      @{ saw(CSS_LANG); } => { fcall vb_aspx_css_line; };
    vb_aspx_js_entry @{ entity = CHECK_BLANK_ENTRY; } @vb_aspx_ccallback
      @{ saw(JS_LANG); } => { fcall vb_aspx_js_line; };
    vb_aspx_cs_entry @{ entity = CHECK_BLANK_ENTRY; } @vb_aspx_ccallback
      @{ saw(VB_LANG); } => { fcall vb_aspx_cs_line; };
    # standard VB_ASPX patterns
    spaces       ${ entity = VB_ASPX_SPACE; } => vb_aspx_ccallback;
    '<!--'       @comment                   => { fgoto vb_aspx_comment; };
    '\''         @code                      => { fgoto vb_aspx_sq_str;  };
    '"'          @code                      => { fgoto vb_aspx_dq_str;  };
    newline      ${ entity = NEWLINE;     } => vb_aspx_ccallback;
    ^space       ${ entity = VB_ASPX_ANY;   } => vb_aspx_ccallback;
  *|;

  # Entity machine

  action vb_aspx_ecallback {
    callback(VB_ASPX_LANG, vb_aspx_entities[entity], cint(ts), cint(te),
             userdata);
  }

  vb_aspx_css_entry_entity = '<' /style/i [^>]+ :>> 'text/css' [^>]+ '>';
  vb_aspx_css_outry_entity = '</' /style/i ws_or_inl* '>';
  vb_aspx_css_entity := |*
    vb_aspx_css_outry_entity @{ fret; };
    # unmodified CSS patterns
    space+             ${ entity = CSS_SPACE;   } => css_ecallback;
    css_comment_entity ${ entity = CSS_COMMENT; } => css_ecallback;
    # TODO:
    ^space;
  *|;

  vb_aspx_js_entry_entity = '<' /script/i [^>]+ :>> 'text/javascript' [^>]+ '>';
  vb_aspx_js_outry_entity = '</' /script/i ws_or_inl* '>';
  vb_aspx_js_entity := |*
    vb_aspx_js_outry_entity @{ fret; };
    # unmodified Javascript patterns
    space+            ${ entity = JS_SPACE;   } => js_ecallback;
    js_comment_entity ${ entity = JS_COMMENT; } => js_ecallback;
    # TODO:
    ^space;
  *|;

  vb_aspx_cs_entry_entity = ('<%' | '<' /script/i [^>]+ :>> 'server' [^>]+ '>') @code;
  vb_aspx_cs_outry_entity = ('%>' | '</' /script/i ws_or_inl* '>' @check_blank_outry) @code;
  vb_aspx_cs_entity := |*
    vb_aspx_cs_outry_entity @{ fret; };
    # unmodified C patterns
    space+              ${ entity = VB_SPACE;   } => vb_ecallback;
    vb_comment_entity ${ entity = VB_COMMENT; } => vb_ecallback;
    # TODO:
    ^space;
  *|;

  vb_aspx_comment_entity = '<!--' any* :>> '-->';

  vb_aspx_entity := |*
    # TODO: vb_aspx_ecallback for vb_aspx_*_{entry,outry}_entity
    vb_aspx_css_entry_entity  => { fcall vb_aspx_css_entity;  };
    vb_aspx_js_entry_entity   => { fcall vb_aspx_js_entity;   };
    vb_aspx_cs_entry_entity => { fcall vb_aspx_cs_entity; };
    # standard VB_ASPX patterns
    space+               ${ entity = VB_ASPX_SPACE;   } => vb_aspx_ecallback;
    vb_aspx_comment_entity ${ entity = VB_ASPX_COMMENT; } => vb_aspx_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with VB_ASPX markup.
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
void parse_vb_aspx(char *buffer, int length, int count,
                   void (*callback) (const char *lang, const char *entity,
                                     int s, int e, void *udata),
                   void *userdata
  ) {
  init

  const char *seen = 0;

  %% write init;
  cs = (count) ? vb_aspx_en_vb_aspx_line : vb_aspx_en_vb_aspx_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(VB_ASPX_LANG) }
}

#endif

/*****************************************************************************/

