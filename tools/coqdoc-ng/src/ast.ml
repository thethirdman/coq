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

(** This function sets up the necessary rules in order to
 * locate identifiers and translate them into cst.doc *)
let initialize =
  let initialized = ref false in
  (fun ct ->
  if not !initialized then
    (let id_manage = (fun fallback args -> match args with
      | [Annotations.AString id] ->
          begin match Hyperlinks.handle_id ct id with
          None -> fallback args
          | Some (`Root (name, path)) -> `Root (fallback args, path)
          | Some (`Link (name, path)) -> `Link (fallback args, path)
          end
      | _ -> fallback args) in
    List.iter (fun e -> Annotations.add_rule e id_manage) [Xml_pp.C_Id; Xml_pp.C_Ref];
    initialized := true)
  else
    ())

(** Does the translation from code to doc *)
let handle_code ct i_type code =
  initialize ct;
  if i_type = Settings.IVernac then
    (** We first evaluate the code in order to manage the identifiers *)
    begin
      ignore (Coqtop.interp ct Coqtop.default_logger code);
      Annotations.doc_of_vernac ct code
    end
  else
    `Doc (`Content code)

(** Cst.cst -> ast *)
let rec translate ct i_type cst =
  let rec aux elt acc = match elt with
    Cst.Doc d    -> (extract_queries d)::acc
    | Cst.Code code -> (handle_code ct i_type code)::acc
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
