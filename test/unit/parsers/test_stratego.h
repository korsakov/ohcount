
void test_stratego_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("stratego", " // comment"),
    "stratego", "", "// comment", 0
  );
}

void test_stratego_char_string_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("stratego", " 'c'"),
    "string", "'c'"
  );
  // single quote can be used in identifiers
  // weak case
  test_parser_verify_entity(
    test_parser_sourcefile("stratego", " c'"),
    "string", ""
  );
  // strong case
  test_parser_verify_entity(
    test_parser_sourcefile("stratego", " c' = e'"),
    "string", ""
  );
}

void all_stratego_tests() {
  test_stratego_comments();
  test_stratego_char_string_entities();
}
