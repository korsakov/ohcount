// visual_basic.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
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

// do not change the following variables

// used for newlines
#define NEWLINE -1

// used for newlines inside patterns like strings and comments that can have
// newlines in them
#define INTERNAL_NL -2

// required by Ragel
int cs, act;
char *p, *pe, *eof, *ts, *te;

// used for calculating offsets from buffer start for start and end positions
char *buffer_start;
#define cint(c) ((int) (c - buffer_start))

// state flags for line and comment counting
int whole_line_comment;
int line_contains_code;

// the beginning of a line in the buffer for line and comment counting
char *line_start;

// state variable for the current entity being matched
int entity;

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
