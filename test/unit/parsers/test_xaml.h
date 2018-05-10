
void test_xaml_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("xaml", " <!--comment-->"),
    "xaml", "", "<!--comment-->", 0
  );
}

void test_xaml_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("xaml", " <!--comment-->"),
    "comment", "<!--comment-->"
  );
}

void all_xaml_tests() {
  test_xaml_comments();
  test_xaml_comment_entities();
}
