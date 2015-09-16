
void test_mxml_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("mxml", " <!--comment-->"),
    "comment", "<!--comment-->"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("mxml", "<mx:Style>\n/*comment*/\n</mx:Style>"),
    "comment", "/*comment*/"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("mxml", "<mx:Script>\n//comment\n</mx:Script>"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("mxml", "<mx:Script>\n/*comment*/\n</mx:Script>"),
    "comment", "/*comment*/"
  );
}

void all_mxml_tests() {
  test_mxml_comment_entities();
}
