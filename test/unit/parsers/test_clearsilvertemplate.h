
void test_clearsilver_template_comments() {
  test_parser_verify_parse2(
    test_parser_sourcefile("clearsilver_template", " <?cs\n #comment\n?>"),
    "html", "<?cs\n?>", "", 0,
    "clearsilver", "", "#comment\n", 0
  );
}

void test_clearsilver_template_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("clearsilver_template", " <!--comment-->"),
    "comment", "<!--comment-->"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("clearsilver_template", " <?cs\n#comment\n?>"),
    "comment", "#comment"
  );
}

void all_clearsilver_template_tests() {
  test_clearsilver_template_comments();
  test_clearsilver_template_comment_entities();
}
