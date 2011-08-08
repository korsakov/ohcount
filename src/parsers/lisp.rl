// lisp.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_LISP_PARSER_H
#define OHCOUNT_LISP_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *LISP_LANG = LANG_LISP;

// the languages entities
const char *lisp_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  LISP_SPACE = 0, LISP_COMMENT, LISP_STRING, LISP_ANY
};

/*****************************************************************************/

%%{
  machine lisp;
  write data;
  include common "common.rl";

  # Line counting machine

  action lisp_ccallback {
    switch(entity) {
    case LISP_SPACE:
      ls
      break;
    case LISP_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(LISP_LANG)
      break;
    case NEWLINE:
      std_newline(LISP_LANG)
    }
  }

  lisp_docstring = '"'{3} @comment (
    newline %{ entity = INTERNAL_NL; } %lisp_ccallback
    |
    ws
    |
    (nonnewline - ws) @comment
  )* :>> '"""' @comment;

  lisp_line_comment = ';' @comment nonnewline*;

  lisp_comment = lisp_line_comment | lisp_docstring;

  lisp_empty_string =
    '"'{2} [^"] @{fhold;} @code;

  lisp_char_string =
    '"' [^"] '"' @code;

  lisp_regular_string =
    '"' ([^"]{2}) @code (
      newline %{ entity = INTERNAL_NL; } %lisp_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';

  lisp_string = lisp_empty_string | lisp_char_string | lisp_regular_string;

  lisp_line := |*
    spaces        ${ entity = LISP_SPACE; } => lisp_ccallback;
    lisp_comment;
    lisp_string;
    newline       ${ entity = NEWLINE;    } => lisp_ccallback;
    ^space        ${ entity = LISP_ANY;   } => lisp_ccallback;
  *|;

  # Entity machine

  action lisp_ecallback {
    callback(LISP_LANG, lisp_entities[entity], cint(ts), cint(te), userdata);
  }

  lisp_comment_entity = ';' nonnewline*;

  lisp_entity := |*
    space+              ${ entity = LISP_SPACE;   } => lisp_ecallback;
    lisp_comment_entity ${ entity = LISP_COMMENT; } => lisp_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/* Parses a string buffer with Lisp code.
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
void parse_lisp(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? lisp_en_lisp_line : lisp_en_lisp_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(LISP_LANG) }
}

const char *ELISP_LANG = LANG_EMACSLISP;
const char *ORIG_LISP_LANG = LANG_LISP;
void parse_emacslisp(char *buffer, int length, int count,
                     void (*callback) (const char *lang, const char *entity,
                                       int s, int e, void *udata),
                     void *userdata
  ) {
  LISP_LANG = ELISP_LANG;
  parse_lisp(buffer, length, count, callback, userdata);
  LISP_LANG = ORIG_LISP_LANG;
}

const char *SCHEME_LANG = LANG_SCHEME;
void parse_scheme(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  LISP_LANG = SCHEME_LANG;
  parse_lisp(buffer, length, count, callback, userdata);
  LISP_LANG = ORIG_LISP_LANG;
}

const char *CLOJURE_LANG = LANG_CLOJURE;
void parse_clojure(char *buffer, int length, int count,
                   void (*callback) (const char *lang, const char *entity, int s,
                                     int e, void *udata),
                   void *userdata
  ) {
  LISP_LANG = CLOJURE_LANG;
  parse_lisp(buffer, length, count, callback, userdata);
  LISP_LANG = ORIG_LISP_LANG;
}

const char *RACKET_LANG = LANG_RACKET;
void parse_racket(char *buffer, int length, int count,
                   void (*callback) (const char *lang, const char *entity, int s,
                                     int e, void *udata),
                   void *userdata
  ) {
  LISP_LANG = RACKET_LANG;
  parse_lisp(buffer, length, count, callback, userdata);
  LISP_LANG = ORIG_LISP_LANG;
}


#endif
