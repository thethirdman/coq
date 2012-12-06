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
let rec extract_queries () = assert false

(* Does the interaction with coqtop for code sections of the input file:
  * takes a Cst.Code, returns a Cst.Doc containing the pretty_print output
    -> Obtains syntactic coloration
    -> Locates each identifier, and if necessary, adds it to the symbol table
       for output
    -> Pretty prints symbols (such as -> or ~) ? *)
let pretty_print ct i_type c = assert false

(** Cst.cst -> ast *)
let rec translate cst i_type cst = assert false

(* Evaluates the queries of an ast *)
let rec eval ast = assert false
