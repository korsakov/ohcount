
void test_fsharp_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("fsharp", " //comment"),
    "fsharp", "", "//comment", 0
  );
}

void test_fsharp_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("fsharp", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("fsharp", " (*comment*)"),
    "comment", "(*comment*)"
  );
}

void all_fsharp_tests() {
  test_fsharp_comments();
  test_fsharp_comment_entities();
}
