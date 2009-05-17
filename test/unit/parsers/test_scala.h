
void test_scala_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("scala", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("scala", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_scala_tests() {
  test_scala_comment_entities();
}
