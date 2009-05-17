
void test_shell_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("shell", " #comment"),
    "shell", "", "#comment", 0
  );
}

void test_shell_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("shell", " #comment"),
    "comment", "#comment"
  );
}

void all_shell_tests() {
  test_shell_comments();
  test_shell_comment_entities();
}
