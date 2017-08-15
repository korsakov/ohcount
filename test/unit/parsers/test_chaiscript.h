
void test_chaiscript_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("chaiscript", " //comment"),
    "chaiscript", "", "//comment", 0
  );
}

void test_chaiscript_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("chaiscript", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("chaiscript", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_chaiscript_tests() {
  test_chaiscript_comments();
  test_chaiscript_comment_entities();
}
