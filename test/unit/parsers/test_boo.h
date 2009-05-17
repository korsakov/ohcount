
void test_boo_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("boo", " #comment"),
    "boo", "", "#comment", 0
  );
}

void test_boo_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("boo", " /*comment*/"),
    "boo", "", "/*comment*/", 0
  );
}

void test_boo_nested_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("boo", " /* comment\n /* nested */\nstill a comment */"),
    "boo", "", "/* comment\n/* nested */\nstill a comment */", 0
  );
}

void test_boo_doc_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("boo", "\"\"\"\\ndoc comment\n\"\"\""),
    "boo", "", "\"\"\"\\ndoc comment\n\"\"\"", 0
  );
}

void test_boo_strings() {
  test_parser_verify_parse(
    test_parser_sourcefile("boo", "\"abc#not a 'comment\""),
    "boo", "\"abc#not a 'comment\"", "", 0
  );
}

void test_boo_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("boo", " #comment"),
    "comment", "#comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("boo", " //comment"),
    "comment", "//comment"
  );
}

void all_boo_tests() {
  test_boo_comment();
  test_boo_block_comment();
  test_boo_nested_block_comment();
  test_boo_doc_comments();
  test_boo_strings();
  test_boo_comment_entities();
}
