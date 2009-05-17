// assembler.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_ASM_PARSER_H
#define OHCOUNT_ASM_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *ASM_LANG = LANG_ASSEMBLER;

// the languages entities
const char *asm_entities[] = {
  "space", "comment", "string", "number",
  "keyword", "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  ASM_SPACE = 0, ASM_COMMENT, ASM_STRING, ASM_NUMBER,
  ASM_KEYWORD, ASM_IDENTIFIER, ASM_OPERATOR, ASM_ANY
};

/*****************************************************************************/

%%{
  machine assembler;
  write data;
  include common "common.rl";

  # Line counting machine

  action asm_ccallback {
    switch(entity) {
    case ASM_SPACE:
      ls
      break;
    case ASM_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(ASM_LANG)
      break;
    case NEWLINE:
      std_newline(ASM_LANG)
    }
  }

  asm_line_comment = ('//' | ';' | '!') @comment nonnewline*;
  asm_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %asm_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  asm_comment = asm_line_comment | asm_block_comment;

  asm_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';

  asm_line := |*
    spaces       ${ entity = ASM_SPACE; } => asm_ccallback;
    asm_comment;
    asm_string;
    newline      ${ entity = NEWLINE;   } => asm_ccallback;
    ^space       ${ entity = ASM_ANY;   } => asm_ccallback;
  *|;

  # Entity machine

  action asm_ecallback {
    callback(ASM_LANG, asm_entities[entity], cint(ts), cint(te), userdata);
  }

  asm_line_comment_entity = ('//' | ';' | '!') nonnewline*;
  asm_block_comment_entity = '/*' any* :>> '*/';
  asm_comment_entity = asm_line_comment_entity | asm_block_comment_entity;

  asm_entity := |*
    space+             ${ entity = ASM_SPACE;   } => asm_ecallback;
    asm_comment_entity ${ entity = ASM_COMMENT; } => asm_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Assembler code.
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
void parse_assembler(char *buffer, int length, int count,
                     void (*callback) (const char *lang, const char *entity,
                                       int s, int e, void *udata),
                     void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? assembler_en_asm_line : assembler_en_asm_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(ASM_LANG) }
}

#endif

/*****************************************************************************/
