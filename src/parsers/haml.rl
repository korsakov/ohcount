// haml.rl written by Fedor Korsakov. spiritusobscurus at gmail dot com

/************************* Required for every parser *************************/
#ifndef OHCOUNT_HAML_PARSER_H
#define OHCOUNT_HAML_PARSER_H

#include "../parser_macros.h"

// the name of the language
const char *HAML_LANG = LANG_HAML;

// the languages entities
const char *haml_entities[] = {
  "space", "comment", "string", "element", "element_class",
  "element_id", "evaluator", "any"
};

// constants associated with the entities
enum {
  HAML_SPACE = 0, HAML_COMMENT, HAML_STRING, HAML_ELEMENT, HAML_ELEMENT_CLASS,
  HAML_ELEMENT_ID, HAML_EVALUATOR, HAML_ANY
};

/*****************************************************************************/

#include "ruby.h"

%%{
  machine haml;
  write data;
  include common "common.rl";
  #EMBED(ruby)

  # Line counting machine

  action haml_ccallback {
    switch(entity) {
    case HAML_SPACE:
      ls
      break;
    case HAML_ANY:
      code
      break;
    case INTERNAL_NL:
      emb_internal_newline(HAML_LANG)
      break;
    case NEWLINE:
      emb_newline(HAML_LANG)
      break;
    case CHECK_BLANK_ENTRY:
      check_blank_entry(HAML_LANG)
    }
  }

	action haml_indent_level_inc { current_indent_level++; }
	action haml_indent_level_res { current_indent_level = 0; }
  action haml_indent_level_set { prior_indent_level = current_indent_level; }
  action bracket_inc { bracket_level++; }
  action bracket_dec { bracket_level--; }
  action bracket_level_res { bracket_level = 0; }

	haml_indent = ([ ]{2}) @haml_indent_level_inc;
  haml_indent_init = ([ ]{2} >haml_indent_level_res @haml_indent_level_inc)? haml_indent*;
  haml_eol = newline >haml_indent_level_res;
  haml_special_char = [\.%#];
  haml_ruby_evaluator = "==" | ([&!]? "=") | "-"  | "~";
  haml_comment_delimiter = ("-#" | "/");

  haml_xhtml_tag_modifier =
    ('{' >bracket_level_res @code (
      newline %{ entity = INTERNAL_NL; } %haml_ccallback
      |
      ws
      |
      (nonnewline - ws - [{}]) @code
      |
      '{' @bracket_inc
      |
      '}' @bracket_dec
    )* :>> ('}' when { bracket_level == 0 }) @code)
    |
    ('[' >bracket_level_res @code (
      newline %{ entity = INTERNAL_NL; } %haml_ccallback
      |
      ws
      |
      '[' @bracket_inc
      |
      ']' @bracket_dec
      |
      (nonnewline - ws - '[' - ']') @code
    )* :>> (']' when { bracket_level == 0 }) @code);

  haml_xhtml_tag = "%" ((nonnewline-ws-'['-'{')+ - haml_ruby_evaluator) haml_xhtml_tag_modifier? '//'?;

  haml_block_line_transition =
    haml_eol %{ entity = INTERNAL_NL;} %haml_ccallback
    ( newline %{ entity = INTERNAL_NL; } %haml_ccallback )*
    ( [ ]{2} when {current_indent_level < prior_indent_level} @haml_indent_level_inc )*
    ( [ ]{2} when {current_indent_level >= prior_indent_level} @haml_indent_level_inc)+;

  haml_block_comment =
    haml_indent_init haml_comment_delimiter >haml_indent_level_set @comment (
      haml_block_line_transition
      |
      ws
      |
      (nonnewline-ws) @comment
    )*;

  haml_comment = haml_block_comment;

  haml_string =
    haml_indent*
    (nonnewline
      - haml_comment_delimiter
      - haml_ruby_evaluator
      - "."
      - "#"
      - "%"
      - [ ]) @code
    (nonnewline @code | ("|" @code newline %{ entity = INTERNAL_NL;}))*;

  haml_ruby_entry =
    ([ ]{2})*
    haml_xhtml_tag{,1}
    haml_ruby_evaluator ws @code;

  haml_ruby_outry =
    newline %{ entity = INTERNAL_NL;} %haml_ccallback
    any @{fhold;};

  haml_ruby_line := |*
    haml_ruby_outry @{ p = ts; fret; };
    spaces        ${ entity = RUBY_SPACE; } => ruby_ccallback;
    ruby_comment;
    ruby_string;
    newline       ${ entity = NEWLINE;    } => ruby_ccallback;
    ^space        ${ entity = RUBY_ANY;   } => ruby_ccallback;
  *|;

  haml_line := |*
    haml_ruby_entry @{entity = CHECK_BLANK_ENTRY; } @{saw(RUBY_LANG)} => {fcall haml_ruby_line; };
    spaces          ${ entity = HAML_SPACE; } => haml_ccallback;
    haml_comment;
    haml_string;
    newline         ${ entity = NEWLINE;    } => haml_ccallback;
    ^space          ${ entity = HAML_ANY;   } => haml_ccallback;
  *|;

  # Entity machine

  action haml_ecallback {
    callback(HAML_LANG, haml_entities[entity], cint(ts), cint(te), userdata);
  }

  haml_element_entity = '%' alnum+;
  haml_element_class_entity = '.' alnum+;
  haml_element_id_entity = '#' alnum+;

  haml_string_entity = (nonnewline
      - haml_comment_delimiter
      - haml_ruby_evaluator
      - "."
      - "#"
      - "%"
      - [ ])
    (nonnewline | ("|" newline))*;

  haml_evaluator_entity = haml_ruby_evaluator;

  # TODO: modifier and comment entity machines

  haml_entity := |*
    space+                     ${ entity = HAML_SPACE;          }  => haml_ecallback;
    haml_element_entity        ${ entity = HAML_ELEMENT;        }  => haml_ecallback;
    haml_element_class_entity  ${ entity = HAML_ELEMENT_CLASS;  }  => haml_ecallback;
    haml_element_id_entity     ${ entity = HAML_ELEMENT_ID;     }  => haml_ecallback;
    haml_evaluator_entity      ${ entity = HAML_EVALUATOR;      }  => haml_ecallback;
    haml_string_entity         ${ entity = HAML_STRING;         }  => haml_ecallback;
    ^space                     ${ entity = HAML_ANY;            }  => haml_ecallback;
  *|;
}%%

/************************* Required for every parser *************************/

/* Parses a string buffer with Haml markup.
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
void parse_haml(char *buffer, int length, int count,
                void (*callback) (const char *lang, const char *entity, int s,
                                  int e, void *udata),
                void *userdata
  ) {
  init

  int prior_indent_level = 0;
  int current_indent_level = 0;
  int bracket_level = 0;

  %% write init;
  cs = (count) ? haml_en_haml_line : haml_en_haml_entity;
  %% write exec;

  // if no newline at EOF; callback contents of last line
  if (count) { process_last_line(HAML_LANG) }
}

#endif

/*****************************************************************************/
