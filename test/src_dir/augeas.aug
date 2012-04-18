(** documentation *)
module Augeas =
autoload xfm
(**/**)
(* extra comment *)

(* multiline
   comment*)
let lns = Shellvars.lns

(* recursion in (* a
   comment *) to complicate things *)
let filter = incl "/foo/bar"
let xfm = transform lns filter
