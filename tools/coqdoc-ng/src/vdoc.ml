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
      val indent     : int     -> string (*FIXME: not used right now*)
      val newline    : unit    -> string (*FIXME: idem *)
      val index      : 'a list -> string
      val footer     : unit    -> string
    end) ->
struct

(* Output file generation function: takes a default function
  * which will be called when Formatter.doc does not implement a rule
  * for a cst node *)
let transform outc default_fun cst =
  match (Formatter.doc cst) with
    None -> output_string outc (default_fun cst)
    | Some s -> output_string outc s

let header outc = output_string outc (Formatter.header ())
let footer outc = output_string outc (Formatter.footer ())
end
