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

let header outc = output_string outc (Formatter.header ())
let footer outc = handle_context outc `None; output_string outc (Formatter.footer ())
end
