
void test_typescript_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("typescript", " //comment"),
    "typescript", "", "//comment", 0
  );
}

void test_typescript_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("typescript", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("typescript", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_typescript_tests() {
  test_typescript_comments();
  test_typescript_comment_entities();
}
