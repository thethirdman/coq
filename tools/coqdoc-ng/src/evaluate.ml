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

(** Show ? * default *)
(** FIXME: real values *)
let code_show = (ref true, true)



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
  if i_type = Settings.IVernac && code <> "" && code <> "\n" then
    (** We first evaluate the code in order to manage the identifiers *)
    begin
      ignore (Coqtop.interp ct Coqtop.null_logger code);
      if !(fst code_show) then
        Annotations.doc_of_vernac ct code
      else
        ""
    end
  else
    code






(** Utility function: only inserts into the output list that are <> None *)
let opt_map f lst = List.fold_right
  (fun elt acc -> match f elt with
    None -> acc
      | Some result -> result::acc) lst []

(* Evaluates the queries of an ast *)
let rec eval_rec_element = function
    `List doclst     -> `List (opt_map eval_doc doclst)
    | `Item d   -> `Item (eval_full_doc d)
    | `Emphasis d    -> `Emphasis (eval_full_doc d)
    | `Root (d, str) -> `Root (eval_full_doc d, str)
    | `Link (d, str) -> `Link (eval_full_doc d, str)
    | `Seq doc_lst   -> `Seq (opt_map eval_doc doc_lst)

and eval_eval_element = function
  | `Add_printing pr -> Annotations.add_printing_rule pr; None
  | `Rm_printing elt -> Annotations.rm_printing_rule elt; None
  | `Query (name,arg_lst) -> Some (`Content "") (** FIXME: replace with eval_query *)

and eval_doc : Cst.doc_with_eval -> Cst.doc_no_eval option = function
  #Cst.flat_element as q -> Some q
  | #Cst.rec_element as r -> Some (eval_rec_element r)
  | #Cst.eval_element as e -> eval_eval_element e

and eval_full_doc cst =
  match opt_map eval_doc [cst] with
  [elt] -> elt
  |_ -> `Content ""

let eval_cst ct i_type = function
    Cst.Doc d -> eval_full_doc d
    | Cst.Code c -> Cst.Code (handle_code ct i_type c)
    (**FIXME: this is ugly, ideally there would be parser + lexer for comments
     * but ... flemme *)
    | Cst.Comment c -> let reg = Str.regexp
        ".*\\(begin\\|end\\) +\\(show\\|hide\\).*" in
    if Str.string_match reg c 0 then
          begin
            match (Str.matched_group 1 c, Str.matched_group 2 c) with
            | "begin","show" -> (fst code_show) := true
            | "begin","hide" -> (fst code_show) := false
            | "end","show"
            | "end","hide"   -> (fst code_show) := (snd code_show)
            | (a,b) -> raise (Invalid_argument ("when treating " ^ a ^ " " ^ b))
          end; Cst.Doc (`Content "")
