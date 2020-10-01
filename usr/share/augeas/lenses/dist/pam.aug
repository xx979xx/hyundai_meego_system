(* Proces /etc/pam.d *)
module Pam =
  autoload xfm

  let eol = Util.eol
  let indent = Util.indent

  (* For the control syntax of [key=value ..] we could split the key value *)
  (* pairs into an array and generate a subtree control/N/KEY = VALUE      *)
  let control = /(\[[^]#\n]*\]|[^[ \t][^ \t]*)/
  let word = /[^# \t\n]+/
  (* Allowed types. FIXME: Should be case insensitive *)
  let types = /(auth|session|account|password)/

  (* This isn't entirely right: arguments enclosed in [ .. ] are allowed   *)
  (* and should be parsed as one                                           *)
  let argument = /[^#\n \t]+/

  let comment = Util.comment
  let empty   = Util.empty


  (* Not mentioned in the man page, but Debian uses the syntax             *)
  (*   @include module                                                     *)
  (* quite a bit                                                           *)
  let include = [ indent . Util.del_str "@" . key "include" .
                  Util.del_ws_spc . store word . eol ]

  let record = [ seq "record" . indent .
                   [ label "optional" . del "-" "-" ]? .
                   [ label "type" . store types ] .
                   Util.del_ws_tab .
                   [ label "control" . store control] .
                   Util.del_ws_tab .
                   [ label "module" . store word ] .
                   [ Util.del_ws_tab . label "argument" . store argument ]* .
		 (comment|eol)
               ]
  let lns = ( empty | comment | include | record ) *

  let xfm = transform lns ((incl "/etc/pam.d/*") . Util.stdexcl)

(* Local Variables: *)
(* mode: caml       *)
(* End:             *)
