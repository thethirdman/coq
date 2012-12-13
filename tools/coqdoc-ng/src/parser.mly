%token EOF STARTCOM ENDCOM STARTDOC STARTVERNAC ENDVERNAC
%token STARTPP ENDPP STARTVERBATIM ENDVERBATIM HRULE
%token EMPHASIS LATEX LATEX_MATH HTML ENDLST ITEM
%token <int> LST
%token <int*string> SECTION
%token <string> CONTENT ADD_TOKEN RM_TOKEN
%token <string*string> QUERY

%start main parse_doc (* FIXME: good return type *)
%type <string Cst.cst_node> main
%type <Cst.doc> parse_doc

%{
  open Str
  let merge_contents lst = List.fold_right (fun a b -> a^b) lst ""
%}

%%


main:
STARTCOM list(CONTENT) ENDCOM
  {Cst.Comment (merge_contents $2)}
| STARTDOC list(CONTENT) ENDCOM
  {Cst.Doc (merge_contents $2)}
| CONTENT
  {Cst.Code $1 }
| EOF
  {raise Cst.End_of_file}

parse_doc:
  lst = list(parse_seq) EOF
    {`Seq lst}

parse_seq:
  term = parse_term
    {term}
  | EMPHASIS lst=list (parse_term) EMPHASIS
    {`Emphasis (`Seq lst)}
  | LST lst=list(parse_lst) ENDLST
    {`List lst}

parse_lst:
| LST lst=list(parse_lst) ENDLST
  {`List lst}
| ITEM c=list(parse_term)
  {(`Item  (0,`Seq c)) }

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
| tok=ADD_TOKEN translations=list(raw_terms) EOF
{
  let open Cst in
  let merged_term =
    List.fold_left (fun acc item ->
      {latex = if item.latex <> "" then item.latex else acc.latex;
      latex_math = if item.latex_math <> "" then item.latex_math else acc.latex_math;
      html = if item.html <> "" then item.html else acc.html;})
    {latex = ""; latex_math = ""; html = ""} translations in
  `Add_token (tok, merged_term)}
| tok=RM_TOKEN
{ `Rm_token tok }
| raw_terms
  {`Raw $1}

raw_terms:
| LATEX CONTENT LATEX
  {{Cst.latex = $2; Cst.latex_math=""; Cst.html="";}}
| LATEX_MATH CONTENT LATEX_MATH
  {{Cst.latex = ""; Cst.latex_math=$2; Cst.html="";}}
| HTML CONTENT HTML
  {{Cst.latex = ""; Cst.latex_math=""; Cst.html=$2;}}
