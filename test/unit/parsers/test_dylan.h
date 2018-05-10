
void test_dylan_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("dylan", " //comment"),
    "dylan", "", "//comment", 0
  );
}

void test_dylan_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("dylan", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("dylan", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_dylan_tests() {
  test_dylan_comments();
  test_dylan_comment_entities();
}
