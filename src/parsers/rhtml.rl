// rhtml.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_RHTML_PARSER_H
#define OHCOUNT_RHTML_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *RHTML_LANG = LANG_HTML;

// the languages entities
const char *rhtml_entities[] = {
  "space", "comment", "doctype",
  "tag", "entity", "any"
};

// constants associated with the entities
enum {
  RHTML_SPACE = 0, RHTML_COMMENT, RHTML_DOCTYPE,
  RHTML_TAG, RHTML_ENTITY, RHTML_ANY
};

/*****************************************************************************/

#include "css.h"
#include "javascript.h"
#include "ruby.h"

%%{
  machine rhtml;
  write data;
  include common "common.rl";
  #EMBED(css)
  #EMBED(javascript)
  #EMBED(ruby)

  # Line counting machine

  action rhtml_ccallback {
    switch(entity) {
    case RHTML_SPACE:
      ls
      break;
    case RHTML_ANY:
      code
      break;
    case INTERNAL_NL:
      emb_internal_newline(RHTML_LANG)
      break;
    case NEWLINE:
      emb_newline(RHTML_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(RHTML_LANG)
    }
  }

  rhtml_comment := (
    newline %{ entity = INTERNAL_NL; } %rhtml_ccallback
    |
    ws
    |
    ^(space | [\-<]) @comment
    |
    '<' '%' @{ saw(RUBY_LANG); fcall rhtml_ruby_line; }
    |
    '<' !'%'
  )* :>> '-->' @comment @{ fgoto rhtml_line; };

  rhtml_sq_str := (
    newline %{ entity = INTERNAL_NL; } %rhtml_ccallback
    |
    ws
    |
    [^\r\n\f\t '\\<] @code
    |
    '\\' nonnewline @code
    |
    '<' '%' @{ saw(RUBY_LANG); fcall rhtml_ruby_line; }
    |
    '<' !'%'
  )* '\'' @{ fgoto rhtml_line; };
  rhtml_dq_str := (
    newline %{ entity = INTERNAL_NL; } %rhtml_ccallback
    |
    ws
    |
    [^\r\n\f\t "\\<] @code
    |
    '\\' nonnewline @code
    |
    '<' '%' @{ saw(RUBY_LANG); fcall rhtml_ruby_line; }
    |
    '<' !'%'
  )* '"' @{ fgoto rhtml_line; };

  ws_or_inl = (ws | newline @{ entity = INTERNAL_NL; } %rhtml_ccallback);

  rhtml_css_entry = '<' /style/i [^>]+ :>> 'text/css' [^>]+ '>' @code;
  rhtml_css_outry = '</' /style/i ws_or_inl* '>' @check_blank_outry @code;
  rhtml_css_line := |*
    rhtml_css_outry @{ p = ts; fret; };
    # unmodified CSS patterns
    spaces      ${ entity = CSS_SPACE; } => css_ccallback;
    css_comment;
    css_string;
    newline     ${ entity = NEWLINE;   } => css_ccallback;
    ^space      ${ entity = CSS_ANY;   } => css_ccallback;
  *|;

  rhtml_js_entry = '<' /script/i [^>]+ :>> 'text/javascript' [^>]+ '>' @code;
  rhtml_js_outry = '</' /script/i ws_or_inl* '>' @check_blank_outry @code;
  rhtml_js_line := |*
    rhtml_js_outry @{ p = ts; fret; };
    # unmodified Javascript patterns
    spaces     ${ entity = JS_SPACE; } => js_ccallback;
    js_comment;
    js_string;
    newline    ${ entity = NEWLINE;  } => js_ccallback;
    ^space     ${ entity = JS_ANY;   } => js_ccallback;
  *|;

  rhtml_ruby_entry = '<%' @code;
  rhtml_ruby_outry = '%>' @check_blank_outry @code;
  rhtml_ruby_line := |*
    rhtml_ruby_outry @{ p = ts; fret; };
    # unmodified Ruby patterns
    spaces        ${ entity = RUBY_SPACE; } => ruby_ccallback;
    ruby_comment;
    ruby_string;
    newline       ${ entity = NEWLINE;    } => ruby_ccallback;
    ^space        ${ entity = RUBY_ANY;   } => ruby_ccallback;
  *|;

  rhtml_line := |*
    rhtml_css_entry @{ entity = CHECK_BLANK_ENTRY; } @rhtml_ccallback
      @{ saw(CSS_LANG); } => { fcall rhtml_css_line; };
    rhtml_js_entry @{ entity = CHECK_BLANK_ENTRY; } @rhtml_ccallback
      @{ saw(JS_LANG); } => { fcall rhtml_js_line; };
    rhtml_ruby_entry @{ entity = CHECK_BLANK_ENTRY; } @rhtml_ccallback
      @{ saw(RUBY_LANG); } => { fcall rhtml_ruby_line; };
    # standard RHTML patterns
    spaces       ${ entity = RHTML_SPACE; } => rhtml_ccallback;
    '<!--'       @comment                   => { fgoto rhtml_comment; };
    '\''         @code                      => { fgoto rhtml_sq_str;  };
    '"'          @code                      => { fgoto rhtml_dq_str;  };
    newline      ${ entity = NEWLINE;     } => rhtml_ccallback;
    ^space       ${ entity = RHTML_ANY;   } => rhtml_ccallback;
  *|;

  # Entity machine

  action rhtml_ecallback {
    callback(RHTML_LANG, rhtml_entities[entity], cint(ts), cint(te), userdata);
  }

  rhtml_css_entry_entity = '<' /style/i [^>]+ :>> 'text/css' [^>]+ '>';
  rhtml_css_outry_entity = '</' /style/i ws_or_inl* '>';
  rhtml_css_entity := |*
    rhtml_css_outry_entity @{ fret; };
    # unmodified CSS patterns
    space+             ${ entity = CSS_SPACE;   } => css_ecallback;
    css_comment_entity ${ entity = CSS_COMMENT; } => css_ecallback;
    # TODO:
    ^space;
  *|;

  rhtml_js_entry_entity = '<' /script/i [^>]+ :>> 'text/javascript' [^>]+ '>';
  rhtml_js_outry_entity = '</' /script/i ws_or_inl* '>';
  rhtml_js_entity := |*
    rhtml_js_outry_entity @{ fret; };
    # unmodified Javascript patterns
    space+            ${ entity = JS_SPACE;   } => js_ecallback;
    js_comment_entity ${ entity = JS_COMMENT; } => js_ecallback;
    # TODO:
    ^space;
  *|;

  rhtml_ruby_entry_entity = '<%';
  rhtml_ruby_outry_entity = '%>';
  rhtml_ruby_entity := |*
    rhtml_ruby_outry_entity @{ fret; };
    # unmodified Ruby patterns
    space+              ${ entity = RUBY_SPACE;   } => ruby_ecallback;
    ruby_comment_entity ${ entity = RUBY_COMMENT; } => ruby_ecallback;
    # TODO:
    ^space;
  *|;

  rhtml_comment_entity = '<!--' any* :>> '-->';

  rhtml_entity := |*
    # TODO: rhtml_ecallback for rhtml_*_{entry,outry}_entity
    rhtml_css_entry_entity  => { fcall rhtml_css_entity;  };
    rhtml_js_entry_entity   => { fcall rhtml_js_entity;   };
    rhtml_ruby_entry_entity => { fcall rhtml_ruby_entity; };
    # standard RHTML patterns
    space+               ${ entity = RHTML_SPACE;   } => rhtml_ecallback;
    rhtml_comment_entity ${ entity = RHTML_COMMENT; } => rhtml_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with RHTML markup.
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
void parse_rhtml(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  const char *seen = 0;

  %% write init;
  cs = (count) ? rhtml_en_rhtml_line : rhtml_en_rhtml_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(RHTML_LANG) }
}

#endif

/*****************************************************************************/
