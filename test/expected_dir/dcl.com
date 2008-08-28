dcl	comment	$! Test file for DCL parser
dcl	comment	$ ! Written by Camiel Vanderhoeven
dcl	blank	
dcl	blank	
dcl	code	$ SET VERIFY
dcl	code	$ WRITE SYS$SYSTEM
dcl	code	This is some text
dcl	blank	
dcl	code	$ EXIT
dcl	comment	$! This is comment again
dcl	comment	$!
dcl	blank	
