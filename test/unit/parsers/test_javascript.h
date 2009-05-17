
void test_javascript_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("javascript", " //comment"),
    "javascript", "", "//comment", 0
  );
}

void test_javascript_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("javascript", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("javascript", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_javascript_tests() {
  test_javascript_comments();
  test_javascript_comment_entities();
}
