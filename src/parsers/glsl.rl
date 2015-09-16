// glsl.rl by Leszek Godlewski <ineqvation ay tee gmail dee oh tee cee oh em>
// Written according to GLSL 1.20.8 specificiation
// Based on c.rl written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

/************************* Required for every parser *************************/
#ifndef OHCOUNT_GLSL_PARSER_H
#define OHCOUNT_GLSL_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *GLSL_LANG = LANG_GLSL;

// the languages entities
const char *glsl_entities[] = {
  "space", "comment", "string", "number", "preproc",
  "keyword", "identifier", "operator", "any"
};

// constants associated with the entities
enum {
  GLSL_SPACE = 0, GLSL_COMMENT, GLSL_STRING, GLSL_NUMBER, GLSL_PREPROC,
  GLSL_KEYWORD, GLSL_IDENTIFIER, GLSL_OPERATOR, GLSL_ANY
};

/*****************************************************************************/

%%{
  machine glsl;
  write data;
  include common "common.rl";

  # Line counting machine

  action glsl_ccallback {
    switch(entity) {
    case GLSL_SPACE:
      ls
      break;
    case GLSL_ANY:
      code
      break;
    case INTERNAL_NL:
      std_internal_newline(GLSL_LANG)
      break;
    case NEWLINE:
      std_newline(GLSL_LANG)
    }
  }

  glsl_line_comment =
    '//' @comment (
      escaped_newline %{ entity = INTERNAL_NL; } %glsl_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )*;
  glsl_block_comment =
    '/*' @comment (
      newline %{ entity = INTERNAL_NL; } %glsl_ccallback
      |
      ws
      |
      (nonnewline - ws) @comment
    )* :>> '*/';
  glsl_comment = glsl_line_comment | glsl_block_comment;

  glsl_sq_str =
    '\'' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %glsl_ccallback
      |
      ws
      |
      [^\t '\\] @code
      |
      '\\' nonnewline @code
    )* '\'';
  glsl_dq_str =
    '"' @code (
      escaped_newline %{ entity = INTERNAL_NL; } %glsl_ccallback
      |
      ws
      |
      [^\t "\\] @code
      |
      '\\' nonnewline @code
    )* '"';
  glsl_string = glsl_sq_str | glsl_dq_str;

  glsl_line := |*
    spaces    ${ entity = GLSL_SPACE; } => glsl_ccallback;
    glsl_comment;
    glsl_string;
    newline   ${ entity = NEWLINE; } => glsl_ccallback;
    ^space    ${ entity = GLSL_ANY;   } => glsl_ccallback;
  *|;

  # Entity machine

  action glsl_ecallback {
    callback(GLSL_LANG, glsl_entities[entity], cint(ts), cint(te), userdata);
  }

  glsl_line_comment_entity = '//' (escaped_newline | nonnewline)*;
  glsl_block_comment_entity = '/*' any* :>> '*/';
  glsl_comment_entity = glsl_line_comment_entity | glsl_block_comment_entity;

  glsl_string_entity = sq_str_with_escapes | dq_str_with_escapes;

  glsl_number_entity = float | integer;

  glsl_preproc_word =
  # macros
    'define' | 'undef' |
  # conditionals
    'if' | 'ifdef' | 'ifndef' | 'else' | 'elif' | 'endif' |
  # miscellanous
    'pragma' | 'error' | 'extension' | 'version' | 'line';
  # TODO: find some way of making preproc match the beginning of a line.
  # Putting a 'when starts_line' conditional throws an assertion error.
  glsl_preproc_entity =
    '#' space* (glsl_block_comment_entity space*)?
      glsl_preproc_word (escaped_newline | nonnewline)*;

  glsl_identifier_entity = (alpha | '_') (alnum | '_')*;

  glsl_keyword_entity =
    'attribute' | 'const' | 'uniform' | 'varying' | 'centroid' | 'break' |
    'continue' | 'do' | 'for' | 'while' | 'if' | 'else' | 'in' | 'out' |
    'inout' | 'float' | 'int' | 'void' | 'bool' | 'true' | 'false' |
    'invariant' | 'discard' | 'return' | 'mat2' | 'mat3' | 'mat4' |
    'mat2x2' | 'mat2x3' | 'mat2x4' | 'mat3x2' | 'mat3x3' | 'mat3x4' |
    'mat4x2' | 'mat4x3' | 'mat4x4' | 'vec2' | 'vec3' | 'vec4' | 'ivec2' |
    'ivec3' | 'ivec4' | 'bvec2' | 'bvec3' | 'bvec4' | 'sampler1D' |
    'sampler2D' | 'sampler3D' | 'samplerCube' | 'sampler1DShadow' |
    'sampler2DShadow' | 'struct';
  # not including keywords reserved for future use

  glsl_operator_entity = [+\-/*%<>!=^&|?~:;.,()\[\]{}];

  glsl_entity := |*
    space+                 ${ entity = GLSL_SPACE;      } => glsl_ecallback;
    glsl_comment_entity    ${ entity = GLSL_COMMENT;    } => glsl_ecallback;
    glsl_string_entity     ${ entity = GLSL_STRING;     } => glsl_ecallback;
    glsl_number_entity     ${ entity = GLSL_NUMBER;     } => glsl_ecallback;
    glsl_preproc_entity    ${ entity = GLSL_PREPROC;    } => glsl_ecallback;
    glsl_identifier_entity ${ entity = GLSL_IDENTIFIER; } => glsl_ecallback;
    glsl_keyword_entity    ${ entity = GLSL_KEYWORD;    } => glsl_ecallback;
    glsl_operator_entity   ${ entity = GLSL_OPERATOR;   } => glsl_ecallback;
    ^(space | digit)       ${ entity = GLSL_ANY;        } => glsl_ecallback;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with OpenGL Shading Language code.
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
void parse_glsl(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  %% write init;
  cs = (count) ? glsl_en_glsl_line : glsl_en_glsl_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(GLSL_LANG) }
}

#endif

/*****************************************************************************/
