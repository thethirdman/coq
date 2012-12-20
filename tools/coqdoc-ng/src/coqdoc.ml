(** This module contains the driver of coqdoc.

    This a good start to have an idea of the global architecture of the
    tool.
*)

(** Initialization. *)
let initialize () =
  Settings.parse ()

let vernac_parser =
  (MenhirLib.Convert.Simplified.traditional2revised Parser.parse_vernac)

let doc_parser str =
    (Parser.parse_doc Doc_lexer.lex_doc (Lexing.from_string str))


(** This function checks if the string is a full vernac sentence (which
 * is terminated by a . *)
let finished_sentence str = (String.get str (String.length str - 2)) = '.'

(** This function handles multi-line vernac sentences.
 * It makes sure that every Cst.Code is a full Vernac expression *)
let merge_code =
  let code_buff = Buffer.create 100 in
  (fun code lst ->
    if finished_sentence code then
      begin
        let sentence = (Buffer.contents code_buff) ^ code in
        let ret = (Cst.make_cst doc_parser (Cst.Code sentence)) in
        Buffer.clear code_buff;
        ret::lst
      end
  else
    begin
      print_endline ("unfinished: \""^code^"\"");
      Buffer.add_string code_buff code;
      lst
    end)

(* This function generates a cst from an input channel *)
let cst_of_input inp =
  let lst = ref [] in
  try
    while true do
      let ret = vernac_parser (Vernac_lexer.lex (Settings.input_channel inp)) in
      match ret with
      | Cst.Code c -> lst := (merge_code c !lst)
      | _ -> lst := (Cst.make_cst doc_parser ret)::!lst
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
        List.flatten (List.map cst_of_input (Settings.input_documents ()))
    | Settings.ICoqTeX -> assert false (* FIXME: Not implemented yet. *)
    | Settings.IHTML   -> assert false (* FIXME: Not implemented yet. *)

(** A Vdoc is not displayed as is because it contains requests to coqtop.
    The purpose of this pass is to turn a Vdoc with requests into a Vdoc
    where all the requests have been replaced by coqtop answers. (If
    they exists).

    These answers are written in a generic format (the subset of the Vdoc
    format that represents coqtop answers, typically an XML-like document).
*)
open Coqtop_handle

let resolve_coqtop_interaction inputs =
  (** Initialize a communication layer with a coqtop instance. *)
  let _ct = Coqtop.spawn [] in
  (** Resolve every requests from inputs. *)
  let ret =List.map
    (fun inp -> Evaluate.eval_cst _ct (Settings.input_type ()) inp) inputs in
  Coqtop.kill_ct _ct; ret

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
  | Settings.OHTML ->
      let module Backend = Vdoc.Backend(Html) in
      let outc = Settings.output_channel (Settings.output_document ()) in
      let print = Backend.transform outc (fun s -> "fixme") in
      Backend.header outc;
      List.iter print resolved_inputs;
      Backend.footer outc
  | Settings.OLaTeX -> assert false
  | Settings.OPrettyPrint -> assert false

(** Coqdoc is a composition of the passes described below. *)
let coqdoc =
  initialize ();
  let inputs          = frontend () in
  let resolved_inputs = resolve_coqtop_interaction inputs in
  backend resolved_inputs
