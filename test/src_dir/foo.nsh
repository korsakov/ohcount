; NSIS "header" libraries can be in .nsh files.
/* Copyright some time
 * never
 * and not much of that either
"still a comment"
*/

!macro SillyMacro Param1
	; ... Because we can ;-)
	!error "Why did you call this macro, ${Param1}?  That was silly."
!macroend

Function Die
	# Likewise, because we can.
	DetailPrint "Aarrrrggghh!  I died."
	Quit
FunctionEnd
