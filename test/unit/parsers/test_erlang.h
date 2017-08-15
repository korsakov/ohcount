
void test_erlang_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("erlang", " %%comment"),
    "erlang", "", "%%comment", 0
  );
}

void test_erlang_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("erlang", " %comment"),
    "comment", "%comment"
  );
}

void all_erlang_tests() {
  test_erlang_comments();
  test_erlang_comment_entities();
}
