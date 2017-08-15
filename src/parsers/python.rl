// python.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_PYTHON_PARSER_H
#define OHCOUNT_PYTHON_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *PYTHON_LANG = LANG_PYTHON;

// the languages entities
const char *python_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  PYTHON_SPACE = 0, PYTHON_COMMENT, PYTHON_STRING, PYTHON_ANY
};

/*****************************************************************************/

%%{
  machine python;
  write data;
  include common "common.rl";

  # Line counting machine

  action python_ccallback {
    switch(entity) {
    case PYTHON_SPACE:
      ls
      break;
    case PYTHON_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(PYTHON_LANG)
      break;
    case NEWLINE:
      std_newline(PYTHON_LANG)
    }
  }

  python_line_comment = ('#' | '//') @comment nonnewline*;
  python_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %python_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  python_sq_doc_str =
    '\'\'\'' @comment (
      newline %{ entity = INTERNAL_NL; } %python_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '\'\'\'' @comment;
  python_dq_doc_str =
    '"""' @comment (
      newline %{ entity = INTERNAL_NL; } %python_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '"""' @comment;
  python_comment = python_line_comment | python_block_comment |
                   python_sq_doc_str | python_dq_doc_str;

  python_sq_str =
    '\'' ([^'] | '\'' [^'] @{ fhold; }) @{ fhold; } # make sure it's not '''
      ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  python_dq_str =
    '"' ([^"] | '"' [^"] @{ fhold; }) @{ fhold; } # make sure it's not """
      ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  python_string = (python_sq_str | python_dq_str) @code;

  python_line := |*
    spaces          ${ entity = PYTHON_SPACE; } => python_ccallback;
    python_comment;
    python_string;
    newline         ${ entity = NEWLINE;      } => python_ccallback;
    ^space          ${ entity = PYTHON_ANY;   } => python_ccallback;
  *|;

  # Entity machine

  action python_ecallback {
    callback(PYTHON_LANG, python_entities[entity], cint(ts), cint(te),
             userdata);
  }

  python_line_comment_entity = ('#' | '//') nonnewline*;
  python_block_comment_entity = '/*' any* :>> '*/';
  python_sq_doc_str_entity = '\'\'\'' any* :>> '\'\'\'';
  python_dq_doc_str_entity = '"""' any* :>> '"""';
  python_comment_entity = python_line_comment_entity |
    python_block_comment_entity | python_sq_doc_str_entity |
    python_dq_doc_str_entity;

  python_entity := |*
    space+                ${ entity = PYTHON_SPACE;   } => python_ecallback;
    python_comment_entity ${ entity = PYTHON_COMMENT; } => python_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Python code.
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
void parse_python(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? python_en_python_line : python_en_python_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(PYTHON_LANG) }
}

#endif

/*****************************************************************************/
