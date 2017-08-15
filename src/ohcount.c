// ohcount.c written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <dirent.h>
#include <stdio.h>
#include <string.h>

#include "hash/option_hash.h"
#include "sourcefile.h"
#include "ohcount.h"

void annotate_callback(const char *language, const char *entity, int start,
                       int end, void *userdata) {
  SourceFile *sf = (SourceFile *)userdata;
  int length = end - start;
  char buf[length];
  strncpy(buf, (const char*)sf->contents + start, length); // field exists
  buf[length] = '\0';
  printf("%s\t%s\t%s", language, entity, buf);
}

void annotate(SourceFileList *list) {
  SourceFileList *iter = list->head;
  while (iter) {
    ohcount_sourcefile_parse_with_callback(iter->sf, annotate_callback,
                                           iter->sf);
    iter = iter->next;
  }
}

void detect(SourceFileList *list) {
  SourceFileList *iter = list->head;
  while (iter) {
    printf("%s\t%s\n", ohcount_sourcefile_get_language(iter->sf),
           iter->sf->filepath);
    iter = iter->next;
  }
}

void licenses(SourceFileList *list) {
  SourceFileList *iter = list->head;
  while (iter) {
    LicenseList *liter = ohcount_sourcefile_get_license_list(iter->sf)->head;
    while (liter) {
      printf("%s%s ", liter->lic->name, (liter->next != NULL) ? "," : "");
      printf("%s\n", iter->sf->filename);
      liter = liter->next;
    }
    iter = iter->next;
  }
}

void raw_entities_callback(const char *language, const char *entity, int start,
                           int end, void *userdata) {
  printf("%s\t%s\t%i\t%i\n", language, entity, start, end);
}

void raw_entities(SourceFileList *list) {
  SourceFileList *iter = list->head;
  while (iter) {
    ohcount_sourcefile_parse_entities_with_callback(iter->sf,
                                                    raw_entities_callback,
                                                    NULL);
    iter = iter->next;
  }
}

void help() {
  printf(
    "Usage: ohcount [option] [paths...]\n"
    "\n"
    "Ohloh source code line counter command line tool.\n"
    "   http://www.ohloh.net/\n"
    "\n"
    "[option] can be one of the following:\n"
    "   -a, --annotate\n"
    "   -d, --detect\n"
    "   -h, --help\n"
    "   -i, --individual\n"
    "   -l, --license\n"
    "   -re\n"
    "   -s, --summary\n"
    "\n"
    "-a, --annotate                  Show annotated source code\n"
    "\n"
    "   The contents of all source code files found within the given\n"
    "   paths will be emitted to stdout. Each line will be prefixed with\n"
    "   a tab-delimited language name and semantic categorization (code,\n"
    "   comment, or blank).\n"
    "\n"
    "-d, --detect                    Find source code files\n"
    "\n"
    "   Recursively find all source code files within the given paths.\n"
    "   For each source code file found, the file name will be emitted to\n"
    "   stdout prefixed with a tab-delimited language name.\n"
    "\n"
    "-h, --help                      Display this message\n"
    "\n"
    "-i, --individual                Count lines of code per file\n"
    "\n"
    "   Count lines in all source code files within the given paths, and\n"
    "   emit a report of the lines of code, comments, and blanks in each\n"
    "   language per file.\n"
    "\n"
    "-l, --license\n"
    "\n"
    "   Displays detected licensing information contained in each source\n"
    "   code file.\n"
    "\n"
    "-re\n"
    "\n"
    "   Prints raw entity information to the screen (mainly for debugging).\n"
    "\n"
    "-s, --summary                   Count lines of code (default)\n"
    "\n"
    "   Count lines in all source code files within the given paths, and\n"
    "   emit a report of the total number of lines of code, comments,\n"
    "   and blanks in each language. This is the default action.\n"
    "\n"
    "[paths] can refer to any number of individual files or directories.\n"
    "   Directories will be probed recursively. If no path is given,\n"
    "   the current directory will be used.\n"
  );
}

void sort_loc_list_by_language(LocList *list) {
  LocList *iter = list->head;
  while (iter) {
    LocList *min = iter;
    LocList *iter2 = iter->next;
    while (iter2) {
      if (strcmp(iter2->loc->language, min->loc->language) < 0)
        min = iter2;
      iter2 = iter2->next;
    }
    if (iter != min) {
      Loc *temp = iter->loc;
      iter->loc = min->loc;
      min->loc = temp;
    }
    iter = iter->next;
  }
}

void individual(SourceFileList *list) {
  int count = 0;
  SourceFileList *titer = list->head;
  while (titer) {
    count++;
    titer = titer->next;
  }
  printf(
    "Examining %i file(s)\n"
    "                              Ohloh Line Count                              \n"
    "Language               Code    Comment  Comment %%      Blank      Total  File\n"
    "----------------  ---------  ---------  ---------  ---------  ---------  -----------------------------------------------\n"
    , count);
  SourceFileList *iter = list->head;
  while (iter) {
    LocList *loc_list = ohcount_sourcefile_get_loc_list(iter->sf);
    sort_loc_list_by_language(loc_list);
    LocList *liter = loc_list->head;
    while (liter) {
      printf("%-16s", liter->loc->language);
      printf(" %10d", liter->loc->code);
      printf(" %10d", liter->loc->comments);
      if (liter->loc->comments + liter->loc->code > 0)
        printf(" %9.1f%%",
               (float)liter->loc->comments / (liter->loc->comments +
                 liter->loc->code) * 100);
      else
        printf("           ");
      printf(" %10d", liter->loc->blanks);
      printf(" %10d",
             liter->loc->code + liter->loc->comments + liter->loc->blanks);
      printf("  %s\n", iter->sf->filepath);
      liter = liter->next;
    }
    iter = iter->next;
  }
}

void sort_loc_list_by_code(LocList *list) {
  LocList *iter = list->head;
  while (iter) {
    LocList *max = iter;
    LocList *iter2 = iter->next;
    while (iter2) {
      if (iter2->loc->code > max->loc->code)
        max = iter2;
      iter2 = iter2->next;
    }
    if (iter != max) {
      Loc *temp = iter->loc;
      iter->loc = max->loc;
      max->loc = temp;
    }
    iter = iter->next;
  }
}

void summary(SourceFileList *list) {
  int count = 0;
  SourceFileList *tmpiter = list->head;
  while (tmpiter) {
    count++;
    tmpiter = tmpiter->next;
  }
  printf("Examining %i file(s)\n", count);
  LocList *loc_list = ohcount_sourcefile_list_analyze_languages(list);
  sort_loc_list_by_code(loc_list);
  printf(
    "\n"
    "                          Ohloh Line Count Summary                          \n"
    "\n"
    "Language          Files       Code    Comment  Comment %%      Blank      Total\n"
    "----------------  -----  ---------  ---------  ---------  ---------  ---------\n");
  LocList *iter = loc_list->head;
  while (iter) {
    printf("%-16s", iter->loc->language);
    printf(" %6d", iter->loc->filecount);
    printf(" %10d", iter->loc->code);
    printf(" %10d", iter->loc->comments);
    if (iter->loc->comments + iter->loc->code > 0)
      printf(" %9.1f%%",
             (float)iter->loc->comments / (iter->loc->comments +
               iter->loc->code) * 100);
    else
      printf("       0.0%%");
    printf(" %10d", iter->loc->blanks);
    printf(" %10d\n",
           iter->loc->code + iter->loc->comments + iter->loc->blanks);
    iter = iter->next;
  }
  printf("----------------  -----  ---------  ---------  ---------  ---------  ---------\n");
  int code = ohcount_loc_list_code(loc_list);
  int comments = ohcount_loc_list_comments(loc_list);
  int blanks = ohcount_loc_list_blanks(loc_list);
  printf("%-16s", "Total");
  printf(" %6d", ohcount_loc_list_filecount(loc_list));
  printf(" %10d", code);
  printf(" %10d", comments);
  if (comments + code > 0)
    printf(" %9.1f%%", (float)comments / (comments + code) * 100);
  else
    printf("       0.0%%");
  printf(" %10d", blanks);
  printf(" %10d\n", code + comments + blanks);
  ohcount_loc_list_free(loc_list);
}

int main(int argc, char *argv[]) {
  int command = 0;
  if (argc > 1) {
    struct OhcountOption *opt = ohcount_hash_command_from_flag(argv[1],
                                                               strlen(argv[1]));
    if (opt)
      command = opt->value;
  }
  int i = 1;
  if (command == 0)
    command = COMMAND_SUMMARY;
  else
    i = 2; // parameter is not a file or directory

  SourceFileList *list = ohcount_sourcefile_list_new();
  if (i == argc)
    ohcount_sourcefile_list_add_directory(list, ".");
  for (; i < argc; i++) {
    DIR *dir = opendir(argv[i]);
    if (dir) {
      ohcount_sourcefile_list_add_directory(list, argv[i]);
      closedir(dir);
    } else {
      FILE *f = fopen(argv[i], "rb");
      if (f) {
        ohcount_sourcefile_list_add_file(list, argv[i]);
        fclose(f);
      } else printf("Bad argument: %s\n", argv[i]);
    }
  }
  switch (command) {
  case COMMAND_ANNOTATE:
    annotate(list);
    break;
  case COMMAND_DETECT:
    detect(list);
    break;
  case COMMAND_HELP:
    help();
    break;
  case COMMAND_INDIVIDUAL:
    individual(list);
    break;
  case COMMAND_LICENSES:
    licenses(list);
    break;
  case COMMAND_RAWENTITIES:
    raw_entities(list);
    break;
  case COMMAND_SUMMARY:
    summary(list);
    break;
  }
  ohcount_sourcefile_list_free(list);

  return 0;
}
