(* Main definition file for coqdoc *)

open Vernac_lexer
open Lexing
open Doc_lexer
open Settings
open Vdoc
open Coqtop_handle

(* Takes a coqdoc documentation string, returns a Cst.doc tree *)
let treat_doc str =
  let lexbuf = from_string str in
  (Parser.parse_doc lex_doc lexbuf)

(* Calls the compilation chain when the input file is a .v*)
let from_v () = assert false

(* Calls the compilation chain when the input file is a .tex*)
let from_coqtex () = assert false

(** Main function for coqdoc. Parses the arguments, and generates a .html file
 * from the given .v file *)
let _ =
  Settings.parse ();
  let ct = Coqtop.spawn [] in
  if !(io.i_type) = Vdoc then
    from_v ()
  else
    from_coqtex ()

