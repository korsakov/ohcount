
void test_postscript_comment_entities(){
    test_parser_verify_entity(
        test_parser_sourcefile("postscript", "%comment"),
        "comment", "%comment"
    );
}

void all_postscript_tests(){
    test_postscript_comment_entities();
}
