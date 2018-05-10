
void test_java_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("java", " //comment"),
    "java", "", "//comment", 0
  );
}

void test_java_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("java", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("java", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_java_tests() {
  test_java_comments();
  test_java_comment_entities();
}
