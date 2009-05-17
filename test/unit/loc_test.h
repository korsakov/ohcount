// loc_test.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "../../src/loc.h"

void test_loc_default() {
  Loc *loc = ohcount_loc_new("c", 0, 0, 0, 0);
  assert(strcmp("c", loc->language) == 0);
  assert(loc->code == 0);
  assert(loc->comments == 0);
  assert(loc->blanks == 0);
  assert(loc->filecount == 0);
  ohcount_loc_free(loc);
}

void test_loc_initializer() {
  Loc *loc = ohcount_loc_new("c", 1, 2, 3, 4);
  assert(strcmp("c", loc->language) == 0);
  assert(loc->code == 1);
  assert(loc->comments == 2);
  assert(loc->blanks == 3);
  assert(loc->filecount == 4);
  ohcount_loc_free(loc);
}

void test_loc_add() {
  Loc *loc = ohcount_loc_new("c", 1, 2, 3, 4);
  Loc *loc2 = ohcount_loc_new("c", 10, 20, 30, 40);
  ohcount_loc_add_loc(loc, loc2);
  assert(strcmp("c", loc->language) == 0);
  assert(loc->code == 11);
  assert(loc->comments == 22);
  assert(loc->blanks == 33);
  assert(ohcount_loc_total(loc) == 66);
  assert(loc->filecount == 44);
  ohcount_loc_free(loc);
  ohcount_loc_free(loc2);
}

void test_loc_add_requires_same_language() {
  Loc *loc = ohcount_loc_new("c", 1, 2, 3, 4);
  Loc *loc2 = ohcount_loc_new("java", 10, 20, 30, 40);
  ohcount_loc_add_loc(loc, loc2);
  assert(strcmp("c", loc->language) == 0);
  assert(loc->code == 1);
  assert(loc->comments == 2);
  assert(loc->blanks == 3);
  assert(loc->filecount == 4);
  ohcount_loc_free(loc);
  ohcount_loc_free(loc2);
}

void test_loc_list_default() {
  LocList *list = ohcount_loc_list_new();
  assert(list->loc == NULL);
  ohcount_loc_list_free(list);
}

void test_loc_list_selector() {
  LocList *list = ohcount_loc_list_new();
  Loc *c = ohcount_loc_new("c", 1, 2, 3, 4);
  Loc *java = ohcount_loc_new("java", 10, 20, 30, 40);
  ohcount_loc_list_add_loc(list, c);
  ohcount_loc_list_add_loc(list, java);
  assert(strcmp(list->head->loc->language, "c") == 0);
  assert(strcmp(list->head->next->loc->language, "java") == 0);
  assert(ohcount_loc_is_equal(ohcount_loc_list_get_loc(list, "c"), c));
  assert(ohcount_loc_is_equal(ohcount_loc_list_get_loc(list, "java"), java));
  ohcount_loc_free(c);
  ohcount_loc_free(java);
  ohcount_loc_list_free(list);
}

void test_loc_list_first_add() {
  LocList *list = ohcount_loc_list_new();
  Loc *c = ohcount_loc_new("c", 1, 2, 3, 4);
  ohcount_loc_list_add_loc(list, c);
  assert(ohcount_loc_is_equal(list->head->loc, c));
  assert(strcmp(list->head->loc->language, "c") == 0);
  assert(ohcount_loc_list_code(list) == 1);
  assert(ohcount_loc_list_comments(list) == 2);
  assert(ohcount_loc_list_blanks(list) == 3);
  assert(ohcount_loc_list_total(list) == 6);
  assert(ohcount_loc_list_filecount(list) == 4);
  ohcount_loc_free(c);
  ohcount_loc_list_free(list);
}

void test_loc_list_add_two_languages() {
  LocList *list = ohcount_loc_list_new();
  Loc *c = ohcount_loc_new("c", 1, 2, 3, 4);
  Loc *java = ohcount_loc_new("java", 10, 20, 30, 40);
  ohcount_loc_list_add_loc(list, c);
  ohcount_loc_list_add_loc(list, java);
  assert(strcmp(list->head->loc->language, "c") == 0);
  assert(strcmp(list->head->next->loc->language, "java") == 0);
  assert(ohcount_loc_is_equal(ohcount_loc_list_get_loc(list, "c"), c));
  assert(ohcount_loc_is_equal(ohcount_loc_list_get_loc(list, "java"), java));
  assert(ohcount_loc_list_code(list) == 11);
  assert(ohcount_loc_list_comments(list) == 22);
  assert(ohcount_loc_list_blanks(list) == 33);
  assert(ohcount_loc_list_total(list) == 66);
  assert(ohcount_loc_list_filecount(list) == 44);
  ohcount_loc_free(c);
  ohcount_loc_free(java);
  ohcount_loc_list_free(list);
}

void test_loc_list_add_same_language_twice() {
  LocList *list = ohcount_loc_list_new();
  Loc *c1 = ohcount_loc_new("c", 1, 2, 3, 4);
  Loc *c2 = ohcount_loc_new("c", 10, 20, 30, 40);
  ohcount_loc_list_add_loc(list, c1);
  ohcount_loc_list_add_loc(list, c2);
  assert(strcmp(list->head->loc->language, "c") == 0);
  assert(list->head->next == NULL);
  assert(ohcount_loc_list_code(list) == 11);
  assert(ohcount_loc_list_comments(list) == 22);
  assert(ohcount_loc_list_blanks(list) == 33);
  assert(ohcount_loc_list_total(list) == 66);
  assert(ohcount_loc_list_filecount(list) == 44);
  ohcount_loc_free(c1);
  ohcount_loc_free(c2);
  ohcount_loc_list_free(list);
}

void test_loc_list_add_loc_lists() {
  LocList *list1 = ohcount_loc_list_new();
  LocList *list2 = ohcount_loc_list_new();
  Loc *c1 = ohcount_loc_new("c", 1, 0, 0, 0);
  Loc *java = ohcount_loc_new("java", 2, 0, 0, 0);
  Loc *c2 = ohcount_loc_new("c", 10, 0, 0, 0);
  Loc *ruby = ohcount_loc_new("ruby", 3, 0, 0, 0);
  ohcount_loc_list_add_loc(list1, c1);
  ohcount_loc_list_add_loc(list1, java);
  ohcount_loc_list_add_loc(list2, c2);
  ohcount_loc_list_add_loc(list2, ruby);
  ohcount_loc_list_add_loc_list(list1, list2);
  assert(strcmp(list1->head->loc->language, "c") == 0);
  assert(strcmp(list1->head->next->loc->language, "java") == 0);
  assert(strcmp(list1->head->next->next->loc->language, "ruby") == 0);
  assert(list1->head->next->next->next == NULL);
  assert(ohcount_loc_list_get_loc(list1, "c")->code == 11);
  assert(ohcount_loc_list_get_loc(list1, "java")->code == 2);
  assert(ohcount_loc_list_get_loc(list1, "ruby")->code == 3);
  assert(ohcount_loc_list_code(list1) == 16);
  ohcount_loc_free(c1);
  ohcount_loc_free(java);
  ohcount_loc_free(c2);
  ohcount_loc_free(ruby);
  ohcount_loc_list_free(list1);
  ohcount_loc_list_free(list2);
}

void test_loc_list_compact() {
  LocList *list = ohcount_loc_list_new();
  Loc *c = ohcount_loc_new("c", 1, 2, 3, 4);
  Loc *java = ohcount_loc_new("java", 0, 0, 0, 0);
  ohcount_loc_list_add_loc(list, c);
  ohcount_loc_list_add_loc(list, java);
  LocList *compacted = ohcount_loc_list_new_compact(list);
  assert(ohcount_loc_is_equal(ohcount_loc_list_get_loc(compacted, "c"), c));
  assert(compacted->head->next == NULL);
  ohcount_loc_free(c);
  ohcount_loc_free(java);
  ohcount_loc_list_free(list);
  ohcount_loc_list_free(compacted);
}

void test_loc_delta_default() {
  LocDelta *delta = ohcount_loc_delta_new("c", 0, 0, 0, 0, 0, 0);
  assert(delta->code_added == 0);
  assert(delta->code_removed == 0);
  assert(delta->comments_added == 0);
  assert(delta->comments_removed == 0);
  assert(delta->blanks_added == 0);
  assert(delta->blanks_removed == 0);
  ohcount_loc_delta_free(delta);
}

void test_loc_delta_initializer() {
  LocDelta *delta = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  assert(strcmp(delta->language, "c") == 0);
  assert(delta->code_added == 1);
  assert(delta->code_removed == 10);
  assert(delta->comments_added == 2);
  assert(delta->comments_removed == 20);
  assert(delta->blanks_added == 3);
  assert(delta->blanks_removed == 30);
  ohcount_loc_delta_free(delta);
}

void test_loc_delta_net_total() {
  LocDelta *delta = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  assert(ohcount_loc_delta_net_code(delta) == -9);
  assert(ohcount_loc_delta_net_comments(delta) == -18);
  assert(ohcount_loc_delta_net_blanks(delta) == -27);
  assert(ohcount_loc_delta_net_total(delta) == -54);
  ohcount_loc_delta_free(delta);
}

void test_loc_delta_addition() {
  LocDelta *delta1 = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  LocDelta *delta2 = ohcount_loc_delta_new("c", 100, 1000, 200, 2000, 300,
                                           3000);
  ohcount_loc_delta_add_loc_delta(delta1, delta2);
  assert(delta1->code_added == 101);
  assert(delta1->code_removed == 1010);
  assert(delta1->comments_added == 202);
  assert(delta1->comments_removed == 2020);
  assert(delta1->blanks_added == 303);
  assert(delta1->blanks_removed == 3030);
  ohcount_loc_delta_free(delta1);
  ohcount_loc_delta_free(delta2);
}

void test_loc_delta_addition_requires_matching_language() {
  LocDelta *delta1 = ohcount_loc_delta_new("c", 0, 0, 0, 0, 0, 0);
  LocDelta *delta2 = ohcount_loc_delta_new("java", 1, 10, 2, 20, 3, 30);
  ohcount_loc_delta_add_loc_delta(delta1, delta2);
  assert(strcmp(delta1->language, "c") == 0);
  assert(delta1->code_added == 0);
  assert(delta1->code_removed == 0);
  assert(delta1->comments_added == 0);
  assert(delta1->comments_removed == 0);
  assert(delta1->blanks_added == 0);
  assert(delta1->blanks_removed == 0);
  ohcount_loc_delta_free(delta1);
  ohcount_loc_delta_free(delta2);
}

void test_loc_delta_equals() {
  LocDelta *delta1 = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  LocDelta *delta2 = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  assert(ohcount_loc_delta_is_equal(delta1, delta2));
  ohcount_loc_delta_free(delta1);
  ohcount_loc_delta_free(delta2);
}

void test_loc_delta_list_default() {
  LocDeltaList *list = ohcount_loc_delta_list_new();
  assert(list->delta == NULL);
  ohcount_loc_delta_list_free(list);
}

void test_loc_delta_list_selector() {
  LocDeltaList *list = ohcount_loc_delta_list_new();
  LocDelta *c = ohcount_loc_delta_new("c", 0, 0, 0, 0, 0, 0);
  LocDelta *java = ohcount_loc_delta_new("java", 0, 0, 0, 0, 0, 0);
  ohcount_loc_delta_list_add_loc_delta(list, c);
  ohcount_loc_delta_list_add_loc_delta(list, java);
  assert(ohcount_loc_delta_is_equal(
         ohcount_loc_delta_list_get_loc_delta(list, "c"), c));
  assert(ohcount_loc_delta_is_equal(
         ohcount_loc_delta_list_get_loc_delta(list, "java"), java));
  ohcount_loc_delta_free(c);
  ohcount_loc_delta_free(java);
  ohcount_loc_delta_list_free(list);
}

void test_loc_delta_list_first_add() {
  LocDeltaList *list = ohcount_loc_delta_list_new();
  LocDelta *c = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  ohcount_loc_delta_list_add_loc_delta(list, c);
  assert(strcmp(list->head->delta->language, "c") == 0);
  assert(ohcount_loc_delta_list_code_added(list) == 1);
  assert(ohcount_loc_delta_list_code_removed(list) == 10);
  assert(ohcount_loc_delta_list_comments_added(list) == 2);
  assert(ohcount_loc_delta_list_comments_removed(list) == 20);
  assert(ohcount_loc_delta_list_blanks_added(list) == 3);
  assert(ohcount_loc_delta_list_blanks_removed(list) == 30);
  ohcount_loc_delta_free(c);
  ohcount_loc_delta_list_free(list);
}

void test_loc_delta_list_add_two_languages() {
  LocDeltaList *list = ohcount_loc_delta_list_new();
  LocDelta *c = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  LocDelta *java = ohcount_loc_delta_new("java", 100, 1000, 200, 2000, 300,
                                         3000);
  ohcount_loc_delta_list_add_loc_delta(list, c);
  ohcount_loc_delta_list_add_loc_delta(list, java);
  assert(ohcount_loc_delta_is_equal(
         ohcount_loc_delta_list_get_loc_delta(list, "c"), c));
  assert(ohcount_loc_delta_is_equal(
         ohcount_loc_delta_list_get_loc_delta(list, "java"), java));
  assert(strcmp(list->head->delta->language, "c") == 0);
  assert(strcmp(list->head->next->delta->language, "java") == 0);
  assert(ohcount_loc_delta_list_code_added(list) == 101);
  assert(ohcount_loc_delta_list_code_removed(list) == 1010);
  assert(ohcount_loc_delta_list_comments_added(list) == 202);
  assert(ohcount_loc_delta_list_comments_removed(list) == 2020);
  assert(ohcount_loc_delta_list_blanks_added(list) == 303);
  assert(ohcount_loc_delta_list_blanks_removed(list) == 3030);
  ohcount_loc_delta_free(c);
  ohcount_loc_delta_free(java);
  ohcount_loc_delta_list_free(list);
}

void test_loc_delta_list_add_same_language_twice() {
  LocDeltaList *list = ohcount_loc_delta_list_new();
  LocDelta *c1 = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  LocDelta *c2 = ohcount_loc_delta_new("c", 100, 1000, 200, 2000, 300, 3000);
  ohcount_loc_delta_list_add_loc_delta(list, c1);
  ohcount_loc_delta_list_add_loc_delta(list, c2);
  assert(list->head->next == NULL);
  assert(strcmp(list->head->delta->language, "c") == 0);
  assert(ohcount_loc_delta_list_code_added(list) == 101);
  assert(ohcount_loc_delta_list_code_removed(list) == 1010);
  assert(ohcount_loc_delta_list_comments_added(list) == 202);
  assert(ohcount_loc_delta_list_comments_removed(list) == 2020);
  assert(ohcount_loc_delta_list_blanks_added(list) == 303);
  assert(ohcount_loc_delta_list_blanks_removed(list) == 3030);
  ohcount_loc_delta_free(c1);
  ohcount_loc_delta_free(c2);
  ohcount_loc_delta_list_free(list);
}

void test_loc_delta_list_add_two_lists() {
  LocDeltaList *list1 = ohcount_loc_delta_list_new();
  LocDeltaList *list2 = ohcount_loc_delta_list_new();
  LocDelta *c1 = ohcount_loc_delta_new("c", 0, 0, 0, 0, 0, 0);
  LocDelta *c2 = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  ohcount_loc_delta_list_add_loc_delta(list1, c1);
  ohcount_loc_delta_list_add_loc_delta(list2, c2);
  ohcount_loc_delta_list_add_loc_delta_list(list1, list2);
  assert(ohcount_loc_delta_list_code_added(list1) == 1);
  assert(ohcount_loc_delta_list_code_removed(list1) == 10);
  assert(ohcount_loc_delta_list_comments_added(list1) == 2);
  assert(ohcount_loc_delta_list_comments_removed(list1) == 20);
  assert(ohcount_loc_delta_list_blanks_added(list1) == 3);
  assert(ohcount_loc_delta_list_blanks_removed(list1) == 30);
  ohcount_loc_delta_free(c1);
  ohcount_loc_delta_free(c2);
  ohcount_loc_delta_list_free(list1);
  ohcount_loc_delta_list_free(list2);
}

void test_loc_delta_list_net_total() {
  LocDeltaList *list = ohcount_loc_delta_list_new();
  LocDelta *c = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  LocDelta *java = ohcount_loc_delta_new("java", 100, 1000, 200, 2000, 300,
                                         3000);
  ohcount_loc_delta_list_add_loc_delta(list, c);
  ohcount_loc_delta_list_add_loc_delta(list, java);
  assert(ohcount_loc_delta_list_net_code(list) == 1 - 10 + 100 - 1000);
  assert(ohcount_loc_delta_list_net_comments(list) == 2 - 20 + 200 - 2000);
  assert(ohcount_loc_delta_list_net_blanks(list) == 3 - 30 + 300 - 3000);
  assert(ohcount_loc_delta_list_net_total(list) == 6 - 60 + 600 - 6000);
  ohcount_loc_delta_free(c);
  ohcount_loc_delta_free(java);
  ohcount_loc_delta_list_free(list);
}

void test_loc_delta_list_compact() {
  LocDeltaList *list = ohcount_loc_delta_list_new();
  LocDelta *c = ohcount_loc_delta_new("c", 1, 10, 2, 20, 3, 30);
  LocDelta *ruby = ohcount_loc_delta_new("ruby", 1, 1, 0, 0, 0, 0);
  LocDelta *java = ohcount_loc_delta_new("java", 0, 0, 0, 0, 0, 0);
  ohcount_loc_delta_list_add_loc_delta(list, c);
  ohcount_loc_delta_list_add_loc_delta(list, ruby);
  ohcount_loc_delta_list_add_loc_delta(list, java);
  LocDeltaList *compacted = ohcount_loc_delta_list_new_compact(list);
  assert(ohcount_loc_delta_is_equal(ohcount_loc_delta_list_get_loc_delta(compacted, "c"), c));
  assert(ohcount_loc_delta_is_equal(ohcount_loc_delta_list_get_loc_delta(compacted, "ruby"), ruby));
  assert(compacted->head->next->next == NULL);
  ohcount_loc_delta_free(c);
  ohcount_loc_delta_free(ruby);
  ohcount_loc_delta_free(java);
  ohcount_loc_delta_list_free(list);
  ohcount_loc_delta_list_free(compacted);
}

void all_loc_tests() {
  test_loc_default();
  test_loc_initializer();
  test_loc_add();
  test_loc_add_requires_same_language();

  test_loc_list_default();
  test_loc_list_selector();
  test_loc_list_first_add();
  test_loc_list_add_two_languages();
  test_loc_list_add_same_language_twice();
  test_loc_list_add_loc_lists();
  test_loc_list_compact();

  test_loc_delta_default();
  test_loc_delta_initializer();
  test_loc_delta_net_total();
  test_loc_delta_addition();
  test_loc_delta_addition_requires_matching_language();
  test_loc_delta_equals();

  test_loc_delta_list_default();
  test_loc_delta_list_selector();
  test_loc_delta_list_first_add();
  test_loc_delta_list_add_two_languages();
  test_loc_delta_list_add_same_language_twice();
  test_loc_delta_list_add_two_lists();
  test_loc_delta_list_net_total();
  test_loc_delta_list_compact();
}
