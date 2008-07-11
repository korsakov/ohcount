! This is a comment
! Factor syntax is very simple, it just contains words separated by spaces
! '!' is a line comment word
! "whatever" is a string word
USING: kernel io ; ! This is a vocabulary inclusion word
IN: testing

: test-string ( -- )
  "this is a string" print ;

: test ( x -- y ) ! Parenthesis define a stack effect declaration
  dup swap drop ;

MAIN: test
