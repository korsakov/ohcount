
void test_bat_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("bat", " REM comment"),
    "bat", "", "REM comment", 0
  );
}

void test_bat_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("bat", " rem comment"),
    "comment", "rem comment"
  );
}

void all_bat_tests() {
  test_bat_comments();
  test_bat_comment_entities();
}
