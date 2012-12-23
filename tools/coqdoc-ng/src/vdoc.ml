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
      val header     : string -> string
      val doc        : Cst.doc_no_eval -> string option
      val begindoc   : unit -> string
      val enddoc     : unit -> string
      val code       : Cst.code list   -> string list
      val begincode  : unit -> string
      val endcode    : unit -> string
      val indent     : int     -> string (*FIXME: not used right now*)
      val newline    : unit    -> string (*FIXME: idem *)
      val index      : link list -> string
      val file_index : (string*string) list -> string
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
let rec file_to_file mod_name output cst_list =
    let outc = Settings.output_channel output in
    let pr_doc = transform outc (fun s -> "fixme") in
    let print = output_string outc in
    print (Formatter.header mod_name);
    List.iter pr_doc cst_list;
    handle_context outc `None;
    print (Formatter.index (List.map Hyperlinks.link_of_symbol
      (Hyperlinks.get_id_of_module mod_name)));
    print (Formatter.file_index
      (List.map (fun file -> match Settings.input_filename file with
          Settings.Named s -> (s,mod_name)
          |_ -> assert false) (Settings.input_documents ())));
    print (Formatter.footer ())

(** When the output is a directory, we generate the set of output files
 * based on each input file, and then we use file_to_file*)
let files_to_dir dirname resolved_inputs =
  let aux input_file cst_lst =
    let output_file = Settings.make_output_from_input dirname (fst input_file) in
    file_to_file (snd input_file) output_file cst_lst in

  List.iter2 aux (Settings.module_list ()) resolved_inputs

(** This function handle the generation of the documentation
 * from a list of Cst. For each output file, the associated list of cst
 * is translated into the output language *)
let generate_doc resolved_inputs =
  let out_document = Settings.output_document () in
  match Settings.output_filename out_document with
  | Settings.Directory dirname -> files_to_dir dirname resolved_inputs
  | other ->
      begin match resolved_inputs with
      | [] -> assert false
      | [one_file] ->
          file_to_file (Settings.module_of_input
          (List.hd (Settings.input_documents ())))
          (Settings.output_document ()) one_file
      | many_files ->
          List.iter2 (fun file libname ->
            file_to_file (snd libname) (Settings.output_document ()) file)
            many_files (Settings.module_list ())
      end

end
