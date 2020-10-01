(*
Module: Util
  Generic module providing useful primitives

Author: David Lutterkort

About: License
  This file is licensed under the LGPLv2+, like the rest of Augeas.
*)


module Util =


(*
Variable: del_str
  Delete a string and default to it

  Parameters:
     s:string - the string to delete and default to
*)
  let del_str (s:string) = del s s

(*
Variable: del_ws
  Delete mandatory whitespace
*)
  let del_ws = del /[ \t]+/

(*
Variable: del_ws_spc
  Delete mandatory whitespace, default to single space
*)
  let del_ws_spc = del_ws " "

(*
Variable: del_ws_tab
  Delete mandatory whitespace, default to single tab
*)
  let del_ws_tab = del_ws "\t"


(*
Variable: del_opt_ws
  Delete optional whitespace
*)
  let del_opt_ws = del /[ \t]*/


(*
Variable: eol
  Delete end of line, including optional trailing whitespace
*)
  let eol = del /[ \t]*\n/ "\n"

(*
Variable: indent
  Delete indentation, including leading whitespace
*)
  let indent = del /[ \t]*/ ""

(* Group: Comment and empty
     This is a general definition of comment and empty.
     It allows indentation for comments, removes the leading and trailing spaces
     of comments and stores them in nodes, except for empty comments which are
     ignored together with empty lines

View: comment
  Map comments into "#comment" nodes
*)
  let comment =
    [ indent . label "#comment" . del /#[ \t]*/ "# "
        . store /([^ \t\n].*[^ \t\n]|[^ \t\n])/ . eol ]

(*
View: empty
  Map empty lines, including empty comments
*)
  let empty   = [ del /[ \t]*#?[ \t]*\n/ "\n" ]

(* View: Split *)
(* Split (SEP . ELT)* into an array-like tree where each match for ELT *)
(* appears in a separate subtree. The labels for the subtrees are      *)
(* consecutive numbers, starting at 0                                  *)
  let split (elt:lens) (sep:lens) =
    let sym = gensym "split" in
    counter sym . ( [ seq sym . sep . elt ] ) *

(* Group: Exclusions

Variable: stdexcl
  Exclusion for files that are commonly not wanted/needed
*)
  let stdexcl = (excl "*~") .
    (excl "*.rpmnew") .
    (excl "*.rpmsave") .
    (excl "*.augsave") .
    (excl "*.augnew")

(* Local Variables: *)
(* mode: caml       *)
(* End:             *)
