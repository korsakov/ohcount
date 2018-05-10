
void test_actionscript_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("actionscript", " //comment"),
    "actionscript", "", "//comment", 0
  );
}

void test_actionscript_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("actionscript", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("actionscript", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_actionscript_tests() {
  test_actionscript_comments();
  test_actionscript_comment_entities();
}
