
void test_r_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("r", " #comment"),
    "r", "", "#comment", 0
  );
}

void test_r_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("r", " #comment"),
    "comment", "#comment"
  );
}

void all_r_tests() {
  test_r_comments();
  test_r_comment_entities();
}
