exception Error

type token = 
  | STARTVERNAC
  | STARTVERBATIM
  | STARTPP
  | STARTDOC
  | STARTCOM
  | SECTION of (int*string)
  | RM_PRINTING of (string)
  | QUERY of (string*string)
  | LST of (int)
  | LATEX_MATH
  | LATEX
  | ITEM
  | HTML
  | HRULE
  | EOF
  | ENDVERNAC
  | ENDVERBATIM
  | ENDPP
  | ENDLST
  | ENDCOM
  | EMPHASIS
  | CONTENT of (string)
  | ADD_PRINTING of (bool*string)


val parse_vernac: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (string Cst.cst_node)
val parse_doc: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Cst.doc_with_eval)