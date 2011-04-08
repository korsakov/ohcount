nsis	comment	; NSIS "header" libraries can be in .nsh files.
nsis	comment	/* Copyright some time
nsis	comment	 * never
nsis	comment	 * and not much of that either
nsis	comment	"still a comment"
nsis	comment	*/
nsis	blank	
nsis	code	!macro SillyMacro Param1
nsis	comment		; ... Because we can ;-)
nsis	code		!error "Why did you call this macro, ${Param1}?  That was silly."
nsis	code	!macroend
nsis	blank	
nsis	code	Function Die
nsis	comment		# Likewise, because we can.
nsis	code		DetailPrint "Aarrrrggghh!  I died."
nsis	code		Quit
nsis	code	FunctionEnd
