(* Passwd module for Augeas
 Author: Free Ekanayaka <free@64studio.com>

 Reference: man 5 passwd

*)

module Passwd =

   autoload xfm

(************************************************************************
 *                           USEFUL PRIMITIVES
 *************************************************************************)

let eol        = Util.eol
let comment    = Util.comment
let empty      = Util.empty
let dels       = Util.del_str

let colon      = del /:/ ":"

let sto_to_col  = store /[^:\n]+/
let sto_to_eol = store /([^ \t\n].*[^ \t\n]|[^ \t\n])/

let word       = /[A-Za-z0-9_.-]+/
let integer    = /[0-9]+/

(************************************************************************
 *                               ENTRIES
 *************************************************************************)

let entry     = [ key word
                . colon
                . [ label "password" . store word    . colon ]
                . [ label "uid"      . store integer . colon ]
                . [ label "gid"      . store integer . colon ]
                . [ label "name"     . sto_to_col?   . colon ]
                . [ label "home"     . sto_to_col?  . colon ]
                . [ label "shell"    . sto_to_eol? ]
                . eol ]

(* A NIS entry has nothing bar the +@:::::: bits. *)
let nisentry =
  let nisuser = /\+\@[A-Za-z0-9_.-]+/ in
  let colons = "::::::" in
  [ dels "+@" . label "@nis" . store word . dels colons . eol ]

(************************************************************************
 *                                LENS
 *************************************************************************)

let lns        = (comment|empty|entry|nisentry) *

let filter
               = incl "/etc/passwd"
               . Util.stdexcl

let xfm        = transform lns filter
