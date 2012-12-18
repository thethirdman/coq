(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, *   INRIA - CNRS - LIX - LRI - PPS - Copyright 1999-2012     *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

open Names

(** Identifiers and names *)
val pr_id : Id.t -> Pp.std_ppcmds
val pr_name : name -> Pp.std_ppcmds

val make_ident : string -> int option -> Id.t
val repr_ident : Id.t -> string * int option

val atompart_of_id : Id.t -> string  (** remove trailing digits *)
val root_of_id : Id.t -> Id.t (** remove trailing digits, ' and _ *)

val add_suffix : Id.t -> string -> Id.t
val add_prefix : string -> Id.t -> Id.t

val has_subscript    : Id.t -> bool
val lift_subscript   : Id.t -> Id.t
val forget_subscript : Id.t -> Id.t

val out_name : name -> Id.t
(** [out_name] associates [id] to [Name id]. Raises [Failure "Nameops.out_name"]
    otherwise. *)

val name_fold : (Id.t -> 'a -> 'a) -> name -> 'a -> 'a
val name_iter : (Id.t -> unit) -> name -> unit
val name_cons : name -> Id.t list -> Id.t list
val name_app : (Id.t -> Id.t) -> name -> name
val name_fold_map : ('a -> Id.t -> 'a * Id.t) -> 'a -> name -> 'a * name


val pr_lab : label -> Pp.std_ppcmds

(** some preset paths *)

val default_library : Dir_path.t

(** This is the root of the standard library of Coq *)
val coq_root : module_ident

(** This is the default root prefix for developments which doesn't
   mention a root *)
val default_root_prefix : Dir_path.t

(** Metavariables *)
val pr_meta : Term.metavariable -> Pp.std_ppcmds
val string_of_meta : Term.metavariable -> string
