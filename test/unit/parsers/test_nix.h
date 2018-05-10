
void test_nix_line_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("nix", "# comment"),
    "nix", "", "# comment", 0
  );
}

void all_nix_tests() {
  test_nix_line_comments();
}
