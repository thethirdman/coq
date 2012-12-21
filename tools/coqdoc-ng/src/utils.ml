(** Utility function: only inserts into the output list that are <> None *)
let opt_map f lst = List.fold_right
  (fun elt acc -> match f elt with
    None -> acc
      | Some result -> result::acc) lst []
