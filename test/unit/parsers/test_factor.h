
void test_factor_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("factor", " ! comment"),
    "factor", "", "! comment", 0
  );
}

void test_factor_strings() {
  test_parser_verify_parse(
    test_parser_sourcefile("factor", "\"abc!not a 'comment\""),
    "factor", "\"abc!not a 'comment\"", "", 0
  );
}

void all_factor_tests() {
  test_factor_comments();
  test_factor_strings();
}
