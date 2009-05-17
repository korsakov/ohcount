// license_test.h written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <assert.h>
#include <dirent.h>
#include <stdio.h>
#include <string.h>

#include "../../src/licenses.h"

void all_license_tests() {
  const char *src_licenses = "../src_licenses/";
  char src[FILENAME_MAX];
  strncpy(src, src_licenses, strlen(src_licenses));
  char *s_p = src + strlen(src_licenses);

  const char *expected_licenses = "../expected_licenses/";
  char expected[FILENAME_MAX];
  strncpy(expected, expected_licenses, strlen(expected_licenses));
  char *e_p = expected + strlen(expected_licenses);

  struct dirent *file;
  DIR *d = opendir(src_licenses);
  if (d) {
    while ((file = readdir(d))) {
      if (strcmp((const char *)file->d_name, ".") != 0 &&
          strcmp((const char *)file->d_name, "..") != 0) {
        char *p;
        int length;

        length = strlen(file->d_name);
        strncpy(s_p, (const char *)file->d_name, length);
        *(s_p + length) = '\0';

        p = file->d_name + length;
        while (*p != '.' && p > file->d_name) p--;
        length = p - file->d_name;
        strncpy(e_p, (const char *)file->d_name, length);
        *(e_p + length) = '\0';
        FILE *f = fopen((const char *)expected, "r");
        if (f) {
          SourceFile *sf = ohcount_sourcefile_new((const char *)src);
          LicenseList *iter = ohcount_sourcefile_get_license_list(sf)->head;
          char line[40]; // max license name size
          while (fgets(line, sizeof(line), f)) {
            p = strstr(line, "\r");
            if (p == NULL) p = strstr(line, "\n");
            if (p) *p = '\0';
            assert(iter->lic->name);
            assert(strcmp(line, iter->lic->name) == 0);
            iter = iter->next;
          }
          fclose(f);
          ohcount_sourcefile_free(sf);
        }
      }
    }
    closedir(d);
  }
}
