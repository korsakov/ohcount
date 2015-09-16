// augeas.rl, based on ocaml.rl
/************************* Required for every parser *************************/
#ifndef OHCOUNT_AUGEAS_PARSER_H
#define OHCOUNT_AUGEAS_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *AUGEAS_LANG = LANG_AUGEAS;

// the languages entities
const char *augeas_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  AUGEAS_SPACE = 0, AUGEAS_COMMENT, AUGEAS_STRING, AUGEAS_ANY
};

/*****************************************************************************/

%%{
  machine augeas;
  write data;
  include common "common.rl";

  # Line counting machine

  action augeas_ccallback {
    switch(entity) {
    case AUGEAS_SPACE:
      ls
      break;
    case AUGEAS_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(AUGEAS_LANG)
      break;
    case NEWLINE:
      std_newline(AUGEAS_LANG)
    }
  }

  action augeas_comment_nc_res { nest_count = 0; }
  action augeas_comment_nc_inc { nest_count++; }
  action augeas_comment_nc_dec { nest_count--; }

  augeas_nested_block_comment =
		'(*' >augeas_comment_nc_res @comment (
			newline %{ entity = INTERNAL_NL; } %augeas_ccallback
			|
			ws
			|
			'(*' @augeas_comment_nc_inc @comment
			|
			'*)' @augeas_comment_nc_dec @comment
			|
			(nonnewline - ws) @comment
		)* :>> ('*)' when { nest_count == 0 }) @comment;

  augeas_comment = augeas_nested_block_comment;
	augeas_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';


  augeas_line := |*
    spaces          ${ entity = AUGEAS_SPACE; } => augeas_ccallback;
    augeas_comment;
    augeas_string;
    newline         ${ entity = NEWLINE;      } => augeas_ccallback;
    ^space          ${ entity = AUGEAS_ANY;   } => augeas_ccallback;
  *|;

  # Entity machine

  action augeas_ecallback {
    callback(AUGEAS_LANG, augeas_entities[entity], cint(ts), cint(te), userdata);
  }

  augeas_comment_entity = '(*' >augeas_comment_nc_res (
    '(*' @augeas_comment_nc_inc
    |
    '*)' @augeas_comment_nc_dec
    |
    any
  )* :>> ('*)' when { nest_count == 0 });

  augeas_entity := |*
    space+               ${ entity = AUGEAS_SPACE;   } => augeas_ecallback;
    augeas_comment_entity ${ entity = AUGEAS_COMMENT; } => augeas_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Objective Caml code.
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
void parse_augeas(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  int nest_count = 0;

  %% write init;
  cs = (count) ? augeas_en_augeas_line : augeas_en_augeas_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(AUGEAS_LANG) }
}

#endif

/*****************************************************************************/
