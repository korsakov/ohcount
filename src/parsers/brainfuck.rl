// brainfuck.rl written by Boris 'billiob' Faure billiob<att>gmail<dott>com

/************************* Required for every parser *************************/
#ifndef OHCOUNT_BRAINFUCK_PARSER_H
#define OHCOUNT_BRAINFUCK_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *BRAINFUCK_LANG = LANG_BRAINFUCK;

// the languages entities
const char *brainfuck_entities[] = {
  "space", "comment", "operator"
};

// constants associated with the entities
enum {
  BRAINFUCK_SPACE = 0, BRAINFUCK_COMMENT, BRAINFUCK_OPERATOR
};

/*****************************************************************************/

%%{
  machine brainfuck;
  write data;
  include common "common.rl";

  # Line counting machine

  action brainfuck_ccallback {
    switch(entity) {
    case BRAINFUCK_SPACE:
      ls
      break;
    case BRAINFUCK_OPERATOR:
      code
      break;
    case BRAINFUCK_COMMENT:
      comment
      break;
    case INTERNAL_NL:
      std_internal_newline(BRAINFUCK_LANG)
      break;
    case NEWLINE:
      std_newline(BRAINFUCK_LANG)
    }
  }

  brainfuck_operator = [+\-<>.,\[\]] @code;

  brainfuck_line := |*
    spaces             ${ entity = BRAINFUCK_SPACE;    } => brainfuck_ccallback;
    newline            ${ entity = NEWLINE;            } => brainfuck_ccallback;
    brainfuck_operator ${ entity = BRAINFUCK_OPERATOR; } => brainfuck_ccallback;
    ^space             ${ entity = BRAINFUCK_COMMENT;  } => brainfuck_ccallback;
  *|;

  # Entity machine

  action brainfuck_ecallback {
    callback(BRAINFUCK_LANG, brainfuck_entities[entity], cint(ts), cint(te), userdata);
  }

  brainfuck_operator_entity = [+\-<>.,\[\]];

  brainfuck_comment_entity = !(space | brainfuck_operator_entity);

  brainfuck_entity := |*
    space+                    ${ entity = BRAINFUCK_SPACE;    } => brainfuck_ecallback;
    brainfuck_operator_entity ${ entity = BRAINFUCK_OPERATOR; } => brainfuck_ecallback;
    brainfuck_comment_entity  ${ entity = BRAINFUCK_COMMENT;  } => brainfuck_ecallback;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Brainfuck code.
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
void parse_brainfuck(char *buffer, int length, int count,
             void (*callback) (const char *lang, const char *entity, int s,
                               int e, void *udata),
             void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? brainfuck_en_brainfuck_line : brainfuck_en_brainfuck_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(BRAINFUCK_LANG) }
}

#endif

/*****************************************************************************/

