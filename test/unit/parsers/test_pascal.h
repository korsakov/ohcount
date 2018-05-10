
void test_pascal_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("pascal", " //comment"),
    "pascal", "", "//comment", 0
  );
}

void test_pascal_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("pascal", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("pascal", " (*comment*)"),
    "comment", "(*comment*)"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("pascal", " {comment}"),
    "comment", "{comment}"
  );
}

void all_pascal_tests() {
  test_pascal_comments();
  test_pascal_comment_entities();
}
