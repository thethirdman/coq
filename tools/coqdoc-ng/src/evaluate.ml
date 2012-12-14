(** This module contains the evaluation rule in order
 * to get from a Cst.doc_with_eval to a Cst.doc_no_eval
 *)

open Settings
open Coqtop_handle

(** stores the defined symbols in coqdoc: primitives and user-defined
 * functions *)
let symbol_table = () (* Hashtbl.create 42*)

type symbol = string
type arglist = string list
type query = (symbol * arglist)


(** This function sets up the necessary rules in order to:
 * locate identifiers and translate them into cst.doc and
 * hyperlinks if necessary *)
let initialize_code_rules =
  let initialized = ref false in
  (fun ct ->
  if not !initialized then
    (let id_manage = (fun fallback args -> match args with
      | [Annotations.AString id] ->
          begin match Hyperlinks.make_hyperlink ct id with
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
    (`Content code)


(** Tests if a given symbol matches the template (spaces arounds
 * the symbol are ignored) *)
let cmp_command e match_elt =
  let open Annotations in let open Xml_pp in
  match e with
    ATag (C_UnpTerminal, [AString s]) ->
      Str.string_match (Str.regexp (" *" ^ match_elt ^ " *")) s 0
    | _ -> false

let cmp_symbol e match_elt =
   (Str.string_match (Str.regexp (" *" ^ match_elt ^ " *")) e 0)

(** This function adds a match rule for a given printing rule. *)
let handle_add_printing pr =
  let open Xml_pp in let open Annotations in let open Cst in
  (** Extract the metavars in order to generate the argument list given to
   * Output_command type *)
  let extract_metavars lst = List.fold_left
    (fun acc elt -> match elt with
      | ATag (C_UnpMetaVar, [AString s]) -> s::acc
      | ATag (C_UnpMetaVar, [ATag (_,[AString s])]) -> s::acc
      |_ -> acc) [] lst in

  (** If the printing rule is translated into a command, the generated type
   * is an output_command that the backends will handle *)
  if pr.is_command then
    add_rule C_CNotation
    (fun fallback args ->
      if (List.exists (fun e -> cmp_command e pr.match_element)
          args) then
            `Output_command (pr.replace_with, extract_metavars args)
      else
          fallback args)
  (* Else, the printing rule is translated into a simple raw_command *)
  else
    Annotations.add_rule Xml_pp.C_UnpTerminal
    (fun fallback args -> match args with
      [Annotations.AString s] when cmp_symbol s pr.match_element
        -> `Raw (pr.replace_with)
      |_ -> fallback args)


(** Utility function: only inserts into the output list that are <> None *)
let opt_map f lst = List.fold_right
  (fun elt acc -> match f elt with
    None -> acc
      | Some result -> result::acc) lst []

(* Evaluates the queries of an ast *)
let rec eval_rec_element = function
    `List doclst     -> `List (opt_map eval_doc doclst)
    | `Item  d       -> `Item (eval_full_doc d)
    | `Emphasis d    -> `Emphasis (eval_full_doc d)
    | `Root (d, str) -> `Root (eval_full_doc d, str)
    | `Link (d, str) -> `Link (eval_full_doc d, str)
    | `Seq doc_lst   -> `Seq (opt_map eval_doc doc_lst)

and eval_eval_element = function
  | `Add_printing pr -> handle_add_printing pr; None
  | `Rm_printing elt ->
      Annotations.add_rule Xml_pp.C_UnpTerminal
        (fun fallback args -> match args with
          [Annotations.AString s] when cmp_symbol s elt -> `Content elt
          | _ -> fallback args); None
  | `Query (name,arg_lst) -> Some (`Content ("query: " ^ name)) (** FIXME: replace with eval_query *)

and eval_doc : Cst.doc_with_eval -> Cst.doc_no_eval option = function
  #Cst.flat_element as q -> Some q
  | #Cst.rec_element as r -> Some (eval_rec_element r)
  | #Cst.eval_element as e -> eval_eval_element e

and eval_full_doc cst =
  match opt_map eval_doc [cst] with
  [elt] -> elt
  |_ -> `Content ""

let eval_cst ct i_type cst =
  let aux = function
    Cst.Doc d -> eval_full_doc d
    | Cst.Code c -> handle_code ct i_type c
    |_ -> `Content "" in
  List.map aux cst
