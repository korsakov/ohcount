augeas	comment	(** documentation *)
augeas	code	module Augeas =
augeas	code	autoload xfm
augeas	comment	(**/**)
augeas	comment	(* extra comment *)
augeas	blank	
augeas	comment	(* multiline
augeas	comment	   comment*)
augeas	code	let lns = Shellvars.lns
augeas	blank	
augeas	comment	(* recursion in (* a
augeas	comment	   comment *) to complicate things *)
augeas	code	let filter = incl "/foo/bar"
augeas	code	let xfm = transform lns filter
