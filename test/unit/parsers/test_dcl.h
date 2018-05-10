
void test_dcl_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("dcl", "$!comment"),
    "dcl", "", "$!comment", 0
  );
}

void test_dcl_code() {
  test_parser_verify_parse(
    test_parser_sourcefile("dcl", "$code"),
    "dcl", "$code", "", 0
  );
}

void test_dcl_blank() {
  test_parser_verify_parse(
    test_parser_sourcefile("dcl", "\n"),
    "dcl", "", "", 1
  );
}

void test_dcl_input_line() {
  test_parser_verify_parse(
    test_parser_sourcefile("dcl", "input"),
    "dcl", "input", "", 0
  );
}

void test_dcl_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("dcl", " !comment"),
    "comment", "!comment"
  );
}

void all_dcl_tests() {
  test_dcl_comments();
  test_dcl_code();
  test_dcl_blank();
  test_dcl_input_line();
  test_dcl_comment_entities();
}
