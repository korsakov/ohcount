
void test_emacs_lisp_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("emacslisp", " ;;comment"),
    "emacslisp", "", ";;comment", 0
  );
}

void test_emacs_lisp_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("emacslisp", " ;comment"),
    "comment", ";comment"
  );
}

void all_emacs_lisp_tests() {
  test_emacs_lisp_comments();
  test_emacs_lisp_comment_entities();
}
