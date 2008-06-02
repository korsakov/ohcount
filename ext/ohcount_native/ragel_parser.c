// ragel_parser.c written by Mitchell Foral. mitchell<att>caladbolg<dott>net.

#include "ruby.h"
#include "common.h"

// BEGIN parser includes
#include "c_parser.h"
#include "lua_parser.h"
#include "ruby_parser.h"
#include "css_parser.h"
#include "javascript_parser.h"
#include "html_parser.h"
#include "java_parser.h"
#include "objective_c_parser.h"
#include "visual_basic_parser.h"
#include "sql_parser.h"
#include "actionscript_parser.h"
#include "ada_parser.h"
#include "assembler_parser.h"
#include "autoconf_parser.h"
#include "automake_parser.h"
#include "awk_parser.h"
#include "bat_parser.h"
//#include "boo_parser.h"
#include "d_parser.h"
#include "dcl_parser.h"
#include "dylan_parser.h"
#include "ebuild_parser.h"
#include "exheres_parser.h"
#include "groovy_parser.h"
#include "lisp_parser.h"
#include "fortranfixed_parser.h"
#include "fortranfree_parser.h"
#include "haskell_parser.h"
#include "makefile_parser.h"
#include "matlab_parser.h"
#include "metafont_parser.h"
#include "metapost_parser.h"
#include "mxml_parser.h"
#include "pascal_parser.h"
//#include "perl_parser.h"
#include "pike_parser.h"
//#include "python_parser.h"
#include "rexx_parser.h"
//#include "rhtml_parser.h"
#include "scheme_parser.h"
#include "shell_parser.h"
#include "smalltalk_parser.h"
#include "tcl_parser.h"
#include "tex_parser.h"
#include "vhdl_parser.h"
#include "vim_parser.h"
#include "xml_parser.h"
#include "xslt_parser.h"
#include "xmlschema_parser.h"
// END parser includes

ParseResult *pr;
char *parse_buffer;
int parse_buffer_len;

struct language {
  char name[MAX_LANGUAGE_NAME];
  void (*parser) (char*, int, int, void*);
};

struct language languages[] = {
// BEGIN languages
  { "c", parse_c },
  { "cpp", parse_cpp },
  { "csharp", parse_csharp },
  { "lua", parse_lua },
  { "ruby", parse_ruby },
  { "css", parse_css },
  { "javascript", parse_javascript },
  { "html", parse_html },
  { "java", parse_java },
  { "objective_c", parse_objective_c },
  { "visualbasic", parse_visual_basic },
  { "sql", parse_sql },
  { "actionscript", parse_actionscript },
  { "ada", parse_ada },
  { "assembler", parse_assembler },
  { "autoconf", parse_autoconf },
  { "automake", parse_automake },
  { "awk", parse_awk },
  { "bat", parse_bat },
  //{ "boo", parse_boo },
  { "dcl", parse_dcl },
  { "dmd", parse_d },
  { "dylan", parse_dylan },
  { "ebuild", parse_ebuild },
  { "exheres", parse_exheres },
  { "emacslisp", parse_emacslisp },
  { "groovy", parse_groovy },
  { "lisp", parse_lisp },
  { "fortranfixed", parse_fortranfixed },
  { "fortranfree", parse_fortranfree },
  { "haskell", parse_haskell },
  { "make", parse_makefile },
  { "matlab", parse_matlab },
  { "metafont", parse_metafont },
  { "metapost", parse_metapost },
  { "mxml", parse_mxml },
  { "pascal", parse_pascal },
  //{ "perl", parse_perl },
  { "pike", parse_pike },
  //{ "python", parse_python },
  { "rexx", parse_rexx },
  //{ "rhtml", parse_rhtml },
  { "scheme", parse_scheme },
  { "shell", parse_shell },
  { "smalltalk", parse_smalltalk },
  { "tcl", parse_tcl },
  { "tex", parse_tex },
  { "vala", parse_vala },
  { "vhdl", parse_vhdl },
  { "vim", parse_vim },
  { "xml", parse_xml },
  { "xslt", parse_xslt },
  { "xmlschema", parse_xmlschema },
// END languages
  { "", NULL }
};

/* Returns a language_breakdown for a given language name. */
LanguageBreakdown *get_language_breakdown(char *name) {
	int i;
	for (i = 0; i < pr->language_breakdown_count; i++)
		if (strcmp(pr->language_breakdowns[i].name, name) == 0)
			return &pr->language_breakdowns[i]; // found one

	language_breakdown_initialize(
    &pr->language_breakdowns[pr->language_breakdown_count],
    name, parse_buffer_len); // create one
	return &pr->language_breakdowns[pr->language_breakdown_count++];
}

/* Yields a line's language, semantic, and text to an optional Ruby block. */
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

/* Callback function called for every entity in the source file discovered.
 *
 * Entities are defined in the parser and are things like comments, strings,
 * keywords, etc.
 * This callback yields for a Ruby block if necessary:
 *   |language, semantic, line|
 * @param *lang The language associated with the entity.
 * @param *entity The entity discovered. There are 3 additional entities used
 *   by Ohcount for counting: lcode, lcomment, and lblank for a line of code,
 *   a whole line comment, or a blank line respectively.
 * @param s The start position of the entity relative to the start of the
 *   buffer.
 * @param e The end position of the entity relative to the start of the buffer
 *   (non-inclusive).
 */
void ragel_parser_callback(const char *lang, const char *entity, int s, int e) {
  LanguageBreakdown *lb = get_language_breakdown((char *) lang);
  if (strcmp(entity, "lcode") == 0) {
    language_breakdown_copy_code(lb, parse_buffer + s, parse_buffer + e);
    ragel_parse_yield_line(lang, entity, s, e);
  } else if (strcmp(entity, "lcomment") == 0) {
    language_breakdown_copy_comment(lb, parse_buffer + s, parse_buffer + e);
    ragel_parse_yield_line(lang, entity, s, e);
  } else if (strcmp(entity, "lblank") == 0) {
    lb->blank_count++;
    ragel_parse_yield_line(lang, entity, s, e);
  }
}

/* Tries to use an existing Ragel parser for the given language.
 *
 * @param *parse_result An allocated, empty ParseResult to hold parse results.
 * @param *buffer A pointer to the buffer or character in the buffer to start
 *   parsing at.
 * @param buffer_len The length of the buffer to parse.
 * @param *lang The language name associated with the buffer to parse.
 * @return 1 if a Ragel parser is found, 0 otherwise.
 */
int ragel_parser_parse(ParseResult *parse_result,
                       char *buffer, int buffer_len, char *lang) {
  pr = parse_result;
  pr->language_breakdown_count = 0;
  parse_buffer = buffer;
  parse_buffer_len = buffer_len;
  int i;
  for (i = 0; strlen(languages[i].name) != 0; i++)
    if (strcmp(languages[i].name, lang) == 0) {
      languages[i].parser(buffer, buffer_len, 1, ragel_parser_callback);
      printf("%s", lang);
      return 1;
    }
  return 0;
}
