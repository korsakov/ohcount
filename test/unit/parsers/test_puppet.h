
void test_puppet_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("puppet", " #comment"),
    "puppet", "", "#comment", 0
  );
}

void test_puppet_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("puppet", " #comment"),
    "comment", "#comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("puppet", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_puppet_tests() {
  test_puppet_comments();
  test_puppet_comment_entities();
}
