
void test_smalltalk_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("smalltalk", " \"comment\\\""),
    "smalltalk", "", "\"comment\\\"", 0
  );
}

void test_smalltalk_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("smalltalk", " \"comment\""),
    "comment", "\"comment\""
  );
}

void all_smalltalk_tests() {
  test_smalltalk_comments();
  test_smalltalk_comment_entities();
}
