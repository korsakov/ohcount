
void test_haskell_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("haskell", " --comment"),
    "haskell", "", "--comment", 0
  );
}

void test_haskell_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("haskell", " --comment"),
    "comment", "--comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("haskell", " {-comment-}"),
    "comment", "{-comment-}"
  );
}

void all_haskell_tests() {
  test_haskell_comments();
  test_haskell_comment_entities();
}
