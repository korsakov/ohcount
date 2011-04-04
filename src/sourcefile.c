// sourcefile.c written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "detector.h"
#include "diff.h"
#include "languages.h"
#include "licenses.h"
#include "parser.h"
#include "log.h"

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
  sourcefile->ext = (*(p - 1) == '.') ? p : sourcefile->filepath + length;

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
    char *path = sourcefile->filepath;
    if (sourcefile->diskpath)
      path = sourcefile->diskpath;
    FILE *f = fopen(path, "rb");
    if (f) {
      fseek(f, 0, SEEK_END);
      int size = ftell(f);
      rewind(f);
      sourcefile->contents = malloc(size + 1);
      if (fread(sourcefile->contents, size, 1, f) != 1) {
        free(sourcefile->contents);
        sourcefile->contents = NULL;
        sourcefile->size = 0;
      } else {
        sourcefile->size = size;
        sourcefile->contents[size] = '\0';
      }
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
  struct LanguageMap *rl =
    ohcount_hash_language_from_name(language, strlen(language));
  if (rl) {
    sourcefile->language = rl->name;
    sourcefile->language_detected = 1;
  }
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
      if (strcmp(iter->pl->name, language) == 0)
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

    // Since the SourceFile contents are not 'free'd until the SourceFile itself
    // is, continually parsing SourceFiles in a SourceFileList will cause an
    // undesirable build-up of memory until the SourceFileList is 'free'd.
    // While it is expensive to re-read the contents from the disk, it is
    // unlikely they will need to be accessed again after parsing.
    free(sourcefile->contents); // field is guaranteed to exist
    sourcefile->contents = NULL;
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
      Loc *loc = ohcount_loc_new(iter->pl->name, iter->pl->code_count,
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
	log_it("Starting ohcount_sourcefile_diff:");
	log_it(from->filename);
	log_it(" vs ");
	log_it(to->filename);
	log_it("\n");
  LocDeltaList *list = ohcount_loc_delta_list_new();

  ParsedLanguageList *iter;
  iter = ohcount_sourcefile_get_parsed_language_list(from)->head;
  while (iter) {
    LocDelta *delta = ohcount_sourcefile_calc_loc_delta(from,
                                                        iter->pl->name,
                                                        to);
    ohcount_loc_delta_list_add_loc_delta(list, delta);
    ohcount_loc_delta_free(delta);
    iter = iter->next;
  }
  iter = ohcount_sourcefile_get_parsed_language_list(to)->head;
  while (iter) {
    if (!ohcount_loc_delta_list_get_loc_delta(list, iter->pl->name)) {
      LocDelta *delta = ohcount_sourcefile_calc_loc_delta(from,
                                                          iter->pl->name,
                                                          to);
      ohcount_loc_delta_list_add_loc_delta(list, delta);
      ohcount_loc_delta_free(delta);
    }
    iter = iter->next;
  }

  return list;
}

LocDelta *ohcount_sourcefile_calc_loc_delta(SourceFile *from_file,
                                            const char *language,
                                            SourceFile *to_file) {
  LocDelta *delta = ohcount_loc_delta_new(language, 0, 0, 0, 0, 0, 0);
	ParsedLanguage * const blank = ohcount_parsed_language_new(language, 0);
	ParsedLanguage *from = blank, *to = blank;

  ParsedLanguageList *iter;
	for (iter = ohcount_sourcefile_get_parsed_language_list(from_file)->head;
			 iter;
			 iter = iter->next) {
		if (strcmp(language, iter->pl->name) == 0) {
			from = iter->pl;
			break;
		}
	}

	for (iter = ohcount_sourcefile_get_parsed_language_list(to_file)->head;
			 iter;
			 iter = iter->next) {
		if (strcmp(language, iter->pl->name) == 0) {
			to = iter->pl;
			break;
		}
	}

  ohcount_calc_diff(from->code, to->code, &delta->code_added,
                    &delta->code_removed);
  ohcount_calc_diff(from->comments, to->comments, &delta->comments_added,
                    &delta->comments_removed);
  if (from->blanks_count > to->blanks_count)
    delta->blanks_removed = from->blanks_count - to->blanks_count;
  else
    delta->blanks_added = to->blanks_count - from->blanks_count;

  return delta;
}

/* NOTE! Does not free sourcefile->filenames.
 * Calling code is responsible for alloc+free of filenames.
 */
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
      struct stat st;
      int length = strlen(file->d_name);
      strncpy(f_p, (const char *)file->d_name, length);
      *(f_p + length) = '\0';

      lstat(filepath, &st);
      if(S_ISLNK(st.st_mode))
        continue;

      if (S_ISDIR(st.st_mode) && *file->d_name != '.') // no hidden dirs
        ohcount_sourcefile_list_add_directory(list, filepath);
      else if (S_ISREG(st.st_mode))
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
