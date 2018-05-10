
char *test_basic_vb_filenames[] = { "frx1.frx", 0 };

void test_basic_sb_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("structured_basic", " REM comment"),
    "structured_basic", "", "REM comment", 0
  );
}

void test_basic_cb_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("classic_basic", " 100 REM comment"),
    "classic_basic", "", "100 REM comment", 0
  );
}

void test_basic_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("structured_basic", " REM comment"),
    "comment", "REM comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("classic_basic", " 'comment"),
    "comment", "'comment"
  );
}

void all_basic_tests() {
  test_basic_sb_comments();
  test_basic_cb_comments();
  test_basic_comment_entities();
}
