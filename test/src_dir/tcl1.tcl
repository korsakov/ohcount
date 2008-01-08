#!/usr/local/bin/tclsh

# Dos2Unix
#	Convert a file to Unix-style line endings
#	If the file is a directory, then recursively
#	convert all the files in the directory and below.
#
# Arguments
#	f	The name of a file or directory.
#
# Side Effects:
#	Rewrites the file to have LF line-endings

proc Dos2Unix {f} {
    puts $f
    if {[file isdirectory $f]} {
	foreach g [glob [file join $f *]] {
	    Dos2Unix $g
	}
    } else {
	set in [open $f]
	set out [open $f.new w]
	fconfigure $out -translation lf
	puts -nonewline $out [read $in]
	close $out
	close $in
	file rename -force $f.new $f
    }
}

# Process each command-line argument

foreach f $argv {
    Dos2Unix $f
}
