// ragel_parser.c written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

#include "ruby.h"
#include "common.h"

// BEGIN parser includes
#include "ragel_parsers/actionscript.h"
#include "ragel_parsers/ada.h"
#include "ragel_parsers/assembler.h"
#include "ragel_parsers/autoconf.h"
#include "ragel_parsers/automake.h"
#include "ragel_parsers/awk.h"
#include "ragel_parsers/bat.h"
#include "ragel_parsers/blitzmax.h"
#include "ragel_parsers/boo.h"
#include "ragel_parsers/c.h"
#include "ragel_parsers/classic_basic.h"
#include "ragel_parsers/clearsilver.h"
#include "ragel_parsers/clearsilverhtml.h"
#include "ragel_parsers/cs_aspx.h"
#include "ragel_parsers/css.h"
#include "ragel_parsers/d.h"
#include "ragel_parsers/dcl.h"
#include "ragel_parsers/dylan.h"
#include "ragel_parsers/ebuild.h"
#include "ragel_parsers/eiffel.h"
#include "ragel_parsers/erlang.h"
#include "ragel_parsers/exheres.h"
#include "ragel_parsers/factor.h"
#include "ragel_parsers/fortranfixed.h"
#include "ragel_parsers/fortranfree.h"
#include "ragel_parsers/glsl.h"
#include "ragel_parsers/groovy.h"
#include "ragel_parsers/haml.h"
#include "ragel_parsers/haskell.h"
#include "ragel_parsers/haxe.h"
#include "ragel_parsers/html.h"
#include "ragel_parsers/java.h"
#include "ragel_parsers/javascript.h"
#include "ragel_parsers/jsp.h"
#include "ragel_parsers/lisp.h"
#include "ragel_parsers/lua.h"
#include "ragel_parsers/makefile.h"
#include "ragel_parsers/matlab.h"
#include "ragel_parsers/metafont.h"
#include "ragel_parsers/metapost.h"
#include "ragel_parsers/metapost_with_tex.h"
#include "ragel_parsers/mxml.h"
#include "ragel_parsers/nix.h"
#include "ragel_parsers/objective_c.h"
#include "ragel_parsers/objective_j.h"
#include "ragel_parsers/ocaml.h"
#include "ragel_parsers/pascal.h"
#include "ragel_parsers/perl.h"
#include "ragel_parsers/phphtml.h"
#include "ragel_parsers/pike.h"
#include "ragel_parsers/python.h"
#include "ragel_parsers/r.h"
#include "ragel_parsers/rexx.h"
#include "ragel_parsers/ruby.h"
#include "ragel_parsers/rhtml.h"
#include "ragel_parsers/scala.h"
#include "ragel_parsers/shell.h"
#include "ragel_parsers/smalltalk.h"
#include "ragel_parsers/stratego.h"
#include "ragel_parsers/structured_basic.h"
#include "ragel_parsers/sql.h"
#include "ragel_parsers/tcl.h"
#include "ragel_parsers/tex.h"
#include "ragel_parsers/vb_aspx.h"
#include "ragel_parsers/vhdl.h"
#include "ragel_parsers/vim.h"
#include "ragel_parsers/visual_basic.h"
#include "ragel_parsers/xaml.h"
#include "ragel_parsers/xml.h"
#include "ragel_parsers/xslt.h"
#include "ragel_parsers/xmlschema.h"
// END parser includes

ParseResult *pr;
char *parse_buffer;
int parse_buffer_len;

struct language {
  char name[MAX_LANGUAGE_NAME];
  void (*parser)(char*, int, int, void(*)(const char*, const char*, int, int));
};

struct language languages[] = {
// BEGIN languages
  { "actionscript", parse_actionscript },
  { "ada", parse_ada },
  { "assembler", parse_assembler },
  { "autoconf", parse_autoconf },
  { "automake", parse_automake },
  { "awk", parse_awk },
  { "bat", parse_bat },
  { "blitzmax", parse_blitzmax },
  { "boo", parse_boo },
  { "c", parse_c },
	{ "classic_basic", parse_classic_basic },
  { "clearsilver", parse_clearsilver },
  { "clearsilver_template", parse_cshtml },
  { "cpp", parse_cpp },
  { "cs_aspx", parse_cs_aspx },
  { "csharp", parse_csharp },
  { "css", parse_css },
  { "dcl", parse_dcl },
  { "dmd", parse_d },
  { "dylan", parse_dylan },
  { "ebuild", parse_ebuild },
	{ "eiffel", parse_eiffel },
  { "erlang", parse_erlang },
  { "exheres", parse_exheres },
  { "emacslisp", parse_emacslisp },
  { "factor", parse_factor },
  { "fortranfixed", parse_fortranfixed },
  { "fortranfree", parse_fortranfree },
  { "glsl", parse_glsl },
  { "groovy", parse_groovy },
  { "haskell", parse_haskell },
  { "haml", parse_haml },
  { "haxe", parse_haxe },
  { "html", parse_html },
  { "java", parse_java },
  { "javascript", parse_javascript },
  { "jsp", parse_jsp },
  { "lisp", parse_lisp },
  { "lua", parse_lua },
  { "make", parse_makefile },
  { "matlab", parse_matlab },
  { "metafont", parse_metafont },
  { "metapost", parse_metapost },
  { "metapost_with_tex", parse_mptex },
  { "mxml", parse_mxml },
  { "nix", parse_nix },
  { "objective_c", parse_objective_c },
  { "objective_j", parse_objective_j },
	{ "ocaml", parse_ocaml },
  { "pascal", parse_pascal },
  { "perl", parse_perl },
  { "php", parse_phtml },
  { "pike", parse_pike },
  { "python", parse_python },
  { "r", parse_r },
  { "rexx", parse_rexx },
  { "rhtml", parse_rhtml },
  { "ruby", parse_ruby },
  { "scala", parse_scala },
  { "scheme", parse_scheme },
  { "shell", parse_shell },
  { "smalltalk", parse_smalltalk },
  { "stratego", parse_stratego },
  { "structured_basic", parse_structured_basic },
  { "sql", parse_sql },
  { "tcl", parse_tcl },
  { "tex", parse_tex },
  { "vala", parse_vala },
	{ "vb_aspx", parse_vb_aspx },
  { "vhdl", parse_vhdl },
  { "vim", parse_vim },
  { "visualbasic", parse_visual_basic },
  { "xaml", parse_xaml },
  { "xml", parse_xml },
  { "xslt", parse_xslt },
  { "xmlschema", parse_xmlschema },
// END languages
  { "", NULL }
};

/** Returns a language_breakdown for a given language name. */
LanguageBreakdown *get_language_breakdown(char *name) {
  int i;
  for (i = 0; i < pr->language_breakdown_count; i++)
    if (strcmp(pr->language_breakdowns[i].name, name) == 0)
      return &pr->language_breakdowns[i]; // found one

  language_breakdown_initialize(
    &pr->language_breakdowns[pr->language_breakdown_count],
    name, parse_buffer_len + 5); // create one
  return &pr->language_breakdowns[pr->language_breakdown_count++];
}

/** Yields a line's language, semantic, and text to an optional Ruby block. */
void ragel_parse_yield_line(const char *lang, const char *entity, int s, int e) {
  if (rb_block_given_p()) {
    VALUE ary;
    ary = rb_ary_new2(2);
    rb_ary_store(ary, 0, ID2SYM(rb_intern(lang)));
    if (strcmp(entity, "lcode") == 0)
      rb_ary_store(ary, 1, ID2SYM(rb_intern("code")));
    else if (strcmp(entity, "lcomment") == 0)
      rb_ary_store(ary, 1, ID2SYM(rb_intern("comment")));
    else if (strcmp(entity, "lblank") == 0)
      rb_ary_store(ary, 1, ID2SYM(rb_intern("blank")));
    rb_ary_store(ary, 2, rb_str_new(parse_buffer + s, e - s));
    rb_yield(ary);
  }
}

/** Yields an entity's language, id, start, and end position to a required Ruby block */
void ragel_parse_yield_entity(const char *lang, const char *entity, int s, int e) {
  if (rb_block_given_p()) {
    VALUE ary;
    ary = rb_ary_new2(3);
    rb_ary_store(ary, 0, ID2SYM(rb_intern(lang)));
    rb_ary_store(ary, 1, ID2SYM(rb_intern(entity)));
    rb_ary_store(ary, 2, rb_int_new(s));
    rb_ary_store(ary, 3, rb_int_new(e));
    rb_yield(ary);
  }
}

/**
 * Callback function called for every entity in the source file discovered.
 *
 * Entities are defined in the parser and are things like comments, strings,
 * keywords, etc.
 * This callback yields for a Ruby block if necessary:
 *   |language, semantic, line| for line counting
 *   |language, entity, s, e| for entity parsing
 * @param *lang The language associated with the entity.
 * @param *entity The entity discovered. There are 3 additional entities used
 *   by Ohcount for counting: lcode, lcomment, and lblank for a line of code,
 *   a whole line comment, or a blank line respectively.
 * @param s The start position of the entity relative to the start of the
 *   buffer.
 * @param e The end position of the entity relative to the start of the buffer
 *   (non-inclusive).
 * TODO: instead of ignoring syntax errors that cause buffer overflows, consider
 *   raising Ruby exceptions to catch and notify the user of.
 */
void ragel_parser_callback(const char *lang, const char *entity, int s, int e) {
  LanguageBreakdown *lb = get_language_breakdown((char *) lang);
  if (strcmp(entity, "lcode") == 0) {
    if (language_breakdown_append_code_line(lb, parse_buffer + s, parse_buffer + e))
      ragel_parse_yield_line(lang, entity, s, e);
  } else if (strcmp(entity, "lcomment") == 0) {
    if (language_breakdown_append_comment_line(lb, parse_buffer + s, parse_buffer + e))
      ragel_parse_yield_line(lang, entity, s, e);
  } else if (strcmp(entity, "lblank") == 0) {
    lb->blank_count++;
    ragel_parse_yield_line(lang, entity, s, e);
  } else {
    ragel_parse_yield_entity(lang, entity, s, e);
  }
}

/**
 * Tries to use an existing Ragel parser for the given language.
 *
 * @param *parse_result An allocated, empty ParseResult to hold parse results.
 * @param count An integer flag indicating whether to count lines or parse
 *   entities.
 * @param *buffer A pointer to the buffer or character in the buffer to start
 *   parsing at.
 * @param buffer_len The length of the buffer to parse.
 * @param *lang The language name associated with the buffer to parse.
 * @return 1 if a Ragel parser is found, 0 otherwise.
 */
int ragel_parser_parse(ParseResult *parse_result, int count,
                       char *buffer, int buffer_len, char *lang) {
  pr = parse_result;
  pr->language_breakdown_count = 0;
  parse_buffer = buffer;
  parse_buffer_len = buffer_len;
  int i;
  for (i = 0; strlen(languages[i].name) != 0; i++) {
    if (strcmp(languages[i].name, lang) == 0) {
      languages[i].parser(buffer, buffer_len, count, ragel_parser_callback);
      return 1;
    }
	}
  return 0;
}
