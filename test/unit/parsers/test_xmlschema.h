
void test_xmlschema_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("xmlschema", " <!--comment-->"),
    "xmlschema", "", "<!--comment-->", 0
  );
}

void test_xmlschema_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("xmlschema", " <!--comment-->"),
    "comment", "<!--comment-->"
  );
}

void all_xmlschema_tests() {
  test_xmlschema_comments();
  test_xmlschema_comment_entities();
}
