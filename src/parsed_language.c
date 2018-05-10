// parsed_language.c written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <stdlib.h>
#include <string.h>

#include "parsed_language.h"

ParsedLanguage *ohcount_parsed_language_new(const char *name,
                                            int buffer_size) {
  ParsedLanguage *pl = malloc(sizeof(ParsedLanguage));
  pl->name = name;
  pl->buffer_size = buffer_size;
  pl->code = malloc(buffer_size + 5);
  pl->code_p = pl->code;
  *pl->code_p = '\0';
  pl->code_count = 0;
  pl->comments = malloc(buffer_size + 5);
  pl->comments_p = pl->comments;
  *pl->comments_p = '\0';
  pl->comments_count = 0;
  pl->blanks_count = 0;
  return pl;
}

void ohcount_parsed_language_add_code(ParsedLanguage *parsed_language,
                                      char *p, int length) {
  if (parsed_language->code_p + length <
      parsed_language->code + parsed_language->buffer_size + 5) {
    strncpy(parsed_language->code_p, p, length);
    parsed_language->code_p += length;
    *parsed_language->code_p = '\0';
    parsed_language->code_count++;
  }
}

void ohcount_parsed_language_add_comment(ParsedLanguage *parsed_language,
                                         char *p, int length) {
  if (parsed_language->comments_p + length <
      parsed_language->comments + parsed_language->buffer_size + 5) {
    strncpy(parsed_language->comments_p, p, length);
    parsed_language->comments_p += length;
    *parsed_language->comments_p = '\0';
    parsed_language->comments_count++;
  }
}

void ohcount_parsed_language_free(ParsedLanguage *parsed_language) {
  free(parsed_language->code);
  free(parsed_language->comments);
  free(parsed_language);
}

ParsedLanguageList *ohcount_parsed_language_list_new() {
  ParsedLanguageList *list = malloc(sizeof(ParsedLanguageList));
  list->pl = NULL;
  list->next = NULL;
  list->head = NULL;
  list->tail = NULL;
  return list;
}

void ohcount_parsed_language_list_free(ParsedLanguageList *list) {
  if (list->head) {
    ParsedLanguageList *iter = list->head;
    while (iter) {
      ParsedLanguageList *next = iter->next;
      ohcount_parsed_language_free(iter->pl);
      free(iter);
      iter = next;
    }
  } else free(list);
}
