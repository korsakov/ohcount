void test_idl_pvwave_comments() {
  test_parser_verify_parse(
    test_parser_sourcefile("idl_pvwave", " ;comment"),
    "idl_pvwave", "", ";comment", 0
  );
}

void test_idl_pvwave_comment_entities() {
  test_parser_verify_entity(
    test_parser_sourcefile("idl_pvwave", " ;comment"),
    "comment", ";comment"
  );
  test_parser_verify_entity(
    test_parser_sourcefile("idl_pvwave", " ;comment"),
    "comment", ";comment"
  );
}

void test_idl_pvwave_is_language() {
	const char *language = "idl_pvwave";
	assert(ohcount_hash_language_from_name(language, strlen(language)) != NULL);
}

void all_idl_pvwave_tests() {
	test_idl_pvwave_is_language();
	test_idl_pvwave_comments();
	test_idl_pvwave_comment_entities();
}
