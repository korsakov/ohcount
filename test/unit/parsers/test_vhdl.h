
void test_vhdl_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("vhdl", " -- comment"),
    "vhdl", "", "-- comment", 0
  );
}

void test_vhdl_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("vhdl", " --comment"),
    "comment", "--comment"
  );
}

void all_vhdl_tests() {
  test_vhdl_comments();
  test_vhdl_comment_entities();
}
