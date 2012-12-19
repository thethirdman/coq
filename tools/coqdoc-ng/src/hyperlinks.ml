(** This file handles the generation of hyperlinks.
 * This applies to identifiers inside Vernac code and
 * (maybe ?) to sections titles inside documented .v files
 *)

open Coqtop_handle
open Cst

(** This hashtable stores all the declared identifiers inside a "project"
 * (i.e a set of files from which the documentation is generated)
 *)
let id_index = Hashtbl.create 42

(** We want to check if a link points to coq's standard library, because
 * it implies a special treatment on the backend side *)
let is_stdlib str =
  (String.length str > 3) && ((String.compare (String.sub str 0 3) "Coq") = 0)

let make_path = Str.split (Str.regexp "\\.")

(** FIXME: function name
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
      try (* The id already exists in id_index, we return a link *)
        Hashtbl.find id_index absolute_path;
        Some (Link
            {is_stdlib = is_stdlib absolute_path;
             adress = make_path absolute_path;
             content = id_str;})
      with Not_found -> (* The id has just been declared *)
        let is_stdlib = is_stdlib absolute_path in
        if not is_stdlib then
          begin
            Hashtbl.add id_index absolute_path ();
            Some (Root
              {is_stdlib = is_stdlib;
               adress = make_path absolute_path;
               content = id_str;})
          end
        else
          None

