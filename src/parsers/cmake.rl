// cmake.rl written by James Webber, bunkerprivate@googlemail.com, based on
// shell.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net
//
// From shell, I remove single quote strings and added an @code to the end
// of a double quote string in case the terminating double string is on a line
// of its own.

/************************* Required for every parser *************************/
#ifndef RAGEL_CMAKE_PARSER
#define RAGEL_CMAKE_PARSER

#include "../parser_macros.h"

// the name of the language
const char *CMAKE_LANG = "cmake";

// the languages entities
const char *cmake_entities[] = {
  "space", "comment", "string", "any"
};

// constants associated with the entities
enum {
  CMAKE_SPACE = 0, CMAKE_COMMENT, CMAKE_STRING, CMAKE_ANY
};

/*****************************************************************************/

%%{
  machine cmake;
  write data;
  include common "common.rl";

  # Line counting machine

  action cmake_ccallback {
    switch(entity) {
    case CMAKE_SPACE:
      ls
      break;
    case CMAKE_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(CMAKE_LANG)
      break;
    case NEWLINE:
      std_newline(CMAKE_LANG)
    }
  }

  action es {
    printf("endstring\n");
  }

  cmake_comment = '#' @comment nonnewline*;

  cmake_dq_str =
    '"' @enqueue @code (
      newline %{ entity = INTERNAL_NL; } %cmake_ccallback
      |
      ws
      |
      [^\r\n\f\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"' @code @commit ;

  cmake_string = cmake_dq_str;

  cmake_line := |*
    spaces         ${ entity = CMAKE_SPACE; } => cmake_ccallback;
    cmake_comment;
    cmake_string;
    newline        ${ entity = NEWLINE;     } => cmake_ccallback;
    ^space         ${ entity = CMAKE_ANY;   } => cmake_ccallback;
  *|;

  # Entity machine

  action cmake_ecallback {
    callback(CMAKE_LANG, cmake_entities[entity], cint(ts), cint(te), userdata);
  }

  cmake_comment_entity = '#' nonnewline*;

  cmake_entity := |*
    space+               ${ entity = CMAKE_SPACE;   } => cmake_ecallback;
    cmake_comment_entity ${ entity = CMAKE_COMMENT; } => cmake_ecallback;
    # TODO: see shell.rl - (what is the todo for?!)
    ^space;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with cmake script code.
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
void parse_cmake(char *buffer, int length, int count,
                 void (*callback) (const char *lang, const char *entity, int s,
                                   int e, void *udata),
                 void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? cmake_en_cmake_line : cmake_en_cmake_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(CMAKE_LANG) }
}

#endif

/*****************************************************************************/
