
void test_clearsilver_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("clearsilver", " #comment"),
    "clearsilver", "", "#comment", 0
  );
}

void test_clearsilver_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("clearsilver", " #comment"),
    "comment", "#comment"
  );
}

void all_clearsilver_tests() {
  test_clearsilver_comments();
  test_clearsilver_comment_entities();
}
