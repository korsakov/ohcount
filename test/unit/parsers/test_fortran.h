
void test_fortran_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("fortranfree", " !comment"),
    "comment", "!comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("fortranfixed", "C comment"),
    "comment", "C comment"
  );
}

void all_fortran_tests() {
  test_fortran_comment_entities();
}
