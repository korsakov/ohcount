/* renamed from lisp unit tests...
 * lots more possible here.
 */

void test_racket_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("racket", " ;;; comment"),
    "racket", "", ";;; comment", 0
  );
}

void test_racket_doc_string() {
  test_parser_verify_parse(
    test_parser_sourcefile("racket", " \"\"\" comment \"\"\""),
    "racket", "", "\"\"\" comment \"\"\"", 0
  );
}

void test_racket_doc_string_blank() {
  test_parser_verify_parse(
    test_parser_sourcefile("racket", " \"\"\"\"\"\""),
    "racket", "", "\"\"\"\"\"\"", 0
  );
}

void test_racket_empty_string() {
  test_parser_verify_parse(
    test_parser_sourcefile("racket", "\"\""),
    "racket", "\"\"", "", 0
  );
}

void test_racket_char_string() {
  test_parser_verify_parse(
    test_parser_sourcefile("racket", " \"a\""),
    "racket", "\"a\"", "", 0
  );
}

void test_racket_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("racket", " ;comment"),
    "comment", ";comment"
  );
}

void all_racket_tests() {
  test_racket_comment();
  test_racket_doc_string();
  test_racket_doc_string_blank();
  test_racket_empty_string();
  test_racket_char_string();
  test_racket_comment_entities();
}
