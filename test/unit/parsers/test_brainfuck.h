void test_brainfuck_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("brainfuck", " #comment"),
    "brainfuck", "", "#comment", 0
  );
}

void test_brainfuck_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("brainfuck", " #comment"),
    "#comment", "#comment"
  );
}

void all_brainfuck_tests() {
  test_brainfuck_comment();
  test_brainfuck_comment_entities();
}
