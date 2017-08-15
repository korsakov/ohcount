tcl	comment	#!/usr/local/bin/tclsh
tcl	blank	
tcl	comment	# Dos2Unix
tcl	comment	#	Convert a file to Unix-style line endings
tcl	comment	#	If the file is a directory, then recursively
tcl	comment	#	convert all the files in the directory and below.
tcl	comment	#
tcl	comment	# Arguments
tcl	comment	#	f	The name of a file or directory.
tcl	comment	#
tcl	comment	# Side Effects:
tcl	comment	#	Rewrites the file to have LF line-endings
tcl	blank	
tcl	code	proc Dos2Unix {f} {
tcl	code	    puts $f
tcl	code	    if {[file isdirectory $f]} {
tcl	code		foreach g [glob [file join $f *]] {
tcl	code		    Dos2Unix $g
tcl	code		}
tcl	code	    } else {
tcl	code		set in [open $f]
tcl	code		set out [open $f.new w]
tcl	code		fconfigure $out -translation lf
tcl	code		puts -nonewline $out [read $in]
tcl	code		close $out
tcl	code		close $in
tcl	code		file rename -force $f.new $f
tcl	code	    }
tcl	code	}
tcl	blank	
tcl	comment	# Process each command-line argument
tcl	blank	
tcl	code	foreach f $argv {
tcl	code	    Dos2Unix $f
tcl	code	}
