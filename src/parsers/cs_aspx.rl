/************************* Required for every parser *************************/
#ifndef OHCOUNT_CS_ASPX_PARSER_H
#define OHCOUNT_CS_ASPX_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *CS_ASPX_LANG = LANG_HTML;

// the languages entities
const char *cs_aspx_entities[] = {
  "space", "comment", "doctype",
  "tag", "entity", "any"
};

// constants associated with the entities
enum {
  CS_ASPX_SPACE = 0, CS_ASPX_COMMENT, CS_ASPX_DOCTYPE,
  CS_ASPX_TAG, CS_ASPX_ENTITY, CS_ASPX_ANY
};

/*****************************************************************************/

#include "css.h"
#include "javascript.h"
#include "c.h"

%%{
  machine cs_aspx;
  write data;
  include common "common.rl";
  #EMBED(css)
  #EMBED(javascript)
  #EMBED(c)

  # Line counting machine

  action cs_aspx_ccallback {
    switch(entity) {
    case CS_ASPX_SPACE:
      ls
      break;
    case CS_ASPX_ANY:
      code
      break;
    case INTERNAL_NL:
      emb_internal_newline(CS_ASPX_LANG)
      break;
    case NEWLINE:
      emb_newline(CS_ASPX_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(CS_ASPX_LANG)
    }
  }

  cs_aspx_comment := (
    newline %{ entity = INTERNAL_NL; } %cs_aspx_ccallback
    |
    ws
    |
    ^(space | [\-<]) @comment
    |
    '<' '%' @{ saw(C_LANG); fcall cs_aspx_cs_line; }
    |
    '<' !'%'
  )* :>> '-->' @comment @{ fgoto cs_aspx_line; };

  cs_aspx_sq_str := (
    newline %{ entity = INTERNAL_NL; } %cs_aspx_ccallback
    |
    ws
    |
    [^\r\n\f\t '\\<] @code
    |
    '\\' nonnewline @code
    |
    '<' '%' @{ saw(C_LANG); fcall cs_aspx_cs_line; }
    |
    '<' !'%'
  )* '\'' @{ fgoto cs_aspx_line; };
  cs_aspx_dq_str := (
    newline %{ entity = INTERNAL_NL; } %cs_aspx_ccallback
    |
    ws
    |
    [^\r\n\f\t "\\<] @code
    |
    '\\' nonnewline @code
    |
    '<' '%' @{ saw(C_LANG); fcall cs_aspx_cs_line; }
    |
    '<' !'%'
  )* '"' @{ fgoto cs_aspx_line; };

  ws_or_inl = (ws | newline @{ entity = INTERNAL_NL; } %cs_aspx_ccallback);

  cs_aspx_css_entry = '<' /style/i [^>]+ :>> 'text/css' [^>]+ '>' @code;
  cs_aspx_css_outry = '</' /style/i ws_or_inl* '>' @check_blank_outry @code;
  cs_aspx_css_line := |*
    cs_aspx_css_outry @{ p = ts; fret; };
    # unmodified CSS patterns
    spaces      ${ entity = CSS_SPACE; } => css_ccallback;
    css_comment;
    css_string;
    newline     ${ entity = NEWLINE;   } => css_ccallback;
    ^space      ${ entity = CSS_ANY;   } => css_ccallback;
  *|;

  cs_aspx_js_entry = '<' /script/i [^>]+ :>> 'text/javascript' [^>]+ '>' @code;
  cs_aspx_js_outry = '</' /script/i ws_or_inl* '>' @check_blank_outry @code;
  cs_aspx_js_line := |*
    cs_aspx_js_outry @{ p = ts; fret; };
    # unmodified Javascript patterns
    spaces     ${ entity = JS_SPACE; } => js_ccallback;
    js_comment;
    js_string;
    newline    ${ entity = NEWLINE;  } => js_ccallback;
    ^space     ${ entity = JS_ANY;   } => js_ccallback;
  *|;

  cs_aspx_cs_entry = ('<%' | '<' /script/i [^>]+ :>> 'server' [^>]+ '>') @code;
  cs_aspx_cs_outry = ('%>' | '</' /script/i ws_or_inl* '>' @check_blank_outry) @code;
  cs_aspx_cs_line := |*
    cs_aspx_cs_outry @{ p = ts; fret; };
    # unmodified C patterns
    spaces        ${ entity = C_SPACE; } => c_ccallback;
    c_comment;
    c_string;
    newline       ${ entity = NEWLINE;    } => c_ccallback;
    ^space        ${ entity = C_ANY;   } => c_ccallback;
  *|;

  cs_aspx_line := |*
    cs_aspx_css_entry @{ entity = CHECK_BLANK_ENTRY; } @cs_aspx_ccallback
      @{ saw(CSS_LANG); } => { fcall cs_aspx_css_line; };
    cs_aspx_js_entry @{ entity = CHECK_BLANK_ENTRY; } @cs_aspx_ccallback
      @{ saw(JS_LANG); } => { fcall cs_aspx_js_line; };
    cs_aspx_cs_entry @{ entity = CHECK_BLANK_ENTRY; } @cs_aspx_ccallback
      @{ saw(C_LANG); } => { fcall cs_aspx_cs_line; };
    # standard CS_ASPX patterns
    spaces       ${ entity = CS_ASPX_SPACE; } => cs_aspx_ccallback;
    '<!--'       @comment                   => { fgoto cs_aspx_comment; };
    '\''         @code                      => { fgoto cs_aspx_sq_str;  };
    '"'          @code                      => { fgoto cs_aspx_dq_str;  };
    newline      ${ entity = NEWLINE;     } => cs_aspx_ccallback;
    ^space       ${ entity = CS_ASPX_ANY;   } => cs_aspx_ccallback;
  *|;

  # Entity machine

  action cs_aspx_ecallback {
    callback(CS_ASPX_LANG, cs_aspx_entities[entity], cint(ts), cint(te),
             userdata);
  }

  cs_aspx_css_entry_entity = '<' /style/i [^>]+ :>> 'text/css' [^>]+ '>';
  cs_aspx_css_outry_entity = '</' /style/i ws_or_inl* '>';
  cs_aspx_css_entity := |*
    cs_aspx_css_outry_entity @{ fret; };
    # unmodified CSS patterns
    space+             ${ entity = CSS_SPACE;   } => css_ecallback;
    css_comment_entity ${ entity = CSS_COMMENT; } => css_ecallback;
    # TODO:
    ^space;
  *|;

  cs_aspx_js_entry_entity = '<' /script/i [^>]+ :>> 'text/javascript' [^>]+ '>';
  cs_aspx_js_outry_entity = '</' /script/i ws_or_inl* '>';
  cs_aspx_js_entity := |*
    cs_aspx_js_outry_entity @{ fret; };
    # unmodified Javascript patterns
    space+            ${ entity = JS_SPACE;   } => js_ecallback;
    js_comment_entity ${ entity = JS_COMMENT; } => js_ecallback;
    # TODO:
    ^space;
  *|;

  cs_aspx_cs_entry_entity = ('<%' | '<' /script/i [^>]+ :>> 'server' [^>]+ '>') @code;
  cs_aspx_cs_outry_entity = ('%>' | '</' /script/i ws_or_inl* '>' @check_blank_outry) @code;
  cs_aspx_cs_entity := |*
    cs_aspx_cs_outry_entity @{ fret; };
    # unmodified C patterns
    space+              ${ entity = C_SPACE;   } => c_ecallback;
    c_comment_entity ${ entity = C_COMMENT; } => c_ecallback;
    # TODO:
    ^space;
  *|;

  cs_aspx_comment_entity = '<!--' any* :>> '-->';

  cs_aspx_entity := |*
    # TODO: cs_aspx_ecallback for cs_aspx_*_{entry,outry}_entity
    cs_aspx_css_entry_entity  => { fcall cs_aspx_css_entity;  };
    cs_aspx_js_entry_entity   => { fcall cs_aspx_js_entity;   };
    cs_aspx_cs_entry_entity => { fcall cs_aspx_cs_entity; };
    # standard CS_ASPX patterns
    space+               ${ entity = CS_ASPX_SPACE;   } => cs_aspx_ecallback;
    cs_aspx_comment_entity ${ entity = CS_ASPX_COMMENT; } => cs_aspx_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with CS_ASPX markup.
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
void parse_cs_aspx(char *buffer, int length, int count,
                   void (*callback) (const char *lang, const char *entity,
                                     int s, int e, void *udata),
                   void *userdata
  ) {
	C_LANG = LANG_CSHARP;
  init

  const char *seen = 0;

  %% write init;
  cs = (count) ? cs_aspx_en_cs_aspx_line : cs_aspx_en_cs_aspx_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(CS_ASPX_LANG) }

	C_LANG = LANG_C;
}

#endif

/*****************************************************************************/

