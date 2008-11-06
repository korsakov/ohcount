#include "ruby.h"
#include "common.h"

static VALUE rb_module_ohcount;
static VALUE rb_class_language_breakdown;


/*****************************************************************************
                               LanguageBreakdown
*****************************************************************************/

static void _language_breakdown_free(LanguageBreakdown *language_breakdown) {
	language_breakdown_free(language_breakdown);
	free(language_breakdown);
}

static VALUE _language_breakdown_allocate(VALUE klass) {
	int _my_language_id;
	int _my_buffer_size;
	_my_language_id = 0;
	_my_buffer_size	= 100;
	LanguageBreakdown *language_breakdown = (LanguageBreakdown *) malloc(sizeof(LanguageBreakdown));
	language_breakdown_initialize(language_breakdown, "", _my_buffer_size);
	return Data_Wrap_Struct(klass, 0, _language_breakdown_free, language_breakdown);
}

/*
 * Initializes a LanguageBreakdown.
 *
 * call-seq:
 *   new<em>(language_name, code_string, comment_string, blank_counts)</em>
 *
 */
static VALUE _language_breakdown_initialize(int argc, VALUE* argv, VALUE self) {
	VALUE name;
	VALUE code;
	VALUE comment;
	VALUE blanks;

 	rb_scan_args(argc, argv, "13", &name, &code, &comment, &blanks);

	/* validation */
	Check_Type(name,    T_STRING);
	if (!NIL_P(code))    { Check_Type(code,    T_STRING); }
	if (!NIL_P(comment)) { Check_Type(comment, T_STRING); }
	if (!NIL_P(blanks))  { Check_Type(blanks,  T_FIXNUM); }

	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);

	/* name */
	strncpy(lb->name, rb_string_value_ptr(&name), MAX_LANGUAGE_NAME);

	/* code */
	if (!NIL_P(code)) {
		if (lb->code != NULL) {
			free(lb->code);
		}
		lb->code = (char*)malloc(RSTRING(code)->len + 1);
		strcpy(lb->code, rb_string_value_ptr(&code));
	}

	/* comment */
	if (!NIL_P(comment)) {
		if (lb->comment != NULL) {
			free(lb->comment);
		}
		lb->comment = (char*)malloc(RSTRING(comment)->len + 1);
		strcpy(lb->comment, rb_string_value_ptr(&comment));
	}

	/* blanks */
	if (!NIL_P(blanks)) {
		lb->blank_count = NUM2INT(blanks);
	}
	return self;
}

/*
 * Returns the language name of this LanguageBreakdown.
 *
 * Example:
 *   puts lb.name
 *
 *   # would output
 *   Ruby # assuming the lb language was Ruby
 */
static VALUE _language_breakdown_name(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return rb_str_new2(lb->name);
}

/*
 * Returns a string containing only the code portion
 * of the file. For example, if the file contained the
 * following Ruby code:
 *
 *   # a comment
 *   i = 5
 *
 * After parsing, the code portion would contain:
 *
 *   i = 5
 */
static VALUE _language_breakdown_code(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return rb_str_new2(lb->code);
}

/*
 * Returns a string containing only the commented lines.
 */
static VALUE _language_breakdown_comment(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return rb_str_new2(lb->comment);
}

/*
 * Returns the count of blanks
 */
static VALUE _language_breakdown_blanks(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return INT2FIX(lb->blank_count);
}

/*
 * Returns the count of lines of code
 */
static VALUE _language_breakdown_code_count(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return INT2FIX(lb->code_count);
}

/*
 * Returns the count of lines of comment
 */
static VALUE _language_breakdown_comment_count(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return INT2FIX(lb->comment_count);
}

/*
 * Ohcount::parse is the Ohcount's workhorse function. It's wrapped by the
 * SourceFile object - which provides a cleaner and easier API.
 *
 * It takes two parameters: a string buffer, and a string Monoglot or Polyglot name.
 * The buffer will be parsed using the specified glot.
 *
 * The method returns an array of LanguageBreakdown objects. One
 * LanguageBreakdown will be returned for each language found in the buffer.
 *
 * You may optionally pass a block of Ruby code. As each line in the buffer
 * is parsed, it will be yielded to the block, along with the language name
 * and code semantic determined for that line.
 *
 * Ruby example:
 *
 *   # Print each line to the console, labeled as code or comments
 *   buffer = File.read("helloworld.c")
 *   results = Ohcount::parse(buffer, 'c') do |language, semantic, line|
 *     puts "#{semantic.to_s} #{line}"
 *   end
 *
 * Another example:
 *
 *   # Print total lines of code
 *   buffer = File.read("helloworld.c")
 *   results = Ohcount::parse(buffer, 'c')
 *   results.each do |result|
 *     puts "Lines of #{result.name} code: #{ result.code.split("\n").size }"
 *   end
 *
 * You must pass the name of a glot appropriate to the buffer you want to parse.
 * If you are not sure which glot is correct, use the Detector to pick a glot.
 */
static VALUE _ohcount_parse(VALUE self, VALUE buffer, VALUE polyglot_name_value) {
	ParseResult pr;

	if (NIL_P(polyglot_name_value)) {
		rb_raise(rb_eStandardError, "Polyglot name required.");
	}

	char *polyglot_name = RSTRING(polyglot_name_value)->ptr;
	if (ragel_parser_parse(&pr, 1, RSTRING(buffer)->ptr, RSTRING(buffer)->len, polyglot_name)) {
		// create array we'll return all the language_breakdowns in
		VALUE ary = rb_ary_new2(pr.language_breakdown_count);

		int i_pr;
		for(i_pr = 0; i_pr < pr.language_breakdown_count; i_pr++) {
			LanguageBreakdown *lb = (LanguageBreakdown *) malloc(sizeof(LanguageBreakdown));
			LanguageBreakdown *src_lb = &(pr.language_breakdowns[i_pr]);
			strcpy(lb->name,src_lb->name);
			lb->code = src_lb->code;
			lb->comment = src_lb->comment;
			lb->code_count = src_lb->code_count;
			lb->comment_count = src_lb->comment_count;
			lb->blank_count = src_lb->blank_count;
			rb_ary_store(ary, i_pr, Data_Wrap_Struct(rb_class_language_breakdown, 0, _language_breakdown_free, lb));
		}

		return ary;
	}
  rb_raise(rb_eStandardError,"Polyglot name invalid: '%s'", polyglot_name);
	return Qnil;
}


/*
 * Document-class: Ohcount
 * Document-method: parse_entities
 *
 * Parses a source file's entities (if available).
 * An entity is each comment, string, number, keyword, etc. that occurs in a
 * source file.
 *
 * You must pass a Ruby block to this function of the form:
 *   |language, entity, s, e| where:
 *     language is the language's name (symbol) e.g. ruby.
 *     entity is the entity's name (symbol) e.g. comment.
 *     s is the entity's start position in the buffer (number).
 *     e is the entity's end position in the buffer non-inclusive (number).
 * If an entity parser is not available for the given language, the block will
 * never be called. There is currently no way to dynamically test if a language
 * has an entity parser.
 *
 * @param buffer The buffer to parse.
 * @param language String language name to parse the buffer as. If you are
 *   unsure which language name is correct, use Ohcount::Detector.detect(file).
 * @return nil
 *
 * @usage
 *
 *   # Print each entity and its position in the buffer
 *   buffer = File.read("helloworld.c")
 *   Ohcount::parse_entities(buffer, 'c') do |lang, entity, s, e|
 *     puts "#{lang}\t#{entity}\t#{s}\t#{e}"
 *   end
 */
static VALUE _ohcount_parse_entities(VALUE self, VALUE buffer, VALUE polyglot_name_value) {
	char *polyglot_name = RSTRING(polyglot_name_value)->ptr;
	ParseResult pr;
	if (!ragel_parser_parse(&pr, 0, RSTRING(buffer)->ptr, RSTRING(buffer)->len, polyglot_name))
		rb_raise(rb_eStandardError,"Polyglot name invalid: '%s'", polyglot_name);
	return Qnil;
}


void Init_ohcount_native () {
	rb_module_ohcount = rb_define_module("Ohcount");
	rb_define_module_function(rb_module_ohcount, "parse", _ohcount_parse, 2);
	rb_define_module_function(rb_module_ohcount, "parse_entities", _ohcount_parse_entities, 2);

 /*
	* When a file containing source code is parsed, it stores the results in a
	* collection of LanguageBreakdowns - one per coding language found in the
	* file. For example, a parsed html file might contain three
	* LanguageBreakdowns: one for html, one for javascript and another for css.
	*
	*/
	rb_class_language_breakdown = rb_define_class_under( rb_module_ohcount, "LanguageBreakdown", rb_cObject);
	rb_define_alloc_func (rb_class_language_breakdown, _language_breakdown_allocate);
	rb_define_method (rb_class_language_breakdown, "initialize", _language_breakdown_initialize, -1);
	rb_define_method (rb_class_language_breakdown, "name", _language_breakdown_name, 0);
	rb_define_method (rb_class_language_breakdown, "code", _language_breakdown_code, 0);
	rb_define_method (rb_class_language_breakdown, "comment", _language_breakdown_comment, 0);
	rb_define_method (rb_class_language_breakdown, "blanks", _language_breakdown_blanks, 0);
	rb_define_method (rb_class_language_breakdown, "code_count", _language_breakdown_code_count, 0);
	rb_define_method (rb_class_language_breakdown, "comment_count", _language_breakdown_comment_count, 0);
}

