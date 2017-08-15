
void test_css_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("css", " /*comment*/"),
    "css", "", "/*comment*/", 0
  );
}

void test_css_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("css", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_css_tests() {
  test_css_comments();
  test_css_comment_entities();
}
