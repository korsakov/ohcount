
void test_vala_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("vala", " //comment"),
    "vala", "", "//comment", 0
  );
}

void test_vala_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("vala", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("vala", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_vala_tests() {
  test_vala_comments();
  test_vala_comment_entities();
}
