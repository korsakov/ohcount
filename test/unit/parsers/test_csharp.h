
void test_csharp_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("csharp", " //comment"),
    "csharp", "", "//comment", 0
  );
}

void test_csharp_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("csharp", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("csharp", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_csharp_tests() {
  test_csharp_comments();
  test_csharp_comment_entities();
}
