
void test_blitzmax_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("blitzmax", "' comment"),
    "blitzmax", "", "' comment", 0
  );
}

void test_blitzmax_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("bat", " ' comment"),
    "comment", "' comment"
  );
}

void all_blitzmax_tests() {
  test_blitzmax_comments();
  test_blitzmax_comment_entities();
}
