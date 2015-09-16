factor	comment	! This is a comment
factor	comment	! Factor syntax is very simple, it just contains words separated by spaces
factor	comment	! '!' is a line comment word
factor	comment	! "whatever" is a string word
factor	code	USING: kernel io ; ! This is a vocabulary inclusion word
factor	code	IN: testing
factor	blank	
factor	code	: test-string ( -- )
factor	code	  "this is a string" print ;
factor	blank	
factor	code	: test ( x -- y ) ! Parenthesis define a stack effect declaration
factor	code	  dup swap drop ;
factor	blank	
factor	code	MAIN: test
