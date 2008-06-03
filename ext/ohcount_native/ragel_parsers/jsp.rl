// jsp.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef RAGEL_JSP_PARSER
#define RAGEL_JSP_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *JSP_LANG = "html";

// the languages entities
const char *jsp_entities[] = {
  "space", "comment", "doctype",
  "tag", "entity", "any"
};

// constants associated with the entities
enum {
  JSP_SPACE = 0, JSP_COMMENT, JSP_DOCTYPE,
  JSP_TAG, JSP_ENTITY, JSP_ANY
};

/*****************************************************************************/

#include "css_parser.h"
#include "javascript_parser.h"
#include "java_parser.h"

%%{
  machine jsp;
  write data;
  include common "common.rl";
  #EMBED(css)
  #EMBED(javascript)
  #EMBED(java)

  # Line counting machine

  action jsp_ccallback {
    switch(entity) {
    case JSP_SPACE:
      ls
      break;
    case JSP_ANY:
      code
      break;
    case INTERNAL_NL:
      emb_internal_newline(JSP_LANG)
      break;
    case NEWLINE:
      emb_newline(JSP_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(JSP_LANG)
    }
  }

  jsp_comment := (
    newline %{ entity = INTERNAL_NL; } %jsp_ccallback
    |
    ws
    |
    ^(space | [\-<]) @comment
    |
    '<' '%' @{ saw(JAVA_LANG); fcall jsp_java_line; }
    |
    '<' !'%'
  )* :>> '-->' @comment @{ fgoto jsp_line; };

  jsp_sq_str := (
    newline %{ entity = INTERNAL_NL; } %jsp_ccallback
    |
    ws
    |
    [^\r\n\f\t '\\<] @code
    |
    '\\' nonnewline @code
    |
    '<' '%' @{ saw(JAVA_LANG); fcall jsp_java_line; }
    |
    '<' !'%'
  )* '\'' @{ fgoto jsp_line; };
  jsp_dq_str := (
    newline %{ entity = INTERNAL_NL; } %jsp_ccallback
    |
    ws
    |
    [^\r\n\f\t "\\<] @code
    |
    '\\' nonnewline @code
    |
    '<' '%' @{ saw(JAVA_LANG); fcall jsp_java_line; }
    |
    '<' !'%'
  )* '"' @{ fgoto jsp_line; };

  ws_or_inl = (ws | newline @{ entity = INTERNAL_NL; } %jsp_ccallback);

  jsp_css_entry = '<' /style/i [^>]+ :>> 'text/css' [^>]+ '>' @code;
  jsp_css_outry = '</' /style/i ws_or_inl* '>' @check_blank_outry @code;
  jsp_css_line := |*
    jsp_css_outry @{ p = ts; fret; };
    # unmodified CSS patterns
    spaces      ${ entity = CSS_SPACE; } => css_ccallback;
    css_comment;
    css_string;
    newline     ${ entity = NEWLINE;   } => css_ccallback;
    ^space      ${ entity = CSS_ANY;   } => css_ccallback;
  *|;

  jsp_js_entry = '<' /script/i [^>]+ :>> 'text/javascript' [^>]+ '>' @code;
  jsp_js_outry = '</' /script/i ws_or_inl* '>' @check_blank_outry @code;
  jsp_js_line := |*
    jsp_js_outry @{ p = ts; fret; };
    # unmodified Javascript patterns
    spaces     ${ entity = JS_SPACE; } => js_ccallback;
    js_comment;
    js_string;
    newline    ${ entity = NEWLINE;  } => js_ccallback;
    ^space     ${ entity = JS_ANY;   } => js_ccallback;
  *|;

  jsp_java_entry = '<%' @code;
  jsp_java_outry = '%>' @check_blank_outry @code;
  jsp_java_line := |*
    jsp_java_outry @{ p = ts; fret; };
    # unmodified JAVA patterns
    spaces        ${ entity = JAVA_SPACE; } => java_ccallback;
    java_comment;
    java_string;
    newline       ${ entity = NEWLINE;    } => java_ccallback;
    ^space        ${ entity = JAVA_ANY;   } => java_ccallback;
  *|;

  jsp_line := |*
    jsp_css_entry @{ entity = CHECK_BLANK_ENTRY; } @jsp_ccallback
      @{ saw(CSS_LANG); } => { fcall jsp_css_line; };
    jsp_js_entry @{ entity = CHECK_BLANK_ENTRY; } @jsp_ccallback
      @{ saw(JS_LANG); } => { fcall jsp_js_line; };
    jsp_java_entry @{ entity = CHECK_BLANK_ENTRY; } @jsp_ccallback
      @{ saw(JAVA_LANG); } => { fcall jsp_java_line; };
    # standard JSP patterns
    spaces       ${ entity = JSP_SPACE; } => jsp_ccallback;
    '<!--'       @comment                 => { fgoto jsp_comment; };
    '\''         @code                    => { fgoto jsp_sq_str;  };
    '"'          @code                    => { fgoto jsp_dq_str;  };
    newline      ${ entity = NEWLINE;   } => jsp_ccallback;
    ^space       ${ entity = JSP_ANY;   } => jsp_ccallback;
  *|;

  # Entity machine

  action jsp_ecallback {
    callback(JSP_LANG, entity, cint(ts), cint(te));
  }

  jsp_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with JSP code.
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
void parse_jsp(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  init

  const char *seen = 0;

  %% write init;
  cs = (count) ? jsp_en_jsp_line : jsp_en_jsp_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(JSP_LANG) }
}

#endif

/*****************************************************************************/
