
void test_haml_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("haml", "/ comment"),
    "haml", "", "/ comment", 0
  );
}

void test_haml_element() {
  test_parser_verify_parse(
    test_parser_sourcefile("haml", "  %code"),
    "haml", "%code", "", 0
  );
}

void test_haml_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("haml", " %element"),
    "element", "%element"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("haml", " .class"),
    "element_class", ".class"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("haml", " #id"),
    "element_id", "#id"
  );
}

void all_haml_tests() {
  test_haml_comment();
  test_haml_element();
  test_haml_comment_entities();
}
