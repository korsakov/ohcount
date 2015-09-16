
void test_golang_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("go", " //comment"),
    "go", "", "//comment", 0
  );
}

void test_golang_empty_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("go", " //\n"),
    "go", "", "//\n", 0
  );
}

void test_golang_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("go", "/*c*/"),
    "go", "", "/*c*/", 0
  );
}

void test_golang_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("go", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("go", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_golang_tests() {
  test_golang_comments();
  test_golang_empty_comments();
  test_golang_block_comment();
  test_golang_comment_entities();
}
