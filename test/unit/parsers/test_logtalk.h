
void test_logtalk_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("logtalk", " %comment"),
    "logtalk", "", "%comment", 0
  );
}

void test_logtalk_empty_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("logtalk", " %\n"),
    "logtalk", "", "%\n", 0
  );
}

void test_logtalk_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("logtalk", " /*d*/"),
    "logtalk", "", "/*d*/", 0
  );
}

void all_logtalk_tests() {
  test_logtalk_comments();
  test_logtalk_empty_comments();
  test_logtalk_block_comment();
}
