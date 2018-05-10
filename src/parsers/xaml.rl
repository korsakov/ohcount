/************************* Required for every parser *************************/
#ifndef OHCOUNT_XAML_PARSER_H
#define OHCOUNT_XAML_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *XAML_LANG = LANG_XAML;

// the languages entities
const char *xaml_entities[] = {
  "space", "comment", "doctype",
  "tag", "entity", "any"
};

// constants associated with the entities
enum {
  XAML_SPACE = 0, XAML_COMMENT, XAML_DOCTYPE,
  XAML_TAG, XAML_ENTITY, XAML_ANY
};

/*****************************************************************************/

%%{
  machine xaml;
  write data;
  include common "common.rl";

  # Line counting machine

  action xaml_ccallback {
    switch(entity) {
    case XAML_SPACE:
      ls
      break;
    case XAML_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(XAML_LANG)
      break;
    case NEWLINE:
      std_newline(XAML_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(XAML_LANG)
    }
  }

  xaml_comment =
    '<!--' @comment (
      newline %{ entity = INTERNAL_NL; } %xaml_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '-->';

  xaml_sq_str = '\'' [^\r\n\f']* '\'' @code;
  xaml_dq_str = '"' [^\r\n\f"]* '"' @code;
  xaml_cdata_str =
    '<![CDATA[' @code (
      newline %{ entity = INTERNAL_NL; } %xaml_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> ']]>';
  xaml_string = xaml_sq_str | xaml_dq_str | xaml_cdata_str;

  xaml_line := |*
    spaces       ${ entity = XAML_SPACE; } => xaml_ccallback;
    xaml_comment;
    xaml_string;
    newline      ${ entity = NEWLINE;   } => xaml_ccallback;
    ^space       ${ entity = XAML_ANY;   } => xaml_ccallback;
  *|;

  # Entity machine

  action xaml_ecallback {
    callback(XAML_LANG, xaml_entities[entity], cint(ts), cint(te), userdata);
  }

  xaml_comment_entity = '<!--' any* :>> '-->';

  xaml_entity := |*
    space+             ${ entity = XAML_SPACE;   } => xaml_ecallback;
    xaml_comment_entity ${ entity = XAML_COMMENT; } => xaml_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with XAML markup.
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
void parse_xaml(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? xaml_en_xaml_line : xaml_en_xaml_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(XAML_LANG) }
}

#endif

/*****************************************************************************/
