
void test_tcl_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("tcl", " #comment"),
    "tcl", "", "#comment", 0
  );
}

void test_tcl_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("tcl", " #comment"),
    "comment", "#comment"
  );
}

void all_tcl_tests() {
  test_tcl_comments();
  test_tcl_comment_entities();
}
