void test_bfpp_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("bfpp", " = comment"),
    "bfpp", "", "= comment", 0
  );
}

void test_bfpp_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("bfpp", " = comment"),
    " comment", "= comment"
  );
}

void all_bfpp_tests() {
  test_bfpp_comment();
  test_bfpp_comment_entities();
}

