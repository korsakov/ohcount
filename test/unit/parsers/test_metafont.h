
void test_metafont_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("metafont", " % comment"),
    "metafont", "", "% comment", 0
  );
}

void test_metafont_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("metafont", " %comment"),
    "comment", "%comment"
  );
}

void all_metafont_tests() {
  test_metafont_comments();
  test_metafont_comment_entities();
}
