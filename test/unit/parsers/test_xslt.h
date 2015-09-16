
void test_xslt_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("xslt", " <!--comment-->"),
    "xslt", "", "<!--comment-->", 0
  );
}

void test_xslt_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("xslt", " <!--comment-->"),
    "comment", "<!--comment-->"
  );
}

void all_xslt_tests() {
  test_xslt_comments();
  test_xslt_comment_entities();
}
