
void test_livecode_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("livecode", " --comment"),
    "livecode", "", "--comment", 0
  );
}

void test_livecode_empty_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("livecode", " --\n"),
    "livecode", "", "--\n", 0
  );
}

void test_livecode_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("livecode", " /*livecode*/"),
    "livecode", "", "/*livecode*/", 0
  );
}

void test_livecode_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("livecode", " --comment"),
    "comment", "--comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("livecode", " #comment"),
    "comment", "#comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("livecode", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("livecode", " /*comment*/"),
    "comment", "/*comment*/"
  );
}

void all_livecode_tests() {
  test_livecode_comments();
  test_livecode_empty_comments();
  test_livecode_block_comment();
  test_livecode_comment_entities();
}
