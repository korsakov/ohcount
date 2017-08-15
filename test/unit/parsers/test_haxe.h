
void test_haxe_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("haxe", " //comment"),
    "haxe", "", "//comment", 0
  );
}

void test_haxe_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("haxe", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("haxe", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_haxe_tests() {
  test_haxe_comments();
  test_haxe_comment_entities();
}
