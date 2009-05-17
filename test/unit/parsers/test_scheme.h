
void test_scheme_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("scheme", " ;;; comment"),
    "scheme", "", ";;; comment", 0
  );
}

void test_scheme_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("scheme", " ;comment"),
    "comment", ";comment"
  );
}

void all_scheme_tests() {
  test_scheme_comments();
  test_scheme_comment_entities();
}
