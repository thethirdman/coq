(** Latex output module, does the translation vdoc -> latex *)

open Vdoc
open Printf
open Cst

exception Unhandled_case

let initialize () = ()

let header _ =
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
      "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"

let pr_raw raw =
  if raw.latex <> "" then raw.html
  else raw.default

let select_section = function
    | 1 -> "section"
    | 2 -> "subsection"
    | 3 -> "subsubsection"
    | _ -> "paragraph"

let doc cst =
  let print_flat_element = function
    `Vernac s          -> sprintf"[%s]" s
    | `Pretty_print s  -> sprintf "[[%s]]" s
    | `Section (lvl,s) -> sprintf "\\%s{%s}" (select_section lvl) s
    | `Hrule           -> "\\par\n\\noindent\\hrulefill\\par\n\\noindent{}"
    | `Raw raw         ->  pr_raw raw
    | `Verbatim s      -> sprintf"\\texttt{%s}" s
    | `Content s       -> s
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
let pr_link link_type link =
  (** FIXME *)
  let normalize name = (List.nth name ((List.length name) -1)) in
  link.content
  (**match link_type with
    | `Root ->
      sprintf "<a id=\"%s\">%s</a>" (normalize link.adress) link.content
    | `Link ->
        sprintf "<a href=\"%s\">%s</a>" (normalize link.adress) link.content*)

let indent id_lvl =
  let str = "_" and tab_size = 4 and ret = ref "" in
  if id_lvl = 0 then ""
  else
    begin
      for i = 1 to tab_size * id_lvl do
        ret := str ^ !ret
      done;
    !ret
    end

(**let escape_chars str =
  let reg = Str.regexp "\\(#\\|$\\|%\\|&\\|~\\|_\\|^\\|\\\|{\\|}\\)" in
    Str.global_replace reg "\\\1" str**)

let code c islocal =
  let rec aux = function
    Keyword s ->   sprintf "\\coqdockw{%s}" s
  | Ident s ->   sprintf "\\coqdocvar{%s}" s
  | Literal s -> sprintf "\\coqdocvar{%s}" s
  | Tactic s -> sprintf  "\\coqdocind{%s}" s
  | Symbol s -> sprintf  "\\coqdoclemma{%s}" s
  | NoFormat s -> s
  | Root l -> pr_link `Root l
  | Link l -> pr_link `Link l
  | Output_command (raw,[]) -> pr_raw raw
  | Output_command (raw,args) -> String.concat (pr_raw raw) args
  | Indent (size,code) -> (indent size) ^ (aux code)
  in (List.map aux c)

let begindoc ()  = ""
let enddoc ()    = ""
let begincode () = "\\begin{coqdoccode}"
let endcode ()   = "\\end{coqdoccode}"

(* FIXME: make real function *)

let newline () = "\\ \n"

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
