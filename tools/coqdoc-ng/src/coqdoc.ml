(** This module contains the driver of coqdoc.

    This a good start to have an idea of the global architecture of the
    tool.
*)

(** Initialization. *)
let initialize () =
  Settings.parse ()

(** This is the first parser: it makes a logical separation between code,
 * comments and documentation.
 * A different evaluation will be applied on each of those types *)
let vernac_parser =
  (Convert.Simplified.traditional2revised Parser.parse_vernac)

(** The second parser parses the documentation into a abstract representation
 *)
let doc_parser str =
    (Parser.parse_doc Doc_lexer.lex_doc (Lexing.from_string str))


(* This function generates a cst from an vernac file's input channel.
 * It first calls the vernac parser, and then calls the make_cst function
 * which parses the doc features and makes sure that every code feature
 * is a complete sentence *)
let cst_of_vernac_input inp =
  let lst = ref [] in
  try
    while true do
      let ret = vernac_parser (Vernac_lexer.lex (Settings.input_channel inp)) in
      match (Cst.make_cst doc_parser ret) with
      | Some element -> lst := element::!lst
      | None -> ()
    done; assert false
  with Cst.End_of_file -> (List.rev !lst)

(** The role of the frontend is to translate a set of input documents
    written in plenty of formats into a common format that we call
    Vdoc.

    A Vdoc is a "glueing" document composed of two things: (i) fragments of
    documents written the initial input format ; (ii) requests to coqtop.
*)
let frontend () = match Settings.input_type () with
    | Settings.IVernac ->
        (List.map cst_of_vernac_input (Settings.input_documents ()))
    | Settings.ICoqTeX -> assert false (* FIXME: Not implemented yet. *)
    | Settings.IHTML   -> assert false (* FIXME: Not implemented yet. *)

(** A Vdoc is not displayed as is because it contains requests to coqtop.
    The purpose of this pass is to turn a Vdoc with requests into a Vdoc
    where all the requests have been replaced by coqtop answers. (If
    they exists).

    These answers are written in a generic format (the subset of the Vdoc
    format that represents coqtop answers, typically an XML-like document).
*)
let resolve_coqtop_interaction _ct inputs =
  (** For each input, we evaluate the cst list (a sequence of cst's) *)
  List.map2
  (fun libname input ->
    Evaluate.open_coq_module _ct (snd libname);
    let ret = List.map
      (fun cst -> Evaluate.eval_cst _ct (Settings.input_type ()) cst) input in
    Evaluate.close_coq_module _ct (snd libname); ret)
    (Settings.module_list ()) inputs

(** The role of the backend is to produce the final set of documents.

    The nature of the documents depends on the settings. Anyway,
    roughly speaking this process consists in inserting the fragments
    of documents coming from the input files (with a possible
    conversion into the output format if it is different from the
    input one) and in pretty printing the coqtop answers into the
    output format.
*)

let backend resolved_inputs =
    match Settings.output_type (Settings.output_document ()) with
    | Settings.OHTML -> let module Out = Vdoc.Backend(Html) in
      Out.generate_doc resolved_inputs
    | Settings.OLaTeX -> let module Out = Vdoc.Backend(Latex) in
      Out.generate_doc resolved_inputs
    | Settings.OPrettyPrint -> let module Out = Vdoc.Backend(Raw) in
      Out.generate_doc resolved_inputs

open Coqtop_handle
(** Coqdoc is a composition of the passes described below. *)
let coqdoc =
  initialize ();
  (** Initialize a communication layer with a coqtop instance. *)
  let inputs          = frontend () in
  let _ct = Coqtop.spawn [] in
  let resolved_inputs = resolve_coqtop_interaction _ct inputs in
  Coqtop.kill_ct _ct;
  backend resolved_inputs;
