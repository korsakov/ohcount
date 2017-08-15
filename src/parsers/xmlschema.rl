// xmlschema.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_XMLSCHEMA_PARSER_H
#define OHCOUNT_XMLSCHEMA_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *XMLSCHEMA_LANG = LANG_XMLSCHEMA;

// the languages entities
const char *xmlschema_entities[] = {
  "space", "comment", "doctype",
  "tag", "entity", "any"
};

// constants associated with the entities
enum {
  XMLSCHEMA_SPACE = 0, XMLSCHEMA_COMMENT, XMLSCHEMA_DOCTYPE,
  XMLSCHEMA_TAG, XMLSCHEMA_ENTITY, XMLSCHEMA_ANY
};

/*****************************************************************************/

%%{
  machine xmlschema;
  write data;
  include common "common.rl";

  # Line counting machine

  action xmlschema_ccallback {
    switch(entity) {
    case XMLSCHEMA_SPACE:
      ls
      break;
    case XMLSCHEMA_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(XMLSCHEMA_LANG)
      break;
    case NEWLINE:
      std_newline(XMLSCHEMA_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(XMLSCHEMA_LANG)
    }
  }

  xmlschema_comment =
    '<!--' @comment (
      newline %{ entity = INTERNAL_NL; } %xmlschema_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '-->';

  xmlschema_sq_str = '\'' ([^\r\n\f'\\] | '\\' nonnewline)* '\'' @code;
  xmlschema_dq_str = '"' ([^\r\n\f"\\] | '\\' nonnewline)* '"' @code;
  xmlschema_cdata_str =
    '<![CDATA[' @code (
      newline %{ entity = INTERNAL_NL; } %xmlschema_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> ']]>';
  xmlschema_string = xmlschema_sq_str | xmlschema_dq_str | xmlschema_cdata_str;

  xmlschema_line := |*
    spaces             ${ entity = XMLSCHEMA_SPACE; } => xmlschema_ccallback;
    xmlschema_comment;
    xmlschema_string;
    newline            ${ entity = NEWLINE;         } => xmlschema_ccallback;
    ^space             ${ entity = XMLSCHEMA_ANY;   } => xmlschema_ccallback;
  *|;

  # Entity machine

  action xmlschema_ecallback {
    callback(XMLSCHEMA_LANG, xmlschema_entities[entity], cint(ts), cint(te),
             userdata);
  }

  xmlschema_comment_entity = '<!--' any* :>> '-->';

  xmlschema_entity := |*
    space+                   ${ entity = XMLSCHEMA_SPACE;   } => xmlschema_ecallback;
    xmlschema_comment_entity ${ entity = XMLSCHEMA_COMMENT; } => xmlschema_ecallback;
    # TODO:
    ^space;
  *|;

}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with XML Schema markup.
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
void parse_xmlschema(char *buffer, int length, int count,
                     void (*callback) (const char *lang, const char *entity,
                                       int s, int e, void *udata),
                     void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? xmlschema_en_xmlschema_line : xmlschema_en_xmlschema_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(XMLSCHEMA_LANG) }
}

#endif

/*****************************************************************************/
