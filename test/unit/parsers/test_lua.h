
void test_lua_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("lua", " -- comment"),
    "lua", "", "-- comment", 0
  );
}

void test_lua_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("lua", " --comment"),
    "comment", "--comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("lua", " --[[comment\ncomment]]"),
    "comment", "--[[comment\ncomment]]"
  );
}

void all_lua_tests() {
  test_lua_comments();
  test_lua_comment_entities();
}
