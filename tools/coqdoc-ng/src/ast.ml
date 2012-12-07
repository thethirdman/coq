(* This module contains the AST representation
 * the evaluation of this ast creates an abstract representation of
 * what will be put in the .vdoc
 *)

(** stores the defined symbols in coqdoc: primitives and user-defined functions
 (symbol * (name -> context -> arglist -> doc) list
 *)
open Settings
open Coqtop_handle

let symbol_table = () (* Hashtbl.create 42*)

type symbol = string
type arglist = string list
type query = (symbol * arglist)

(*FIXME: set up real type *)
type context = unit


type no_query = [ `Doc of Cst.doc ]

type with_query = [`Query of query | no_query ];;

type ast_with_query = with_query list
type ast_no_query = no_query list

(** Cst.doc -> ast: extract the queries to evaluate *)
let rec extract_queries = function
  `Query (name, arglist) -> `Query (name, arglist)
  | d -> `Doc d

(* Does the interaction with coqtop for code sections of the input file:
  * takes a Cst.Code, returns a Cst.Doc containing the pretty_print output
    -> Locates each identifier, and if necessary, adds it to the symbol table
       for output
    -> Pretty prints symbols (such as -> or ~) ? *)

(** Core_rules stores all rules defined in order to translate a annot type
 * into a Cst.doc version.
 *)
let code_rules = Hashtbl.create 42

(** Function to add rules to the hashtable. Tag is a Pp.context_handler, and
 * f is a function of type (annot list -> doc ) -> annot list -> doc.
 * f takes in first argument a fallback function, which will be provided
 * inside add_rule (this way, we can add multiple rules for the same tag).
 * If this is the first rule inserted, the fallback function raises
 * an exception Not_found, in order to fall back to the default rule.
 *)
let add_rule tag f =
  try let fallback = Hashtbl.find code_rules tag in
    Hashtbl.replace code_rules tag (f fallback)
  with Not_found -> Hashtbl.add code_rules tag (f (fun _ -> raise Not_found))

(** Calls the translation for an annotation type, returns a CsT.doc type *)
let rec annot_to_doc annot =
  match annot with
       | Coqtop.AString s -> `Code [Cst.NoFormat s]
       | Coqtop.ATag (node, values) ->
           try (((Hashtbl.find code_rules node) values):Cst.doc)
           with Not_found -> `Seq (List.map annot_to_doc values)

(** Translate a Cst.Code into a Cst.Doc, after interacting with coqtop *)
let code_to_doc ct i_type c =
 if (i_type = Settings.IVernac) && (c <> "") then
   try
     let ret = Coqtop.get_notation (Coqtop.handle_value (Coqtop.prettyprint ct c)) in
     `Doc (annot_to_doc ret)
   with Invalid_argument _ -> `Doc (`Code [Cst.NoFormat c])
 else
   `Doc (`Code [Cst.NoFormat c])

(** We add the rules for syntactic coloration *)
let _ =
  begin
    let open Pp in
    let keyword_nodes = [V_Fixpoint; V_CoFixpoint; V_Definition; V_Inductive;
    V_CheckMayEval; C_CLetIn; C_CNotation; C_UnpTerminal; C_CProdN ] in

    (** This is a generic rule for keyword printing. If the sequence starts with
     * a string, we consider it as being a set of keywords. We then do the printing
     * on the rest of the arguments
     *)
    let node_generic = (fun fallback args ->
        `Seq (List.map
          (function Coqtop.AString s -> `Code [Cst.Keyword s]
                    | ann -> annot_to_doc ann) args)) in
    List.iter (fun e -> add_rule e node_generic) keyword_nodes;

    (** Rules for identifiers *)
    let id_types = [C_Id; C_Ref] in
    let id_print = (fun fallback args -> match args with
        | [Coqtop.AString id] -> (`Code [Cst.Ident id])
      |_  -> fallback args) in
    List.iter (fun e -> add_rule e id_print) id_types;

      (** Rules for literals *)
    let lit_types = [C_CPrim; C_GlobSort] in
    let lit_rule = (fun fallback args -> match args with
        | [Coqtop.AString lit] -> (`Code [Cst.Literal lit])
        |_ -> fallback args) in
    List.iter (fun e -> add_rule e lit_rule) lit_types
  end


(** Cst.cst -> ast *)
let rec translate ct i_type cst =
  let rec aux elt acc = match elt with
    Cst.Doc d    -> (extract_queries d)::acc
    | Cst.Code c -> (code_to_doc ct i_type c)::acc
    | _          -> acc (* FIXME: real type *) in
    List.fold_right aux cst []

(* Evaluates the queries of an ast *)
let rec eval ast = assert false
  (*let aux : with_query -> no_query = function
    #no_query as q -> q
    | `Query (name, arglist) ->
        try
          `Doc ((Hashtbl.find symbol_table name) () arglist)
        with Not_found -> Printf.fprintf stderr "Error: Invalid query \"%s\"\n"
        name; exit 1
  in
  List.map aux ast*)
