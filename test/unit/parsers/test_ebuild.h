
void test_ebuild_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("ebuild", " #comment"),
    "comment", "#comment"
  );
}

void all_ebuild_tests() {
  test_ebuild_comment_entities();
}
