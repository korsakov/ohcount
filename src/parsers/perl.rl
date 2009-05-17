// perl.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net

/************************* Required for every parser *************************/
#ifndef OHCOUNT_PERL_PARSER_H
#define OHCOUNT_PERL_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *PERL_LANG = LANG_PERL;

// the languages entities
const char *perl_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  PERL_SPACE = 0, PERL_COMMENT, PERL_STRING, PERL_ANY
};

/*****************************************************************************/

%%{
  machine perl;
  write data;
  include common "common.rl";

  # Line counting machine

  action perl_ccallback {
    switch(entity) {
    case PERL_SPACE:
      ls
      break;
    case PERL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(PERL_LANG)
      break;
    case NEWLINE:
      std_newline(PERL_LANG)
    }
  }

  perl_line_comment = '#' @comment nonnewline*;
  perl_block_comment =
    '=' when starts_line @enqueue @comment nonnewline+ (
      '=' when starts_line 'cut' @commit @comment @{ fgoto perl_line; }
      |
      newline %{ entity = INTERNAL_NL; } %perl_ccallback
      |
      ws
      |
      ^space @comment
    )* %/commit;
  perl_comment = perl_line_comment | perl_block_comment;

  perl_sq_str =
    '\'' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %perl_ccallback
      |
      ws
      |
      [^\r\n\f\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'' @commit @code;
  perl_dq_str =
    '"' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %perl_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"' @commit @code;
  perl_cmd_str =
    '`' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %perl_ccallback
      |
      ws
      |
      [^\r\n\f\t `\\] @code
      |
      '\\' nonnewline @code
    )* '`' @commit @code;
  perl_regex = '/' ([^\r\n\f/\\] | '\\' nonnewline)* '/' @code;
  # TODO: heredoc detection
  # This is impossible with current Ragel. We need to extract what the end
  # delimiter should be from the heredoc and search up to it on a new line.
  # perl_heredoc =
  perl_string = perl_sq_str | perl_dq_str | perl_cmd_str | perl_regex;

  perl_line := |*
    spaces         ${ entity = PERL_SPACE; } => perl_ccallback;
    perl_comment;
    perl_string;
    newline        ${ entity = NEWLINE;    } => perl_ccallback;
    '=' when !starts_line;
    ^(space | '=') ${ entity = PERL_ANY;   } => perl_ccallback;
  *|;

  # Entity machine

  action perl_ecallback {
    callback(PERL_LANG, perl_entities[entity], cint(ts), cint(te), userdata);
  }

  perl_line_comment_entity = '#' nonnewline*;
  perl_block_comment_entity =
    ('=' when starts_line) alpha+ any* :>> (('=' when starts_line) 'cut');
  perl_comment_entity = perl_line_comment_entity | perl_block_comment_entity;

  perl_entity := |*
    space+              ${ entity = PERL_SPACE;   } => perl_ecallback;
    perl_comment_entity ${ entity = PERL_COMMENT; } => perl_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Perl code.
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
void parse_perl(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? perl_en_perl_line : perl_en_perl_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(PERL_LANG) }
}

#endif

/*****************************************************************************/
