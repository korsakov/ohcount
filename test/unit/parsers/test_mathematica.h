
void test_mathematica_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("mathematica", " (*comment*)"),
    "comment", "(*comment*)"
  );
}

void all_mathematica_tests() {
  test_mathematica_comment_entities();
}
