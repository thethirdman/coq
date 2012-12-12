(** This module offers a way to semi-structure the output of the {Pp}
    module by issueing tags opening and closing at some specific
    points of the stream of pretty-printing commands.

    This feature is used by coqdoc to allow user-defined
    pretty-printing of some subterms depending on their nature. For
    instance, this allows the use of LaTeX command to display 
    a Coq notation. 

    This mechanism could also be used by coqide in the future to
    implement code folding.
*)

(** Enable semi-structured pretty-printing. *)
val enable_semistructured_pp : unit -> unit

(** Disable semi-structured pretty-printing. *)
val enable_flat_pp : unit -> unit

(** Are we currently producing a semi-structured pretty-printing? *)
val is_semistructured_pp : unit -> bool

(** The following tags are inserted in the flow of pretty-printing
    commands. They correspond to the name of data constructors of
    the type [constr_expr] and [vernac_expr]. *)
type context_tag = C_CNotation | C_Id | C_Ref | C_UnpMetaVar
    | C_UnpListMetaVar | C_UnpBinderListMetaVar | C_UnpTerminal | C_UnpBox
    | C_UnpCut | C_Name | C_GlobSort | C_CHole
    | C_Explicitation | C_Qualid | C_Patt | C_Binder | C_RecDecl
    | C_CFix | C_CCoFix | C_CProdN | C_CLambdaN | C_CLetIn | C_CAppExpl
    | C_CApp | C_CRecord | C_CCases | C_CLetTuple | C_CIf | C_CEvar | C_CPatVar
    | C_CSort | C_CCast | C_CGeneralization | C_CDelimiters | C_CPrim
    | V_AbortAll | V_Restart | V_Unfocus | V_Unfocused | V_Goal | V_Abort
    | V_Undo | V_UndoTo | V_Backtrack | V_Focus | V_Show | V_CheckGuard
    | V_ResetName | V_ResetInitial | V_Back | V_BackTo | V_WriteState
    | V_RestoreState | V_List | V_Load | V_Time | V_Timeout | V_Fail
    | V_TacticNotation | V_OpenCloseScope | V_Delimiters | V_BindScope
    | V_ArgumentScope | V_Infix | V_Notation | V_SyntaxExtension
    | V_Definition | V_StartTheoremProof | V_EndProof | V_ExactProof
    | V_Assumption | V_Inductive | V_Fixpoint | V_CoFixpoint | V_Scheme
    | V_CombinedScheme | V_BeginSection | V_EndSegment | V_Require | V_Import
    | V_Canonical | V_Coercion | V_IdentityCoercion | V_Instance | V_Context
    | V_DeclareInstances | V_DeclareClass | V_DefineModule | V_DeclareModule
    | V_DeclareModuleType | V_Include | V_Solve | V_SolveExistential
    | V_RequireFrom | V_AddLoadPath | V_RemoveLoadPath | V_AddMLPath
    | V_DeclareMLModule | V_Chdir | V_DeclareTacticDefinition | V_CreateHintDb
    | V_RemoveHints | V_Hints | V_SyntacticDefinition | V_DeclareImplicits
    | V_Arguments | V_Reserve | V_Generalizable | V_SetOpacity | V_UnsetOption
    | V_SetOption | V_AddOption | V_RemoveOption | V_MemOption | V_PrintOption
    | V_CheckMayEval | V_GlobalCheck | V_DeclareReduction | V_Print | V_Locate
    | V_Comments | V_ToplevelControl | V_Extend | V_Proof | V_ProofMode
    | V_Subproof | V_EndSubproof | V_Search | V_Bullet

(** [context_of_string s] translates [s] as a tag. Raise [InvalidPpTag s] if
    [s] is not a correct representation for a tag. *)
val context_tag_of_string : string -> context_tag
exception InvalidPpTag of string

(** [tag_with_context pp_tag ctx x] decorates [x] by an opening tag
    and a closing tag named [ctx] using [pp_tag] if semi-structured
    pretty-printing is enabled. *)
val tag_with_context : (string -> 'a -> 'a) -> context_tag -> 'a -> 'a


