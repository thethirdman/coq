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
  let loc_info = Coqtop.handle_value (Coqtop.locate ct id_str) in
  match loc_info with
  | None -> None (* no reference has been found *)
  | Some absolute_path ->
      try (* The id already exists in id_index, we return a link *)
        Hashtbl.find id_index absolute_path;
        Some (`Link (id_str, absolute_path))
      with Not_found -> (* The id has just been declared *)
        Hashtbl.add id_index absolute_path ();
        Some (`Root (id_str,absolute_path))

