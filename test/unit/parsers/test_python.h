
void test_python_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("python", " #comment"),
    "python", "", "#comment", 0
  );
}

void test_python_doc_string() {
  test_parser_verify_parse(
    test_parser_sourcefile("python", "  '''\n  doc comment\n  '''"),
    "python", "", "'''\ndoc comment\n'''", 0
  );
}

void test_python_strings() {
  test_parser_verify_parse(
    test_parser_sourcefile("python", "\"abc#not a 'comment\""),
    "python", "\"abc#not a 'comment\"", "", 0
  );
}

void test_python_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("python", " #comment"),
    "comment", "#comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("python", " \"\"\"comment\"\"\""),
    "comment", "\"\"\"comment\"\"\""
  );
}

void all_python_tests() {
  test_python_comment();
  test_python_doc_string();
  test_python_strings();
  test_python_comment_entities();
}
