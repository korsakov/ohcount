
void test_rhtml_comment() {
  test_parser_verify_parse2(
    test_parser_sourcefile("rhtml", "<%\n #comment\n%>"),
    "html", "<%\n%>", "", 0,
    "ruby", "", "#comment\n", 0
  );
}

void all_rhtml_tests() {
  test_rhtml_comment();
}
