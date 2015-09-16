/************************* Required for every parser *************************/
#ifndef OHCOUNT_NIX_PARSER_H
#define OHCOUNT_NIX_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *NIX_LANG = LANG_NIX;

// the languages entities
const char *nix_entities[] = {
  "space", "comment", "any"
};

// constants associated with the entities
enum {
  NIX_SPACE = 0, NIX_COMMENT, NIX_ANY
};

/*****************************************************************************/

#include "shell.h"

%%{
  machine nix;
  write data;
  include common "common.rl";
  #EMBED(shell)

  # Line counting machine

  action nix_ccallback {
    switch(entity) {
    case NIX_SPACE:
      ls
      break;
    case NIX_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(NIX_LANG)
      break;
    case NEWLINE:
      std_newline(NIX_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(NIX_LANG)
    }
  }

  nix_line_comment = '#' @comment nonnewline*;

  nix_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %nix_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';

  nix_comment = nix_line_comment | nix_block_comment;

  nix_dq_shell_entry = '"' @code;
  nix_dq_shell_outry = '"' @check_blank_outry @code;
  nix_dq_shell_line := |*
    nix_dq_shell_outry @{ p = ts; fret; };
    # TODO: Add embeded Nix between '${' and '}'
    # unmodified SHELL patterns
    spaces         ${ entity = SHELL_SPACE; } => shell_ccallback;
    shell_comment;
    shell_string;
    newline        ${ entity = NEWLINE;     } => shell_ccallback;
    ^space         ${ entity = SHELL_ANY;   } => shell_ccallback;
  *|;

  nix_dsq_shell_entry = "''" @code;
  nix_dsq_shell_outry = "''" @check_blank_outry @code;
  nix_dsq_shell_line := |*
    nix_dsq_shell_outry @{ p = ts; fret; };
    # TODO: Add embeded Nix between '${' and '}'
    # unmodified SHELL patterns
    spaces         ${ entity = SHELL_SPACE; } => shell_ccallback;
    shell_comment;
    shell_string;
    newline        ${ entity = NEWLINE;     } => shell_ccallback;
    ^space         ${ entity = SHELL_ANY;   } => shell_ccallback;
  *|;

  nix_line := |*
    nix_dq_shell_entry @{ entity = CHECK_BLANK_ENTRY; } @nix_ccallback
      @{ saw(SHELL_LANG); } => { fcall nix_dq_shell_line; };
    nix_dsq_shell_entry @{ entity = CHECK_BLANK_ENTRY; } @nix_ccallback
      @{ saw(SHELL_LANG); } => { fcall nix_dsq_shell_line; };
    # NIX patterns
    spaces    ${ entity = NIX_SPACE; } => nix_ccallback;
    nix_comment;
    newline   ${ entity = NEWLINE; } => nix_ccallback;
    ^space    ${ entity = NIX_ANY;   } => nix_ccallback;
  *|;

  # Entity machine

  action nix_ecallback {
    callback(NIX_LANG, nix_entities[entity], cint(ts), cint(te), userdata);
  }

  nix_line_comment_entity = '#' nonnewline*;
  nix_block_comment_entity = '/*' any* :>> '*/';
  nix_comment_entity = nix_line_comment_entity | nix_block_comment_entity;


  nix_dq_shell_entry_entity = '"';
  nix_dq_shell_outry_entity = '"';
  nix_dq_shell_entity := |*
    nix_dq_shell_outry_entity @{ fret; };
    # TODO: Add embeded Nix between '${' and '}'
    # unmodified SHELL patterns
    space+               ${ entity = SHELL_SPACE;   } => shell_ecallback;
    shell_comment_entity ${ entity = SHELL_COMMENT; } => shell_ecallback;
    # TODO:
    ^space;
  *|;

  nix_dsq_shell_entry_entity = "''";
  nix_dsq_shell_outry_entity = "''";
  nix_dsq_shell_entity := |*
    nix_dsq_shell_outry_entity @{ fret; };
    # TODO: Add embeded Nix between '${' and '}'
    # unmodified SHELL patterns
    space+               ${ entity = SHELL_SPACE;   } => shell_ecallback;
    shell_comment_entity ${ entity = SHELL_COMMENT; } => shell_ecallback;
    # TODO:
    ^space;
  *|;

  nix_entity := |*
    nix_dq_shell_entry_entity  => { fcall nix_dq_shell_entity;  };
    nix_dsq_shell_entry_entity => { fcall nix_dsq_shell_entity; };
    space+             ${ entity = NIX_SPACE;   } => nix_ecallback;
    nix_comment_entity ${ entity = NIX_COMMENT; } => nix_ecallback;
    # TODO;
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Nix code.
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
void parse_nix(char *buffer, int length, int count,
               void (*callback) (const char *lang, const char *entity, int s,
                                 int e, void *udata),
               void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? nix_en_nix_line : nix_en_nix_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(NIX_LANG) }
}

#endif

/*****************************************************************************/
