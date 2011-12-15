
void test_qml_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("qml", " //comment"),
    "qml", "", "//comment", 0
  );
}

void test_qml_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("qml", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("qml", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_qml_tests() {
  test_qml_comments();
  test_qml_comment_entities();
}
