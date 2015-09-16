vim	comment	" Vim syntax file
vim	comment	" Language:	Test file for ohcount
vim	comment	" Author:	Ciaran McCreesh
vim	comment	"
vim	comment	" This is a test vim syntax file for ohcount.
vim	comment	"
vim	blank	
vim	code	if &compatible || v:version < 700
vim	code	    finish
vim	code	endif
vim	blank	
vim	code	if exists("b:current_syntax")
vim	code	  finish
vim	code	endif
vim	blank	
vim	comment	" This is a comment. There are many like it, but this one is mine.
vim	code	syn region GiantSpaceMonkey start=/^\s*#/ end=/$/
vim	code	hi def link GiantSpaceMonkey Comment
vim	blank	
vim	code	let b:current_syntax = "ohcount-test"
vim	blank	
