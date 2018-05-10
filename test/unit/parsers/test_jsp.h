
void test_jsp_comment() {
  test_parser_verify_parse2(
    test_parser_sourcefile("jsp", " <% //comment\n%>"),
    "java", "", "<% //comment\n", 0,
    "html", "%>", "", 0
  );
}

void test_jsp_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("jsp", " <!--comment-->"),
    "comment", "<!--comment-->"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("jsp", "<style type='text/css'>\n/*comment*/\n</style>"),
    "comment", "/*comment*/"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("jsp", "<%\n//comment\n%>"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("jsp", "<%\n/*comment*/\n%>"),
    "comment", "/*comment*/"
  );
}

void all_jsp_tests() {
  test_jsp_comment_entities();
}
