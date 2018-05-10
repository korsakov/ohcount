
void test_matlab_line_comment_1() {
  test_parser_verify_parse(
    test_parser_sourcefile("matlab", " %comment"),
    "matlab", "", "%comment", 0
  );
}

void test_matlab_ancient_syntax_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("matlab", " ... comment"),
    "matlab", "", "... comment", 0
  );
}

void test_matlab_false_line_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("matlab", " %{block%} code"),
    "matlab", "%{block%} code", "", 0
  );
}

void test_matlab_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("matlab", " %comment"),
    "comment", "%comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("matlab", " ... comment"),
    "comment", "... comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("matlab", " %{comment%}"),
    "comment", "%{comment%}"
  );
}

void all_matlab_tests() {
  test_matlab_line_comment_1();
  test_matlab_ancient_syntax_comment();
  test_matlab_false_line_comment();
  test_matlab_comment_entities();
}
