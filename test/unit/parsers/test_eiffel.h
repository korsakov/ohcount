
void test_eiffel_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("eiffel", " --comment"),
    "eiffel", "", "--comment", 0
  );
}

void test_eiffel_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("eiffel", " --comment"),
    "comment", "--comment"
  );
}

void all_eiffel_tests() {
  test_eiffel_comments();
  test_eiffel_comment_entities();
}
