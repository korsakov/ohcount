$! Test file for DCL parser
$ ! Written by Camiel Vanderhoeven
$
$ 
$ SET VERIFY
$ WRITE SYS$SYSTEM
This is some text

$ EXIT
$! This is comment again
$!
$
