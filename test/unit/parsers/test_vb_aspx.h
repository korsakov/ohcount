
void test_vb_aspx_comment() {
  test_parser_verify_parse2(
    test_parser_sourcefile("vb_aspx", "<%\n 'comment\n%>"),
    "html", "<%\n%>", "", 0,
    "visualbasic", "", "'comment\n", 0
  );
}

void all_vb_aspx_tests() {
  test_vb_aspx_comment();
}
