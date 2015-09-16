
void test_lisp_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("lisp", " ;;; comment"),
    "lisp", "", ";;; comment", 0
  );
}

void test_lisp_doc_string() {
  test_parser_verify_parse(
    test_parser_sourcefile("lisp", " \"\"\" comment \"\"\""),
    "lisp", "", "\"\"\" comment \"\"\"", 0
  );
}

void test_lisp_doc_string_blank() {
  test_parser_verify_parse(
    test_parser_sourcefile("lisp", " \"\"\"\"\"\""),
    "lisp", "", "\"\"\"\"\"\"", 0
  );
}

void test_lisp_empty_string() {
  test_parser_verify_parse(
    test_parser_sourcefile("lisp", "\"\""),
    "lisp", "\"\"", "", 0
  );
}

void test_lisp_char_string() {
  test_parser_verify_parse(
    test_parser_sourcefile("lisp", " \"a\""),
    "lisp", "\"a\"", "", 0
  );
}

void test_lisp_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("lisp", " ;comment"),
    "comment", ";comment"
  );
}

void all_lisp_tests() {
  test_lisp_comment();
  test_lisp_doc_string();
  test_lisp_doc_string_blank();
  test_lisp_empty_string();
  test_lisp_char_string();
  test_lisp_comment_entities();
}
