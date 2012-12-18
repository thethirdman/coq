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

let is_empty outc cst =
  let is_empty_str str = Str.string_match (Str.regexp "\\( \\|\n\\)*") str 0 in
  match cst with
  Cst.Code [Cst.NoFormat s]
  | Cst.Doc (`Content s) -> if is_empty_str s then output_string outc s; true
  |_ -> false

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
  if is_empty outc cst then ()
  else match cst with
    Cst.Doc d -> handle_context outc `Doc;
                begin match Formatter.doc d with
                  None -> output_string outc (default_fun cst)
                  | Some s -> output_string outc s
                end
    | Cst.Code c -> handle_context outc `Code;
        List.iter (output_string outc) (Formatter.code c)
    | _ -> assert false

let header outc = output_string outc (Formatter.header ())
let footer outc = handle_context outc `None; output_string outc (Formatter.footer ())
end
