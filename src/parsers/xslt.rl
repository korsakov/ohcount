// xslt.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_XSLT_PARSER_H
#define OHCOUNT_XSLT_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *XSLT_LANG = LANG_XSLT;

// the languages entities
const char *xslt_entities[] = {
  "space", "comment", "doctype",
  "tag", "entity", "any"
};

// constants associated with the entities
enum {
  XSLT_SPACE = 0, XSLT_COMMENT, XSLT_DOCTYPE,
  XSLT_TAG, XSLT_ENTITY, XSLT_ANY
};

/*****************************************************************************/

%%{
  machine xslt;
  write data;
  include common "common.rl";

  # Line counting machine

  action xslt_ccallback {
    switch(entity) {
    case XSLT_SPACE:
      ls
      break;
    case XSLT_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(XSLT_LANG)
      break;
    case NEWLINE:
      std_newline(XSLT_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(XSLT_LANG)
    }
  }

  xslt_comment =
    '<!--' @comment (
      newline %{ entity = INTERNAL_NL; } %xslt_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '-->';

  xslt_sq_str = '\'' ([^\r\n\f'\\] | '\\' nonnewline)* '\'' @code;
  xslt_dq_str = '"' ([^\r\n\f"\\] | '\\' nonnewline)* '"' @code;
  xslt_cdata_str =
    '<![CDATA[' @code (
      newline %{ entity = INTERNAL_NL; } %xslt_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> ']]>';
  xslt_string = xslt_sq_str | xslt_dq_str | xslt_cdata_str;

  xslt_line := |*
    spaces        ${ entity = XSLT_SPACE; } => xslt_ccallback;
    xslt_comment;
    xslt_string;
    newline       ${ entity = NEWLINE;    } => xslt_ccallback;
    ^space        ${ entity = XSLT_ANY;   } => xslt_ccallback;
  *|;

  # Entity machine

  action xslt_ecallback {
    callback(XSLT_LANG, xslt_entities[entity], cint(ts), cint(te), userdata);
  }

  xslt_comment_entity = '<!--' any* :>> '-->';

  xslt_entity := |*
    space+              ${ entity = XSLT_SPACE;   } => xslt_ecallback;
    xslt_comment_entity ${ entity = XSLT_COMMENT; } => xslt_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with XSLT markup.
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
void parse_xslt(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? xslt_en_xslt_line : xslt_en_xslt_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(XSLT_LANG) }
}

#endif

/*****************************************************************************/
