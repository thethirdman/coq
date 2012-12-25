(** This file handles the generation of hyperlinks.
 * This applies to identifiers inside Vernac code and
 * (maybe ?) to sections titles inside documented .v files
 *)

open Coqtop_handle
open Cst

module Symbol = struct
  type t = string list

  let compare sym1 sym2 = match sym1,sym2 with
    | [],[] -> 0
    | e1::l1, [] -> String.compare e1 ""
    | [], e2::l2 -> String.compare "" e2
    | e1::l1, e2::l2 ->
        let ret = String.compare e1 e2 in
        if ret = 0 then
          compare l1 l2
        else
          ret

   (** Make a Symbol.t from a string *)
   let make str = Str.split (Str.regexp "\\.") str

   (** Checks wheter a given symbol is located in coq's standard library *)
   let is_stdlib = function
     | e::l when (String.compare e "Coq") = 0 -> true
     |_ -> false
end

module Symbol_set = Set.Make(Symbol)

let link_of_symbol sym =
  let rec aux = function
    [] -> assert false
    | [e] -> e
    | e::l -> aux l in
  let open Cst in
  {is_stdlib = Symbol.is_stdlib sym;
   adress = sym;
   content = aux sym;}

(** This set stores the identifiers declared in the different modules of
 * coqtop *)

let symbol_table = ref (Symbol_set.empty)

let show_stdlib = ref true

let add_symbol symbol =
  let symbol = match symbol with "Top"::l -> l | other -> other in
  symbol_table := Symbol_set.add symbol !symbol_table

(**let find_symbol symbol =
  try
    Some (Symbol.choose symbol !symbol_table)
  with Not_found -> None*)

(** Returns the list of identifiers from a given module *)
let get_id_of_module namespace =
  let filter_fun = function
     | e::l when (String.compare e namespace) = 0 -> true
     |_ -> false in
  let subset = Symbol_set.filter filter_fun !symbol_table in
  Symbol_set.elements subset

(**
 * This function takes a string and tries to find the corresponding identifier
 * in the project.
 * It returns an option type containing a Cst.link type if a reference has
 * been found
 *
 * FIXME: This is currently a naive implementation. There may be a way to
 * handle identifiers, calling only the locate command if necesary.
 *)
let make_hyperlink ct id_str =
  let open Cst in
  let loc_info = Coqtop.handle_value (Coqtop.locate ct id_str) in
  match loc_info with
  | None -> None (* no reference has been found *)
  | Some absolute_path ->
      let sym = Symbol.make absolute_path in
      let is_stdlib = Symbol.is_stdlib sym in
      if Symbol_set.mem sym !symbol_table then
      (* The id already exists in id_index, we return a link *)
        if is_stdlib && not !show_stdlib then
          None
        else
          Some (Link
            {is_stdlib = is_stdlib;
             adress = sym;
             content = id_str;})
      else (* The id has just been declared *)
        begin
          add_symbol sym;
          if is_stdlib && not !show_stdlib then
            None
          else
            Some (Root
              {is_stdlib = is_stdlib;
               adress = sym;
               content = id_str;})
        end

