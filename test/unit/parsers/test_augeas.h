
void test_augeas_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("augeas", " (* comment *)"),
    "augeas", "", "(* comment *)", 0
  );
}

void test_augeas_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("augeas", " (*comment*)"),
    "comment", "(*comment*)"
  );
}

void all_augeas_tests() {
  test_augeas_comments();
  test_augeas_comment_entities();
}
