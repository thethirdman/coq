(** This file contains the type and the functions
 * used for translation between Xml protocol's prettyprint
 * output and the Cst/Ast type.
 *
 * It contains also utility functions for specific treatments (read further)
 *)

open Coqtop_handle


(** This is the output type of the xml parser. It is only used
 * for translation purposes, into the annot type.
 *)
exception Xml_error of string
type xml = Serialize.xml =
        | Element of (string * (string * string) list * xml list)
        | PCData of string

(* Annotation type: This is the data representation of prettyprint's output
 * The logical structure is very similar to the xml type above.
 * Either an annotation is a empty element (a tree), or it is
 * a tag made of a given type (the context_tag type), containing multiple
 * annotations
 *)
type annot =
  | AString of string
  | ATag of Xml_pp.context_tag * annot list

(* coqtop_handle -> string -> annot list
 * This function translates a string of vernac code into an annot type
 * by calling the prettyprint command, and then parsing the result into the
 * annot type.
 *)
let annot_of_vernac ct vernac_string =
  let pp_output = Coqtop.handle_value (Coqtop.prettyprint ct vernac_string) in
  (** We encapsulate the response string into a tag in order to parse
   * the full xml hierarchy *)
  let xml_parser = Xml_parser.make (Xml_parser.SString ("<xml>" ^ pp_output ^ "</xml>")) in
  let xml_result = Xml_parser.parse xml_parser in

  (** This is an ugly hack (part 2.). Because the xml_parser will remove
   * some spaces, we escaped them before sending them through coqtop (see
   * toplevel/ide_slave). We now unescape the spaces *)
  let unescape = Str.global_replace (Str.regexp "&nbsp;") " " in

  (** Translates from xml to annot *)
  let rec translate = function
    PCData s -> AString (unescape s)
    | Element (name, [], xml) -> (* We do not accept attributes *)
        ATag (Xml_pp.context_tag_of_string name, List.map translate xml)
    | Element (name,_,_) ->
        raise (Xml_error ("Invalid formated tag: " ^ name ^ "\n")) in

  (** This function unboxes the xml tag *)
  let un_xml = function
    |Element ("xml", [], xml) -> List.map translate xml
    | _ -> raise (Xml_error "Could not de-encapsulate xml tag")

  in un_xml xml_result


(** The following section handles the translations rules from annot to
 * Cst.doc_with_eval
 *
 * In order to allow user-defined interactions, we use a chain-of-control
 * design pattern.
 * We use a hashtable to store translation rules: the key is the tag
 * (Xml_pp.context_tag) on which the rule applies, while the content is the
 * function which does the translation from annot to Cst.doc_with_eval *)
let code_rules = Hashtbl.create 42

(** Function to add rules to the hashtable.
 * Tag is a Xml_pp.context_tag, and
 * f is a function of type (annot list -> doc ) -> annot list -> doc.
 * The first argument is a "fallback" function which should be called when
 * the rule does not apply. This fallback functions calls the rest of the
 * rules on a given tag, and handle the case when no rule can be applied.
 *)
let add_rule tag f =
  try let fallback = Hashtbl.find code_rules tag in
    Hashtbl.replace code_rules tag (f fallback)
  with Not_found -> Hashtbl.add code_rules tag (f (fun _ -> raise Not_found))


(** This functions indents multilines expression:
  * after having computed the indentation level of a sentence, the rest of the
  * each line of the sentence must be indented *)
let indent_newline depth lst =
  let gen_split constructor str =
      let split_exp = Str.full_split (Str.regexp "\n") str in
      let rec aux = function
      | [] -> []
      | [Str.Text s] -> [constructor s]
      | (Str.Delim _)::(Str.Text s)::l ->
        (constructor "\n")::(Cst.Indent (depth + 1, (constructor s)))::(aux l)
      | e::l -> (aux l) in
    aux split_exp in
  let indent_code = function
    | Cst.Keyword str -> gen_split (fun s -> Cst.Keyword s) str
    | Cst.Ident str -> gen_split (fun s -> Cst.Ident s) str
    | Cst.Literal str -> gen_split (fun s -> Cst.Literal s) str
    | Cst.Tactic str -> gen_split (fun s -> Cst.Tactic s) str
    | Cst.Symbol str -> gen_split (fun s -> Cst.Symbol s) str
    | Cst.NoFormat str -> gen_split (fun s -> Cst.NoFormat s) str
    | other -> [other] in
  List.flatten (List.map indent_code lst)

(** This function handle the indentation of the code (because the xml_protocol
 * can't), some xml tags describe the opening of a new block, making a new
 * level of indentation, while others close the block, reducing the indentation
 *)
let indent =
  let open Xml_pp in let open Cst in
  let id_lvl = ref 0 in
  (fun node code_lst ->
  let aux node code = match node with
    | V_BeginSection ->
      let ret = Indent (!id_lvl,code) in incr id_lvl; ret
    | V_EndSegment ->
        decr id_lvl; Indent (!id_lvl,code)
    |_ -> Indent (!id_lvl,code) in
  match code_lst with
  [] -> []
  | e::l -> (aux node e)::(indent_newline (!id_lvl + 1) l))


(** This function handle the calling of the rules in order to do the
  * translation from annot to doc. It returns a code list
  *)
let rec doc_of_annot = function
  | AString s -> [Cst.NoFormat s]
  | ATag (node, values) ->
      try ((Hashtbl.find code_rules node) values)
      with Not_found -> List.flatten (List.map doc_of_annot values)

let id_annotate = function
   | (AString _) as s -> doc_of_annot s
   | (ATag (node, _)) as tag -> indent node (doc_of_annot tag)

(** Utility: string -> Cst.code
  * This function is used when we want to distinguish simple strings
  * or keywords from symbols. If it is a sequence of non-alphabetic characters,
  * then the return value is a symbol type (belonging to Cst.code).
  * Else, the user-given function is called which yields another Cst.code type.
  *)
let maybe_symbol f str =
  if Str.string_match (Str.regexp "^[^a-zA-Z]+$") str 0 then
    Cst.Symbol str
  else
    f str

(* The following section defines a set of rules to apply for syntactic
 * annotation of the code (in order to enable syntactic coloration in the
 * output files, and in order to allow location of identifiers *)
let _ =
  begin
    let open Xml_pp in
    (** This is a generic rule for keyword printing. We consider all the
     * string elements of an expression as being keywords or symbols.
     *)
    let keyword_nodes = [V_Fixpoint; V_CoFixpoint; V_Definition; V_Inductive;
    V_Proof; V_Assumption; V_Solve; V_EndProof; V_CheckMayEval; V_Require;
    V_StartTheoremProof; C_CLetIn; C_CNotation; V_Notation; V_EndSegment;
    V_BeginSection; C_UnpTerminal; C_CProdN; V_SyntacticDefinition;
    V_Delimiters;
    ] in
    let node_generic = (fun fallback args ->
        List.flatten (List.map
          (function
            AString s -> [maybe_symbol (fun e -> Cst.Keyword e) s]
            | ann -> doc_of_annot ann) args)) in
    List.iter (fun e -> add_rule e node_generic) keyword_nodes;

    (** Rules for identifiers *)
    let id_types = [C_Id; C_Ref] in
    let id_print = (fun fallback args -> match args with
        | [AString id] -> [Cst.Ident id]
      |_  -> fallback args) in
    List.iter (fun e -> add_rule e id_print) id_types;

      (** Rules for literals *)
    let lit_types = [C_CPrim; C_GlobSort] in
    let lit_rule = (fun fallback args -> match args with
        | [AString lit] -> [Cst.Literal lit]
        |_ -> fallback args) in
    List.iter (fun e -> add_rule e lit_rule) lit_types;

    (** Rule for tactics *)
    add_rule V_Solve (fun fallback args -> match args with
      | [AString lit] -> [Cst.Tactic lit]
      | _ -> fallback args);

  end

(* The following section defines help function and a set of rules used for
 * translating printing comments defined by the user.
 *
 * It handles both the "rich" commands defined by the user, and the simple
 * translation rules of the old coqdoc (such as -> becoming a \rightarrow) *)

(** Tests if a given symbol matches the template (spaces arounds
 * the symbol are ignored) *)

let cmp_symbol s match_elt =
   (Str.string_match (Str.regexp (" *" ^ match_elt ^ " *")) s 0)

let cmp_command e match_elt =
  match e with
    ATag (Xml_pp.C_UnpTerminal, [AString s]) ->
      cmp_symbol s match_elt
    | _ -> false


(**
 * For the commands, we want to extract the argument list given to the printing
 * symbol.
 * For instance, when printing a latex document, those are the arguments
 * which will be given to the macro inside the latex document
 *)
let extract_metavars lst = List.fold_left
  (fun acc elt -> match elt with
    | ATag (Xml_pp.C_UnpMetaVar, [ATag (_,[AString s])]) -> s::acc
    |_ -> acc) [] lst

(** We refine the add_rule function by taking a printing rule
 *)
let add_printing_rule pr =
  let open Cst in
  (** If the printing rule is translated into a command, the generated type
   * is an output_command that the backends will handle *)
  if pr.is_command then
    add_rule Xml_pp.C_CNotation
    (fun fallback args ->
      if (List.exists (fun e -> cmp_command e pr.match_element)
          args) then
            [Cst.Output_command (pr.replace_with, extract_metavars args)]
      else
          fallback args)
  (* Else, the printing rule is translated into a simple raw_command *)
  else
    add_rule Xml_pp.C_UnpTerminal
    (fun fallback args -> match args with
      [AString s] when cmp_symbol s pr.match_element
        -> [Cst.Output_command (pr.replace_with, [])]
      |_ -> fallback args)

(** FIXME: we should really remove the printing rule instead of just
 * shadowing it (but this would suppose comparing functions ?)
 *
 * We'd also like a more specific return type for the function given to
 * add_rule. The naive approach would be to call fallback instead of returning
 * a NoFormat, but this would call to rule we want to shadow *)
let rm_printing_rule match_elt =
  add_rule Xml_pp.C_UnpTerminal
    (fun fallback args -> match args with
      [AString s] when cmp_symbol s match_elt -> [Cst.NoFormat match_elt]
      | _ -> fallback args)

let _ =
  let open Cst in
  (** We now generate the translation rules for the symbols that are supposed
   * to be translated automatically *)
  let default_symbols = [
    (* default symbol, latex, html *)
  ("\\*" ,     "\\ensuremath{\\times}",                  "");
	("|",      "\\ensuremath{|}",                        "");
	("->",     "\\ensuremath{\\rightarrow}",             "");
	("->~",    "\\ensuremath{\\rightarrow\\lnot}",       "");
	("->~~",   "\\ensuremath{\\rightarrow\\lnot\\lnot}", "");
	("<-",     "\\ensuremath{\\leftarrow}",              "");
	("<->",    "\\ensuremath{\\leftrightarrow}",         "");
	("=>",     "\\ensuremath{\\Rightarrow}",             "");
	("<=",     "\\ensuremath{\\le}",                     "");
	(">=",     "\\ensuremath{\\ge}",                     "");
	("<>",     "\\ensuremath{\\not=}",                   "");
  ("~",      "\\ensuremath{\\lnot}",                   "");
	("/\\\\",    "\\ensuremath{\\land}",                 "");
	("\\\\/",    "\\ensuremath{\\lor}" ,                 "");
	("|-",     "\\ensuremath{\\vdash}",                  "");
	("forall", "\\ensuremath{\\forall}",                 "");
  ("exists", "\\ensuremath{\\exists}",                 "");] in

  List.iter (fun (def, latex, html) ->
    add_printing_rule {is_command = false; match_element = def;
    replace_with = {default = def; latex = latex; html=html; latex_math = ""}})
  default_symbols

(** Does the full translation from vernac to doc type *)
let doc_of_vernac ct code =
  let ret =
    (try
      let annot_lst = annot_of_vernac ct code in
        List.flatten (List.map id_annotate annot_lst)
    with Invalid_argument s -> print_endline s;
      [maybe_symbol (fun e -> Cst.NoFormat e) code])
      in ret