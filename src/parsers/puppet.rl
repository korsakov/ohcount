// puppet.rl written by Ken Barber <ken@bob.sh>
// Based on pascal.rl by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_PUPPET_PARSER_H
#define OHCOUNT_PUPPET_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *PUPPET_LANG = LANG_PUPPET;

// the languages entities
const char *puppet_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  PUPPET_SPACE = 0, PUPPET_COMMENT, PUPPET_STRING, PUPPET_ANY
};

/*****************************************************************************/

%%{
  machine puppet;
  write data;
  include common "common.rl";

  # Line counting machine

  action puppet_ccallback {
    switch(entity) {
    case PUPPET_SPACE:
      ls
      break;
    case PUPPET_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(PUPPET_LANG)
      break;
    case NEWLINE:
      std_newline(PUPPET_LANG)
    }
  }

  puppet_line_comment = '#' @comment nonnewline*;
  puppet_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %puppet_ccallback
      |
      ws
      |
      (nonnewline - ws) @code
    )* :>> '*/';
  puppet_comment = puppet_line_comment | puppet_block_comment;

  puppet_string =
    '\'' @code (
      newline %{ entity = INTERNAL_NL; } %puppet_ccallback
      |
      ws
      |
      [^\r\n\f\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';

  puppet_line := |*
    spaces          ${ entity = PUPPET_SPACE; } => puppet_ccallback;
    puppet_comment;
    puppet_string;
    newline         ${ entity = NEWLINE;      } => puppet_ccallback;
    ^space          ${ entity = PUPPET_ANY;   } => puppet_ccallback;
  *|;

  # Entity machine

  action puppet_ecallback {
    callback(PUPPET_LANG, puppet_entities[entity], cint(ts), cint(te),
             userdata);
  }

  puppet_line_comment_entity = '#' nonnewline*;
  puppet_block_comment_entity = '/*' any* :>> '*/';
  puppet_comment_entity = puppet_line_comment_entity |
    puppet_block_comment_entity;

  puppet_entity := |*
    space+                ${ entity = PUPPET_SPACE;   } => puppet_ecallback;
    puppet_comment_entity ${ entity = PUPPET_COMMENT; } => puppet_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Puppet DSL code.
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
void parse_puppet(char *buffer, int length, int count,
                  void (*callback) (const char *lang, const char *entity, int s,
                                    int e, void *udata),
                  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? puppet_en_puppet_line : puppet_en_puppet_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(PUPPET_LANG) }
}

#endif

/*****************************************************************************/
