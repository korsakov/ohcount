
void test_autoconf_comment_entities() {
  test_parser_verify_parse(
    test_parser_sourcefile("autoconf", " dnl comment"),
    "autoconf", "", "dnl comment", 0
  );
}

void all_autoconf_tests() {
  test_autoconf_comment_entities();
}
