(** Backend of coqdoc does the translation vdoc -> .output *)

(** This backend manages the default rules for printing and
 ** user-made rules*)

open Cst
open Printf

(** Set of core functions that each backend has to implement *)
module Backend =
  functor (Formatter :
    sig
      val initialize : unit    -> unit
      val header     : unit    -> string
      val doc        : Cst.doc_no_eval -> string option
      val begindoc   : unit -> string
      val enddoc     : unit -> string
      val code       : Cst.code list   -> string list
      val begincode  : unit -> string
      val endcode    : unit -> string
      val indent     : int     -> string (*FIXME: not used right now*)
      val newline    : unit    -> string (*FIXME: idem *)
      val index      : 'a list -> string
      val footer     : unit    -> string
    end) ->
struct

(* Output file generation function: takes a default function
  * which will be called when Formatter.doc does not implement a rule
  * for a cst node *)

let (context: [`None | `Code | `Doc] ref) = ref `None
let handle_context outc tok =
  let open Formatter in
    output_string outc (match tok with
  `Code -> let ret =
    if !context = `Doc then enddoc () ^ begincode ()
    else if !context = `None then begincode ()
    else "" in context:=`Code; ret
  | `Doc -> let ret =
    if !context = `Code then endcode () ^ begindoc ()
    else if !context = `None then begindoc ()
    else "" in context := `Doc; ret
  | `None ->
      if !context <> `None then (context := `None; "</div>")
      else "")

let transform outc default_fun cst =
  begin match cst with
    Cst.Doc d ->
      if d <> `Content "" then
        begin handle_context outc `Doc;
          match Formatter.doc d with
            None -> output_string outc (default_fun cst)
            | Some s -> output_string outc s;
          output_string outc (Formatter.newline ())
        end
    | Cst.Code c -> handle_context outc `Code;
        List.iter (output_string outc) (Formatter.code c);
        output_string outc (Formatter.newline ())
    | _ -> assert false end



(** This function prints into an output file a vdoc *)
let rec write_file output cst_list =
    let outc = Settings.output_channel output in
    let print = transform outc (fun s -> "fixme") in
    output_string outc (Formatter.header ());
    List.iter print cst_list;
    output_string outc (Formatter.footer ())

(** When the output is a directory, we generate the set of output files
 * based on each input file, and then we use write_file *)
let write_dir dirname resolved_inputs =
  let aux input_file cst_lst =
    let output_file = Settings.make_output_from_input dirname input_file in
    write_file output_file cst_lst in

  List.iter2 aux (Settings.input_documents ()) resolved_inputs

(** This function handle the generation of the documentation
 * from a list of Cst. For each output file, the associated list of cst
 * is translated into the output language *)
let generate_doc resolved_inputs =
  let out_document = Settings.output_document () in
  match Settings.output_filename out_document with
  | Settings.Directory dirname -> write_dir dirname resolved_inputs
  | other -> write_file (Settings.output_document ()) (List.flatten
  resolved_inputs)

end
