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

	/* bs initializers */
	strcpy(language_breakdown->name, "");
	strcpy(language_breakdown->code, "");
	strcpy(language_breakdown->comment, "");
	return Data_Wrap_Struct(klass, 0, _language_breakdown_free, language_breakdown);
}

static VALUE _language_breakdown_initialize(VALUE self, VALUE name, VALUE code, VALUE comment, VALUE blanks) {
	/* validation */
	Check_Type(name, T_STRING);
	Check_Type(code, T_STRING);
	Check_Type(comment, T_STRING);
	Check_Type(blanks, T_FIXNUM);

	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);

	/* name */
	strncpy(lb->name, rb_string_value_ptr(&name), MAX_LANGUAGE_NAME);

	/* code */
	if (lb->code != NULL) {
		free(lb->code);
	}
	lb->code = (char*)malloc(RSTRING(code)->len);
	strcpy(lb->code, rb_string_value_ptr(&code));

	/* comment */
	if (lb->comment != NULL) {
		free(lb->comment);
	}
	lb->comment = (char*)malloc(RSTRING(comment)->len);
	strcpy(lb->comment, rb_string_value_ptr(&comment));

	/* blanks */
	lb->blank_count = NUM2INT(blanks);

	return self;
}

static VALUE _language_breakdown_name(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return rb_str_new2(lb->name);
}

static VALUE _language_breakdown_code(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return rb_str_new2(lb->code);
}

static VALUE _language_breakdown_comment(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return rb_str_new2(lb->comment);
}

static VALUE _language_breakdown_blanks(VALUE self) {
	LanguageBreakdown *lb;
	Data_Get_Struct (self, LanguageBreakdown, lb);
	return INT2NUM(lb->blank_count);
}


/*****************************************************************************
                                Ohcount (Module)
*****************************************************************************/
static VALUE _ohcount_parse(VALUE self, VALUE buffer, VALUE polyglot_name_value) {

	// find the polyglot to parse with
	char *polyglot_name = RSTRING(polyglot_name_value)->ptr;
	int i_polyglot;
	for (i_polyglot = 0; POLYGLOTS[i_polyglot] != NULL; i_polyglot++) {
		if (strcmp(POLYGLOTS[i_polyglot]->name, polyglot_name) == 0) {
			Polyglot *polyglot = POLYGLOTS[i_polyglot];

			ParseResult pr;
			parser_parse(&pr, RSTRING(buffer)->ptr, RSTRING(buffer)->len, polyglot);

			// create array we'll return all the language_breakdowns in
			VALUE ary = rb_ary_new2(pr.language_breakdown_count);

			int i_pr;
			for(i_pr = 0; i_pr < pr.language_breakdown_count; i_pr++) {
				LanguageBreakdown *lb = (LanguageBreakdown *) malloc(sizeof(LanguageBreakdown));
				LanguageBreakdown *src_lb = &(pr.language_breakdowns[i_pr]);
				strcpy(lb->name,src_lb->name);
				lb->code = src_lb->code;
				lb->comment = src_lb->comment;
				lb->blank_count = src_lb->blank_count;
				rb_ary_store(ary, i_pr, Data_Wrap_Struct(rb_class_language_breakdown, 0, _language_breakdown_free, lb));
			}

			return ary;
		}
	}
  rb_raise(rb_eStandardError,"Polyglot name invalid");
	return Qnil;
}


static VALUE _ohcount_polyglots(VALUE self) {

	// how many are they?
	int poly_count = 0;
	Polyglot **p = POLYGLOTS;
	while ((*p++) != NULL) {
		poly_count++;
	}

	// create the array
	VALUE ary = rb_ary_new2(poly_count);

	// fill it in
	int i_poly;
	for (i_poly = 0; POLYGLOTS[i_poly] != NULL; i_poly++) {
		VALUE poly_name = rb_str_new2(POLYGLOTS[i_poly]->name);
		rb_ary_store(ary, i_poly, poly_name);
	}

	return ary;
}


/*****************************************************************************
                                Initialize Ruby
*****************************************************************************/
void Init_ohcount_native () {
	rb_module_ohcount = rb_define_module("Ohcount");
	rb_define_module_function(rb_module_ohcount, "parse", _ohcount_parse, 2);
	rb_define_module_function(rb_module_ohcount, "polyglots", _ohcount_polyglots, 0);

	// define language_breakdown
	rb_class_language_breakdown = rb_define_class_under( rb_module_ohcount, "LanguageBreakdown", rb_cObject);
	rb_define_alloc_func (rb_class_language_breakdown, _language_breakdown_allocate);
	rb_define_method (rb_class_language_breakdown, "initialize", _language_breakdown_initialize, 4);
	rb_define_method (rb_class_language_breakdown, "name", _language_breakdown_name, 0);
	rb_define_method (rb_class_language_breakdown, "code", _language_breakdown_code, 0);
	rb_define_method (rb_class_language_breakdown, "comment", _language_breakdown_comment, 0);
	rb_define_method (rb_class_language_breakdown, "blanks", _language_breakdown_blanks, 0);
}

