// all_tests.c written by Mitchell Foral. mitchell<att>caladbolg.net.
// See COPYING for license information.

#include <stdio.h>

#include "detector_test.h"
#include "license_test.h"
#include "loc_test.h"
#include "parser_test.h"
#include "sourcefile_test.h"

void all_tests() {
  printf("Running sourcefile tests\n");
  all_sourcefile_tests();
  printf("Running detector tests\n");
  all_detector_tests();
  printf("Running license tests\n");
  all_license_tests();
  printf("Running parser tests\n");
  all_parser_tests();
  printf("Running loc tests\n");
  all_loc_tests();
}

int main() {
  all_tests();
  printf("ALL TESTS PASSED.\n");
  return 0;
}
