
void test_assembler_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("assembler", " !comment\n ;comment"),
    "assembler", "", "!comment\n;comment", 0
  );
}

void test_assembler_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("assembler", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("assembler", " ; comment"),
    "comment", "; comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("assembler", " !comment"),
    "comment", "!comment"
  );
}

void all_assembler_tests() {
  test_assembler_comments();
  test_assembler_comment_entities();
}
