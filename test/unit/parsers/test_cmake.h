
void test_cmake_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("cmake", " #comment"),
    "cmake", "", "#comment", 0
  );
}

void test_cmake_empty_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("cmake", " #\n"),
    "cmake", "", "#\n", 0
  );
}

void test_cmake_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("cmake", " #comment"),
    "comment", "#comment"
  );
}

void all_cmake_tests() {
  test_cmake_comments();
  test_cmake_empty_comments();
  test_cmake_comment_entities();
}
