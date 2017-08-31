
void test_crystal_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("crystal", " #comment"),
    "crystal", "", "#comment", 0
  );
}

void test_crystal_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("crystal", " #comment"),
    "comment", "#comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("crystal", "=begin\ncomment\n=end"),
    "comment", "=begin\ncomment\n=end"
  );
}

void all_crystal_tests() {
  test_crystal_comments();
  test_crystal_comment_entities();
}
