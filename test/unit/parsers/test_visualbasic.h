
void test_visualbasic_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("visualbasic", " 'comment"),
    "visualbasic", "", "'comment", 0
  );
}

void test_visualbasic_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("visualbasic", " 'comment"),
    "comment", "'comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("visualbasic", " Rem comment"),
    "comment", "Rem comment"
  );
}

void all_visualbasic_tests() {
  test_visualbasic_comments();
  test_visualbasic_comment_entities();
}
