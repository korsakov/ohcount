
void test_scilab_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("scilab", " //comment"),
    "scilab", "", "//comment", 0
  );
}

void test_scilab_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("scilab", " //comment"),
    "comment", "//comment"
  );
}

void all_scilab_tests() {
  test_scilab_comments();
  test_scilab_comment_entities();
}
