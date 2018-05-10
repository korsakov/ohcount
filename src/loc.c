// loc.c written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <stdlib.h>
#include <string.h>

#include "loc.h"

// Loc

Loc *ohcount_loc_new(const char *language, int code, int comments, int blanks,
                     int filecount) {
  Loc *loc = malloc(sizeof(Loc));
  loc->language = language;
  loc->code = code;
  loc->comments = comments;
  loc->blanks = blanks;
  loc->filecount = filecount;
  return loc;
}

int ohcount_loc_total(Loc *loc) {
  return loc->code + loc->comments + loc->blanks;
}

void ohcount_loc_add_loc(Loc *loc, Loc *other) {
  if (strcmp(loc->language, other->language) == 0) {
    loc->code += other->code;
    loc->comments += other->comments;
    loc->blanks += other->blanks;
    loc->filecount += other->filecount;
  }
}

int ohcount_loc_is_equal(Loc *loc, Loc *other) {
  return strcmp(loc->language, other->language) == 0 &&
         loc->code == other->code && loc->comments == other->comments &&
         loc->blanks == other->blanks && loc->filecount == other->filecount;
}

void ohcount_loc_free(Loc *loc) {
  free(loc);
}

// LocList

LocList *ohcount_loc_list_new() {
  LocList *list = malloc(sizeof(LocList));
  list->loc = NULL;
  list->next = NULL;
  list->head = NULL;
  list->tail = NULL;
  return list;
}

void ohcount_loc_list_add_loc(LocList *list, Loc *loc) {
  if (list->head == NULL) { // empty list
    list->head = list;
    list->tail = list;
    list->head->loc = ohcount_loc_new(loc->language, loc->code, loc->comments,
                                      loc->blanks, loc->filecount);
    list->head->next = NULL;
  } else {
    LocList *iter = list->head;
    while (iter) {
      if (iter->loc && strcmp(iter->loc->language, loc->language) == 0) break;
      iter = iter->next;
    }
    if (iter == NULL) { // new language
      LocList *item = ohcount_loc_list_new();
      item->loc = ohcount_loc_new(loc->language, loc->code, loc->comments,
                                  loc->blanks, loc->filecount);
      list->tail->next = item;
      list->tail = item;
    } else ohcount_loc_add_loc(iter->loc, loc); // existing language
  }
}

void ohcount_loc_list_add_loc_list(LocList *list, LocList *other) {
  LocList *iter = other->head;
  while (iter) {
    ohcount_loc_list_add_loc(list, iter->loc);
    iter = iter->next;
  }
}

Loc *ohcount_loc_list_get_loc(LocList *list, const char *language) {
  LocList *iter = list->head;
  while (iter) {
    if (strcmp(iter->loc->language, language) == 0) return iter->loc;
    iter = iter->next;
  }
  return NULL;
}

int ohcount_loc_list_code(LocList *list) {
  int sum = 0;
  LocList *iter = list->head;
  while (iter) {
    sum += iter->loc->code;
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_list_comments(LocList *list) {
  int sum = 0;
  LocList *iter = list->head;
  while (iter) {
    sum += iter->loc->comments;
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_list_blanks(LocList *list) {
  int sum = 0;
  LocList *iter = list->head;
  while (iter) {
    sum += iter->loc->blanks;
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_list_total(LocList *list) {
  int sum = 0;
  LocList *iter = list->head;
  while (iter) {
    sum += ohcount_loc_total(iter->loc);
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_list_filecount(LocList *list) {
  int sum = 0;
  LocList *iter = list->head;
  while (iter) {
    sum += iter->loc->filecount;
    iter = iter->next;
  }
  return sum;
}

LocList *ohcount_loc_list_new_compact(LocList *list) {
  LocList *new_list = ohcount_loc_list_new();
  LocList *iter = list->head;
  while (iter) {
    if (ohcount_loc_total(iter->loc) != 0)
      ohcount_loc_list_add_loc(new_list, iter->loc);
    iter = iter->next;
  }
  return new_list;
}

void ohcount_loc_list_free(LocList *list) {
  if (list->head) {
    LocList *iter = list->head;
    while (iter) {
      LocList *next = iter->next;
      ohcount_loc_free(iter->loc);
      free(iter);
      iter = next;
    }
  } else free(list);
}

// LocDelta

LocDelta *ohcount_loc_delta_new(const char *language, int code_added,
                                int code_removed, int comments_added,
                                int comments_removed, int blanks_added,
                                int blanks_removed) {
  LocDelta *delta = malloc(sizeof(LocDelta));
  delta->language = language;
  delta->code_added = code_added;
  delta->code_removed = code_removed;
  delta->comments_added = comments_added;
  delta->comments_removed = comments_removed;
  delta->blanks_added = blanks_added;
  delta->blanks_removed = blanks_removed;
  return delta;
}

int ohcount_loc_delta_net_code(LocDelta *delta) {
  return delta->code_added - delta->code_removed;
}

int ohcount_loc_delta_net_comments(LocDelta *delta) {
  return delta->comments_added - delta->comments_removed;
}

int ohcount_loc_delta_net_blanks(LocDelta *delta) {
  return delta->blanks_added - delta->blanks_removed;
}

int ohcount_loc_delta_net_total(LocDelta *delta) {
  return ohcount_loc_delta_net_code(delta) +
         ohcount_loc_delta_net_comments(delta) +
         ohcount_loc_delta_net_blanks(delta);
}

void ohcount_loc_delta_add_loc_delta(LocDelta *delta, LocDelta *other) {
  if (strcmp(delta->language, other->language) == 0) {
    delta->code_added += other->code_added;
    delta->code_removed += other->code_removed;
    delta->comments_added += other->comments_added;
    delta->comments_removed += other->comments_removed;
    delta->blanks_added += other->blanks_added;
    delta->blanks_removed += other->blanks_removed;
  }
}

int ohcount_loc_delta_is_changed(LocDelta *delta) {
  return delta->code_added != 0 || delta->code_removed != 0 ||
         delta->comments_added != 0 || delta->comments_removed != 0 ||
         delta->blanks_added != 0 || delta->blanks_removed != 0;
}

int ohcount_loc_delta_is_equal(LocDelta *delta, LocDelta *other) {
  return strcmp(delta->language, other->language) == 0 &&
         delta->code_added == other->code_added &&
         delta->code_removed == other->code_removed &&
         delta->comments_added == other->comments_added &&
         delta->comments_removed == other->comments_removed &&
         delta->blanks_added == other->blanks_added &&
         delta->blanks_removed == other->blanks_removed;
}

void ohcount_loc_delta_free(LocDelta *delta) {
  free(delta);
}

// LocDeltaList

LocDeltaList *ohcount_loc_delta_list_new() {
  LocDeltaList *list = malloc(sizeof(LocDeltaList));
  list->delta = NULL;
  list->next = NULL;
  list->head = NULL;
  list->tail = NULL;
  return list;
}

void ohcount_loc_delta_list_add_loc_delta(LocDeltaList *list, LocDelta *delta) {
  if (list->head == NULL) { // empty list
    list->head = list;
    list->tail = list;
    list->head->delta = ohcount_loc_delta_new(delta->language,
                                              delta->code_added,
                                              delta->code_removed,
                                              delta->comments_added,
                                              delta->comments_removed,
                                              delta->blanks_added,
                                              delta->blanks_removed);
    list->head->next = NULL;
  } else {
    LocDeltaList *iter = list->head;
    while (iter) {
      if (list->delta && strcmp(list->delta->language, delta->language) == 0) break;
      iter = iter->next;
    }
    if (iter == NULL) { // new language
      LocDeltaList *item = ohcount_loc_delta_list_new();
      item->delta = ohcount_loc_delta_new(delta->language,
                                          delta->code_added,
                                          delta->code_removed,
                                          delta->comments_added,
                                          delta->comments_removed,
                                          delta->blanks_added,
                                          delta->blanks_removed);
      list->tail->next = item;
      list->tail = item;
    } else ohcount_loc_delta_add_loc_delta(iter->delta, delta); // existing
  }
}

void ohcount_loc_delta_list_add_loc_delta_list(LocDeltaList *list,
                                               LocDeltaList *loc_delta_list) {
  LocDeltaList *iter = loc_delta_list->head;
  while (iter) {
    ohcount_loc_delta_list_add_loc_delta(list, iter->delta);
    iter = iter->next;
  }
}

LocDelta *ohcount_loc_delta_list_get_loc_delta(LocDeltaList *list,
                                               const char *language) {
  LocDeltaList *iter = list->head;
  while (iter) {
    if (strcmp(iter->delta->language, language) == 0) return iter->delta;
    iter = iter->next;
  }
  return NULL;
}

int ohcount_loc_delta_list_code_added(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += iter->delta->code_added;
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_delta_list_code_removed(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += iter->delta->code_removed;
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_delta_list_comments_added(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += iter->delta->comments_added;
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_delta_list_comments_removed(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += iter->delta->comments_removed;
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_delta_list_blanks_added(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += iter->delta->blanks_added;
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_delta_list_blanks_removed(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += iter->delta->blanks_removed;
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_delta_list_net_code(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += ohcount_loc_delta_net_code(iter->delta);
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_delta_list_net_comments(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += ohcount_loc_delta_net_comments(iter->delta);
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_delta_list_net_blanks(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += ohcount_loc_delta_net_blanks(iter->delta);
    iter = iter->next;
  }
  return sum;
}

int ohcount_loc_delta_list_net_total(LocDeltaList *list) {
  int sum = 0;
  LocDeltaList *iter = list->head;
  while (iter) {
    sum += ohcount_loc_delta_net_total(iter->delta);
    iter = iter->next;
  }
  return sum;
}

LocDeltaList *ohcount_loc_delta_list_new_compact(LocDeltaList *list) {
  LocDeltaList *new_list = ohcount_loc_delta_list_new();
  LocDeltaList *iter = list->head;
  while (iter) {
    if (ohcount_loc_delta_is_changed(iter->delta))
      ohcount_loc_delta_list_add_loc_delta(new_list, iter->delta);
    iter = iter->next;
  }
  return new_list;
}

void ohcount_loc_delta_list_free(LocDeltaList *list) {
  if (list->head) {
    LocDeltaList *iter = list->head;
    while (iter) {
      LocDeltaList *next = iter->next;
      ohcount_loc_delta_free(iter->delta);
      free(iter);
      iter = next;
    }
  } else free(list);
}
