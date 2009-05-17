
void test_cs_aspx_comments() {
  test_parser_verify_parse2(
    test_parser_sourcefile("cs_aspx", "<%\n //comment\n%>"),
    "html", "<%\n%>", "", 0,
    "csharp", "", "//comment\n", 0
  );
}

void all_cs_aspx_tests() {
  test_cs_aspx_comments();
}
