
void test_make_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("make", " #comment"),
    "comment", "#comment"
  );
}

void all_make_tests() {
  test_make_comment_entities();
}
