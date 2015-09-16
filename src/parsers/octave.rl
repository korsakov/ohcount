// octave.rl based on Mitchell Foral's matlab.rl, modified my Jason Riedy <jason@acm.org>

/************************* Required for every parser *************************/
#ifndef OHCOUNT_OCTAVE_PARSER_H
#define OHCOUNT_OCTAVE_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *OCTAVE_LANG = LANG_OCTAVE;

// the languages entities
const char *octave_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  OCTAVE_SPACE = 0, OCTAVE_COMMENT, OCTAVE_STRING, OCTAVE_ANY
};

/*****************************************************************************/

%%{
  machine octave;
  write data;
  include common "common.rl";

  # Line counting machine

  action octave_ccallback {
    switch(entity) {
    case OCTAVE_SPACE:
      ls
      break;
    case OCTAVE_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(OCTAVE_LANG)
      break;
    case NEWLINE:
      std_newline(OCTAVE_LANG)
    }
  }

  # note: GNU Octave accepts % as well as #, but not '...' at the moment.  We
  # accept it anyways, as that may change.  Also, GNU Octave does not currently
  # support block comments but likely will someday.
  octave_line_comment = (('%' | '...') [^{] @{ fhold; } | '#') @comment nonnewline*;
  octave_block_comment =
    '%{' @comment (
      newline %{ entity = INTERNAL_NL; } %octave_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> '%}';
  octave_comment = octave_line_comment | octave_block_comment;

  octave_sq_str = '\'' @code ([^\r\n\f'\\] | '\\' nonnewline)* '\'';
  octave_dq_str = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';
  octave_string = octave_sq_str | octave_dq_str;

  octave_line := |*
    spaces          ${ entity = OCTAVE_SPACE; } => octave_ccallback;
    octave_comment;
    octave_string;
    newline         ${ entity = NEWLINE;      } => octave_ccallback;
    ^space          ${ entity = OCTAVE_ANY;   } => octave_ccallback;
  *|;

  # Entity machine

  action octave_ecallback {
    callback(OCTAVE_LANG, octave_entities[entity], cint(ts), cint(te),
             userdata);
  }

  octave_line_comment_entity = (('%' | '...') [^{] @{ fhold; } | '#') nonnewline*;
  octave_block_comment_entity = '%{' any* :>> '%}';
  octave_comment_entity =
    octave_line_comment_entity | octave_block_comment_entity;

  octave_entity := |*
    space+                ${ entity = OCTAVE_SPACE;   } => octave_ecallback;
    octave_comment_entity ${ entity = OCTAVE_COMMENT; } => octave_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with OCTAVE code.
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
void parse_octave(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? octave_en_octave_line : octave_en_octave_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(OCTAVE_LANG) }
}

#endif

/*****************************************************************************/
