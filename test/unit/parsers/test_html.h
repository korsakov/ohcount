
void test_html_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("html", " <!--comment-->"),
    "comment", "<!--comment-->"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("html", "<style type='text/css'>\n/*comment*/\n</style>"),
    "comment", "/*comment*/"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("html", "<script type='text/javascript'>\n//comment\n</script>"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("html", "<script type='text/javascript'>\n/*comment*/\n</script>"),
    "comment", "/*comment*/"
  );
}

void all_html_tests() {
  test_html_comment_entities();
}
