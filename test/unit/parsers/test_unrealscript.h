
void test_unrealscript_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("unrealscript", " //comment"),
    "unrealscript", "", "//comment", 0
  );
}

void test_unrealscript_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("unrealscript", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("unrealscript", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_unrealscript_tests() {
  test_unrealscript_comments();
  test_unrealscript_comment_entities();
}
