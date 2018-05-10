
void test_exheres_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("exheres", " #comment"),
    "comment", "#comment"
  );
}

void all_exheres_tests() {
  test_exheres_comment_entities();
}
