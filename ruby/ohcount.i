
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

%nodefaultctor SourceFile;
%immutable;
%include "../src/languages.h"
%include "../src/structs.h"
%mutable;

%extend SourceFile {
  void set_diskpath(const char *diskpath) {
    ohcount_sourcefile_set_diskpath($self, diskpath);
  }
  void set_contents(const char *contents) {
    ohcount_sourcefile_set_contents($self, contents);
  }
  char *get_contents() {
    return ohcount_sourcefile_get_contents($self);
  }
  int contents_size() {
    return ohcount_sourcefile_get_contents_size($self);
  }
  const char *get_language() {
    return ohcount_sourcefile_get_language($self);
  }
  void parse() {
    ohcount_sourcefile_parse($self);
  }
  ParsedLanguageList *get_parsed_language_list() {
    return ohcount_sourcefile_get_parsed_language_list($self);
  }
  LicenseList *get_license_list() {
    return ohcount_sourcefile_get_license_list($self);
  }
  LocList *get_loc_list() {
    return ohcount_sourcefile_get_loc_list($self);
  }
  LocDeltaList *_diff(SourceFile *to) {
    return ohcount_sourcefile_diff($self, to);
  }
  void set_filenames(VALUE filenames) {
    int i, length = RARRAY(filenames)->len;
    char **fnames = calloc(length + 1, sizeof(char *));
    VALUE *iter = RARRAY(filenames)->ptr;
    for (i = 0; i < length; i++, iter++)
      fnames[i] = STR2CSTR(*iter);
    ohcount_sourcefile_set_filenames($self, fnames);
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
    ohcount_sourcefile_free($self);
  }
};

%extend SourceFileList {
  SourceFileList() {
    return ohcount_sourcefile_list_new();
  }
  ~SourceFileList() {
    ohcount_sourcefile_list_free($self);
  }
  void add_file(const char *filepath) {
    ohcount_sourcefile_list_add_file($self, filepath);
  }
  void add_directory(const char *directory) {
    ohcount_sourcefile_list_add_directory($self, directory);
  }
}

int ohcount_is_binary_filename(const char *filename);

struct LanguageMap *ohcount_hash_language_from_name(register const char *str, register unsigned int len);
