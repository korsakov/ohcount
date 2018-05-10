nsis	comment	; some nsis code
nsis	comment	/*
nsis	comment	 * lorem
nsis	comment	ipsum
nsis	comment	dolor sit amet etcetera
nsis	comment	*/
nsis	blank	
nsis	code	!include LogicLib.nsh
nsis	code	OutFile foo.exe
nsis	blank	
nsis	code	Section
nsis	code		IfFileExists ${__FILE__} 0 +2 ; comments can be inline
nsis	comment			# Use of ; in a string on the next line
nsis	code			MessageBox MB_OK "You moved this installer file; you shouldn't do that ;-)"
nsis	code	SectionEnd
