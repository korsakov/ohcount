// sourcefile.c written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "detector.h"
#include "diff.h"
#include "licenses.h"
#include "parser.h"

// SourceFile

SourceFile *ohcount_sourcefile_new(const char *filepath) {
  SourceFile *sourcefile = malloc(sizeof(SourceFile));

  int length = strlen(filepath);
  sourcefile->filepath = malloc(length + 1);
  strncpy(sourcefile->filepath, filepath, length);
  char *p = sourcefile->filepath + length;
  *p = '\0';

  while (p > sourcefile->filepath && *(p - 1) != '.' &&
         *(p - 1) != '/' && *(p - 1) != '\\') p--;
  sourcefile->ext = p;

  while (p > sourcefile->filepath &&
         *(p - 1) != '/' && *(p - 1) != '\\') p--;
  sourcefile->filename = p;

  sourcefile->dirpath = (p - 1) - sourcefile->filepath;
  if (sourcefile->dirpath < 0) sourcefile->dirpath = 0;

  sourcefile->diskpath = NULL;

  sourcefile->contents = NULL;
  sourcefile->size = -1;

  sourcefile->language = NULL;
  sourcefile->language_detected = 0;

  sourcefile->parsed_language_list = NULL;

  sourcefile->license_list = NULL;

  sourcefile->loc_list = NULL;

  sourcefile->filenames = NULL;

  return sourcefile;
}

void ohcount_sourcefile_set_diskpath(SourceFile *sourcefile,
                                     const char *diskpath) {
  if (sourcefile->diskpath)
    free(sourcefile->diskpath);
  int size = strlen(diskpath);
  sourcefile->diskpath = malloc(size + 1);
  strncpy(sourcefile->diskpath, diskpath, size);
  sourcefile->diskpath[size] = '\0';
}

void ohcount_sourcefile_set_contents(SourceFile *sourcefile,
                                     const char *contents) {
  if (sourcefile->contents)
    free(sourcefile->contents);
  int size = strlen(contents);
  sourcefile->contents = malloc(size + 1);
  strncpy(sourcefile->contents, contents, size);
  sourcefile->contents[size] = '\0';
  sourcefile->size = size;
}

char *ohcount_sourcefile_get_contents(SourceFile *sourcefile) {
  if (sourcefile->contents == NULL) {
    FILE *f = fopen(sourcefile->filepath, "r");
    if (f) {
      fseek(f, 0, SEEK_END);
      int size = ftell(f);
      rewind(f);
      sourcefile->contents = malloc(size + 1);
      fread(sourcefile->contents, 1, size, f);
      sourcefile->contents[size] = '\0';
      sourcefile->size = size;
      fclose(f);
    } else {
      sourcefile->contents = NULL;
      sourcefile->size = 0;
    }
  }
  return sourcefile->contents;
}

int ohcount_sourcefile_get_contents_size(SourceFile *sourcefile) {
  if (sourcefile->size < 0)
    ohcount_sourcefile_get_contents(sourcefile);
  return sourcefile->size;
}

void ohcount_sourcefile_set_language(SourceFile *sourcefile,
                                     const char *language) {
  sourcefile->language = language;
  sourcefile->language_detected = 1;
}

const char *ohcount_sourcefile_get_language(SourceFile *sourcefile) {
  if (!sourcefile->language_detected) {
    sourcefile->language = ohcount_detect_language(sourcefile);
    sourcefile->language_detected = 1;
  }
  return sourcefile->language;
}

/**
 * Callback function for populating a SourceFile's parsed_language_list field.
 * This callback is passed to ohcount_parse() for parsing lines of code.
 * @param language The language associated with the incoming line.
 * @param entity The type of line. ("lcode", "lcomment", or "lblank").
 * @param start The start position of the entity relative to the start of the
 *   buffer.
 * @param end The end position of the entity relative to the start of the buffer
 *   (non-inclusive).
 * @param userdata Pointer to the SourceFile being parsed.
 * @see ohcount_sourcefile_parse.
 */
void parser_callback(const char *language, const char *entity, int start,
                     int end, void *userdata) {
  SourceFile *sf = (SourceFile *)userdata;
  char *buffer = sf->contents; // field is guaranteed to exist
  int buffer_size = sf->size; // field is guaranteed to exist
  char *p = buffer + start, *pe = buffer + end;

  ParsedLanguageList *list = sf->parsed_language_list;
  ParsedLanguage *lang;
  if (list->head == NULL) {
    // Empty list.
    list->head = list;
    list->tail = list;
    list->pl = ohcount_parsed_language_new(language, buffer_size);
    list->next = NULL;
    lang = list->pl;
  } else {
    // Has this language been detected before?
    ParsedLanguageList *iter = list->head;
    while (iter) {
      if (strcmp(iter->pl->language, language) == 0)
        break; // yes it has
      iter = iter->next;
    }
    if (iter == NULL) {
      // This language has not been detected before. Create a new entry and add
      // it to the list.
      iter = ohcount_parsed_language_list_new();
      iter->pl = ohcount_parsed_language_new(language, buffer_size);
      list->tail->next = iter;
      list->tail = iter;
    }
    lang = iter->pl;
  }

  if (strcmp(entity, "lcode") == 0) {
    while (*p == ' ' || *p == '\t') p++;
    ohcount_parsed_language_add_code(lang, p, pe - p);
  } else if (strcmp(entity, "lcomment") == 0) {
    while (*p == ' ' || *p == '\t') p++;
    ohcount_parsed_language_add_comment(lang, p, pe - p);
  } else if (strcmp(entity, "lblank") == 0) {
    lang->blanks_count++;
  }
}

void ohcount_sourcefile_parse(SourceFile *sourcefile) {
  if (sourcefile->parsed_language_list == NULL) {
    sourcefile->parsed_language_list = ohcount_parsed_language_list_new();
    ohcount_parse(sourcefile, 1, parser_callback, sourcefile);
  }
}

ParsedLanguageList *ohcount_sourcefile_get_parsed_language_list(SourceFile
                                                                *sourcefile) {
  ohcount_sourcefile_parse(sourcefile);
  return sourcefile->parsed_language_list;
}

void ohcount_sourcefile_parse_with_callback(SourceFile *sourcefile,
                                            void (*callback)(const char *,
                                                             const char *, int,
                                                             int, void *),
                                            void *userdata) {
  ohcount_parse(sourcefile, 1, callback, userdata);
}

void ohcount_sourcefile_parse_entities_with_callback(SourceFile *sourcefile,
                                                     void (*callback)
                                                       (const char *,
                                                        const char *, int,
                                                        int, void *),
                                                     void *userdata) {
  ohcount_parse(sourcefile, 0, callback, userdata);
}

LicenseList *ohcount_sourcefile_get_license_list(SourceFile *sourcefile) {
  if (sourcefile->license_list == NULL)
    sourcefile->license_list = ohcount_detect_license(sourcefile);
  return sourcefile->license_list;
}

LocList *ohcount_sourcefile_get_loc_list(SourceFile *sourcefile) {
  if (sourcefile->loc_list == NULL) {
    LocList *list = ohcount_loc_list_new();
    ohcount_sourcefile_parse(sourcefile);
    ParsedLanguageList *iter;
    iter = ohcount_sourcefile_get_parsed_language_list(sourcefile)->head;
    while (iter) {
      Loc *loc = ohcount_loc_new(iter->pl->language, iter->pl->code_count,
                                 iter->pl->comments_count,
                                 iter->pl->blanks_count, 1);
      ohcount_loc_list_add_loc(list, loc);
      ohcount_loc_free(loc);
      iter = iter->next;
    }
    sourcefile->loc_list = list;
  }
  return sourcefile->loc_list;
}

LocDeltaList *ohcount_sourcefile_diff(SourceFile *from, SourceFile *to) {
  LocDeltaList *list = ohcount_loc_delta_list_new();

  ParsedLanguageList *iter;
  iter = ohcount_sourcefile_get_parsed_language_list(from)->head;
  while (iter) {
    LocDelta *delta = ohcount_sourcefile_calc_loc_delta(from,
                                                        iter->pl->language,
                                                        to);
    ohcount_loc_delta_list_add_loc_delta(list, delta);
    ohcount_loc_delta_free(delta);
    iter = iter->next;
  }
  iter = ohcount_sourcefile_get_parsed_language_list(to)->head;
  while (iter) {
    if (!ohcount_loc_delta_list_get_loc_delta(list, iter->pl->language)) {
      LocDelta *delta = ohcount_sourcefile_calc_loc_delta(from,
                                                          iter->pl->language,
                                                          to);
      ohcount_loc_delta_list_add_loc_delta(list, delta);
      ohcount_loc_delta_free(delta);
    }
    iter = iter->next;
  }

  return list;
}

LocDelta *ohcount_sourcefile_calc_loc_delta(SourceFile *from,
                                            const char *language,
                                            SourceFile *to) {
  LocDelta *delta = ohcount_loc_delta_new(language, 0, 0, 0, 0, 0, 0);

  char *from_code = "", *to_code = "";
  char *from_comments = "", *to_comments = "";
  int from_blanks_count = 0, to_blanks_count = 0;

  ParsedLanguageList *iter;
  iter = ohcount_sourcefile_get_parsed_language_list(from)->head;
  while (iter) {
    if (strcmp(language, iter->pl->language) == 0) {
      from_code = iter->pl->code;
      from_comments = iter->pl->comments;
      from_blanks_count = iter->pl->blanks_count;
      break;
    }
    iter = iter->next;
  }
  iter = ohcount_sourcefile_get_parsed_language_list(to)->head;
  while (iter) {
    if (strcmp(language, iter->pl->language) == 0) {
      to_code = iter->pl->code;
      to_comments = iter->pl->comments;
      to_blanks_count = iter->pl->blanks_count;
      break;
    }
    iter = iter->next;
  }

  ohcount_calc_diff(from_code, to_code, &delta->code_added,
                    &delta->code_removed);
  ohcount_calc_diff(from_comments, to_comments, &delta->comments_added,
                    &delta->comments_removed);
  if (from_blanks_count > to_blanks_count)
    delta->blanks_removed = from_blanks_count - to_blanks_count;
  else
    delta->blanks_added = to_blanks_count - from_blanks_count;

  return delta;
}

void ohcount_sourcefile_set_filenames(SourceFile *sourcefile,
                                      char **filenames) {
  if (sourcefile->filenames) {
    int i = 0;
    while (sourcefile->filenames[i])
      free(sourcefile->filenames[i++]);
    free(sourcefile->filenames);
  }

  if (filenames != NULL) {
    int length = 0;
    while (filenames[length] != NULL) length++;
    char **fnames = calloc(length + 1, sizeof(char *));

    int i;
    for (i = 0; i < length; i++) {
      int len = strlen(filenames[i]);
      char *fname = malloc(len + 1);
      strncpy(fname, filenames[i], len);
      fname[len] = '\0';
      fnames[i] = fname;
    }
    sourcefile->filenames = fnames;
  } else sourcefile->filenames = NULL;
}

char **ohcount_sourcefile_get_filenames(SourceFile *sourcefile) {
  if (sourcefile->filenames == NULL) {
    char dirpath[FILENAME_MAX];
    strncpy(dirpath, sourcefile->filepath, sourcefile->dirpath);
    dirpath[sourcefile->dirpath] = '\0';
    struct dirent *file;
    DIR *d = opendir((const char *)dirpath);
    if (d) {
      int length = 0;
      while ((file = readdir(d))) length++;
      closedir(d);

      char **filenames = calloc(length + 1, sizeof(char *));
      int i = 0;
      d = opendir((const char *)dirpath);
      while ((file = readdir(d))) {
        int len = strlen(file->d_name);
        char *filename = malloc(len + 1);
        strncpy(filename, file->d_name, len);
        filename[len] = '\0';
        filenames[i++] = filename;
      }
      closedir(d);
      sourcefile->filenames = filenames;
    }
  }
  return sourcefile->filenames;
}

void ohcount_sourcefile_free(SourceFile *sourcefile) {
  free(sourcefile->filepath);
  if (sourcefile->diskpath)
    free(sourcefile->diskpath);
  if (sourcefile->contents)
    free(sourcefile->contents);
  if (sourcefile->parsed_language_list)
    ohcount_parsed_language_list_free(sourcefile->parsed_language_list);
  if (sourcefile->license_list)
    ohcount_license_list_free(sourcefile->license_list);
  if (sourcefile->loc_list)
    ohcount_loc_list_free(sourcefile->loc_list);
  if (sourcefile->filenames) {
    int i = 0;
    while (sourcefile->filenames[i])
      free(sourcefile->filenames[i++]);
    free(sourcefile->filenames);
  }
  free(sourcefile);
}

// SourceFileList

SourceFileList *ohcount_sourcefile_list_new() {
  SourceFileList *list = malloc(sizeof(SourceFileList));
  list->sf = NULL;
  list->next = NULL;
  list->head = NULL;
  list->tail = NULL;
  return list;
}

void ohcount_sourcefile_list_add_file(SourceFileList *list,
                                      const char *filepath) {
  if (list->head == NULL) { // empty list
    list->head = list;
    list->tail = list;
    list->head->sf = ohcount_sourcefile_new(filepath);
    list->head->next = NULL;
  } else {
    SourceFileList *item = ohcount_sourcefile_list_new();
    item->sf = ohcount_sourcefile_new(filepath);
    list->tail->next = item;
    list->tail = item;
  }
}

void ohcount_sourcefile_list_add_directory(SourceFileList *list,
                                           const char *directory) {
  char filepath[FILENAME_MAX];
  strncpy(filepath, directory, strlen(directory));
  *(filepath + strlen(directory)) = '/';
  char *f_p = filepath + strlen(directory) + 1;

  struct dirent *file;
  DIR *d = opendir(directory);
  if (d) {
    while ((file = readdir(d))) {
      int length = strlen(file->d_name);
      strncpy(f_p, (const char *)file->d_name, length);
      *(f_p + length) = '\0';

      if (file->d_type == DT_DIR && *file->d_name != '.') // no hidden dirs
        ohcount_sourcefile_list_add_directory(list, filepath);
      else if (file->d_type == DT_REG)
        ohcount_sourcefile_list_add_file(list, filepath);
    }
    closedir(d);
  }
}

LocList *ohcount_sourcefile_list_analyze_languages(SourceFileList *list) {
  LocList *loc_list = ohcount_loc_list_new();
  SourceFileList *iter = list->head;
  while (iter) {
    ohcount_loc_list_add_loc_list(loc_list,
                                  ohcount_sourcefile_get_loc_list(iter->sf));
    iter = iter->next;
  }
  return loc_list;
}

void ohcount_sourcefile_list_free(SourceFileList *list) {
  if (list->head) {
    SourceFileList *iter = list->head;
    while (iter) {
      SourceFileList *next = iter->next;
      ohcount_sourcefile_free(iter->sf);
      free(iter);
      iter = next;
    }
  } else free(list);
}
