
%module ohcount
%{
#include "../src/detector.h"
#include "../src/languages.h"
#include "../src/sourcefile.h"
%}

%include typemaps.i

%typemap(in) (register const char *str, register unsigned int len) {
  Check_Type($input, T_STRING);
  $1 = STR2CSTR($input);
  $2 = RSTRING($input)->len;
};

%typemap(out) char ** {
  VALUE arr = rb_ary_new();
  int i;
  for (i = 0; $1[i] != NULL; i++)
    rb_ary_push(arr, rb_str_new2($1[i]));
  $result = arr;
};

%nodefaultctor SourceFile;
%immutable;
%include "../src/languages.h"
%include "../src/structs.h"
%mutable;

%extend SourceFile {
  void set_diskpath(const char *diskpath) {
    ohcount_sourcefile_set_diskpath(self, diskpath);
  }
  void set_contents(const char *contents) {
    ohcount_sourcefile_set_contents(self, contents);
  }
  char *get_contents() {
    return ohcount_sourcefile_get_contents(self);
  }
  int contents_size() {
    return ohcount_sourcefile_get_contents_size(self);
  }
  const char *get_language() {
    return ohcount_sourcefile_get_language(self);
  }
  void parse() {
    ohcount_sourcefile_parse(self);
  }
  ParsedLanguageList *get_parsed_language_list() {
    return ohcount_sourcefile_get_parsed_language_list(self);
  }
  LicenseList *get_license_list() {
    return ohcount_sourcefile_get_license_list(self);
  }
  LocList *get_loc_list() {
    return ohcount_sourcefile_get_loc_list(self);
  }
  LocDeltaList *_diff(SourceFile *to) {
    return ohcount_sourcefile_diff(self, to);
  }
  void set_filenames(VALUE filenames) {
    int i, length = RARRAY(filenames)->len;
    char **fnames = calloc(length + 1, sizeof(char *));
    VALUE *iter = RARRAY(filenames)->ptr;
    for (i = 0; i < length; i++, iter++)
      fnames[i] = STR2CSTR(*iter);
    ohcount_sourcefile_set_filenames(self, fnames);
    free(fnames);
  }
  SourceFile(const char *filepath, VALUE opt_hash=NULL) {
    SourceFile *sourcefile = ohcount_sourcefile_new(filepath);
    if (opt_hash) {
      VALUE val;
      val = rb_hash_aref(opt_hash, ID2SYM(rb_intern("contents")));
      if (val && rb_type(val) == T_STRING)
        ohcount_sourcefile_set_contents(sourcefile, STR2CSTR(val));
      val = rb_hash_aref(opt_hash, ID2SYM(rb_intern("file_location")));
      if (val && rb_type(val) == T_STRING)
        ohcount_sourcefile_set_diskpath(sourcefile, STR2CSTR(val));
      val = rb_hash_aref(opt_hash, ID2SYM(rb_intern("filenames")));
      if (val && rb_type(val) == T_ARRAY)
        SourceFile_set_filenames(sourcefile, val);
    }
    return sourcefile;
  }
  ~SourceFile() {
    ohcount_sourcefile_free(self);
  }
};

%extend SourceFileList {
  static VALUE rb_add_directory(VALUE directory, SourceFileList *list) {
    if (directory && rb_type(directory) == T_STRING)
      ohcount_sourcefile_list_add_directory(list, STR2CSTR(directory));
    return Qnil;
  }
  SourceFileList(VALUE opt_hash=NULL) {
    SourceFileList *list = ohcount_sourcefile_list_new();
    if (opt_hash) {
      VALUE val;
      val = rb_hash_aref(opt_hash, ID2SYM(rb_intern("paths")));
      if (val && rb_type(val) == T_ARRAY)
        rb_iterate(rb_each, val, SourceFileList_rb_add_directory, (VALUE)list);
    }
    return list;
  }
  ~SourceFileList() {
    ohcount_sourcefile_list_free(self);
  }
  void add_file(const char *filepath) {
    ohcount_sourcefile_list_add_file(self, filepath);
  }
  void add_directory(const char *directory) {
    ohcount_sourcefile_list_add_directory(self, directory);
  }
  LocList *analyze_languages() {
    return ohcount_sourcefile_list_analyze_languages(self);
  }
}

int ohcount_is_binary_filename(const char *filename);

struct LanguageMap *ohcount_hash_language_from_name(register const char *str, register unsigned int len);
