(** Latex output module, does the translation vdoc -> latex *)

open Vdoc
open Printf
open Cst

exception Unhandled_case

let initialize () = ()

let header title =
      "\\documentclass[12pt]{report}\n" ^
      (**if !inputenc != "" then printf "\\usepackage[%s]{inputenc}\n" !inputenc;
        if !inputenc = "utf8x" then utf8x_extra_support ();*)
      "\\usepackage[T1]{fontenc}\n" ^
      "\\usepackage{fullpage}\n" ^
      "\\usepackage{coqdoc}\n" ^
      "\\usepackage{amsmath,amssymb}\n" ^
      (** (match !toc_depth with
       | None -> ()
       | Some n -> printf "\\setcounter{tocdepth}{%i}\n" n);
      Queue.iter (fun s -> printf "%s\n" s) preamble; *)
      "\\begin{document}\n" ^
      "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n" ^
      "%% This file has been automatically generated with the command\n" ^
      (** FIXME: detail the command line *)
      "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n" ^
      "\\chapter{" ^ title ^ "}"

let title_print title = "\\chapter{" ^ title ^ "}\n"

let pr_raw raw =
  if raw.latex <> "" then raw.html
  else if raw.latex_math <> "" then "$" ^ raw.latex_math ^ "$"
  else raw.default

let escape str =
  let reg  =  Str.regexp  "\\(\\$\\|~\\|#\\|%\\|&\\|~\\|_\\|\\^\\|{\\|}\\)" in
  let intermediary = Str.global_replace (Str.regexp "\\") "$\\backslash$" str in
  Str.global_replace reg "\\\\\\1" intermediary

let select_section = function
    | 1 -> "section"
    | 2 -> "subsection"
    | 3 -> "subsubsection"
    | _ -> "paragraph"

let doc cst =
  let print_flat_element = function
    `Vernac s          -> sprintf"[%s]" (escape s)
    | `Pretty_print s  -> sprintf "[[%s]]" (escape s)
    | `Section (lvl,s) -> sprintf "\\%s{%s}" (select_section lvl) (escape s)
    | `Hrule           -> "\\par\n\\noindent\\hrulefill\\par\n\\noindent{}"
    | `Raw raw         ->  pr_raw raw
    | `Verbatim s      -> sprintf"\\texttt{%s}" (escape s)
    | `Content s       -> (escape s)
    in
  let rec print_rec_element = function
    | `Emphasis d      -> (sprintf "\\textit{%s}" (print_no_eval d))
    | `List lst        -> sprintf "\\begin{itemize}%s\\end{itemize}"
    (String.concat "" (List.map print_no_eval lst))
    | `Seq lst -> String.concat "" (List.map print_no_eval lst)
    | `Item doc -> sprintf "\\item %s\n" (print_no_eval doc)
    | _ -> raise Unhandled_case
  and
  print_no_eval = function
    | #Cst.flat_element as c -> print_flat_element c
    | #Cst.rec_element as c -> print_rec_element c
    |_ -> raise Unhandled_case
    in
      try Some (print_no_eval cst)
      with Unhandled_case -> None

(**FIXME*)
let pr_link libname link_type link =
  (** FIXME *)
  let normalize name = String.concat "." name in
  match link_type with
    | `Root ->
        sprintf "%s\\label{%s}" (escape link.content) (normalize link.adress)
    | `Link ->
        if (is_local libname link.adress) && (not link.is_stdlib) then
          sprintf "%s$^{\\pageref{%s}}$" (escape link.content) (normalize link.adress)
        else
          (** If the link is not local, we get the output file of the module *)
          sprintf "%s\\footnote{%s:%s}" (escape link.content)
          (Settings.output_name_of_module (List.hd link.adress))
          (normalize link.adress)

let rec indent id_lvl =
  let tab_size = 4 in
  String.make (id_lvl * tab_size) '~'

(**let escape_chars str =
  let reg = Str.regexp "\\(#\\|$\\|%\\|&\\|~\\|_\\|^\\|\\\|{\\|}\\)" in
    Str.global_replace reg "\\\1" str**)

let code libname c =
  let rec aux = function
    Keyword s ->   sprintf "\\coqdockw{%s}" (escape s)
  | Ident s ->   sprintf "\\coqdocvar{%s}" (escape s)
  | Literal s -> sprintf "\\coqdocvar{%s}" (escape s)
  | Tactic s -> sprintf  "\\coqdocind{%s}" (escape s)
  | Symbol s -> sprintf  "\\coqdoclemma{%s}" (escape s)
  | NoFormat s -> (escape s)
  | Root l -> pr_link libname `Root l
  | Link l -> pr_link libname `Link l
  | Output_command (raw,[]) -> pr_raw raw
  | Output_command (raw,args) -> String.concat (pr_raw raw) (List.map escape
  args)
  | Indent (size,code) -> (indent size) ^ (aux code)
  in (List.map aux c)

let begindoc ()  = ""
let enddoc ()    = ""
let begincode () = "\\begin{coqdoccode}"
let endcode ()   = "\\end{coqdoccode}"

(* FIXME: make real function *)

let newline () = "\\coqdoceol\n"

(*FIXME*)
let index lst = ""
  (**sprintf "<h1>Index of symbols</h1><br/>\n<hr/>\n<ul>\n%s</ul>\n"
    (String.concat "" (List.map (fun e -> sprintf "<li>%s</li>\n" (pr_link `Link
    e)) lst)) *)

let file_index lst = ""
  (**sprintf "<h1>Index of files</h1><br/>\n<hr/>\n<ul>\n%s</ul>\n"
  (String.concat "" (List.map (fun (fname,modname) -> sprintf "<li><a href=\"%s\">%s</a></li>\n"
    fname modname) lst)) *)

let footer () = "\\end{document}\n"
