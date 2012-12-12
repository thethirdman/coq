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
 * a tag made of a given type (the context_handler type), containing multiple
 * annotations
 *)
type annot =
  | AString of string
  | ATag of Pp.context_handler * annot list

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

  (** Translates from xml to annot *)
  let rec translate = function
    PCData s -> AString s
    | Element (name, [], xml) -> (* We do not accept attributes *)
        ATag (Pp.context_of_string name, List.map translate xml)
    | Element (name,_,_) ->
        raise (Xml_error ("Invalid formated tag: " ^ name ^ "\n")) in

  (** This function unboxes the xml tag *)
  let un_xml = function
    |Element ("xml", [], xml) -> List.map translate xml
    | _ -> raise (Xml_error "Could not de-encapsulate xml tag")

  in un_xml xml_result


(** The following section handles the translations rules from annot to Cst.doc
 *
 * In order to allow user-defined interactions, we use a chain-of-control
 * design pattern.
 * We use a hashtable to store translation rules: the key is the tag
 * (Pp.context_handler) on which the rule applies, while the content is the
 * function which does the translation from annot to Cst.doc *)
let code_rules = Hashtbl.create 42

(** Function to add rules to the hashtable.
 * Tag is a Pp.context_handler, and
 * f is a function of type (annot list -> doc ) -> annot list -> doc.
 * The first argument is a "fallback" function which should be called when
 * the rule does not apply. This fallback functions calls the rest of the
 * rules on a given tag, and handle the case when no rule can be applied.
 *)
let add_rule tag f =
  try let fallback = Hashtbl.find code_rules tag in
    Hashtbl.replace code_rules tag (f fallback)
  with Not_found -> Hashtbl.add code_rules tag (f (fun _ -> raise Not_found))

(** This function handle the calling of the rules in order to do the
  * translation from annot to doc. It returns a Cst.doc
  *)
let rec doc_of_annot annot =
  match annot with
       | AString s -> `Code [Cst.NoFormat s]
       | ATag (node, values) ->
           try (((Hashtbl.find code_rules node) values):Cst.doc)
           with Not_found -> `Seq (List.map doc_of_annot values)

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
    let open Pp in
    (** This is a generic rule for keyword printing. We consider all the
     * string elements of an expression as being keywords or symbols.
     *)
    let keyword_nodes = [V_Fixpoint; V_CoFixpoint; V_Definition; V_Inductive;
    V_Proof; V_Assumption; V_Solve; V_EndProof; V_CheckMayEval;
    V_StartTheoremProof; C_CLetIn; C_CNotation; C_UnpTerminal; C_CProdN ] in
    let node_generic = (fun fallback args ->
        `Seq (List.map
          (function
            AString s -> `Code [maybe_symbol (fun e -> Cst.Keyword e) s]
            | ann -> doc_of_annot ann) args)) in
    List.iter (fun e -> add_rule e node_generic) keyword_nodes;

    (** Rules for identifiers *)
    let id_types = [C_Id; C_Ref] in
    let id_print = (fun fallback args -> match args with
        | [AString id] -> (`Code [Cst.Ident id])
      |_  -> fallback args) in
    List.iter (fun e -> add_rule e id_print) id_types;

      (** Rules for literals *)
    let lit_types = [C_CPrim; C_GlobSort] in
    let lit_rule = (fun fallback args -> match args with
        | [AString lit] -> (`Code [Cst.Literal lit])
        |_ -> fallback args) in
    List.iter (fun e -> add_rule e lit_rule) lit_types;

    (** Rule for tactics *)
    add_rule V_Solve (fun fallback args -> match args with
      | [AString lit] -> `Code [Cst.Tactic lit]
      | _ -> fallback args);
  end


(** Does the full translation from vernac to doc type *)
let doc_of_vernac ct code =
  let ret =
    try
      let annot_lst = annot_of_vernac ct code in
        `Seq (List.map doc_of_annot annot_lst)
      with Invalid_argument _ ->
        `Code [maybe_symbol (fun e -> Cst.NoFormat e) code] in
    `Doc ret
