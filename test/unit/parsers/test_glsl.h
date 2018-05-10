
void test_glsl_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("glsl", " //comment"),
    "glsl", "", "//comment", 0
  );
}

void test_glsl_empty_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("glsl", " //\n"),
    "glsl", "", "//\n", 0
  );
}

void test_glsl_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("glsl", "/*glsl*/"),
    "glsl", "", "/*glsl*/", 0
  );
}

void test_glsl_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("glsl", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("glsl", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_glsl_tests() {
  test_glsl_comments();
  test_glsl_empty_comments();
  test_glsl_block_comment();
  test_glsl_comment_entities();
}
