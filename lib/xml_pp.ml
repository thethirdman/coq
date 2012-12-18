let semistructured = ref false

let is_semistructured_pp () = !semistructured

let enable_semistructured_pp () = semistructured := true

let enable_flat_pp () = semistructured := false

type context_tag =
  | C_CNotation | C_Id | C_Ref | C_UnpMetaVar
  | C_UnpListMetaVar | C_UnpBinderListMetaVar | C_UnpTerminal
  | C_Name | C_GlobSort | C_CHole
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

(** This is a fatal error. *)
exception InvalidPpTag of string

let context_tag_of_string = function
  | "cnotation" -> C_CNotation
  | "id" -> C_Id
  | "ref" -> C_Ref
  | "unpmetavar" -> C_UnpMetaVar
  | "unplistmetavar" -> C_UnpListMetaVar
  | "unpbinderlistmetavar" -> C_UnpBinderListMetaVar
  | "unpterminal" -> C_UnpTerminal
  | "name" -> C_Name
  | "globsort" -> C_GlobSort
  | "hole" -> C_CHole
  | "explicitation" -> C_Explicitation
  | "qualid" -> C_Qualid
  | "patt" -> C_Patt
  | "binder" -> C_Binder
  | "recdecl" -> C_RecDecl
  | "fix" -> C_CFix
  | "cofix" -> C_CCoFix
  | "prodn" -> C_CProdN
  | "lambdan" -> C_CLambdaN
  | "letin" -> C_CLetIn
  | "appexpl" -> C_CAppExpl
  | "app" -> C_CApp
  | "record" -> C_CRecord
  | "cases" -> C_CCases
  | "lettuple" -> C_CLetTuple
  | "if" -> C_CIf
  | "evar" -> C_CEvar
  | "patvar" -> C_CPatVar
  | "sort" -> C_CSort
  | "cast" -> C_CCast
  | "generalization" -> C_CGeneralization
  | "cdelimiters" -> C_CDelimiters
  | "prim" -> C_CPrim
  | "abortall" -> V_AbortAll
  | "restart" -> V_Restart
  | "unfocus" -> V_Unfocus
  | "unfocused" -> V_Unfocused
  | "goal" -> V_Goal
  | "abort" -> V_Abort
  | "undo" -> V_Undo
  | "undoto" -> V_UndoTo
  | "backtrack" -> V_Backtrack
  | "focus" -> V_Focus
  | "show" -> V_Show
  | "checkguard" -> V_CheckGuard
  | "resetname" -> V_ResetName
  | "resetinitial" -> V_ResetInitial
  | "back" -> V_Back
  | "backto" -> V_BackTo
  | "writestate" -> V_WriteState
  | "restorestate" -> V_RestoreState
  | "list" -> V_List
  | "load" -> V_Load
  | "time" -> V_Time
  | "timeout" -> V_Timeout
  | "fail" -> V_Fail
  | "tacticnotation" -> V_TacticNotation
  | "openclosescope" -> V_OpenCloseScope
  | "vdelimiters" -> V_Delimiters
  | "bindscope" -> V_BindScope
  | "argumentscope" -> V_ArgumentScope
  | "infix" -> V_Infix
  | "vnotation" -> V_Notation
  | "syntaxextension" -> V_SyntaxExtension
  | "definition" -> V_Definition
  | "starttheoremproof" -> V_StartTheoremProof
  | "endproof" -> V_EndProof
  | "exactproof" -> V_ExactProof
  | "assumption" -> V_Assumption
  | "inductive" -> V_Inductive
  | "fixpoint" -> V_Fixpoint
  | "cofixpoint" -> V_CoFixpoint
  | "scheme" -> V_Scheme
  | "combinedscheme" -> V_CombinedScheme
  | "beginsection" -> V_BeginSection
  | "endsegment" -> V_EndSegment
  | "require" -> V_Require
  | "import" -> V_Import
  | "canonical" -> V_Canonical
  | "coercion" -> V_Coercion
  | "identitycoercion" -> V_IdentityCoercion
  | "instance" -> V_Instance
  | "context" -> V_Context
  | "declareinstances" -> V_DeclareInstances
  | "declareclass" -> V_DeclareClass
  | "definemodule" -> V_DefineModule
  | "declaremodule" -> V_DeclareModule
  | "declaremoduletype" -> V_DeclareModuleType
  | "include" -> V_Include
  | "solve" -> V_Solve
  | "solveexistential" -> V_SolveExistential
  | "requirefrom" -> V_RequireFrom
  | "addloadpath" -> V_AddLoadPath
  | "removeloadpath" -> V_RemoveLoadPath
  | "addmlpath" -> V_AddMLPath
  | "declaremlmodule" -> V_DeclareMLModule
  | "chdir" -> V_Chdir
  | "declaretacticdefinition" -> V_DeclareTacticDefinition
  | "createhintdb" -> V_CreateHintDb
  | "removehints" -> V_RemoveHints
  | "hints" -> V_Hints
  | "syntacticdefinition" -> V_SyntacticDefinition
  | "declareimplicits" -> V_DeclareImplicits
  | "arguments" -> V_Arguments
  | "reserve" -> V_Reserve
  | "generalizable" -> V_Generalizable
  | "setopacity" -> V_SetOpacity
  | "unsetoption" -> V_UnsetOption
  | "setoption" -> V_SetOption
  | "addoption" -> V_AddOption
  | "removeoption" -> V_RemoveOption
  | "memoption" -> V_MemOption
  | "printoption" -> V_PrintOption
  | "checkmayeval" -> V_CheckMayEval
  | "globalcheck" -> V_GlobalCheck
  | "declarereduction" -> V_DeclareReduction
  | "print" -> V_Print
  | "locate" -> V_Locate
  | "comments" -> V_Comments
  | "toplevelcontrol" -> V_ToplevelControl
  | "extend" -> V_Extend
  | "proof" -> V_Proof
  | "proofmode" -> V_ProofMode
  | "subproof" -> V_Subproof
  | "endsubproof" -> V_EndSubproof
  | "search" -> V_Search
  | "bullet" -> V_Bullet
  | s -> raise (InvalidPpTag s) 


let string_of_context_tag = function
  | C_CNotation -> "cnotation"
  | C_Id -> "id"
  | C_Ref -> "ref"
  | C_UnpMetaVar -> "unpmetavar"
  | C_UnpListMetaVar -> "unplistmetavar"
  | C_UnpBinderListMetaVar -> "unpbinderlistmetavar"
  | C_UnpTerminal -> "unpterminal"
  | C_Name   -> "name"
  | C_GlobSort -> "globsort"
  | C_CHole -> "hole"
  | C_Explicitation -> "explicitation"
  | C_Qualid -> "qualid"
  | C_Patt -> "patt"
  | C_Binder -> "binder"
  | C_RecDecl -> "recdecl"
  | C_CFix -> "fix"
  | C_CCoFix -> "cofix"
  | C_CProdN -> "prodn"
  | C_CLambdaN -> "lambdan"
  | C_CLetIn -> "letin"
  | C_CAppExpl -> "appexpl"
  | C_CApp -> "app"
  | C_CRecord -> "record"
  | C_CCases -> "cases"
  | C_CLetTuple -> "lettuple"
  | C_CIf -> "if"
  | C_CEvar -> "evar"
  | C_CPatVar -> "patvar"
  | C_CSort -> "sort"
  | C_CCast -> "cast"
  | C_CGeneralization -> "generalization"
  | C_CDelimiters -> "cdelimiters"
  | C_CPrim -> "prim"
  | V_AbortAll -> "abortall"
  | V_Restart -> "restart"
  | V_Unfocus -> "unfocus"
  | V_Unfocused -> "unfocused"
  | V_Goal -> "goal"
  | V_Abort -> "abort"
  | V_Undo -> "undo"
  | V_UndoTo -> "undoto"
  | V_Backtrack -> "backtrack"
  | V_Focus -> "focus"
  | V_Show -> "show"
  | V_CheckGuard -> "checkguard"
  | V_ResetName -> "resetname"
  | V_ResetInitial -> "resetinitial"
  | V_Back -> "back"
  | V_BackTo -> "backto"
  | V_WriteState -> "writestate"
  | V_RestoreState -> "restorestate"
  | V_List -> "list"
  | V_Load -> "load"
  | V_Time -> "time"
  | V_Timeout -> "timeout"
  | V_Fail -> "fail"
  | V_TacticNotation -> "tacticnotation"
  | V_OpenCloseScope -> "openclosescope"
  | V_Delimiters -> "vdelimiters"
  | V_BindScope -> "bindscope"
  | V_ArgumentScope -> "argumentscope"
  | V_Infix -> "infix"
  | V_Notation -> "vnotation"
  | V_SyntaxExtension -> "syntaxextension"
  | V_Definition -> "definition"
  | V_StartTheoremProof -> "starttheoremproof"
  | V_EndProof -> "endproof"
  | V_ExactProof -> "exactproof"
  | V_Assumption -> "assumption"
  | V_Inductive -> "inductive"
  | V_Fixpoint -> "fixpoint"
  | V_CoFixpoint -> "cofixpoint"
  | V_Scheme -> "scheme"
  | V_CombinedScheme -> "combinedscheme"
  | V_BeginSection -> "beginsection"
  | V_EndSegment -> "endsegment"
  | V_Require -> "require"
  | V_Import -> "import"
  | V_Canonical -> "canonical"
  | V_Coercion -> "coercion"
  | V_IdentityCoercion -> "identitycoercion"
  | V_Instance -> "instance"
  | V_Context -> "context"
  | V_DeclareInstances -> "declareinstances"
  | V_DeclareClass -> "declareclass"
  | V_DefineModule -> "definemodule"
  | V_DeclareModule -> "declaremodule"
  | V_DeclareModuleType -> "declaremoduletype"
  | V_Include -> "include"
  | V_Solve -> "solve"
  | V_SolveExistential -> "solveexistential"
  | V_RequireFrom -> "requirefrom"
  | V_AddLoadPath -> "addloadpath"
  | V_RemoveLoadPath -> "removeloadpath"
  | V_AddMLPath -> "addmlpath"
  | V_DeclareMLModule -> "declaremlmodule"
  | V_Chdir -> "chdir"
  | V_DeclareTacticDefinition -> "declaretacticdefinition"
  | V_CreateHintDb -> "createhintdb"
  | V_RemoveHints -> "removehints"
  | V_Hints -> "hints"
  | V_SyntacticDefinition -> "syntacticdefinition"
  | V_DeclareImplicits -> "declareimplicits"
  | V_Arguments -> "arguments"
  | V_Reserve -> "reserve"
  | V_Generalizable -> "generalizable"
  | V_SetOpacity -> "setopacity"
  | V_UnsetOption -> "unsetoption"
  | V_SetOption -> "setoption"
  | V_AddOption -> "addoption"
  | V_RemoveOption -> "removeoption"
  | V_MemOption -> "memoption"
  | V_PrintOption -> "printoption"
  | V_CheckMayEval -> "checkmayeval"
  | V_GlobalCheck -> "globalcheck"
  | V_DeclareReduction -> "declarereduction"
  | V_Print -> "print"
  | V_Locate -> "locate"
  | V_Comments -> "comments"
  | V_ToplevelControl -> "toplevelcontrol"
  | V_Extend -> "extend"
  | V_Proof -> "proof"
  | V_ProofMode -> "proofmode"
  | V_Subproof -> "subproof"
  | V_EndSubproof -> "endsubproof"
  | V_Search -> "search"
  | V_Bullet -> "bullet"

let tag_with_context pp_tag context elt =
  if not !semistructured then
    elt
  else
    pp_tag (string_of_context_tag context) elt
