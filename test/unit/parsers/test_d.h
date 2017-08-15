
void test_dmd_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("dmd", " //comment"),
    "dmd", "", "//comment", 0
  );
}

void test_dmd_empty_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("dmd", " //\n"),
    "dmd", "", "//\n", 0
  );
}

void test_dmd_strings() {
  test_parser_verify_parse(
    test_parser_sourcefile("dmd", "'/*' not a comment '*/'"),
    "dmd", "'/*' not a comment '*/'", "", 0
  );
}

void test_dmd_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("dmd", " /*d*/"),
    "dmd", "", "/*d*/", 0
  );
  test_parser_verify_parse(
    test_parser_sourcefile("dmd", " /+d+/"),
    "dmd", "", "/+d+/", 0
  );
}

void test_dmd_nested_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("dmd", "/+ /*d*/ not_code(); +/"),
    "dmd", "", "/+ /*d*/ not_code(); +/", 0
  );
}

void test_dmd_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("dmd", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("dmd", " /*comment*/"),
    "comment", "/*comment*/"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("dmd", " /+comment+/"),
    "comment", "/+comment+/"
  );
}

void all_dmd_tests() {
  test_dmd_comments();
  test_dmd_empty_comments();
  test_dmd_strings();
  test_dmd_block_comment();
  test_dmd_nested_block_comment();
  test_dmd_comment_entities();
}
