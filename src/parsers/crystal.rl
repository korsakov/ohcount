// renamed copy of ruby.rl(without *_sq_str).

/************************* Required for every parser *************************/
#ifndef OHCOUNT_CRYSTAL_PARSER_H
#define OHCOUNT_CRYSTAL_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *CRYSTAL_LANG = LANG_CRYSTAL;

// the languages entities
const char *crystal_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  CRYSTAL_SPACE = 0, CRYSTAL_COMMENT, CRYSTAL_STRING, CRYSTAL_ANY
};

/*****************************************************************************/

%%{
  machine crystal;
  write data;
  include common "common.rl";

  # Line counting machine

  action crystal_ccallback {
    switch(entity) {
    case CRYSTAL_SPACE:
      ls
      break;
    case CRYSTAL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(CRYSTAL_LANG)
      break;
    case NEWLINE:
      std_newline(CRYSTAL_LANG)
    }
  }

  crystal_line_comment = '#' @comment nonnewline*;
  # TODO: detect =begin and =end at start of their lines
  # Can't do that now because using 'when starts_line' fails a Ragel assertion.
  crystal_block_comment =
    '=begin' @enqueue @comment (
      newline %{ entity = INTERNAL_NL; } %crystal_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '=end' @commit;
  crystal_comment = crystal_line_comment | crystal_block_comment;

  crystal_dq_str =
    '"' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %crystal_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"' @commit @code;
  # TODO: true literal string detection
  # Turns out any non-alphanum char can be after the initial '%' for a literal
  # string. I only have '(', '[', '{' for now because they are common(?). Their
  # respective closing characters need to be escaped though, which is not
  # accurate; only the single closing character needs to be escaped in a literal
  # string.
  # We need to detect which non-alphanum char opens a literal string, somehow
  # let Ragel know what it is (currently unsupported), and put its respective
  # closing char in the literal string below.
  crystal_lit_str =
    '%' [qQ]? [(\[{] @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %crystal_ccallback
      |
      ws
      |
      [^\r\n\f\t )\]}\\] @code
      |
      '\\' nonnewline @code
    )* [)\]}] @commit @code;
  crystal_cmd_str =
    '`' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %crystal_ccallback
      |
      ws
      |
      [^\r\n\f\t `\\] @code
      |
      '\\' nonnewline @code
    )* '`' @commit @code;
  crystal_regex = '/' ([^\r\n\f/\\] | '\\' nonnewline)* '/' @code;
  # TODO: true literal array and command detection
  # See TODO above about literal string detection
  crystal_lit_other =
    '%' [wrx] [(\[{] @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %crystal_ccallback
      |
      ws
      |
      [^\r\n\f\t )\]}\\] @code
      |
      '\\' nonnewline @code
    )* [)\]}] @commit @code;
  # TODO: heredoc detection
  # This is impossible with current Ragel. We need to extract what the end
  # delimiter should be from the heredoc and search up to it on a new line.
  # crystal_heredoc =
  crystal_string =
    crystal_dq_str | crystal_lit_str | crystal_cmd_str | crystal_regex |
    crystal_lit_other;

  crystal_line := |*
    spaces        ${ entity = CRYSTAL_SPACE; } => crystal_ccallback;
    crystal_comment;
    crystal_string;
    newline       ${ entity = NEWLINE;    } => crystal_ccallback;
    ^space        ${ entity = CRYSTAL_ANY;   } => crystal_ccallback;
  *|;

  # Entity machine

  action crystal_ecallback {
    callback(CRYSTAL_LANG, crystal_entities[entity], cint(ts), cint(te), userdata);
  }

  crystal_line_comment_entity = '#' nonnewline*;
  crystal_block_comment_entity = ('=' when starts_line) 'begin'
    any* :>> (('=' when starts_line) 'end');
  crystal_comment_entity = crystal_line_comment_entity | crystal_block_comment_entity;

  crystal_entity := |*
    space+              ${ entity = CRYSTAL_SPACE;   } => crystal_ecallback;
    crystal_comment_entity ${ entity = CRYSTAL_COMMENT; } => crystal_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with crystal code.
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
void parse_crystal(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? crystal_en_crystal_line : crystal_en_crystal_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(CRYSTAL_LANG) }
}

#endif

/*****************************************************************************/
