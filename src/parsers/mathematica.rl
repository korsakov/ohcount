// mathematica.rl written by Erik Schnetter <eschnetter@perimaterinstitute.ca>

/************************* Required for every parser *************************/
#ifndef OHCOUNT_MATHEMATICA_PARSER_H
#define OHCOUNT_MATHEMATICA_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *MATHEMATICA_LANG = LANG_MATHEMATICA;

// the languages entities
const char *mathematica_entities[] = {
  "space", "comment", "string", "any",
};

// constants associated with the entities
enum {
  MATHEMATICA_SPACE = 0, MATHEMATICA_COMMENT, MATHEMATICA_STRING, MATHEMATICA_ANY
};

/*****************************************************************************/

%%{
  machine mathematica;
  write data;
  include common "common.rl";

  # Line counting machine

  action mathematica_ccallback {
    switch(entity) {
    case MATHEMATICA_SPACE:
      ls
      break;
    case MATHEMATICA_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(MATHEMATICA_LANG)
      break;
    case NEWLINE:
      std_newline(MATHEMATICA_LANG)
    }
  }

  action mathematica_comment_nc_res { nest_count = 0; }
  action mathematica_comment_nc_inc { nest_count++; }
  action mathematica_comment_nc_dec { nest_count--; }

  mathematica_nested_block_comment =
		'(*' >mathematica_comment_nc_res @comment (
			newline %{ entity = INTERNAL_NL; } %mathematica_ccallback
			|
			ws
			|
			'(*' @mathematica_comment_nc_inc @comment
			|
			'*)' @mathematica_comment_nc_dec @comment
			|
			(nonnewline - ws) @comment
		)* :>> ('*)' when { nest_count == 0 }) @comment;

  mathematica_comment = mathematica_nested_block_comment;

  mathematica_string = '"' @code ([^"]) '"';

  mathematica_line := |*
    spaces               ${ entity = MATHEMATICA_SPACE; } => mathematica_ccallback;
    mathematica_comment;
    mathematica_string;
    newline              ${ entity = NEWLINE;      } => mathematica_ccallback;
    ^space               ${ entity = MATHEMATICA_ANY;   } => mathematica_ccallback;
  *|;

  # Entity machine

  action mathematica_ecallback {
    callback(MATHEMATICA_LANG, mathematica_entities[entity], cint(ts), cint(te),
             userdata);
  }

  mathematica_comment_entity = '(*' >mathematica_comment_nc_res (
    '(*' @mathematica_comment_nc_inc
    |
    '*)' @mathematica_comment_nc_dec
    |
    any
  )* :>> ('*)' when { nest_count == 0 });

  mathematica_entity := |*
    space+                     ${ entity = MATHEMATICA_SPACE;   } => mathematica_ecallback;
    mathematica_comment_entity ${ entity = MATHEMATICA_COMMENT; } => mathematica_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with MATHEMATICA code.
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
void parse_mathematica(char *buffer, int length, int count,
                       void (*callback) (const char *lang, const char *entity, int s,
                                         int e, void *udata),
                       void *userdata
  ) {
  init

  int nest_count = 0;

  %% write init;
  cs = (count) ? mathematica_en_mathematica_line : mathematica_en_mathematica_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(MATHEMATICA_LANG) }
}

#endif

/*****************************************************************************/
