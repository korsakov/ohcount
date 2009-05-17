
void test_ruby_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("ruby", " #comment"),
    "ruby", "", "#comment", 0
  );
}

void test_ruby_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("ruby", " #comment"),
    "comment", "#comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("ruby", "=begin\ncomment\n=end"),
    "comment", "=begin\ncomment\n=end"
  );
}

void all_ruby_tests() {
  test_ruby_comments();
  test_ruby_comment_entities();
}
