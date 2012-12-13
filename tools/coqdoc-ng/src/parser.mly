(** This file contain the parsers for coqdoc:
  * It is to be compiled with menhir *)

%token EOF STARTCOM ENDCOM STARTDOC STARTVERNAC ENDVERNAC STARTPP ENDPP
       STARTVERBATIM ENDVERBATIM HRULE EMPHASIS LATEX LATEX_MATH HTML ENDLST
       ITEM
%token <int> LST
%token <int*string> SECTION
%token <string> CONTENT RM_PRINTING
%token <bool*string> ADD_PRINTING
%token <string*string> QUERY

%start parse_vernac parse_doc

%type <string Cst.cst_node> parse_vernac
%type <Cst.doc> parse_doc

%{
  open Str
  let merge_contents lst = List.fold_right (fun a b -> a^b) lst ""

  (** Merges a list of Cst.raw_content elements. The last non-empty fields
   * encountered are kept *)
  let merge_raw_content lst =
    let open Cst in List.fold_left (fun acc item ->
    { latex =
          if item.latex <> "" then item.latex else acc.latex;
      latex_math =
        if item.latex_math <> "" then item.latex_math else acc.latex_math;
      html =
        if item.html <> "" then item.html else acc.html;})
    {latex = ""; latex_math = ""; html = ""} lst
%}

%%


(** This function does the separation from code, comment and documentation,
 * after the input has been lexed by vernac_lexer *)
parse_vernac:
STARTCOM list(CONTENT) ENDCOM
  {Cst.Comment (merge_contents $2)}
| STARTDOC list(CONTENT) ENDCOM
  {Cst.Doc (merge_contents $2)}
| CONTENT
  {Cst.Code $1 }
| EOF
  {raise Cst.End_of_file}

(** This function parses the different elements of the documentation strings
   * from the source file *)
parse_doc:
  lst = list(parse_seq) EOF
    {`Seq lst}

(**  This is used to allow the parsing of elements that allow "documented"
 * elements inside them (for example: an emphasis containing a query) *)
parse_seq:
  term = parse_term
    {term}
  | EMPHASIS lst=list (parse_term) EMPHASIS
    {`Emphasis (`Seq lst)}
  | LST lst=list(parse_lst) ENDLST
    {`List lst}
(** Function for parsing documentation lists *)
parse_lst:
| LST lst=list(parse_lst) ENDLST
  {`List lst}
| ITEM c=list(parse_term)
  {(`Item  (0,`Seq c)) }

(* Basic elements of documentation strings *)
parse_term:
STARTVERNAC CONTENT ENDVERNAC
  {`Vernac $2}
| STARTPP CONTENT ENDPP
  {`Pretty_print $2}
| STARTVERBATIM list(CONTENT) ENDVERBATIM
  {`Verbatim (merge_contents $2)}
| SECTION
  {`Section $1}
| HRULE
  {`Hrule}
| CONTENT
  {`Content $1}
| query = QUERY
  {let (name,arglist) = query in `Query (name,(Str.split (Str.regexp ",")
  arglist))}
| ADD_PRINTING translations=list(raw_terms) EOF
{ let open Cst in
  `Add_printing {is_command = (fst $1); match_element = (snd $1);
  replace_with = (merge_raw_content translations)}
}
| tok=RM_PRINTING
{ `Rm_printing tok }
| raw_terms
  {`Raw $1}

raw_terms:
| LATEX CONTENT LATEX
  {{Cst.latex = $2; Cst.latex_math=""; Cst.html="";}}
| LATEX_MATH CONTENT LATEX_MATH
  {{Cst.latex = ""; Cst.latex_math=$2; Cst.html="";}}
| HTML CONTENT HTML
  {{Cst.latex = ""; Cst.latex_math=""; Cst.html=$2;}}
