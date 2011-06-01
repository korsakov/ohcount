
void test_rebol_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("rebol", "REBOL []\n;comment"),
    "rebol", "REBOL []\n", ";comment", 0
  );
}

void test_rebol_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("rebol", " ;comment"),
    "comment", ";comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("rebol", " \";no comment\""),
    "string", "\";no comment\""
  );
}

void all_rebol_tests() {
  test_rebol_comments();
  test_rebol_comment_entities();
}
