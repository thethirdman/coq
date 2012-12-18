(***********************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team    *)
(* <O___,, *        INRIA-Rocquencourt  &  LRI-CNRS-Orsay              *)
(*   \VV/  *************************************************************)
(*    //   *      This file is distributed under the terms of the      *)
(*         *       GNU Lesser General Public License Version 2.1       *)
(***********************************************************************)

(*** This module implements an "untyped store", in this particular case we
        see it as an extensible record whose fields are left unspecified. ***)

(* We give a short implementation of a universal type. This is mostly equivalent
    to what is proposed by module Dyn.ml, except that it requires no explicit tag. *)

(* We use a dynamic "name" allocator. But if we needed to serialise stores, we
might want something static to avoid troubles with plugins order. *)

let next =
  let count = ref 0 in fun () ->
  let n = !count in
  incr count;
  n

type t = Obj.t Int.Map.t

module Field = struct
  type 'a field = {
    set : 'a -> t -> t ;
    get : t -> 'a option ;
    remove : t -> t 
  }
  type 'a t = 'a field
end

open Field

let empty = Int.Map.empty

let field () =
  let fid = next () in
  let set a s =
    Int.Map.add fid (Obj.repr a) s
  in
  let get s =
    try Some (Obj.obj (Int.Map.find fid s))
    with _ -> None
  in
  let remove s =
    Int.Map.remove fid s
  in
  { set = set ; get = get ; remove = remove }
