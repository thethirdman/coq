(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, *   INRIA - CNRS - LIX - LRI - PPS - Copyright 1999-2012     *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

open Pp_control

(** Modify pretty printing functions behavior for emacs ouput (special
   chars inserted at some places). This function should called once in
   module [Options], that's all. *)
val make_pp_emacs:unit -> unit
val make_pp_nonemacs:unit -> unit

(** Pretty-printers. *)

type std_ppcmds

(** {6 Formatting commands} *)

val str  : string -> std_ppcmds
val stras : int * string -> std_ppcmds
val brk : int * int -> std_ppcmds
val tbrk : int * int -> std_ppcmds
val tab : unit -> std_ppcmds
val fnl : unit -> std_ppcmds
val pifb : unit -> std_ppcmds
val ws : int -> std_ppcmds
val mt : unit -> std_ppcmds
val ismt : std_ppcmds -> bool

val comment : int -> std_ppcmds
val comments : ((int * int) * string) list ref

(** {6 Manipulation commands} *)

val app : std_ppcmds -> std_ppcmds -> std_ppcmds
(** Concatenation. *)

val (++) : std_ppcmds -> std_ppcmds -> std_ppcmds
(** Infix alias for [app]. *)

val eval_ppcmds : std_ppcmds -> std_ppcmds
(** Force computation. *)

val is_empty : std_ppcmds -> bool
(** Test emptyness. *)

(** {6 Derived commands} *)

val spc : unit -> std_ppcmds
val cut : unit -> std_ppcmds
val align : unit -> std_ppcmds
val int : int -> std_ppcmds
val real : float -> std_ppcmds
val bool : bool -> std_ppcmds
val qstring : string -> std_ppcmds
val qs : string -> std_ppcmds
val quote : std_ppcmds -> std_ppcmds
val strbrk : string -> std_ppcmds

val xmlescape : std_ppcmds -> std_ppcmds

(** {6 Boxing commands} *)

val h : int -> std_ppcmds -> std_ppcmds
val v : int -> std_ppcmds -> std_ppcmds
val hv : int -> std_ppcmds -> std_ppcmds
val hov : int -> std_ppcmds -> std_ppcmds
val t : std_ppcmds -> std_ppcmds

(** {6 Opening and closing of boxes} *)

val hb : int -> std_ppcmds
val vb : int -> std_ppcmds
val hvb : int -> std_ppcmds
val hovb : int -> std_ppcmds
val tb : unit -> std_ppcmds
val close : unit -> std_ppcmds
val tclose : unit -> std_ppcmds

(** {6 Sending messages to the user} *)

type logger = Interface.message_level -> std_ppcmds -> unit

val msg_info : std_ppcmds -> unit
(** Message that displays information, usually in verbose mode, such as [Foobar
    is defined] *)

val msg_notice : std_ppcmds -> unit
(** Message that should be displayed, such as [Print Foo] or [Show Bar]. *)

val msg_warning : std_ppcmds -> unit
(** Message indicating that something went wrong, but without serious 
    consequences. *)

val msg_error : std_ppcmds -> unit
(** Message indicating that something went really wrong, though still 
    recoverable; otherwise an exception would have been raised. *)

val msg_debug : std_ppcmds -> unit
(** For debugging purposes *)

val std_logger : logger
(** Standard logging function *)

val set_logger : logger -> unit

(** {6 Utilities} *)

val string_of_ppcmds : std_ppcmds -> string

(** {6 Printing combinators} *)

val pr_comma : unit -> std_ppcmds
(** Well-spaced comma. *)

val pr_semicolon : unit -> std_ppcmds
(** Well-spaced semicolon. *)

val pr_bar : unit -> std_ppcmds
(** Well-spaced pipe bar. *)

val pr_arg : ('a -> std_ppcmds) -> 'a -> std_ppcmds
(** Adds a space in front of its argument. *)

val pr_opt : ('a -> std_ppcmds) -> 'a option -> std_ppcmds
(** Inner object preceded with a space if [Some], nothing otherwise. *)

val pr_opt_no_spc : ('a -> std_ppcmds) -> 'a option -> std_ppcmds
(** Same as [pr_opt] but without the leading space. *)

val pr_nth : int -> std_ppcmds
(** Ordinal number with the correct suffix (i.e. "st", "nd", "th", etc.). *)

val prlist : ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** Concatenation of the list contents, without any separator.

    Unlike all other functions below, [prlist] works lazily. If a strict 
    behavior is needed, use [prlist_strict] instead. *)

val prlist_strict :  ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** Same as [prlist], but strict. *)

val prlist_with_sep :
   (unit -> std_ppcmds) -> ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** [prlist_with_sep sep pr [a ; ... ; c]] outputs
    [pr a ++ sep() ++ ... ++ sep() ++ pr c]. *)

val prvect : ('a -> std_ppcmds) -> 'a array -> std_ppcmds
(** As [prlist], but on arrays. *)

val prvecti : (int -> 'a -> std_ppcmds) -> 'a array -> std_ppcmds
(** Indexed version of [prvect]. *)

val prvect_with_sep :
   (unit -> std_ppcmds) -> ('a -> std_ppcmds) -> 'a array -> std_ppcmds
(** As [prlist_with_sep], but on arrays. *)

val prvecti_with_sep :
   (unit -> std_ppcmds) -> (int -> 'a -> std_ppcmds) -> 'a array -> std_ppcmds
(** Indexed version of [prvect_with_sep]. *)

val pr_enum : ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** [pr_enum pr [a ; b ; ... ; c]] outputs
    [pr a ++ str "," ++ pr b ++ str "," ++ ... ++ str "and" ++ pr c]. *)

val pr_sequence : ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** Sequence of objects separated by space (unless an element is empty). *)

val surround : std_ppcmds -> std_ppcmds
(** Surround with parenthesis. *)

val pr_vertical_list : ('b -> std_ppcmds) -> 'b list -> std_ppcmds

(** {6 Low-level pretty-printing functions {% \emph{%}without flush{% }%}. } *)

val pp_with : Format.formatter -> std_ppcmds -> unit
val ppnl_with : Format.formatter -> std_ppcmds -> unit
val pp_flush_with : Format.formatter -> unit -> unit

(** {6 Pretty-printing functions {% \emph{%}without flush{% }%} on [stdout] and [stderr]. } *)

(** These functions are low-level interface to printing and should not be used
    in usual code. Consider using the [msg_*] function family instead. *)

val pp : std_ppcmds -> unit
val ppnl : std_ppcmds -> unit
val pperr : std_ppcmds -> unit
val pperrnl : std_ppcmds -> unit
val pperr_flush : unit -> unit
val pp_flush : unit -> unit
val flush_all: unit -> unit

(** Modify pretty printing for Xml output:
  * We chose to do std_ppcmds -> std_ppcmds translation for the sake
  * of simplicity. This way, we just have to annotate the pp[constr|vernac]
  * with the type needed.
  * An interesting improvement would be to translate to the XML type, but
  * this requires a lot more code modifications
  *)

type context_handler = C_CNotation | C_Id | C_Ref | C_UnpMetaVar
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

val explicit : bool ref
val handle : context_handler -> std_ppcmds -> std_ppcmds

exception Context_error of string
val context_of_string : string -> context_handler


(** {6 Deprecated functions} *)

(** DEPRECATED. Do not use in newly written code. *)

val msg_with : Format.formatter -> std_ppcmds -> unit

val msg : std_ppcmds -> unit
val msgnl : std_ppcmds -> unit
val msgerr : std_ppcmds -> unit
val msgerrnl : std_ppcmds -> unit
val message : string -> unit       (** = pPNL *)
