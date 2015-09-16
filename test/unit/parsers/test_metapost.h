
void test_metapost_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("metapost", " % comment"),
    "metapost", "", "% comment", 0
  );
}

void test_metapost_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("metapost", " %comment"),
    "comment", "%comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("metapost", "verbatim\n%comment\netex"),
    "comment", "%comment"
  );
}

void all_metapost_tests() {
  test_metapost_comments();
  test_metapost_comment_entities();
}
