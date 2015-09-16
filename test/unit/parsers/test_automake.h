
void test_automake_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("automake", " #comment"),
    "comment", "#comment"
  );
}

void all_automake_tests() {
  test_automake_comment_entities();
}
