/************************* Required for every parser *************************/
#ifndef OHCOUNT_OCAML_PARSER_H
#define OHCOUNT_OCAML_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *OCAML_LANG = LANG_OCAML;

// the languages entities
const char *ocaml_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  OCAML_SPACE = 0, OCAML_COMMENT, OCAML_STRING, OCAML_ANY
};

/*****************************************************************************/

%%{
  machine ocaml;
  write data;
  include common "common.rl";

  # Line counting machine

  action ocaml_ccallback {
    switch(entity) {
    case OCAML_SPACE:
      ls
      break;
    case OCAML_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(OCAML_LANG)
      break;
    case NEWLINE:
      std_newline(OCAML_LANG)
    }
  }

  action ocaml_comment_nc_res { nest_count = 0; }
  action ocaml_comment_nc_inc { nest_count++; }
  action ocaml_comment_nc_dec { nest_count--; }

  ocaml_nested_block_comment =
		'(*' >ocaml_comment_nc_res @comment (
			newline %{ entity = INTERNAL_NL; } %ocaml_ccallback
			|
			ws
			|
			'(*' @ocaml_comment_nc_inc @comment
			|
			'*)' @ocaml_comment_nc_dec @comment
			|
			(nonnewline - ws) @comment
		)* :>> ('*)' when { nest_count == 0 }) @comment;

  ocaml_comment = ocaml_nested_block_comment;
	ocaml_string = '"' @code ([^\r\n\f"\\] | '\\' nonnewline)* '"';


  ocaml_line := |*
    spaces          ${ entity = OCAML_SPACE; } => ocaml_ccallback;
    ocaml_comment;
    ocaml_string;
    newline         ${ entity = NEWLINE;      } => ocaml_ccallback;
    ^space          ${ entity = OCAML_ANY;   } => ocaml_ccallback;
  *|;

  # Entity machine

  action ocaml_ecallback {
    callback(OCAML_LANG, ocaml_entities[entity], cint(ts), cint(te), userdata);
  }

  ocaml_comment_entity = '(*' >ocaml_comment_nc_res (
    '(*' @ocaml_comment_nc_inc
    |
    '*)' @ocaml_comment_nc_dec
    |
    any
  )* :>> ('*)' when { nest_count == 0 });

  ocaml_entity := |*
    space+               ${ entity = OCAML_SPACE;   } => ocaml_ecallback;
    ocaml_comment_entity ${ entity = OCAML_COMMENT; } => ocaml_ecallback;
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
void parse_ocaml(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  int nest_count = 0;

  %% write init;
  cs = (count) ? ocaml_en_ocaml_line : ocaml_en_ocaml_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(OCAML_LANG) }
}

#endif

/*****************************************************************************/
