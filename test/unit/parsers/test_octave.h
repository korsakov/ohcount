
void test_octave_line_comment_1() {
  test_parser_verify_parse(
    test_parser_sourcefile("octave", " %comment"),
    "octave", "", "%comment", 0
  );
}

void test_octave_syntax_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("octave", " # comment"),
    "octave", "", "# comment", 0
  );
}

void test_octave_false_line_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("octave", " %{block%} code"),
    "octave", "%{block%} code", "", 0
  );
}

void test_octave_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("octave", " %comment"),
    "comment", "%comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("octave", " # comment"),
    "comment", "# comment"
  );
}

void all_octave_tests() {
  test_octave_line_comment_1();
  test_octave_syntax_comment();
  test_octave_false_line_comment();
  test_octave_comment_entities();
}
