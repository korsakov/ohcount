
void test_ada_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("ada", " --comment"),
    "ada", "", "--comment", 0
  );
}

void test_ada_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("ada", " --comment"),
    "comment", "--comment"
  );
}

void all_ada_tests() {
  test_ada_comments();
  test_ada_comment_entities();
}
