" Vim syntax file
" Language:	Test file for ohcount
" Author:	Ciaran McCreesh
"
" This is a test vim syntax file for ohcount.
"

if &compatible || v:version < 700
    finish
endif

if exists("b:current_syntax")
  finish
endif

" This is a comment. There are many like it, but this one is mine.
syn region GiantSpaceMonkey start=/^\s*#/ end=/$/
hi def link GiantSpaceMonkey Comment

let b:current_syntax = "ohcount-test"

