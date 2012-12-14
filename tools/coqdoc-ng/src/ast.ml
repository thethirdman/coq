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

(** This function sets up the necessary rules in order to:
 * locate identifiers and translate them into cst.doc
 * translate such identifiers into hyperlinks if necessary *)
let initialize_code_rules =
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
  initialize_code_rules ct;
  if i_type = Settings.IVernac then
    (** We first evaluate the code in order to manage the identifiers *)
    begin
      ignore (Coqtop.interp ct Coqtop.default_logger code);
      Annotations.doc_of_vernac ct code
    end
  else
    `Doc (`Content code)

(** This function adds a match rule for a given printing rule. *)
let handle_add_printing pr =
  let open Xml_pp in let open Annotations in let open Cst in
  (** Extract the metavars in order to generate the argument list given to
   * Output_command type *)
  let extract_metavars lst = List.fold_left
    (fun acc elt -> match elt with
      | ATag (C_UnpMetaVar, [AString s]) -> s::acc
      |_ -> acc) [] lst in

  (** Tests if a given symbol matches the template (spaces arounds
   * the symbol are ignored) *)
  let sym_tst e match_elt = match e with
  ATag (C_UnpTerminal, [AString s]) ->
    Str.string_match (Str.regexp (" *" ^ match_elt ^ " *")) s 0
  | _ -> false in

  (** If the printing rule is translated into a command, the generated type
   * is an output_command that the backends will handle *)
  if pr.is_command then
    add_rule C_CNotation
    (fun fallback args ->
      if (List.exists (fun e -> sym_tst e pr.match_element)
          args) then
            `Output_command (pr.replace_with, extract_metavars args)
      else
          fallback args)
  (* Else, the printing rule is translated into a simple raw_command *)
  else
    Annotations.add_rule Xml_pp.C_UnpTerminal
    (fun fallback args -> match args with
      [Annotations.AString s]
        when (Str.string_match (Str.regexp (" *" ^ pr.match_element ^ " *")) s 0)
        -> `Raw (pr.replace_with)
      |_ -> fallback args)

(** Handle the documentation translation: queries are extracted and
 * printing_rule are evaluated
 *)
let rec handle_doc elt acc = match elt with
  `Query n -> (`Query n)::acc
  | `Add_printing pr -> handle_add_printing pr; acc
  | `Rm_printing elt ->
      Annotations.add_rule Xml_pp.C_UnpTerminal
        (fun fallback args -> match args with
          [Annotations.AString s] when s = elt -> `Content elt
          | _ -> fallback args); acc
  | `Seq lst -> List.fold_right (fun elt acc -> (handle_doc elt [])@acc) lst
    acc
  | d -> (`Doc d)::acc


(** Cst.cst -> ast *)
let rec translate ct i_type cst =
  let rec aux acc elt = match elt with
    Cst.Doc d    -> handle_doc d acc
    | Cst.Code code -> (handle_code ct i_type code)::acc
    | _          -> acc (* FIXME: real type *) in
    List.fold_left aux [] cst

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
