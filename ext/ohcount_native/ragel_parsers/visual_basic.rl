// visual_basic.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef RAGEL_VISUAL_BASIC_PARSER
#define RAGEL_VISUAL_BASIC_PARSER

#include "ragel_parser_macros.h"

// the name of the language
const char *VB_LANG = "visualbasic";

// the languages entities
const char *vb_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  VB_SPACE = 0, VB_COMMENT, VB_STRING, VB_ANY,
};

/*****************************************************************************/

%%{
  machine visual_basic;
  write data;
  include common "common.rl";

  # Line counting machine

  action vb_ccallback {
    switch(entity) {
    case VB_SPACE:
      ls
      break;
    case VB_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(VB_LANG)
      break;
    case NEWLINE:
      std_newline(VB_LANG)
    }
  }

  vb_comment = '\'' @comment nonnewline*;

  vb_string = '"' @code ([^"\\] | '\\' nonnewline)* '"';

  vb_line := |*
    spaces      ${ entity = VB_SPACE; } => vb_ccallback;
    vb_comment;
    vb_string;
    newline     ${ entity = NEWLINE;  } => vb_ccallback;
    ^space      ${ entity = VB_ANY;   } => vb_ccallback;
  *|;

  # Entity machine

  action vb_ecallback {
    callback(VB_LANG, vb_entities[entity], cint(ts), cint(te));
  }

  vb_entity := 'TODO:';
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Visual Basic code.
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
void parse_visual_basic(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end)
  ) {
  p = buffer;
  pe = buffer + length;
  eof = pe;

  buffer_start = buffer;
  whole_line_comment = 0;
  line_contains_code = 0;
  line_start = 0;
  entity = 0;

  %% write init;
  cs = (count) ? visual_basic_en_vb_line : visual_basic_en_vb_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(VB_LANG) }
}

#endif

/*****************************************************************************/
