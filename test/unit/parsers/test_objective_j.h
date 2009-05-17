
void test_objective_j_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("objective_j", " //comment"),
    "objective_j", "", "//comment", 0
  );
}

void test_objective_j_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("objective_j", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("objective_j", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_objective_j_tests() {
  test_objective_j_comments();
  test_objective_j_comment_entities();
}
