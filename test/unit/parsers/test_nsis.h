
void test_nsis_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("nsis", " ;comment"),
    "nsis", "", ";comment", 0
  );
  test_parser_verify_parse(
    test_parser_sourcefile("nsis", " #comment"),
    "nsis", "", "#comment", 0
  );
  test_parser_verify_parse(
    test_parser_sourcefile("nsis", " /*comment*/"),
    "nsis", "", "/*comment*/", 0
  );
}

void test_nsis_strings() {
  test_parser_verify_parse(
    test_parser_sourcefile("nsis", "\"abc;not a 'comment\""),
    "nsis", "\"abc;not a 'comment\"", "", 0
  );
  test_parser_verify_parse(
    test_parser_sourcefile("nsis", "'abc;not a \"comment'"),
    "nsis", "'abc;not a \"comment'", "", 0
  );
  test_parser_verify_parse(
    test_parser_sourcefile("nsis", "`abc;not a 'comment`"),
    "nsis", "`abc;not a 'comment`", "", 0
  );
}

void test_nsis_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("nsis", " ;comment"),
    "comment", ";comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("nsis", " #comment"),
    "comment", "#comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("nsis", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_nsis_tests() {
  test_nsis_comments();
  test_nsis_strings();
  test_nsis_comment_entities();
}
