(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, *   INRIA - CNRS - LIX - LRI - PPS - Copyright 1999-2012     *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

open Libobject
open Pattern
open Pp
open Genredexpr
open Glob_term
open Tacred
open Errors
open Util
open Names
open Nameops
open Libnames
open Globnames
open Nametab
open Smartlocate
open Constrexpr
open Constrexpr_ops
open Termops
open Tacexpr
open Genarg
open Mod_subst
open Extrawit
open Misctypes
open Locus

(** Globalization of tactic expressions :
    Conversion from [raw_tactic_expr] to [glob_tactic_expr] *)

let dloc = Loc.ghost

let error_global_not_found_loc (loc,qid) =
  error_global_not_found_loc loc qid

let error_syntactic_metavariables_not_allowed loc =
  user_err_loc
    (loc,"out_ident",
     str "Syntactic metavariables allowed only in quotations.")

let error_tactic_expected loc =
  user_err_loc (loc,"",str "Tactic expected.")

let skip_metaid = function
  | AI x -> x
  | MetaId (loc,_) -> error_syntactic_metavariables_not_allowed loc

(** Generic arguments *)

type glob_sign = {
  ltacvars : Id.t list * Id.t list;
     (* ltac variables and the subset of vars introduced by Intro/Let/... *)
  ltacrecvars : (Id.t * ltac_constant) list;
     (* ltac recursive names *)
  gsigma : Evd.evar_map;
  genv : Environ.env }

let fully_empty_glob_sign =
  { ltacvars = ([],[]); ltacrecvars = [];
    gsigma = Evd.empty; genv = Environ.empty_env }

let make_empty_glob_sign () =
  { fully_empty_glob_sign with genv = Global.env () }

type intern_genarg_type =
    glob_sign -> raw_generic_argument -> glob_generic_argument

let genarginterns =
  ref (String.Map.empty : intern_genarg_type String.Map.t)

let add_intern_genarg id f =
  genarginterns := String.Map.add id f !genarginterns

let lookup_intern_genarg id =
  try String.Map.find id !genarginterns
  with Not_found ->
    let msg = "No globalization function found for entry "^id in
    Pp.msg_warning (Pp.strbrk msg);
    let dflt = fun _ _ -> failwith msg in
    add_intern_genarg id dflt;
    dflt

(* Table of "pervasives" macros tactics (e.g. auto, simpl, etc.) *)

let atomic_mactab = ref Id.Map.empty
let add_primitive_tactic s tac =
  let id = Id.of_string s in
  atomic_mactab := Id.Map.add id tac !atomic_mactab

let _ =
  let nocl = {onhyps=Some[];concl_occs=AllOccurrences} in
  List.iter
      (fun (s,t) -> add_primitive_tactic s (TacAtom(dloc,t)))
      [ "red", TacReduce(Red false,nocl);
        "hnf", TacReduce(Hnf,nocl);
        "simpl", TacReduce(Simpl None,nocl);
        "compute", TacReduce(Cbv Redops.all_flags,nocl);
        "intro", TacIntroMove(None,MoveLast);
        "intros", TacIntroPattern [];
        "assumption", TacAssumption;
        "cofix", TacCofix None;
        "trivial", TacTrivial (Off,[],None);
        "auto", TacAuto(Off,None,[],None);
        "left", TacLeft(false,NoBindings);
        "eleft", TacLeft(true,NoBindings);
        "right", TacRight(false,NoBindings);
        "eright", TacRight(true,NoBindings);
        "split", TacSplit(false,false,[NoBindings]);
        "esplit", TacSplit(true,false,[NoBindings]);
        "constructor", TacAnyConstructor (false,None);
        "econstructor", TacAnyConstructor (true,None);
        "reflexivity", TacReflexivity;
        "symmetry", TacSymmetry nocl
      ];
  List.iter
      (fun (s,t) -> add_primitive_tactic s t)
      [ "idtac",TacId [];
        "fail", TacFail(ArgArg 0,[]);
        "fresh", TacArg(dloc,TacFreshId [])
      ]

let lookup_atomic id = Id.Map.find id !atomic_mactab
let is_atomic_kn kn =
  let (_,_,l) = repr_kn kn in
  Id.Map.mem (id_of_label l) !atomic_mactab

(* Tactics table (TacExtend). *)

let tac_tab = Hashtbl.create 17

let add_tactic s t =
  if Hashtbl.mem tac_tab s then
    errorlabstrm ("Refiner.add_tactic: ")
      (str ("Cannot redeclare tactic "^s^"."));
  Hashtbl.add tac_tab s t

let overwriting_add_tactic s t =
  if Hashtbl.mem tac_tab s then begin
    Hashtbl.remove tac_tab s;
    msg_warning (strbrk ("Overwriting definition of tactic "^s))
  end;
  Hashtbl.add tac_tab s t

let lookup_tactic s =
  try
    Hashtbl.find tac_tab s
  with Not_found ->
    errorlabstrm "Refiner.lookup_tactic"
      (str"The tactic " ++ str s ++ str" is not installed.")

(* Summary and Object declaration *)

let mactab = ref (Gmap.empty : (ltac_constant,glob_tactic_expr) Gmap.t)

let lookup_ltacref r = Gmap.find r !mactab

let _ =
  Summary.declare_summary "tactic-definition"
    { Summary.freeze_function   = (fun () -> !mactab);
      Summary.unfreeze_function = (fun fs -> mactab := fs);
      Summary.init_function     = (fun () -> mactab := Gmap.empty); }



(* We have identifier <| global_reference <| constr *)

let find_ident id ist =
  List.mem id (fst ist.ltacvars) or
  List.mem id (ids_of_named_context (Environ.named_context ist.genv))

let find_recvar qid ist = List.assoc qid ist.ltacrecvars

(* a "var" is a ltac var or a var introduced by an intro tactic *)
let find_var id ist = List.mem id (fst ist.ltacvars)

(* a "ctxvar" is a var introduced by an intro tactic (Intro/LetTac/...) *)
let find_ctxvar id ist = List.mem id (snd ist.ltacvars)

(* a "ltacvar" is an ltac var (Let-In/Fun/...) *)
let find_ltacvar id ist = find_var id ist & not (find_ctxvar id ist)

let find_hyp id ist =
  List.mem id (ids_of_named_context (Environ.named_context ist.genv))

(* Globalize a name introduced by Intro/LetTac/... ; it is allowed to *)
(* be fresh in which case it is binding later on *)
let intern_ident l ist id =
  (* We use identifier both for variables and new names; thus nothing to do *)
  if not (find_ident id ist) then l:=(id::fst !l,id::snd !l);
  id

let intern_name l ist = function
  | Anonymous -> Anonymous
  | Name id -> Name (intern_ident l ist id)

let strict_check = ref false

let adjust_loc loc = if !strict_check then dloc else loc

(* Globalize a name which must be bound -- actually just check it is bound *)
let intern_hyp ist (loc,id as locid) =
  if not !strict_check then
    locid
  else if find_ident id ist then
    (dloc,id)
  else
    Pretype_errors.error_var_not_found_loc loc id

let intern_hyp_or_metaid ist id = intern_hyp ist (skip_metaid id)

let intern_or_var ist = function
  | ArgVar locid -> ArgVar (intern_hyp ist locid)
  | ArgArg _ as x -> x

let intern_inductive_or_by_notation = smart_global_inductive

let intern_inductive ist = function
  | AN (Ident (loc,id)) when find_var id ist -> ArgVar (loc,id)
  | r -> ArgArg (intern_inductive_or_by_notation r)

let intern_global_reference ist = function
  | Ident (loc,id) when find_var id ist -> ArgVar (loc,id)
  | r ->
      let loc,_ as lqid = qualid_of_reference r in
      try ArgArg (loc,locate_global_with_alias lqid)
      with Not_found -> error_global_not_found_loc lqid

let intern_ltac_variable ist = function
  | Ident (loc,id) ->
      if find_ltacvar id ist then
	(* A local variable of any type *)
	ArgVar (loc,id)
      else
      (* A recursive variable *)
      ArgArg (loc,find_recvar id ist)
  | _ ->
      raise Not_found

let intern_constr_reference strict ist = function
  | Ident (_,id) as r when not strict & find_hyp id ist ->
      GVar (dloc,id), Some (CRef r)
  | Ident (_,id) as r when find_ctxvar id ist ->
      GVar (dloc,id), if strict then None else Some (CRef r)
  | r ->
      let loc,_ as lqid = qualid_of_reference r in
      GRef (loc,locate_global_with_alias lqid), if strict then None else Some (CRef r)

let intern_move_location ist = function
  | MoveAfter id -> MoveAfter (intern_hyp_or_metaid ist id)
  | MoveBefore id -> MoveBefore (intern_hyp_or_metaid ist id)
  | MoveFirst -> MoveFirst
  | MoveLast -> MoveLast

(* Internalize an isolated reference in position of tactic *)

let intern_isolated_global_tactic_reference r =
  let (loc,qid) = qualid_of_reference r in
  try TacCall (loc,ArgArg (loc,locate_tactic qid),[])
  with Not_found ->
  match r with
  | Ident (_,id) -> Tacexp (lookup_atomic id)
  | _ -> raise Not_found

let intern_isolated_tactic_reference strict ist r =
  (* An ltac reference *)
  try Reference (intern_ltac_variable ist r)
  with Not_found ->
  (* A global tactic *)
  try intern_isolated_global_tactic_reference r
  with Not_found ->
  (* Tolerance for compatibility, allow not to use "constr:" *)
  try ConstrMayEval (ConstrTerm (intern_constr_reference strict ist r))
  with Not_found ->
  (* Reference not found *)
  error_global_not_found_loc (qualid_of_reference r)

(* Internalize an applied tactic reference *)

let intern_applied_global_tactic_reference r =
  let (loc,qid) = qualid_of_reference r in
  ArgArg (loc,locate_tactic qid)

let intern_applied_tactic_reference ist r =
  (* An ltac reference *)
  try intern_ltac_variable ist r
  with Not_found ->
  (* A global tactic *)
  try intern_applied_global_tactic_reference r
  with Not_found ->
  (* Reference not found *)
  error_global_not_found_loc (qualid_of_reference r)

(* Intern a reference parsed in a non-tactic entry *)

let intern_non_tactic_reference strict ist r =
  (* An ltac reference *)
  try Reference (intern_ltac_variable ist r)
  with Not_found ->
  (* A constr reference *)
  try ConstrMayEval (ConstrTerm (intern_constr_reference strict ist r))
  with Not_found ->
  (* Tolerance for compatibility, allow not to use "ltac:" *)
  try intern_isolated_global_tactic_reference r
  with Not_found ->
  (* By convention, use IntroIdentifier for unbound ident, when not in a def *)
  match r with
  | Ident (loc,id) when not strict -> IntroPattern (loc,IntroIdentifier id)
  | _ ->
  (* Reference not found *)
  error_global_not_found_loc (qualid_of_reference r)

let intern_message_token ist = function
  | (MsgString _ | MsgInt _ as x) -> x
  | MsgIdent id -> MsgIdent (intern_hyp_or_metaid ist id)

let intern_message ist = List.map (intern_message_token ist)

let rec intern_intro_pattern lf ist = function
  | loc, IntroOrAndPattern l ->
      loc, IntroOrAndPattern (intern_or_and_intro_pattern lf ist l)
  | loc, IntroIdentifier id ->
      loc, IntroIdentifier (intern_ident lf ist id)
  | loc, IntroFresh id ->
      loc, IntroFresh (intern_ident lf ist id)
  | loc, (IntroWildcard | IntroAnonymous | IntroRewrite _ | IntroForthcoming _)
      as x -> x

and intern_or_and_intro_pattern lf ist =
  List.map (List.map (intern_intro_pattern lf ist))

let intern_quantified_hypothesis ist = function
  | AnonHyp n -> AnonHyp n
  | NamedHyp id ->
      (* Uncomment to disallow "intros until n" in ltac when n is not bound *)
      NamedHyp ((*snd (intern_hyp ist (dloc,*)id(* ))*))

let intern_binding_name ist x =
  (* We use identifier both for variables and binding names *)
  (* Todo: consider the body of the lemma to which the binding refer
     and if a term w/o ltac vars, check the name is indeed quantified *)
  x

let intern_constr_gen allow_patvar isarity {ltacvars=lfun; gsigma=sigma; genv=env} c =
  let warn = if !strict_check then fun x -> x else Constrintern.for_grammar in
  let scope = if isarity then Pretyping.IsType else Pretyping.OfType None in
  let c' =
    warn (Constrintern.intern_gen scope ~allow_patvar ~ltacvars:(fst lfun,[]) sigma env) c
  in
  (c',if !strict_check then None else Some c)

let intern_constr = intern_constr_gen false false
let intern_type = intern_constr_gen false true

(* Globalize bindings *)
let intern_binding ist (loc,b,c) =
  (loc,intern_binding_name ist b,intern_constr ist c)

let intern_bindings ist = function
  | NoBindings -> NoBindings
  | ImplicitBindings l -> ImplicitBindings (List.map (intern_constr ist) l)
  | ExplicitBindings l -> ExplicitBindings (List.map (intern_binding ist) l)

let intern_constr_with_bindings ist (c,bl) =
  (intern_constr ist c, intern_bindings ist bl)

  (* TODO: catch ltac vars *)
let intern_induction_arg ist = function
  | ElimOnConstr c -> ElimOnConstr (intern_constr_with_bindings ist c)
  | ElimOnAnonHyp n as x -> x
  | ElimOnIdent (loc,id) ->
      if !strict_check then
	(* If in a defined tactic, no intros-until *)
	match intern_constr ist (CRef (Ident (dloc,id))) with
	| GVar (loc,id),_ -> ElimOnIdent (loc,id)
	| c -> ElimOnConstr (c,NoBindings)
      else
	ElimOnIdent (loc,id)

let short_name = function
  | AN (Ident (loc,id)) when not !strict_check -> Some (loc,id)
  | _ -> None

let intern_evaluable_global_reference ist r =
  let lqid = qualid_of_reference r in
  try evaluable_of_global_reference ist.genv (locate_global_with_alias lqid)
  with Not_found ->
  match r with
  | Ident (loc,id) when not !strict_check -> EvalVarRef id
  | _ -> error_global_not_found_loc lqid

let intern_evaluable_reference_or_by_notation ist = function
  | AN r -> intern_evaluable_global_reference ist r
  | ByNotation (loc,ntn,sc) ->
      evaluable_of_global_reference ist.genv
      (Notation.interp_notation_as_global_reference loc
        (function ConstRef _ | VarRef _ -> true | _ -> false) ntn sc)

(* Globalize a reduction expression *)
let intern_evaluable ist = function
  | AN (Ident (loc,id)) when find_ltacvar id ist -> ArgVar (loc,id)
  | AN (Ident (loc,id)) when not !strict_check & find_hyp id ist ->
      ArgArg (EvalVarRef id, Some (loc,id))
  | AN (Ident (loc,id)) when find_ctxvar id ist ->
      ArgArg (EvalVarRef id, if !strict_check then None else Some (loc,id))
  | r ->
      let e = intern_evaluable_reference_or_by_notation ist r in
      let na = short_name r in
      ArgArg (e,na)

let intern_unfold ist (l,qid) = (l,intern_evaluable ist qid)

let intern_flag ist red =
  { red with rConst = List.map (intern_evaluable ist) red.rConst }

let intern_constr_with_occurrences ist (l,c) = (l,intern_constr ist c)

let intern_constr_pattern ist ltacvars pc =
  let metas,pat =
    Constrintern.intern_constr_pattern ist.gsigma ist.genv ~ltacvars pc in
  let c = intern_constr_gen true false ist pc in
  metas,(c,pat)

let intern_typed_pattern ist p =
  let dummy_pat = PRel 0 in
  (* we cannot ensure in non strict mode that the pattern is closed *)
  (* keeping a constr_expr copy is too complicated and we want anyway to *)
  (* type it, so we remember the pattern as a glob_constr only *)
  (intern_constr_gen true false ist p,dummy_pat)

let intern_typed_pattern_with_occurrences ist (l,p) =
  (l,intern_typed_pattern ist p)

(* This seems fairly hacky, but it's the first way I've found to get proper
   globalization of [unfold].  --adamc *)
let dump_glob_red_expr = function
  | Unfold occs -> List.iter (fun (_, r) ->
    try
      Dumpglob.add_glob (loc_of_or_by_notation Libnames.loc_of_reference r)
	(Smartlocate.smart_global r)
    with _ -> ()) occs
  | Cbv grf | Lazy grf ->
    List.iter (fun r ->
      try
        Dumpglob.add_glob (loc_of_or_by_notation Libnames.loc_of_reference r)
	  (Smartlocate.smart_global r)
      with _ -> ()) grf.rConst
  | _ -> ()

let intern_red_expr ist = function
  | Unfold l -> Unfold (List.map (intern_unfold ist) l)
  | Fold l -> Fold (List.map (intern_constr ist) l)
  | Cbv f -> Cbv (intern_flag ist f)
  | Lazy f -> Lazy (intern_flag ist f)
  | Pattern l -> Pattern (List.map (intern_constr_with_occurrences ist) l)
  | Simpl o -> Simpl (Option.map (intern_typed_pattern_with_occurrences ist) o)
  | CbvVm o -> CbvVm (Option.map (intern_typed_pattern_with_occurrences ist) o)
  | (Red _ | Hnf | ExtraRedExpr _ as r ) -> r

let intern_in_hyp_as ist lf (id,ipat) =
  (intern_hyp_or_metaid ist id, Option.map (intern_intro_pattern lf ist) ipat)

let intern_hyp_list ist = List.map (intern_hyp_or_metaid ist)

let intern_inversion_strength lf ist = function
  | NonDepInversion (k,idl,ids) ->
      NonDepInversion (k,intern_hyp_list ist idl,
      Option.map (intern_intro_pattern lf ist) ids)
  | DepInversion (k,copt,ids) ->
      DepInversion (k, Option.map (intern_constr ist) copt,
      Option.map (intern_intro_pattern lf ist) ids)
  | InversionUsing (c,idl) ->
      InversionUsing (intern_constr ist c, intern_hyp_list ist idl)

(* Interprets an hypothesis name *)
let intern_hyp_location ist ((occs,id),hl) =
  ((Locusops.occurrences_map (List.map (intern_or_var ist)) occs,
   intern_hyp_or_metaid ist id), hl)

(* Reads a pattern *)
let intern_pattern ist ?(as_type=false) lfun = function
  | Subterm (b,ido,pc) ->
      let ltacvars = (lfun,[]) in
      let (metas,pc) = intern_constr_pattern ist ltacvars pc in
      ido, metas, Subterm (b,ido,pc)
  | Term pc ->
      let ltacvars = (lfun,[]) in
      let (metas,pc) = intern_constr_pattern ist ltacvars pc in
      None, metas, Term pc

let intern_constr_may_eval ist = function
  | ConstrEval (r,c) -> ConstrEval (intern_red_expr ist r,intern_constr ist c)
  | ConstrContext (locid,c) ->
      ConstrContext (intern_hyp ist locid,intern_constr ist c)
  | ConstrTypeOf c -> ConstrTypeOf (intern_constr ist c)
  | ConstrTerm c -> ConstrTerm (intern_constr ist c)


(* Reads the hypotheses of a "match goal" rule *)
let rec intern_match_goal_hyps ist lfun = function
  | (Hyp ((_,na) as locna,mp))::tl ->
      let ido, metas1, pat = intern_pattern ist ~as_type:true lfun mp in
      let lfun, metas2, hyps = intern_match_goal_hyps ist lfun tl in
      let lfun' = name_cons na (Option.List.cons ido lfun) in
      lfun', metas1@metas2, Hyp (locna,pat)::hyps
  | (Def ((_,na) as locna,mv,mp))::tl ->
      let ido, metas1, patv = intern_pattern ist ~as_type:false lfun mv in
      let ido', metas2, patt = intern_pattern ist ~as_type:true lfun mp in
      let lfun, metas3, hyps = intern_match_goal_hyps ist lfun tl in
      let lfun' = name_cons na (Option.List.cons ido' (Option.List.cons ido lfun)) in
      lfun', metas1@metas2@metas3, Def (locna,patv,patt)::hyps
  | [] -> lfun, [], []

(* Utilities *)
let extract_let_names lrc =
  List.fold_right
    (fun ((loc,name),_) l ->
      if List.mem name l then
	user_err_loc
	  (loc, "glob_tactic", str "This variable is bound several times.");
      name::l)
    lrc []

let clause_app f = function
    { onhyps=None; concl_occs=nl } ->
      { onhyps=None; concl_occs=nl }
  | { onhyps=Some l; concl_occs=nl } ->
      { onhyps=Some(List.map f l); concl_occs=nl}

(* Globalizes tactics : raw_tactic_expr -> glob_tactic_expr *)
let rec intern_atomic lf ist x =
  match (x:raw_atomic_tactic_expr) with
  (* Basic tactics *)
  | TacIntroPattern l ->
      TacIntroPattern (List.map (intern_intro_pattern lf ist) l)
  | TacIntrosUntil hyp -> TacIntrosUntil (intern_quantified_hypothesis ist hyp)
  | TacIntroMove (ido,hto) ->
      TacIntroMove (Option.map (intern_ident lf ist) ido,
                    intern_move_location ist hto)
  | TacAssumption -> TacAssumption
  | TacExact c -> TacExact (intern_constr ist c)
  | TacExactNoCheck c -> TacExactNoCheck (intern_constr ist c)
  | TacVmCastNoCheck c -> TacVmCastNoCheck (intern_constr ist c)
  | TacApply (a,ev,cb,inhyp) ->
      TacApply (a,ev,List.map (intern_constr_with_bindings ist) cb,
                Option.map (intern_in_hyp_as ist lf) inhyp)
  | TacElim (ev,cb,cbo) ->
      TacElim (ev,intern_constr_with_bindings ist cb,
               Option.map (intern_constr_with_bindings ist) cbo)
  | TacElimType c -> TacElimType (intern_type ist c)
  | TacCase (ev,cb) -> TacCase (ev,intern_constr_with_bindings ist cb)
  | TacCaseType c -> TacCaseType (intern_type ist c)
  | TacFix (idopt,n) -> TacFix (Option.map (intern_ident lf ist) idopt,n)
  | TacMutualFix (id,n,l) ->
      let f (id,n,c) = (intern_ident lf ist id,n,intern_type ist c) in
      TacMutualFix (intern_ident lf ist id, n, List.map f l)
  | TacCofix idopt -> TacCofix (Option.map (intern_ident lf ist) idopt)
  | TacMutualCofix (id,l) ->
      let f (id,c) = (intern_ident lf ist id,intern_type ist c) in
      TacMutualCofix (intern_ident lf ist id, List.map f l)
  | TacCut c -> TacCut (intern_type ist c)
  | TacAssert (otac,ipat,c) ->
      TacAssert (Option.map (intern_pure_tactic ist) otac,
                 Option.map (intern_intro_pattern lf ist) ipat,
                 intern_constr_gen false (not (Option.is_empty otac)) ist c)
  | TacGeneralize cl ->
      TacGeneralize (List.map (fun (c,na) ->
	               intern_constr_with_occurrences ist c,
                       intern_name lf ist na) cl)
  | TacGeneralizeDep c -> TacGeneralizeDep (intern_constr ist c)
  | TacLetTac (na,c,cls,b,eqpat) ->
      let na = intern_name lf ist na in
      TacLetTac (na,intern_constr ist c,
                 (clause_app (intern_hyp_location ist) cls),b,
		 (Option.map (intern_intro_pattern lf ist) eqpat))

  (* Automation tactics *)
  | TacTrivial (d,lems,l) -> TacTrivial (d,List.map (intern_constr ist) lems,l)
  | TacAuto (d,n,lems,l) ->
      TacAuto (d,Option.map (intern_or_var ist) n,
        List.map (intern_constr ist) lems,l)

  (* Derived basic tactics *)
  | TacSimpleInductionDestruct (isrec,h) ->
      TacSimpleInductionDestruct (isrec,intern_quantified_hypothesis ist h)
  | TacInductionDestruct (ev,isrec,(l,el,cls)) ->
      TacInductionDestruct (ev,isrec,(List.map (fun (c,(ipato,ipats)) ->
	      (intern_induction_arg ist c,
               (Option.map (intern_intro_pattern lf ist) ipato,
	        Option.map (intern_intro_pattern lf ist) ipats))) l,
               Option.map (intern_constr_with_bindings ist) el,
               Option.map (clause_app (intern_hyp_location ist)) cls))
  | TacDoubleInduction (h1,h2) ->
      let h1 = intern_quantified_hypothesis ist h1 in
      let h2 = intern_quantified_hypothesis ist h2 in
      TacDoubleInduction (h1,h2)
  | TacDecomposeAnd c -> TacDecomposeAnd (intern_constr ist c)
  | TacDecomposeOr c -> TacDecomposeOr (intern_constr ist c)
  | TacDecompose (l,c) -> let l = List.map (intern_inductive ist) l in
      TacDecompose (l,intern_constr ist c)
  | TacSpecialize (n,l) -> TacSpecialize (n,intern_constr_with_bindings ist l)
  | TacLApply c -> TacLApply (intern_constr ist c)

  (* Context management *)
  | TacClear (b,l) -> TacClear (b,List.map (intern_hyp_or_metaid ist) l)
  | TacClearBody l -> TacClearBody (List.map (intern_hyp_or_metaid ist) l)
  | TacMove (dep,id1,id2) ->
    TacMove (dep,intern_hyp_or_metaid ist id1,intern_move_location ist id2)
  | TacRename l ->
      TacRename (List.map (fun (id1,id2) ->
			     intern_hyp_or_metaid ist id1,
			     intern_hyp_or_metaid ist id2) l)
  | TacRevert l -> TacRevert (List.map (intern_hyp_or_metaid ist) l)

  (* Constructors *)
  | TacLeft (ev,bl) -> TacLeft (ev,intern_bindings ist bl)
  | TacRight (ev,bl) -> TacRight (ev,intern_bindings ist bl)
  | TacSplit (ev,b,bll) -> TacSplit (ev,b,List.map (intern_bindings ist) bll)
  | TacAnyConstructor (ev,t) -> TacAnyConstructor (ev,Option.map (intern_pure_tactic ist) t)
  | TacConstructor (ev,n,bl) -> TacConstructor (ev,intern_or_var ist n,intern_bindings ist bl)

  (* Conversion *)
  | TacReduce (r,cl) ->
      dump_glob_red_expr r;
      TacReduce (intern_red_expr ist r, clause_app (intern_hyp_location ist) cl)
  | TacChange (None,c,cl) ->
      let is_onhyps = match cl.onhyps with
      | None | Some [] -> true
      | _ -> false
      in
      let is_onconcl = match cl.concl_occs with
      | AllOccurrences | NoOccurrences -> true
      | _ -> false
      in
      TacChange (None,
        (if is_onhyps && is_onconcl
         then intern_type ist c else intern_constr ist c),
	clause_app (intern_hyp_location ist) cl)
  | TacChange (Some p,c,cl) ->
      TacChange (Some (intern_typed_pattern ist p),intern_constr ist c,
	clause_app (intern_hyp_location ist) cl)

  (* Equivalence relations *)
  | TacReflexivity -> TacReflexivity
  | TacSymmetry idopt ->
      TacSymmetry (clause_app (intern_hyp_location ist) idopt)
  | TacTransitivity c -> TacTransitivity (Option.map (intern_constr ist) c)

  (* Equality and inversion *)
  | TacRewrite (ev,l,cl,by) ->
      TacRewrite
	(ev,
	List.map (fun (b,m,c) -> (b,m,intern_constr_with_bindings ist c)) l,
	clause_app (intern_hyp_location ist) cl,
	Option.map (intern_pure_tactic ist) by)
  | TacInversion (inv,hyp) ->
      TacInversion (intern_inversion_strength lf ist inv,
        intern_quantified_hypothesis ist hyp)

  (* For extensions *)
  | TacExtend (loc,opn,l) ->
      let _ = lookup_tactic opn in
      TacExtend (adjust_loc loc,opn,List.map (intern_genarg ist) l)
  | TacAlias (loc,s,l,(dir,body)) ->
      let l = List.map (fun (id,a) -> (id,intern_genarg ist a)) l in
      TacAlias (loc,s,l,(dir,body))

and intern_tactic onlytac ist tac = snd (intern_tactic_seq onlytac ist tac)

and intern_tactic_seq onlytac ist = function
  | TacAtom (loc,t) ->
      let lf = ref ist.ltacvars in
      let t = intern_atomic lf ist t in
      !lf, TacAtom (adjust_loc loc, t)
  | TacFun tacfun -> ist.ltacvars, TacFun (intern_tactic_fun ist tacfun)
  | TacLetIn (isrec,l,u) ->
      let (l1,l2) = ist.ltacvars in
      let ist' = { ist with ltacvars = (extract_let_names l @ l1, l2) } in
      let l = List.map (fun (n,b) ->
	  (n,intern_tacarg !strict_check false (if isrec then ist' else ist) b)) l in
      ist.ltacvars, TacLetIn (isrec,l,intern_tactic onlytac ist' u)

  | TacMatchGoal (lz,lr,lmr) ->
      ist.ltacvars, TacMatchGoal(lz,lr, intern_match_rule onlytac ist lmr)
  | TacMatch (lz,c,lmr) ->
      ist.ltacvars,
      TacMatch (lz,intern_tactic_or_tacarg ist c,intern_match_rule onlytac ist lmr)
  | TacId l -> ist.ltacvars, TacId (intern_message ist l)
  | TacFail (n,l) ->
      ist.ltacvars, TacFail (intern_or_var ist n,intern_message ist l)
  | TacProgress tac -> ist.ltacvars, TacProgress (intern_pure_tactic ist tac)
  | TacShowHyps tac -> ist.ltacvars, TacShowHyps (intern_pure_tactic ist tac)
  | TacAbstract (tac,s) ->
      ist.ltacvars, TacAbstract (intern_pure_tactic ist tac,s)
  | TacThen (t1,[||],t2,[||]) ->
      let lfun', t1 = intern_tactic_seq onlytac ist t1 in
      let lfun'', t2 = intern_tactic_seq onlytac { ist with ltacvars = lfun' } t2 in
      lfun'', TacThen (t1,[||],t2,[||])
  | TacThen (t1,tf,t2,tl) ->
      let lfun', t1 = intern_tactic_seq onlytac ist t1 in
      let ist' = { ist with ltacvars = lfun' } in
      (* Que faire en cas de (tac complexe avec Match et Thens; tac2) ?? *)
      lfun', TacThen (t1,Array.map (intern_pure_tactic ist') tf,intern_pure_tactic ist' t2,
		       Array.map (intern_pure_tactic ist') tl)
  | TacThens (t,tl) ->
      let lfun', t = intern_tactic_seq true ist t in
      let ist' = { ist with ltacvars = lfun' } in
      (* Que faire en cas de (tac complexe avec Match et Thens; tac2) ?? *)
      lfun', TacThens (t, List.map (intern_pure_tactic ist') tl)
  | TacDo (n,tac) ->
      ist.ltacvars, TacDo (intern_or_var ist n,intern_pure_tactic ist tac)
  | TacTry tac -> ist.ltacvars, TacTry (intern_pure_tactic ist tac)
  | TacInfo tac -> ist.ltacvars, TacInfo (intern_pure_tactic ist tac)
  | TacRepeat tac -> ist.ltacvars, TacRepeat (intern_pure_tactic ist tac)
  | TacTimeout (n,tac) ->
      ist.ltacvars, TacTimeout (intern_or_var ist n,intern_tactic onlytac ist tac)
  | TacOrelse (tac1,tac2) ->
      ist.ltacvars, TacOrelse (intern_pure_tactic ist tac1,intern_pure_tactic ist tac2)
  | TacFirst l -> ist.ltacvars, TacFirst (List.map (intern_pure_tactic ist) l)
  | TacSolve l -> ist.ltacvars, TacSolve (List.map (intern_pure_tactic ist) l)
  | TacComplete tac -> ist.ltacvars, TacComplete (intern_pure_tactic ist tac)
  | TacArg (loc,a) -> ist.ltacvars, intern_tactic_as_arg loc onlytac ist a

and intern_tactic_as_arg loc onlytac ist a =
  match intern_tacarg !strict_check onlytac ist a with
  | TacCall _ | TacExternal _ | Reference _ | TacDynamic _ as a -> TacArg (loc,a)
  | Tacexp a -> a
  | TacVoid | IntroPattern _ | Integer _
  | ConstrMayEval _ | TacFreshId _ as a ->
      if onlytac then error_tactic_expected loc else TacArg (loc,a)
  | MetaIdArg _ -> assert false

and intern_tactic_or_tacarg ist = intern_tactic false ist

and intern_pure_tactic ist = intern_tactic true ist

and intern_tactic_fun ist (var,body) =
  let (l1,l2) = ist.ltacvars in
  let lfun' = List.rev_append (Option.List.flatten var) l1 in
  (var,intern_tactic_or_tacarg { ist with ltacvars = (lfun',l2) } body)

and intern_tacarg strict onlytac ist = function
  | TacVoid -> TacVoid
  | Reference r -> intern_non_tactic_reference strict ist r
  | IntroPattern ipat ->
      let lf = ref([],[]) in (*How to know what names the intropattern binds?*)
      IntroPattern (intern_intro_pattern lf ist ipat)
  | Integer n -> Integer n
  | ConstrMayEval c -> ConstrMayEval (intern_constr_may_eval ist c)
  | MetaIdArg (loc,istac,s) ->
      (* $id can occur in Grammar tactic... *)
      let id = Id.of_string s in
      if find_ltacvar id ist then
	if istac then Reference (ArgVar (adjust_loc loc,id))
	else ConstrMayEval (ConstrTerm (GVar (adjust_loc loc,id), None))
      else error_syntactic_metavariables_not_allowed loc
  | TacCall (loc,f,[]) -> intern_isolated_tactic_reference strict ist f
  | TacCall (loc,f,l) ->
      TacCall (loc,
        intern_applied_tactic_reference ist f,
        List.map (intern_tacarg !strict_check false ist) l)
  | TacExternal (loc,com,req,la) ->
      TacExternal (loc,com,req,List.map (intern_tacarg !strict_check false ist) la)
  | TacFreshId x -> TacFreshId (List.map (intern_or_var ist) x)
  | Tacexp t -> Tacexp (intern_tactic onlytac ist t)
  | TacDynamic(loc,t) as x ->
      (match Dyn.tag t with
	| "tactic" | "value" -> x
        | "constr" -> if onlytac then error_tactic_expected loc else x
	| s -> anomaly_loc (loc, "",
                 str "Unknown dynamic: <" ++ str s ++ str ">"))

(* Reads the rules of a Match Context or a Match *)
and intern_match_rule onlytac ist = function
  | (All tc)::tl ->
      All (intern_tactic onlytac ist tc) :: (intern_match_rule onlytac ist tl)
  | (Pat (rl,mp,tc))::tl ->
      let {ltacvars=(lfun,l2); gsigma=sigma; genv=env} = ist in
      let lfun',metas1,hyps = intern_match_goal_hyps ist lfun rl in
      let ido,metas2,pat = intern_pattern ist lfun mp in
      let metas = List.uniquize (metas1@metas2) in
      let ist' = { ist with ltacvars = (metas@(Option.List.cons ido lfun'),l2) } in
      Pat (hyps,pat,intern_tactic onlytac ist' tc) :: (intern_match_rule onlytac ist tl)
  | [] -> []

and intern_genarg ist x =
  match genarg_tag x with
  | BoolArgType -> in_gen globwit_bool (out_gen rawwit_bool x)
  | IntArgType -> in_gen globwit_int (out_gen rawwit_int x)
  | IntOrVarArgType ->
      in_gen globwit_int_or_var
        (intern_or_var ist (out_gen rawwit_int_or_var x))
  | StringArgType ->
      in_gen globwit_string (out_gen rawwit_string x)
  | PreIdentArgType ->
      in_gen globwit_pre_ident (out_gen rawwit_pre_ident x)
  | IntroPatternArgType ->
      let lf = ref ([],[]) in
      (* how to know which names are bound by the intropattern *)
      in_gen globwit_intro_pattern
        (intern_intro_pattern lf ist (out_gen rawwit_intro_pattern x))
  | IdentArgType b ->
      let lf = ref ([],[]) in
      in_gen (globwit_ident_gen b)
	(intern_ident lf ist (out_gen (rawwit_ident_gen b) x))
  | VarArgType ->
      in_gen globwit_var (intern_hyp ist (out_gen rawwit_var x))
  | RefArgType ->
      in_gen globwit_ref (intern_global_reference ist (out_gen rawwit_ref x))
  | SortArgType ->
      in_gen globwit_sort (out_gen rawwit_sort x)
  | ConstrArgType ->
      in_gen globwit_constr (intern_constr ist (out_gen rawwit_constr x))
  | ConstrMayEvalArgType ->
      in_gen globwit_constr_may_eval
        (intern_constr_may_eval ist (out_gen rawwit_constr_may_eval x))
  | QuantHypArgType ->
      in_gen globwit_quant_hyp
        (intern_quantified_hypothesis ist (out_gen rawwit_quant_hyp x))
  | RedExprArgType ->
      in_gen globwit_red_expr (intern_red_expr ist (out_gen rawwit_red_expr x))
  | OpenConstrArgType b ->
      in_gen (globwit_open_constr_gen b)
        ((),intern_constr ist (snd (out_gen (rawwit_open_constr_gen b) x)))
  | ConstrWithBindingsArgType ->
      in_gen globwit_constr_with_bindings
        (intern_constr_with_bindings ist (out_gen rawwit_constr_with_bindings x))
  | BindingsArgType ->
      in_gen globwit_bindings
        (intern_bindings ist (out_gen rawwit_bindings x))
  | List0ArgType _ -> app_list0 (intern_genarg ist) x
  | List1ArgType _ -> app_list1 (intern_genarg ist) x
  | OptArgType _ -> app_opt (intern_genarg ist) x
  | PairArgType _ -> app_pair (intern_genarg ist) (intern_genarg ist) x
  | ExtraArgType s ->
      match tactic_genarg_level s with
      | Some n ->
          (* Special treatment of tactic arguments *)
          in_gen (globwit_tactic n) (intern_tactic_or_tacarg ist
	    (out_gen (rawwit_tactic n) x))
      | None ->
          lookup_intern_genarg s ist x

(** Other entry points *)

let glob_tactic x =
  Flags.with_option strict_check
    (intern_pure_tactic (make_empty_glob_sign ())) x

let glob_tactic_env l env x =
  Flags.with_option strict_check
  (intern_pure_tactic
    { ltacvars = (l,[]); ltacrecvars = []; gsigma = Evd.empty; genv = env })
    x

(***************************************************************************)
(* Tactic registration *)

(* Declaration of the TAC-DEFINITION object *)
let add (kn,td) = mactab := Gmap.add kn td !mactab
let replace (kn,td) = mactab := Gmap.add kn td (Gmap.remove kn !mactab)

type tacdef_kind =
  | NewTac of Id.t
  | UpdateTac of ltac_constant

let load_md i ((sp,kn),(local,defs)) =
  let dp,_ = repr_path sp in
  let mp,dir,_ = repr_kn kn in
  List.iter (fun (id,t) ->
    match id with
      | NewTac id ->
	  let sp = Libnames.make_path dp id in
	  let kn = Names.make_kn mp dir (label_of_id id) in
	    Nametab.push_tactic (Until i) sp kn;
	    add (kn,t)
      | UpdateTac kn -> replace (kn,t)) defs

let open_md i ((sp,kn),(local,defs)) =
  let dp,_ = repr_path sp in
  let mp,dir,_ = repr_kn kn in
  List.iter (fun (id,t) ->
    match id with
	NewTac id ->
	  let sp = Libnames.make_path dp id in
	  let kn = Names.make_kn mp dir (label_of_id id) in
	    Nametab.push_tactic (Exactly i) sp kn
      | UpdateTac kn -> ()) defs

let cache_md x = load_md 1 x

let subst_kind subst id =
  match id with
    | NewTac _ -> id
    | UpdateTac kn -> UpdateTac (subst_kn subst kn)

let subst_md (subst,(local,defs)) =
  (local,
   List.map (fun (id,t) ->
     (subst_kind subst id,Tacsubst.subst_tactic subst t)) defs)

let classify_md (local,defs as o) =
  if local then Dispose else Substitute o

let inMD : bool * (tacdef_kind * glob_tactic_expr) list -> obj =
  declare_object {(default_object "TAC-DEFINITION") with
     cache_function  = cache_md;
     load_function   = load_md;
     open_function   = open_md;
     subst_function = subst_md;
     classify_function = classify_md}

let split_ltac_fun = function
  | TacFun (l,t) -> (l,t)
  | t -> ([],t)

let pr_ltac_fun_arg = function
  | None -> spc () ++ str "_"
  | Some id -> spc () ++ pr_id id

let print_ltac id =
 try
  let kn = Nametab.locate_tactic id in
  let l,t = split_ltac_fun (lookup_ltacref kn) in
  hv 2 (
    hov 2 (str "Ltac" ++ spc() ++ pr_qualid id ++
           prlist pr_ltac_fun_arg l ++ spc () ++ str ":=")
    ++ spc() ++ Pptactic.pr_glob_tactic (Global.env ()) t)
 with
  Not_found ->
   errorlabstrm "print_ltac"
    (pr_qualid id ++ spc() ++ str "is not a user defined tactic.")

open Libnames

(* Adds a definition for tactics in the table *)
let make_absolute_name ident repl =
  let loc = loc_of_reference ident in
  try
    let id, kn =
      if repl then None, Nametab.locate_tactic (snd (qualid_of_reference ident))
      else let id = coerce_reference_to_id ident in
	     Some id, Lib.make_kn id
    in
      if Gmap.mem kn !mactab then
	if repl then id, kn
	else
	  user_err_loc (loc,"Tacinterp.add_tacdef",
		       str "There is already an Ltac named " ++ pr_reference ident ++ str".")
      else if is_atomic_kn kn then
	user_err_loc (loc,"Tacinterp.add_tacdef",
		     str "Reserved Ltac name " ++ pr_reference ident ++ str".")
      else id, kn
  with Not_found ->
    user_err_loc (loc,"Tacinterp.add_tacdef",
		 str "There is no Ltac named " ++ pr_reference ident ++ str".")

let add_tacdef local isrec tacl =
  let rfun = List.map (fun (ident, b, _) -> make_absolute_name ident b) tacl in
  let ist =
    { (make_empty_glob_sign ()) with ltacrecvars =
	if isrec then List.map_filter
	  (function (Some id, qid) -> Some (id, qid) | (None, _) -> None) rfun
	else []} in
  let gtacl =
    List.map2 (fun (_,b,def) (id, qid) ->
      let k = if b then UpdateTac qid else NewTac (Option.get id) in
      let t = Flags.with_option strict_check (intern_tactic_or_tacarg ist) def in
	(k, t))
      tacl rfun in
  let id0 = fst (List.hd rfun) in
  let _ = match id0 with
    | Some id0 -> ignore(Lib.add_leaf id0 (inMD (local,gtacl)))
    | _ -> Lib.add_anonymous_leaf (inMD (local,gtacl)) in
  List.iter
    (fun (id,b,_) ->
      Flags.if_verbose msg_info (Libnames.pr_reference id ++
				 (if b then str " is redefined"
				   else str " is defined")))
    tacl

(***************************************************************************)
(* Backwarding recursive needs of tactic glob/interp/eval functions *)

let _ = Auto.set_extern_intern_tac
  (fun l ->
    Flags.with_option strict_check
    (intern_pure_tactic { (make_empty_glob_sign()) with ltacvars=(l,[])}))
