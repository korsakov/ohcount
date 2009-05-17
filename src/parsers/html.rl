// html.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_HTML_PARSER_H
#define OHCOUNT_HTML_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *HTML_LANG = LANG_HTML;

// the languages entities
const char *html_entities[] = {
  "space", "comment", "doctype",
  "tag", "entity", "any"
};

// constants associated with the entities
enum {
  HTML_SPACE = 0, HTML_COMMENT, HTML_DOCTYPE,
  HTML_TAG, HTML_ENTITY, HTML_ANY
};

/*****************************************************************************/

#include "css.h"
#include "javascript.h"

%%{
  machine html;
  write data;
  include common "common.rl";
  #EMBED(css)
  #EMBED(javascript)

  # Line counting machine

  action html_ccallback {
    switch(entity) {
    case HTML_SPACE:
      ls
      break;
    case HTML_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(HTML_LANG)
      break;
    case NEWLINE:
      std_newline(HTML_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(HTML_LANG)
    }
  }

  html_comment =
    '<!--' @comment (
      newline %{ entity = INTERNAL_NL; } %html_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '-->';

  html_sq_str = '\'' ([^\r\n\f'\\] | '\\' nonnewline)* '\'' @code;
  html_dq_str = '"' ([^\r\n\f"\\] | '\\' nonnewline)* '"' @code;
  html_string = html_sq_str | html_dq_str;

  ws_or_inl = (ws | newline @{ entity = INTERNAL_NL; } %html_ccallback);

  html_css_entry = '<' /style/i [^>]+ :>> 'text/css' [^>]+ '>' @code;
  html_css_outry = '</' /style/i ws_or_inl* '>' @check_blank_outry @code;
  html_css_line := |*
    html_css_outry @{ p = ts; fret; };
    # unmodified CSS patterns
    spaces      ${ entity = CSS_SPACE; } => css_ccallback;
    css_comment;
    css_string;
    newline     ${ entity = NEWLINE;   } => css_ccallback;
    ^space      ${ entity = CSS_ANY;   } => css_ccallback;
  *|;

  html_js_entry = '<' /script/i [^>]+ :>> 'text/javascript' [^>]+ '>' @code;
  html_js_outry = '</' /script/i ws_or_inl* '>' @check_blank_outry @code;
  html_js_line := |*
    html_js_outry @{ p = ts; fret; };
    # unmodified Javascript patterns
    spaces     ${ entity = JS_SPACE; } => js_ccallback;
    js_comment;
    js_string;
    newline    ${ entity = NEWLINE;  } => js_ccallback;
    ^space     ${ entity = JS_ANY;   } => js_ccallback;
  *|;

  html_line := |*
    html_css_entry @{ entity = CHECK_BLANK_ENTRY; } @html_ccallback
      @{ saw(CSS_LANG); } => { fcall html_css_line; };
    html_js_entry @{ entity = CHECK_BLANK_ENTRY; } @html_ccallback
      @{ saw(JS_LANG); } => { fcall html_js_line; };
    # standard HTML patterns
    spaces       ${ entity = HTML_SPACE; } => html_ccallback;
    html_comment;
    html_string;
    newline      ${ entity = NEWLINE;    } => html_ccallback;
    ^space       ${ entity = HTML_ANY;   } => html_ccallback;
  *|;

  # Entity machine

  action html_ecallback {
    callback(HTML_LANG, html_entities[entity], cint(ts), cint(te), userdata);
  }

  html_css_entry_entity = '<' /style/i [^>]+ :>> 'text/css' [^>]+ '>';
  html_css_outry_entity = '</' /style/i ws_or_inl* '>';
  html_css_entity := |*
    html_css_outry_entity @{ fret; };
    # unmodified CSS patterns
    space+             ${ entity = CSS_SPACE;   } => css_ecallback;
    css_comment_entity ${ entity = CSS_COMMENT; } => css_ecallback;
    # TODO:
    ^space;
  *|;

  html_js_entry_entity = '<' /script/i [^>]+ :>> 'text/javascript' [^>]+ '>';
  html_js_outry_entity = '</' /script/i ws_or_inl* '>';
  html_js_entity := |*
    html_js_outry_entity @{ fret; };
    # unmodified Javascript patterns
    space+            ${ entity = JS_SPACE;   } => js_ecallback;
    js_comment_entity ${ entity = JS_COMMENT; } => js_ecallback;
    # TODO:
    ^space;
  *|;

  html_comment_entity = '<!--' any* :>> '-->';

  html_entity := |*
    # TODO: html_ecallback for html_*_{entry,outry}_entity
    html_css_entry_entity => { fcall html_css_entity; };
    html_js_entry_entity  => { fcall html_js_entity;  };
    # standard HTML patterns
    space+              ${ entity = HTML_SPACE;   } => html_ecallback;
    html_comment_entity ${ entity = HTML_COMMENT; } => html_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with HTML markup.
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
void parse_html(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? html_en_html_line : html_en_html_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(HTML_LANG) }
}

#endif

/*****************************************************************************/
