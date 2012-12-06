(** This module contains the driver of coqdoc. 

    This a good start to have an idea of the global architecture of the 
    tool. 
*)

open Coqtop_handle

(** Initialization. *)
let initialize () = 
  Settings.parse ()

(** The role of the frontend is to translate a set of input documents
    written in plenty of formats into a common format that we call 
    Vdoc.

    A Vdoc is a "glueing" document composed of two things: (i) fragments of
    documents written the initial input format ; (ii) requests to coqtop.
*)
let frontend () = 
  match Settings.input_type () with
    | Settings.IVernac -> assert false (* FIXME: Not implemented yet. *)
    | Settings.ICoqTeX -> assert false (* FIXME: Not implemented yet. *)
    | Settings.IHTML   -> assert false (* FIXME: Not implemented yet. *)

(** A Vdoc is not displayed as is because it contains requests to coqtop. 
    The purpose of this pass is to turn a Vdoc with requests into a Vdoc
    where all the requests have been replaced by coqtop answers. (If 
    they exists). 

    These answers are written in a generic format (the subset of the Vdoc
    format that represents coqtop answers, typically an XML-like document).
*)
let resolve_coqtop_interaction inputs = 
  (** Initialize a communication layer with a coqtop instance. *)
  let _ct = Coqtop.spawn [] in  
  (** Resolve every requests from inputs. *)
  assert false

(** The role of the backend is to produce the final set of documents.

    The nature of the documents depends on the settings. Anyway,
    roughly speaking this process consists in inserting the fragments
    of documents coming from the input files (with a possible
    conversion into the output format if it is different from the
    input one) and in pretty printing the coqtop answers into the
    output format. 
*)
let backend resolved_inputs = 
  assert false

(** Coqdoc is a composition of the passes described below. *)
let coqdoc =
  initialize ();
  let inputs          = frontend () in
  let resolved_inputs = resolve_coqtop_interaction inputs in
  backend resolved_inputs


