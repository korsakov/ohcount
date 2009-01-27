// ragel_parser.c written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

#include "ruby.h"
#include "common.h"

// BEGIN parser includes
#include "actionscript_parser.h"
#include "ada_parser.h"
#include "assembler_parser.h"
#include "autoconf_parser.h"
#include "automake_parser.h"
#include "awk_parser.h"
#include "bat_parser.h"
#include "blitzmax_parser.h"
#include "boo_parser.h"
#include "c_parser.h"
#include "classic_basic_parser.h"
#include "clearsilver_parser.h"
#include "clearsilverhtml_parser.h"
#include "cs_aspx_parser.h"
#include "css_parser.h"
#include "d_parser.h"
#include "dcl_parser.h"
#include "dylan_parser.h"
#include "ebuild_parser.h"
#include "eiffel_parser.h"
#include "erlang_parser.h"
#include "exheres_parser.h"
#include "factor_parser.h"
#include "fortranfixed_parser.h"
#include "fortranfree_parser.h"
#include "glsl_parser.h"
#include "groovy_parser.h"
#include "haml_parser.h"
#include "haskell_parser.h"
#include "haxe_parser.h"
#include "html_parser.h"
#include "java_parser.h"
#include "javascript_parser.h"
#include "jsp_parser.h"
#include "lisp_parser.h"
#include "lua_parser.h"
#include "makefile_parser.h"
#include "matlab_parser.h"
#include "metafont_parser.h"
#include "metapost_parser.h"
#include "metapost_with_tex_parser.h"
#include "mxml_parser.h"
#include "nix_parser.h"
#include "objective_c_parser.h"
#include "objective_j_parser.h"
#include "ocaml_parser.h"
#include "pascal_parser.h"
#include "perl_parser.h"
#include "phphtml_parser.h"
#include "pike_parser.h"
#include "python_parser.h"
#include "r_parser.h"
#include "rexx_parser.h"
#include "ruby_parser.h"
#include "rhtml_parser.h"
#include "scala_parser.h"
#include "shell_parser.h"
#include "smalltalk_parser.h"
#include "stratego_parser.h"
#include "structured_basic_parser.h"
#include "sql_parser.h"
#include "tcl_parser.h"
#include "tex_parser.h"
#include "vb_aspx_parser.h"
#include "vhdl_parser.h"
#include "vim_parser.h"
#include "visual_basic_parser.h"
#include "xaml_parser.h"
#include "xml_parser.h"
#include "xslt_parser.h"
#include "xmlschema_parser.h"
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
