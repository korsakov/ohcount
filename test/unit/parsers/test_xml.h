
void test_xml_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("xml", " <!--comment-->"),
    "xml", "", "<!--comment-->", 0
  );
}

void test_xml_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("xml", " <!--comment-->"),
    "comment", "<!--comment-->"
  );
}

void all_xml_tests() {
  test_xml_comments();
  test_xml_comment_entities();
}
