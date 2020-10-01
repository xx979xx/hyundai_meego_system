(*
Module: IniFile
  Generic module to create INI files lenses

Author: Raphael Pinson <raphink@gmail.com>

About: License
  This file is licensed under the GPL.

About: TODO
  Things to add in the future
  - Support double quotes in value
  - Support multiline values (is it standard?)

About: Lens usage
  This lens is made to provide generic primitives to construct INI File lenses.
  See <Puppet>, <PHP>, <MySQL> or <Dput> for examples of real life lenses using it.

*)

module IniFile  =


(************************************************************************
 * Group:               USEFUL PRIMITIVES
 *************************************************************************)

(* Group: Internal primitives *)

(*
Variable: eol
  End of line, inherited from <Util.eol>
*)
let eol                = Util.eol

(*
View: empty
  Empty line, an <eol> subnode
*)
let empty              = [ eol ]


(* Group: Separators *)



(*
Variable: sep
  Generic separator

  Parameters:
    pat:regexp - the pattern to delete
    default:string - the default string to use
*)
let sep (pat:regexp) (default:string)
                       = Util.del_opt_ws "" . del pat default

(*
Variable: sep_re
  The default regexp for a separator
*)

let sep_re             = /[=:]/

(*
Variable: sep_default
  The default separator value
*)
let sep_default        = "="


(* Group: Stores *)


(*
Variable: sto_to_eol
  Store until end of line
*)
let sto_to_eol         = Util.del_opt_ws ""
                         . store /([^ \t\n].*[^ \t\n]|[^ \t\n])/
(*
Variable: sto_to_comment
  Store until comment
*)
let sto_to_comment     = Util.del_opt_ws ""
                         . store /[^;# \t\n][^;#\n]*[^;# \t\n]|[^;# \t\n]/


(* Group: Define comment and defaults *)

(*
View: comment
  Map comments into "#comment" nodes

  Parameters:
    pat:regexp - pattern to delete before commented data
    default:string - default pattern before commented data

  Sample Usage:
  (start code)
    let comment  = IniFile.comment "#" "#"
    let comment  = IniFile.comment IniFile.comment_re IniFile.comment_default
  (end code)
*)
let comment (pat:regexp) (default:string)
                       = [ label "#comment" . sep pat default
		         . sto_to_eol? . eol ]
(*
Variable: comment_re
  Default regexp for <comment> pattern
*)

let comment_re         = /[;#]/

(*
Variable: comment_default
  Default value for <comment> pattern
*)
let comment_default    = ";"


(************************************************************************
 * Group:                     ENTRY
 *************************************************************************)

(* Group: entry includes comments *)

(*
View: entry
  Generic INI File entry

  Parameters:
    kw:regexp    - keyword regexp for the label
    sep:lens     - lens to use as key/value separator
    comment:lens - lens to use as comment

  Sample Usage:
     > let entry = IniFile.entry setting sep comment
*)
let entry (kw:regexp) (sep:lens) (comment:lens)
                       = [ key kw . sep . sto_to_comment? . (comment|eol) ] | comment

(*
View: indented_entry
  Generic INI File entry that might be indented with an arbitrary
  amount of whitespace

  Parameters:
    kw:regexp    - keyword regexp for the label
    sep:lens     - lens to use as key/value separator
    comment:lens - lens to use as comment

  Sample Usage:
     > let entry = IniFile.indented_entry setting sep comment
*)
let indented_entry (kw:regexp) (sep:lens) (comment:lens)
                       = [ Util.del_opt_ws "" .
                           key kw . sep . sto_to_comment? .
                           (comment|eol)
                         ]
                         | comment

(*
Variable: entry_re
  Default regexp for <entry> keyword
*)
let entry_re           = ( /[A-Za-z][A-Za-z0-9\._-]+/ )


(************************************************************************
 * Group:                      RECORD
 *************************************************************************)

(* Group: Title definition *)

(*
View: title
  Title for <record>. This maps the title of a record as a node in the abstract tree.

  Parameters:
    kw:regexp - keyword regexp for the label

  Sample Usage:
    > let title   = IniFile.title IniFile.record_re
*)
let title (kw:regexp)
                       = Util.del_str "[" . key kw
                         . Util.del_str "]". eol

(*
View: indented_title
  Title for <record>. This maps the title of a record as a node in the abstract tree. The title may be indented with arbitrary amounts of whitespace

  Parameters:
    kw:regexp - keyword regexp for the label

  Sample Usage:
    > let title   = IniFile.title IniFile.record_re
*)
let indented_title (kw:regexp)
                       = Util.del_opt_ws "" . Util.del_str "[" . key kw
                         . Util.del_str "]". eol

(*
View: title_label
  Title for <record>. This maps the title of a record as a value in the abstract tree.

  Parameters:
    name:string - name for the title label
    kw:regexp   - keyword regexp for the label

  Sample Usage:
    > let title   = IniFile.title_label "target" IniFile.record_label_re
*)
let title_label (name:string) (kw:regexp)
                       = label name
                         . Util.del_str "[" . store kw
                         . Util.del_str "]". eol


(*
Variable: record_re
  Default regexp for <title> keyword pattern
*)
let record_re          = ( /[^]\n\/]+/ - /#comment/ )

(*
Variable: record_label_re
  Default regexp for <title_label> keyword pattern
*)
let record_label_re    = /[^]\n]+/


(* Group: Record definition *)

(*
View: record_noempty
  INI File Record with no empty lines allowed.

  Parameters:
    title:lens - lens to use for title. Use either <title> or <title_label>.
    entry:lens - lens to use for entries in the record. See <entry>.
*)
let record_noempty (title:lens) (entry:lens)
                       = [ title
		       . entry* ]

(*
View: record
  Generic INI File record

  Parameters:
    title:lens - lens to use for title. Use either <title> or <title_label>.
    entry:lens - lens to use for entries in the record. See <entry>.

  Sample Usage:
    > let record  = IniFile.record title entry
*)
let record (title:lens) (entry:lens)
                       = record_noempty title ( entry | empty )


(************************************************************************
 * Group:                      LENS
 *************************************************************************)


(*

Group: Lens definition

View: lns_noempty
  Generic INI File lens with no empty lines

  Parameters:
    record:lens  - record lens to use. See <record_noempty>.
    comment:lens - comment lens to use. See <comment>.

  Sample Usage:
    > let lns     = IniFile.lns_noempty record comment
*)
let lns_noempty (record:lens) (comment:lens)
                       = comment* . record*

(*
View: lns
  Generic INI File lens

  Parameters:
    record:lens  - record lens to use. See <record>.
    comment:lens - comment lens to use. See <comment>.

  Sample Usage:
    > let lns     = IniFile.lns record comment
*)
let lns (record:lens) (comment:lens)
                       = lns_noempty record (comment|empty)


