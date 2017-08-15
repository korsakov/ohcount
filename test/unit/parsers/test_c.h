
void test_c_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("c", " //comment"),
    "c", "", "//comment", 0
  );
}

void test_c_empty_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("c", " //\n"),
    "c", "", "//\n", 0
  );
}

void test_c_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("c", "/*c*/"),
    "c", "", "/*c*/", 0
  );
}

void test_c_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("c", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("c", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_c_tests() {
  test_c_comments();
  test_c_empty_comments();
  test_c_block_comment();
  test_c_comment_entities();
}
