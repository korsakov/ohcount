
void test_jam_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("jam", " #comment"),
    "jam", "", "#comment", 0
  );
}

void test_jam_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("jam", " #comment"),
    "comment", "#comment"
  );
}

void all_jam_tests() {
  test_jam_comments();
  test_jam_comment_entities();
}
