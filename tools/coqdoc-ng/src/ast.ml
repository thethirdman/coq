(* This module contains the AST representation
 * the evaluation of this ast creates an abstract representation of
 * what will be put in the .vdoc
 *)

(** stores the defined symbols in coqdoc: primitives and user-defined functions
 (symbol * (name -> context -> arglist -> doc) list
 *)
open Settings
open Coqtop_handle

let symbol_table = () (* Hashtbl.create 42*)

type symbol = string
type arglist = string list
type query = (symbol * arglist)

(*FIXME: set up real type *)
type context = unit


type no_query = [ `Doc of Cst.doc ]

type with_query = [`Query of query | no_query ];;

type ast_with_query = with_query list
type ast_no_query = no_query list

(** Cst.doc -> ast: extract the queries to evaluate *)
let rec extract_queries = function
  `Query (name, arglist) -> `Query (name, arglist)
  | d -> `Doc d

(* Does the interaction with coqtop for code sections of the input file:
  * takes a Cst.Code, returns a Cst.Doc containing the pretty_print output
    -> Locates each identifier, and if necessary, adds it to the symbol table
       for output
    -> Pretty prints symbols (such as -> or ~) ? *)

(** Core_rules stores all rules defined in order to translate a annot type
 * into a Cst.doc version.
 *)
let code_rules = Hashtbl.create 42

(** Function to add rules to the hashtable. Tag is a Pp.context_handler, and
 * f is a function of type (annot list -> doc ) -> annot list -> doc.
 * f takes in first argument a fallback function, which will be provided
 * inside add_rule (this way, we can add multiple rules for the same tag).
 * If this is the first rule inserted, the fallback function raises
 * an exception Not_found, in order to fall back to the default rule.
 *)
let add_rule tag f =
  try let fallback = Hashtbl.find code_rules tag in
    Hashtbl.replace code_rules tag (f fallback)
  with Not_found -> Hashtbl.add code_rules tag (f (fun _ -> raise Not_found))

(** Translate a Cst.Code into a Cst.Doc, after interacting with coqtop *)
let code_to_doc ct i_type c =
 if (i_type = Settings.Vdoc) && (c <> "") then
   try
     let ret = Coqtop.get_notation (Coqtop.handle_value (Coqtop.prettyprint ct c)) in
     let rec xml_to_code annot =
       match annot with
       | Coqtop.AString s -> `Content s
       | Coqtop.ATag (node, values) ->
           try (((Hashtbl.find code_rules node) values):Cst.doc)
           with Not_found -> `Seq (List.map xml_to_code values)
     in
     `Doc (xml_to_code ret)
   with Invalid_argument _ -> `Doc (`Content c)
 else
   `Doc (`Content c)

(** Cst.cst -> ast *)
let rec translate ct i_type cst =
  let rec aux elt acc = match elt with
    Cst.Doc d    -> (extract_queries d)::acc
    | Cst.Code c -> (code_to_doc ct i_type c)::acc
    | _          -> acc (* FIXME: real type *) in
    List.fold_right aux cst []

(* Evaluates the queries of an ast *)
let rec eval ast = assert false
