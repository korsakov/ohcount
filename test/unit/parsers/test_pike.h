
void test_pike_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("pike", " //comment"),
    "pike", "", "//comment", 0
  );
}

void test_pike_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("pike", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("pike", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_pike_tests() {
  test_pike_comments();
  test_pike_comment_entities();
}
