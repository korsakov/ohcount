; some nsis code
/*
 * lorem
ipsum
dolor sit amet etcetera
*/

!include LogicLib.nsh
OutFile foo.exe

Section
	IfFileExists ${__FILE__} 0 +2 ; comments can be inline
		# Use of ; in a string on the next line
		MessageBox MB_OK "You moved this installer file; you shouldn't do that ;-)"
SectionEnd
