
void test_groovy_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("groovy", " //comment"),
    "groovy", "", "//comment", 0
  );
}

void test_groovy_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("groovy", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("groovy", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_groovy_tests() {
  test_groovy_comments();
  test_groovy_comment_entities();
}
