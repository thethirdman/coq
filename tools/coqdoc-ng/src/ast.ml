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

(** Cst.cst -> ast *)
let rec translate ct i_type cst =
  let rec aux elt acc = match elt with
    Cst.Doc d    -> (extract_queries d)::acc
    | Cst.Code code ->
        let result =
          if i_type = Settings.IVernac then Annotations.doc_of_vernac ct code
          else `Doc (`Content code) in
        result::acc
    | _          -> acc (* FIXME: real type *) in
    List.fold_right aux cst []

(* Evaluates the queries of an ast *)
let rec eval ast = assert false
  (*let aux : with_query -> no_query = function
    #no_query as q -> q
    | `Query (name, arglist) ->
        try
          `Doc ((Hashtbl.find symbol_table name) () arglist)
        with Not_found -> Printf.fprintf stderr "Error: Invalid query \"%s\"\n"
        name; exit 1
  in
  List.map aux ast*)
