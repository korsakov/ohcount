
void test_perl_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("perl", " #comment"),
    "perl", "", "#comment", 0
  );
}

void test_perl_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("perl", " #comment"),
    "comment", "#comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("perl", "=head1\ncomment\n=cut"),
    "comment", "=head1\ncomment\n=cut"
  );
}

void all_perl_tests() {
  test_perl_comments();
  test_perl_comment_entities();
}
