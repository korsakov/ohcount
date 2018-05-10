
void test_clojure_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("clojure", " ;;; comment"),
    "clojure", "", ";;; comment", 0
  );
}

void test_clojure_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("clojure", " ;comment"),
    "comment", ";comment"
  );
}

void all_clojure_tests() {
  test_clojure_comments();
  test_clojure_comment_entities();
}
