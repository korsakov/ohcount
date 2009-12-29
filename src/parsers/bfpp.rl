// bfpp.rl written by Boris 'billiob' Faure billiob<att>gmail<dott>com

/************************* Required for every parser *************************/
#ifndef OHCOUNT_BFPP_PARSER_H
#define OHCOUNT_BFPP_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *BFPP_LANG = LANG_BFPP;

// the languages entities
const char *bfpp_entities[] = {
  "space", "comment", "operator", "include"
};

// constants associated with the entities
enum {
  BFPP_SPACE = 0, BFPP_COMMENT, BFPP_OPERATOR, BFPP_INCLUDE
};

/*****************************************************************************/

%%{
  machine bfpp;
  write data;
  include common "common.rl";

  # Line counting machine

  action bfpp_ccallback {
    switch(entity) {
    case BFPP_SPACE:
      ls
      break;
    case BFPP_OPERATOR:
    case BFPP_INCLUDE:
      code
      break;
    case BFPP_COMMENT:
      comment
      break;
    case INTERNAL_NL:
      std_internal_newline(BFPP_LANG)
      break;
    case NEWLINE:
      std_newline(BFPP_LANG)
    }
  }

  bfpp_operator = [+\-<>.,\[\]\%\!\#\^\:\;] @code;

  bfpp_line_comment = ('=') @comment nonnewline*;

  bfpp_include = '@include(' @code (
      newline %{ entity = INTERNAL_NL; } %bfpp_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> ')';

  bfpp_line := |*
    spaces             ${ entity = BFPP_SPACE;    } => bfpp_ccallback;
    newline            ${ entity = NEWLINE;       } => bfpp_ccallback;
    bfpp_line_comment;
    bfpp_include;
    bfpp_operator      ${ entity = BFPP_OPERATOR; } => bfpp_ccallback;
    ^space             ${ entity = BFPP_COMMENT;  } => bfpp_ccallback;
  *|;

  # Entity machine

  action bfpp_ecallback {
    callback(BFPP_LANG, bfpp_entities[entity], cint(ts), cint(te), userdata);
  }

  bfpp_operator_entity = [+\-<>.,\[\]%\#^;:];

  bfpp_include_entity = '@include(' any* :>> ')';

  bfpp_line_comment_entity = '=' (escaped_newline | nonnewline)*;

  bfpp_comment_entity = (bfpp_line_comment_entity |
                      !(space | bfpp_operator_entity | bfpp_include_entity));

  bfpp_entity := |*
    space+               ${ entity = BFPP_SPACE;    } => bfpp_ecallback;
    bfpp_operator_entity ${ entity = BFPP_OPERATOR; } => bfpp_ecallback;
    bfpp_include_entity  ${ entity = BFPP_INCLUDE;  } => bfpp_ecallback;
    bfpp_comment_entity  ${ entity = BFPP_COMMENT;  } => bfpp_ecallback;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Brainfuck++ code.
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
void parse_bfpp(char *buffer, int length, int count,
             void (*callback) (const char *lang, const char *entity, int s,
                               int e, void *udata),
             void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? bfpp_en_bfpp_line : bfpp_en_bfpp_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(BFPP_LANG) }
}

#endif

/*****************************************************************************/

