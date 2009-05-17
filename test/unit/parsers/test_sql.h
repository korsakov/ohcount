
void test_sql_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("sql", " --comment"),
    "sql", "", "--comment", 0
  );
}

void test_sql_empty_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("sql", " --\n"),
    "sql", "", "--\n", 0
  );
}

void test_sql_block_comment() {
  test_parser_verify_parse(
    test_parser_sourcefile("sql", " {sql}"),
    "sql", "", "{sql}", 0
  );
}

void test_sql_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("sql", " --comment"),
    "comment", "--comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("sql", " #comment"),
    "comment", "#comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("sql", " //comment"),
    "comment", "//comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("sql", " /*comment*/"),
    "comment", "/*comment*/"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("sql", " {comment}"),
    "comment", "{comment}"
  );
}

void all_sql_tests() {
  test_sql_comments();
  test_sql_empty_comments();
  test_sql_block_comment();
  test_sql_comment_entities();
}
