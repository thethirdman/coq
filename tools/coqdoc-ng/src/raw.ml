(** Raw output module, produces a text document *)

open Vdoc
open Printf
open Cst

let initialize () = ()

let header _ = ""

let pr_raw raw = raw.default

let doc cst =
  let print_flat_element = function
    `Vernac s          -> sprintf"[%s]" s
    | `Pretty_print s  -> sprintf "[[%s]]" s
    | `Section (lvl,s) -> sprintf "%s %s\n" (String.make lvl '*') s
    | `Hrule           -> "\n" ^ (String.make 4 '=') ^ "\n"
    | `Raw raw         ->  pr_raw raw
    | `Verbatim s      -> sprintf "\n<pre>\n%s\n</pre>" s
    | `Content s       -> s
    in
  let rec print_rec_element = function
    (** FIXME: if the string contain at the beginning and the end, it will
     * not print correctly *)
    | `Emphasis d      -> (sprintf "_%s_" (print_no_eval d))
    | `List lst        ->
    (** We insert a space between backquotes to explictly delimit the end
     * of the list. This hack allows to print code directly after a list *)
      "\n" ^ (String.concat "" (List.map print_no_eval lst)) ^ "\n"
    | `Seq lst -> String.concat "" (List.map print_no_eval lst)
    | `Item doc -> sprintf "*    %s" (print_no_eval doc)
    | _ -> raise Unhandled_case
  and print_no_eval = function
    | #Cst.flat_element as c -> print_flat_element c
    | #Cst.rec_element as c -> print_rec_element c
    |_ -> raise Unhandled_case in
    try Some
        ("(** " ^ (print_no_eval cst) ^ "*)\n")
    with Unhandled_case -> None

(** This function only prints the content of a link *)
let pr_link _ _ link = link.content

let indent id_lvl = String.make (4 * id_lvl) ' '

(** Libname is the name of the lib being printed *)
let code libname c =
  let rec aux = function
  Keyword s | Ident s | Literal s | Tactic s | Symbol s | NoFormat s -> s
  | Root l -> pr_link libname `Root l
  | Link l -> pr_link libname `Link l
  | Output_command (raw,[]) -> pr_raw raw
  | Output_command (raw,args) -> String.concat (pr_raw raw) args
  | Indent (size,code) -> (indent size) ^ (aux code)
  in (**(List.map (fun e -> (Str.global_replace (Str.regexp "\n") "\n    i" (aux e)))
      c)*)
  List.map aux c

let begindoc ()  = ""
let enddoc ()    = ""
let begincode () = ""
let endcode ()   = ""

(* FIXME: make real function *)

let newline () = "\n"

(*FIXME*)
let index _ = ""

let file_index _ = ""

let footer () = ""
