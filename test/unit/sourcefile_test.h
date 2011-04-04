// sourcefile_test.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <string.h>
#include <assert.h>

#include "../../src/sourcefile.h"
#include "../../src/diff.h"
#include "../../src/loc.h"

void test_sourcefile_initialize() {
  SourceFile *sf = ohcount_sourcefile_new("foo.rb");
  assert(strcmp("foo.rb", sf->filepath) == 0);
  assert(strcmp("rb", sf->ext) == 0);
  assert(strcmp("foo.rb", sf->filename) == 0);
  assert(strncmp("", sf->filepath, sf->dirpath) == 0);
  assert(sf->contents == NULL);
  ohcount_sourcefile_free(sf);

  sf = ohcount_sourcefile_new("foo/bar.rb");
  assert(strcmp("foo/bar.rb", sf->filepath) == 0);
  assert(strcmp("rb", sf->ext) == 0);
  assert(strcmp("bar.rb", sf->filename) == 0);
  assert(strncmp("foo/", sf->filepath, sf->dirpath) == 0);
  assert(sf->contents == NULL);
  ohcount_sourcefile_free(sf);
}

void test_sourcefile_language_breakdowns() {
  SourceFile *sf = ohcount_sourcefile_new("foo.rb");
  ohcount_sourcefile_set_contents(sf, "x = 5");
  ParsedLanguageList *list = ohcount_sourcefile_get_parsed_language_list(sf);
  assert(strcmp("ruby", list->head->pl->name) == 0);
  assert(strcmp("x = 5", list->head->pl->code) == 0);
  ohcount_sourcefile_free(sf);
}

void test_sourcefile_diff() {
  SourceFile *old = ohcount_sourcefile_new("foo.c");
  ohcount_sourcefile_set_contents(old, "int i;");
  SourceFile *new = ohcount_sourcefile_new("foo.c");
  ohcount_sourcefile_set_contents(new, "int j;");
  LocDelta *delta1 = ohcount_loc_delta_new("c", 1, 1, 0, 0, 0, 0);
  LocDelta *delta2 = ohcount_sourcefile_calc_loc_delta(old, "c", new);
  assert(ohcount_loc_delta_is_equal(delta1, delta2));
  LocDeltaList *list1 = ohcount_loc_delta_list_new();
  ohcount_loc_delta_list_add_loc_delta(list1, delta1);
  LocDeltaList *list2 = ohcount_sourcefile_diff(old, new);
  assert(list1->head != NULL);
  assert(list2->head != NULL);
  assert(list1->head->next == NULL);
  assert(list2->head->next == NULL);
  assert(ohcount_loc_delta_is_equal(list1->head->delta, list2->head->delta));
  ohcount_sourcefile_free(old);
  ohcount_sourcefile_free(new);
  ohcount_loc_delta_free(delta1);
  ohcount_loc_delta_free(delta2);
  ohcount_loc_delta_list_free(list1);
  ohcount_loc_delta_list_free(list2);
}

void test_sourcefile_calc_diff2() {
  SourceFile *old = ohcount_sourcefile_new("foo.html");
  ohcount_sourcefile_set_contents(old,
    "<html>\n"
    "  <script type='text/javascript'>\n"
    "    var i = 1;\n"
    "  </script>\n"
    "  <style type=\"text/css\">\n"
    "    new_css_code\n"
    "    /* css_comment */\n"
    "  </style>\n"
    "</html>"
  );
  SourceFile *new = ohcount_sourcefile_new("foo.html");
  ohcount_sourcefile_set_contents(new,
    "<html>\n"
    "  <script type='text/javascript'>\n"
    "    var i = 2;\n"
    "  </script>\n"
    "  <style type=\"text/css\">\n"
    "    new_css_code\n"
    "    /* different css_comment */\n"
    "  </style>\n"
    "</html>"
  );
  LocDeltaList *list = ohcount_sourcefile_diff(old, new);
  assert(strcmp(list->head->delta->language, "html") == 0);
  assert(strcmp(list->head->next->delta->language, "javascript") == 0);
  assert(strcmp(list->head->next->next->delta->language, "css") == 0);
  LocDelta *delta1 = ohcount_loc_delta_new("javascript", 1, 1, 0, 0, 0, 0);
  LocDelta *delta2 = ohcount_loc_delta_list_get_loc_delta(list, "javascript");
  assert(ohcount_loc_delta_is_equal(delta1, delta2));
  ohcount_loc_delta_free(delta1);
  delta1 = ohcount_loc_delta_new("css", 0, 0, 1, 1, 0, 0);
  delta2 = ohcount_loc_delta_list_get_loc_delta(list, "css");
  assert(ohcount_loc_delta_is_equal(delta1, delta2));
  ohcount_sourcefile_free(old);
  ohcount_sourcefile_free(new);
  ohcount_loc_delta_list_free(list);
  ohcount_loc_delta_free(delta1);
}

void test_sourcefile_diff_longer() {
  SourceFile *old = ohcount_sourcefile_new("foo.c");
  ohcount_sourcefile_set_contents(old,
    "int = 1;\n"
    "int = 2;\n"
    "int = 3;\n"
    "int = 4;\n"
  );
  SourceFile *new = ohcount_sourcefile_new("foo.c");
  ohcount_sourcefile_set_contents(new,
    "int = 1;\n"
    "int = 5;\n"
    "int = 6;\n"
    "int = 4;\n"
  );
  LocDeltaList *list = ohcount_sourcefile_diff(old, new);
  LocDelta *delta1 = ohcount_loc_delta_new("c", 2, 2, 0, 0, 0, 0);
  LocDelta *delta2 = ohcount_loc_delta_list_get_loc_delta(list, "c");
  assert(ohcount_loc_delta_is_equal(delta1, delta2));
  ohcount_sourcefile_free(old);
  ohcount_sourcefile_free(new);
  ohcount_loc_delta_list_free(list);
  ohcount_loc_delta_free(delta1);
}

void test_sourcefile_diff_very_long() {
	int len = 5500000;
	char *a = malloc(len);
	memset(a, 'i', len);
	a[len-1] = '\0';
	a[len-2] = '\n';

  SourceFile *old = ohcount_sourcefile_new("foo.c");
  ohcount_sourcefile_set_contents(old, a);
	strncpy(a, "int = 1;\n", strlen("int = 1;\n"));
  SourceFile *new = ohcount_sourcefile_new("foo.c");
  ohcount_sourcefile_set_contents(new, a);
  LocDeltaList *list = ohcount_sourcefile_diff(old, new);
	// 2 lines added, 1 removed... strange but thats the expectation
  LocDelta *delta1 = ohcount_loc_delta_new("c", 2, 1, 0, 0, 0, 0);
  LocDelta *delta2 = ohcount_loc_delta_list_get_loc_delta(list, "c");
  assert(ohcount_loc_delta_is_equal(delta1, delta2));
  ohcount_sourcefile_free(old);
  ohcount_sourcefile_free(new);
  ohcount_loc_delta_list_free(list);
  ohcount_loc_delta_free(delta1);
}

void test_sourcefile_calc_diff() {
  int added, removed;
  ohcount_calc_diff("", "", &added, &removed);
  assert(added == 0);
  assert(removed == 0);
  ohcount_calc_diff("a", "a", &added, &removed);
  assert(added == 0);
  assert(removed == 0);
  ohcount_calc_diff("a\n", "a\n", &added, &removed);
  assert(added == 0);
  assert(removed == 0);
  ohcount_calc_diff("", "a\n", &added, &removed);
  assert(added == 1);
  assert(removed == 0);
  ohcount_calc_diff("a\n", "", &added, &removed);
  assert(added == 0);
  assert(removed == 1);
  ohcount_calc_diff("a\n", "b\n", &added, &removed);
  assert(added = 1);
  assert(removed == 1);
  ohcount_calc_diff("a\nb\nc\n", "a\nc\nd\n", &added, &removed);
  assert(added == 1);
  assert(removed == 1);

  ohcount_calc_diff(
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n", // 10 times
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n"
    "Hello, World!\n", // 11 times
    &added, &removed
  );
  assert(added == 1);
  assert(removed == 0);
}

void test_sourcefile_list_language_facts() {
  SourceFileList *sfl = ohcount_sourcefile_list_new();
  ohcount_sourcefile_list_add_directory(sfl, "../gestalt_files/win32_enough/");
  LocList *list = ohcount_sourcefile_list_analyze_languages(sfl);
  assert(ohcount_loc_list_filecount(list) == 2);
  Loc *loc = ohcount_loc_list_get_loc(list, "c");
  assert(loc->code == 2);
  assert(loc->comments == 2);
  assert(loc->blanks == 2);
  ohcount_sourcefile_list_free(sfl);
  ohcount_loc_list_free(list);
}

void test_sourcefile_list_no_symlink_dir() {
  SourceFileList *sfl = ohcount_sourcefile_list_new();
  ohcount_sourcefile_list_add_directory(sfl, "../symlink_test_dir");
  LocList *list = ohcount_sourcefile_list_analyze_languages(sfl);
  assert(ohcount_loc_list_filecount(list) == 0);
  ohcount_sourcefile_list_free(sfl);
  ohcount_loc_list_free(list);
}

#define FALSE 0
#define TRUE 1
char *tmp_file_from_buf(const char *buf);

void test_tmp_dir() {
	char buf[] = "This is just some bogus text.";
	char *tmp_path = tmp_file_from_buf(buf);

	SourceFileList *list = ohcount_sourcefile_list_new();
	ohcount_sourcefile_list_add_directory(list, "/tmp");
	int has_tmp = FALSE;
	SourceFileList *iter = list->head;

	for (; iter != NULL; iter = iter->next) {
		if (strcmp(iter->sf->filepath, tmp_path) == 0) {
			has_tmp = TRUE;
			break;
		}
	}
	assert(has_tmp);
}


void all_sourcefile_tests() {
  test_sourcefile_initialize();
  test_sourcefile_language_breakdowns();
  test_sourcefile_diff();
  test_sourcefile_calc_diff2();
  test_sourcefile_diff_longer();
  test_sourcefile_diff_very_long();
  test_sourcefile_calc_diff();

  test_sourcefile_list_language_facts();
  test_sourcefile_list_no_symlink_dir();
	test_tmp_dir();
}
