
void test_tex_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("tex", " %comment"),
    "tex", "", "%comment", 0
  );
}

void test_tex_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("tex", " %comment"),
    "comment", "%comment"
  );
}

void all_tex_tests() {
  test_tex_comments();
  test_tex_comment_entities();
}
