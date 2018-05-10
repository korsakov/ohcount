
void test_awk_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("awk", " #comment"),
    "awk", "", "#comment", 0
  );
}

void test_awk_double_slash() {
  test_parser_verify_parse(
    test_parser_sourcefile("awk", "\"\\\\\"\n#comment"),
    "awk", "\"\\\\\"\n", "#comment", 0
  );
  // awk doesn't recognize backslash escaping of double quote...weird
}

void test_awk_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("awk", " #comment"),
    "comment", "#comment"
  );
}

void all_awk_tests() {
  test_awk_comments();
  test_awk_double_slash();
  test_awk_comment_entities();
}
