
void test_rexx_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("rexx", " /*comment*/"),
    "rexx", "", "/*comment*/", 0
  );
}

void test_rexx_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("rexx", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_rexx_tests() {
  test_rexx_comment();
  test_rexx_comment_entities();
}
