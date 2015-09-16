// jam.rl written by Scott Lawrence. bytbox@gmail.com

/************************* Required for every parser *************************/
#ifndef OHCOUNT_JAM_PARSER_H
#define OHCOUNT_JAM_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *JAM_LANG = LANG_JAM;

// the languages entities
const char *jam_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  JAM_SPACE = 0, JAM_COMMENT, JAM_STRING, JAM_ANY
};

/*****************************************************************************/

%%{
  machine jam;
  write data;
  include common "common.rl";

  # Line counting machine

  action jam_ccallback {
    switch(entity) {
    case JAM_SPACE:
      ls
      break;
    case JAM_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(JAM_LANG)
      break;
    case NEWLINE:
      std_newline(JAM_LANG)
    }
  }

  jam_comment = '#' @comment nonnewline*;

  jam_sq_str =
    '\'' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %jam_ccallback
      |
      ws
      |
      [^\r\n\f\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'' @commit;
  jam_dq_str =
    '"' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %jam_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"' @commit;
  # TODO: heredocs; see ruby.rl for details
  jam_string = jam_sq_str | jam_dq_str;

  jam_line := |*
    spaces         ${ entity = JAM_SPACE; } => jam_ccallback;
    jam_comment;
    jam_string;
    newline        ${ entity = NEWLINE;     } => jam_ccallback;
    ^space         ${ entity = JAM_ANY;   } => jam_ccallback;
  *|;

  # Entity machine

  action jam_ecallback {
    callback(JAM_LANG, jam_entities[entity], cint(ts), cint(te), userdata);
  }

  jam_comment_entity = '#' nonnewline*;

  jam_entity := |*
    space+               ${ entity = JAM_SPACE;   } => jam_ecallback;
    jam_comment_entity ${ entity = JAM_COMMENT; } => jam_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Jam code.
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
void parse_jam(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? jam_en_jam_line : jam_en_jam_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(JAM_LANG) }
}

#endif

/*****************************************************************************/
