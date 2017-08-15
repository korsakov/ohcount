
void test_ocaml_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("ocaml", " (* comment *)"),
    "ocaml", "", "(* comment *)", 0
  );
}

void test_ocaml_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("ocaml", " (*comment*)"),
    "comment", "(*comment*)"
  );
}

void all_ocaml_tests() {
  test_ocaml_comments();
  test_ocaml_comment_entities();
}
