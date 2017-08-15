// idl_pvwave.rl written by Sylwester Arabas. slayoo<att>igf<dott>fuw<dott>edu<dott>pl.
// (it's the tex.rl file with the comment symbol changed from "%" into ";")

/************************* Required for every parser *************************/
#ifndef RAGEL_IDL_PVWAVE_PARSER
#define RAGEL_IDL_PVWAVE_PARSER

#include "../parser_macros.h"

// the name of the language
const char *IDL_PVWAVE_LANG = "idl_pvwave";

// the languages entities
const char *idl_pvwave_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  IDL_PVWAVE_SPACE = 0, IDL_PVWAVE_COMMENT, IDL_PVWAVE_STRING, IDL_PVWAVE_ANY
};

/*****************************************************************************/

%%{
  machine idl_pvwave;
  write data;
  include common "common.rl";

  # Line counting machine

  action idl_pvwave_ccallback {
    switch(entity) {
    case IDL_PVWAVE_SPACE:
      ls
      break;
    case IDL_PVWAVE_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(IDL_PVWAVE_LANG)
      break;
    case NEWLINE:
      std_newline(IDL_PVWAVE_LANG)
    }
  }

  idl_pvwave_comment = ';' @comment nonnewline*;

  idl_pvwave_line := |*
    spaces       ${ entity = IDL_PVWAVE_SPACE; } => idl_pvwave_ccallback;
    idl_pvwave_comment;
    newline      ${ entity = NEWLINE;   } => idl_pvwave_ccallback;
    ^space       ${ entity = IDL_PVWAVE_ANY;   } => idl_pvwave_ccallback;
  *|;

  # Entity machine

  action idl_pvwave_ecallback {
    callback(IDL_PVWAVE_LANG, idl_pvwave_entities[entity], cint(ts), cint(te), userdata);
  }

  idl_pvwave_comment_entity = ';' nonnewline*;

  idl_pvwave_entity := |*
    space+             ${ entity = IDL_PVWAVE_SPACE;   } => idl_pvwave_ecallback;
    idl_pvwave_comment_entity ${ entity = IDL_PVWAVE_COMMENT; } => idl_pvwave_ecallback;
    # TODO:
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with IDL_PVWAVE markup.
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
void parse_idl_pvwave(char *buffer, int length, int count,
  void (*callback) (const char *lang, const char *entity, int start, int end, void *udata),
  void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? idl_pvwave_en_idl_pvwave_line : idl_pvwave_en_idl_pvwave_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(IDL_PVWAVE_LANG) }
}

#endif

/*****************************************************************************/
