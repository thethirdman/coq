(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, *   INRIA - CNRS - LIX - LRI - PPS - Copyright 1999-2012     *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

open Constrintern
open Pattern
open Patternops
open Matching
open Pp
open Genredexpr
open Glob_term
open Glob_ops
open Tacred
open Errors
open Util
open Names
open Nameops
open Libnames
open Globnames
open Nametab
open Pfedit
open Proof_type
open Refiner
open Tacmach
open Tactic_debug
open Constrexpr
open Term
open Termops
open Tacexpr
open Hiddentac
open Genarg
open Printer
open Pretyping
open Extrawit
open Evd
open Misctypes
open Miscops
open Locus
open Tacintern

let safe_msgnl s =
  let _ =
    try ppnl s with e ->
    ppnl (str "bug in the debugger: an exception is raised while printing debug information")
  in
  pp_flush () 

(* Values for interpretation *)
type value =
  | VRTactic of (goal list sigma) (* For Match results *)
                                               (* Not a true value *)
  | VFun of ltac_trace * (Id.t*value) list *
      Id.t option list * glob_tactic_expr
  | VVoid
  | VInteger of int
  | VIntroPattern of intro_pattern_expr (* includes idents which are not *)
                        (* bound as in "Intro H" but which may be bound *)
                        (* later, as in "tac" in "Intro H; tac" *)
  | VConstr of constr_under_binders
                        (* includes idents known to be bound and references *)
  | VConstr_context of constr
  | VList of value list
  | VRec of (Id.t*value) list ref * glob_tactic_expr

let dloc = Loc.ghost

let catch_error call_trace tac g =
  if List.is_empty call_trace then tac g else try tac g with
  | LtacLocated _ as e -> raise e
  | Loc.Exc_located (_,LtacLocated _) as e -> raise e
  | e ->
    let (nrep,loc',c),tail = List.sep_last call_trace in
    let loc,e' = match e with Loc.Exc_located(loc,e) -> loc,e | _ ->dloc,e in
    if List.is_empty tail then
      let loc = if Loc.is_ghost loc then loc' else loc in
      raise (Loc.Exc_located(loc,e'))
    else
      raise (Loc.Exc_located(loc',LtacLocated((nrep,c,tail,loc),e')))

(* Signature for interpretation: val_interp and interpretation functions *)
type interp_sign =
    { lfun : (Id.t * value) list;
      avoid_ids : Id.t list; (* ids inherited from the call context
				      (needed to get fresh ids) *)
      debug : debug_info;
      trace : ltac_trace }

let check_is_value = function
  | VRTactic _ -> (* These are goals produced by Match *)
   error "Immediate match producing tactics not allowed in local definitions."
  | _ -> ()

(* Gives the constr corresponding to a Constr_context tactic_arg *)
let constr_of_VConstr_context = function
  | VConstr_context c -> c
  | _ ->
    errorlabstrm "constr_of_VConstr_context" (str "Not a context variable.")

(* Displays a value *)
let rec pr_value env = function
  | VVoid -> str "()"
  | VInteger n -> int n
  | VIntroPattern ipat -> pr_intro_pattern (dloc,ipat)
  | VConstr c ->
      (match env with Some env ->
	pr_lconstr_under_binders_env env c | _ -> str "a term")
  | VConstr_context c ->
      (match env with Some env -> pr_lconstr_env env c | _ -> str "a term")
  | (VRTactic _ | VFun _ | VRec _) -> str "a tactic"
  | VList [] -> str "an empty list"
  | VList (a::_) ->
      str "a list (first element is " ++ pr_value env a ++ str")"

(* Transforms an id into a constr if possible, or fails with Not_found *)
let constr_of_id env id =
  Term.mkVar (let _ = Environ.lookup_named id env in id)

(* To embed tactics *)

let ((tactic_in : (interp_sign -> glob_tactic_expr) -> Dyn.t),
     (tactic_out : Dyn.t -> (interp_sign -> glob_tactic_expr))) =
  Dyn.create "tactic"

let ((value_in : value -> Dyn.t),
     (value_out : Dyn.t -> value)) = Dyn.create "value"

let valueIn t = TacDynamic (Loc.ghost,value_in t)

(** Generic arguments : table of interpretation functions *)

type interp_genarg_type =
  interp_sign -> goal sigma -> glob_generic_argument ->
    Evd.evar_map * typed_generic_argument

let extragenargtab =
  ref (String.Map.empty : interp_genarg_type String.Map.t)
let add_interp_genarg id f =
  extragenargtab := String.Map.add id f !extragenargtab
let lookup_interp_genarg id =
  try String.Map.find id !extragenargtab
  with Not_found ->
    let msg = "No interpretation function found for entry " ^ id in
    msg_warning (strbrk msg);
    let f = fun _ _ _ -> failwith msg in
    add_interp_genarg id f;
    f

let push_trace (loc,ck) = function
  | (n,loc',ck')::trl when Pervasives.(=) ck ck' -> (n+1,loc,ck)::trl (** FIXME *)
  | trl -> (1,loc,ck)::trl

let propagate_trace ist loc id = function
  | VFun (_,lfun,it,b) ->
      let t = if List.is_empty it then b else TacFun (it,b) in
      VFun (push_trace(loc,LtacVarCall (id,t)) ist.trace,lfun,it,b)
  | x -> x

(* Dynamically check that an argument is a tactic *)
let coerce_to_tactic loc id = function
  | VFun _ | VRTactic _ as a -> a
  | _ -> user_err_loc
  (loc, "", str "Variable " ++ pr_id id ++ str " should be bound to a tactic.")

(* External tactics *)
let print_xml_term = ref (fun _ -> failwith "print_xml_term unset")
let declare_xml_printer f = print_xml_term := f

let internalise_tacarg ch = G_xml.parse_tactic_arg ch

let extern_tacarg ch env sigma = function
  | VConstr ([],c) -> !print_xml_term ch env sigma c
  | VRTactic _ | VFun _ | VVoid | VInteger _ | VConstr_context _
  | VIntroPattern _  | VRec _ | VList _ | VConstr _ ->
      error "Only externing of closed terms is implemented."

let extern_request ch req gl la =
  output_string ch "<REQUEST req=\""; output_string ch req;
  output_string ch "\">\n";
  List.iter (pf_apply (extern_tacarg ch) gl) la;
  output_string ch "</REQUEST>\n"

let value_of_ident id = VIntroPattern (IntroIdentifier id)

let extend_values_with_bindings (ln,lm) lfun =
  let lnames = List.map (fun (id,id') ->(id,value_of_ident id')) ln in
  let lmatch = List.map (fun (id,(ids,c)) -> (id,VConstr (ids,c))) lm in
  (* For compatibility, bound variables are visible only if no other
     binding of the same name exists *)
  lmatch@lfun@lnames

(***************************************************************************)
(* Evaluation/interpretation *)

let is_variable env id =
  List.mem id (ids_of_named_context (Environ.named_context env))

(* Debug reference *)
let debug = ref DebugOff

(* Sets the debugger mode *)
let set_debug pos = debug := pos

(* Gives the state of debug *)
let get_debug () = !debug

let debugging_step ist pp =
  match ist.debug with
  | DebugOn lev ->
      safe_msgnl (str "Level " ++ int lev ++ str": " ++ pp () ++ fnl())
  | _ -> ()

let debugging_exception_step ist signal_anomaly e pp =
  let explain_exc =
    if signal_anomaly then explain_logic_error
    else explain_logic_error_no_anomaly in
  debugging_step ist (fun () ->
    pp() ++ spc() ++ str "raised the exception" ++ fnl() ++ !explain_exc e)

let error_ltac_variable loc id env v s =
   user_err_loc (loc, "", str "Ltac variable " ++ pr_id id ++
   strbrk " is bound to" ++ spc () ++ pr_value env v ++ spc () ++
   strbrk "which cannot be coerced to " ++ str s ++ str".")

exception CannotCoerceTo of string

(* Raise Not_found if not in interpretation sign *)
let try_interp_ltac_var coerce ist env (loc,id) =
  let v = List.assoc id ist.lfun in
  try coerce v with CannotCoerceTo s -> error_ltac_variable loc id env v s

let interp_ltac_var coerce ist env locid =
  try try_interp_ltac_var coerce ist env locid
  with Not_found -> anomaly ("Detected '" ^ (Id.to_string (snd locid)) ^ "' as ltac var at interning time")

(* Interprets an identifier which must be fresh *)
let coerce_to_ident fresh env = function
  | VIntroPattern (IntroIdentifier id) -> id
  | VConstr ([],c) when isVar c & not (fresh & is_variable env (destVar c)) ->
      (* We need it fresh for intro e.g. in "Tac H = clear H; intro H" *)
      destVar c
  | v -> raise (CannotCoerceTo "a fresh identifier")

let interp_ident_gen fresh ist env id =
  try try_interp_ltac_var (coerce_to_ident fresh env) ist (Some env) (dloc,id)
  with Not_found -> id

let interp_ident = interp_ident_gen false
let interp_fresh_ident = interp_ident_gen true
let pf_interp_ident id gl = interp_ident_gen false id (pf_env gl)
let pf_interp_fresh_ident id gl = interp_ident_gen true id (pf_env gl)

(* Interprets an optional identifier which must be fresh *)
let interp_fresh_name ist env = function
  | Anonymous -> Anonymous
  | Name id -> Name (interp_fresh_ident ist env id)

let coerce_to_intro_pattern env = function
  | VIntroPattern ipat -> ipat
  | VConstr ([],c) when isVar c ->
      (* This happens e.g. in definitions like "Tac H = clear H; intro H" *)
      (* but also in "destruct H as (H,H')" *)
      IntroIdentifier (destVar c)
  | v -> raise (CannotCoerceTo "an introduction pattern")

let interp_intro_pattern_var loc ist env id =
  try try_interp_ltac_var (coerce_to_intro_pattern env) ist (Some env) (loc,id)
  with Not_found -> IntroIdentifier id

let coerce_to_hint_base = function
  | VIntroPattern (IntroIdentifier id) -> Id.to_string id
  | _ -> raise (CannotCoerceTo "a hint base name")

let interp_hint_base ist s =
  try try_interp_ltac_var coerce_to_hint_base ist None (dloc,Id.of_string s)
  with Not_found -> s

let coerce_to_int = function
  | VInteger n -> n
  | v -> raise (CannotCoerceTo "an integer")

let interp_int ist locid =
  try try_interp_ltac_var coerce_to_int ist None locid
  with Not_found ->
    user_err_loc(fst locid,"interp_int",
      str "Unbound variable "  ++ pr_id (snd locid) ++ str".")

let interp_int_or_var ist = function
  | ArgVar locid -> interp_int ist locid
  | ArgArg n -> n

let int_or_var_list_of_VList = function
  | VList l -> List.map (fun n -> ArgArg (coerce_to_int n)) l
  | _ -> raise Not_found

let interp_int_or_var_as_list ist = function
  | ArgVar (_,id as locid) ->
      (try int_or_var_list_of_VList (List.assoc id ist.lfun)
       with Not_found | CannotCoerceTo _ -> [ArgArg (interp_int ist locid)])
  | ArgArg n as x -> [x]

let interp_int_or_var_list ist l =
  List.flatten (List.map (interp_int_or_var_as_list ist) l)

let constr_of_value env = function
  | VConstr csr -> csr
  | VIntroPattern (IntroIdentifier id) -> ([],constr_of_id env id)
  | _ -> raise Not_found

let closed_constr_of_value env v =
  let ids,c = constr_of_value env v in
  if not (List.is_empty ids) then raise Not_found;
  c

let coerce_to_hyp env = function
  | VConstr ([],c) when isVar c -> destVar c
  | VIntroPattern (IntroIdentifier id) when is_variable env id -> id
  | _ -> raise (CannotCoerceTo "a variable")

(* Interprets a bound variable (especially an existing hypothesis) *)
let interp_hyp ist gl (loc,id as locid) =
  let env = pf_env gl in
  (* Look first in lfun for a value coercible to a variable *)
  try try_interp_ltac_var (coerce_to_hyp env) ist (Some env) locid
  with Not_found ->
  (* Then look if bound in the proof context at calling time *)
  if is_variable env id then id
  else user_err_loc (loc,"eval_variable",
    str "No such hypothesis: " ++ pr_id id ++ str ".")

let hyp_list_of_VList env = function
  | VList l -> List.map (coerce_to_hyp env) l
  | _ -> raise Not_found

let interp_hyp_list_as_list ist gl (loc,id as x) =
  try hyp_list_of_VList (pf_env gl) (List.assoc id ist.lfun)
  with Not_found | CannotCoerceTo _ -> [interp_hyp ist gl x]

let interp_hyp_list ist gl l =
  List.flatten (List.map (interp_hyp_list_as_list ist gl) l)

let interp_move_location ist gl = function
  | MoveAfter id -> MoveAfter (interp_hyp ist gl id)
  | MoveBefore id -> MoveBefore (interp_hyp ist gl id)
  | MoveFirst -> MoveFirst
  | MoveLast -> MoveLast

(* Interprets a qualified name *)
let coerce_to_reference env v =
  try match v with
  | VConstr ([],c) -> global_of_constr c (* may raise Not_found *)
  | _ -> raise Not_found
  with Not_found -> raise (CannotCoerceTo "a reference")

let interp_reference ist env = function
  | ArgArg (_,r) -> r
  | ArgVar locid ->
      interp_ltac_var (coerce_to_reference env) ist (Some env) locid

let pf_interp_reference ist gl = interp_reference ist (pf_env gl)

let coerce_to_inductive = function
  | VConstr ([],c) when isInd c -> destInd c
  | _ -> raise (CannotCoerceTo "an inductive type")

let interp_inductive ist = function
  | ArgArg r -> r
  | ArgVar locid -> interp_ltac_var coerce_to_inductive ist None locid

let coerce_to_evaluable_ref env v =
  let ev = match v with
    | VConstr ([],c) when isConst c -> EvalConstRef (destConst c)
    | VConstr ([],c) when isVar c -> EvalVarRef (destVar c)
    | VIntroPattern (IntroIdentifier id) when List.mem id (ids_of_context env)
	-> EvalVarRef id
    | _ -> raise (CannotCoerceTo "an evaluable reference")
  in
  if not (Tacred.is_evaluable env ev) then
    raise (CannotCoerceTo "an evaluable reference")
  else
    ev

let interp_evaluable ist env = function
  | ArgArg (r,Some (loc,id)) ->
      (* Maybe [id] has been introduced by Intro-like tactics *)
      (try match Environ.lookup_named id env with
       | (_,Some _,_) -> EvalVarRef id
       | _ -> error_not_evaluable (VarRef id)
       with Not_found ->
       match r with
       | EvalConstRef _ -> r
       | _ -> error_global_not_found_loc loc (qualid_of_ident id))
  | ArgArg (r,None) -> r
  | ArgVar locid ->
      interp_ltac_var (coerce_to_evaluable_ref env) ist (Some env) locid

(* Interprets an hypothesis name *)
let interp_occurrences ist occs =
  Locusops.occurrences_map (interp_int_or_var_list ist) occs

let interp_hyp_location ist gl ((occs,id),hl) =
  ((interp_occurrences ist occs,interp_hyp ist gl id),hl)

let interp_clause ist gl { onhyps=ol; concl_occs=occs } =
  { onhyps=Option.map(List.map (interp_hyp_location ist gl)) ol;
    concl_occs=interp_occurrences ist occs }

(* Interpretation of constructions *)

(* Extract the constr list from lfun *)
let extract_ltac_constr_values ist env =
  let rec aux = function
  | (id,v)::tl ->
      let (l1,l2) = aux tl in
      (try ((id,constr_of_value env v)::l1,l2)
       with Not_found ->
	 let ido = match v with
	   | VIntroPattern (IntroIdentifier id0) -> Some id0
	   | _ -> None in
	 (l1,(id,ido)::l2))
  | [] -> ([],[]) in
  aux ist.lfun

(* Extract the identifier list from lfun: join all branches (what to do else?)*)
let rec intropattern_ids (loc,pat) = match pat with
  | IntroIdentifier id -> [id]
  | IntroOrAndPattern ll ->
      List.flatten (List.map intropattern_ids (List.flatten ll))
  | IntroWildcard | IntroAnonymous | IntroFresh _ | IntroRewrite _
  | IntroForthcoming _ -> []

let rec extract_ids ids = function
  | (id,VIntroPattern ipat)::tl when not (List.mem id ids) ->
      intropattern_ids (dloc,ipat) @ extract_ids ids tl
  | _::tl -> extract_ids ids tl
  | [] -> []

let default_fresh_id = Id.of_string "H"

let interp_fresh_id ist env l =
  let ids = List.map_filter (function ArgVar (_, id) -> Some id | _ -> None) l in
  let avoid = (extract_ids ids ist.lfun) @ ist.avoid_ids in
  let id =
    if List.is_empty l then default_fresh_id
    else
      let s =
	String.concat "" (List.map (function
	  | ArgArg s -> s
	  | ArgVar (_,id) -> Id.to_string (interp_ident ist env id)) l) in
      let s = if Lexer.is_keyword s then s^"0" else s in
      Id.of_string s in
  Tactics.fresh_id_in_env avoid id env

let pf_interp_fresh_id ist gl = interp_fresh_id ist (pf_env gl)

let interp_gen kind ist allow_patvar expand_evar fail_evar use_classes env sigma (c,ce) =
  let (ltacvars,unbndltacvars as vars) = extract_ltac_constr_values ist env in
  let c = match ce with
  | None -> c
    (* If at toplevel (ce<>None), the error can be due to an incorrect
       context at globalization time: we retype with the now known
       intros/lettac/inversion hypothesis names *)
  | Some c ->
      let ltacdata = (List.map fst ltacvars,unbndltacvars) in
      intern_gen kind ~allow_patvar ~ltacvars:ltacdata sigma env c
  in
  let trace = push_trace (dloc,LtacConstrInterp (c,vars)) ist.trace in
  let evdc =
    catch_error trace 
      (understand_ltac ~resolve_classes:use_classes expand_evar sigma env vars kind) c 
  in
  let (evd,c) =
    if expand_evar then
      solve_remaining_evars fail_evar use_classes
        solve_by_implicit_tactic env sigma evdc
    else
      evdc in
  db_constr ist.debug env c;
  (evd,c)

(* Interprets a constr; expects evars to be solved *)
let interp_constr_gen kind ist env sigma c =
  interp_gen kind ist false true true true env sigma c

let interp_constr = interp_constr_gen (OfType None)

let interp_type = interp_constr_gen IsType

(* Interprets an open constr *)
let interp_open_constr ccl ist =
  interp_gen (OfType ccl) ist false true false (not (Option.is_empty ccl))

let interp_pure_open_constr ist =
  interp_gen (OfType None) ist false false false false

let interp_typed_pattern ist env sigma (c,_) =
  let sigma, c =
    interp_gen (OfType None) ist true false false false env sigma c in
  pattern_of_constr sigma c

(* Interprets a constr expression casted by the current goal *)
let pf_interp_casted_constr ist gl c =
  interp_constr_gen (OfType (Some (pf_concl gl))) ist (pf_env gl) (project gl) c

(* Interprets a constr expression *)
let pf_interp_constr ist gl =
  interp_constr ist (pf_env gl) (project gl)

let constr_list_of_VList env = function
  | VList l -> List.map (closed_constr_of_value env) l
  | _ -> raise Not_found

let interp_constr_in_compound_list inj_fun dest_fun interp_fun ist env sigma l =
  let try_expand_ltac_var sigma x =
    try match dest_fun x with
    | GVar (_,id), _ ->	
        sigma,
        List.map inj_fun (constr_list_of_VList env (List.assoc id ist.lfun))
    | _ ->
        raise Not_found
    with Not_found ->
      (*all of dest_fun, List.assoc, constr_list_of_VList may raise Not_found*)
      let sigma, c = interp_fun ist env sigma x in
      sigma, [c] in
  let sigma, l = List.fold_map try_expand_ltac_var sigma l in
  sigma, List.flatten l

let interp_constr_list ist env sigma c =
  interp_constr_in_compound_list (fun x -> x) (fun x -> x) interp_constr ist env sigma c

let interp_open_constr_list =
  interp_constr_in_compound_list (fun x -> x) (fun x -> x)
    (interp_open_constr None)

let interp_auto_lemmas ist env sigma lems =
  let local_sigma, lems = interp_open_constr_list ist env sigma lems in
  List.map (fun lem -> (local_sigma,lem)) lems

(* Interprets a type expression *)
let pf_interp_type ist gl =
  interp_type ist (pf_env gl) (project gl)

(* Interprets a reduction expression *)
let interp_unfold ist env (occs,qid) =
  (interp_occurrences ist occs,interp_evaluable ist env qid)

let interp_flag ist env red =
  { red with rConst = List.map (interp_evaluable ist env) red.rConst }

let interp_constr_with_occurrences ist sigma env (occs,c) =
  let (sigma,c_interp) = interp_constr ist sigma env c in
  sigma , (interp_occurrences ist occs, c_interp)

let interp_typed_pattern_with_occurrences ist env sigma (occs,c) =
  let sign,p = interp_typed_pattern ist env sigma c in
  sign, (interp_occurrences ist occs, p)

let interp_closed_typed_pattern_with_occurrences ist env sigma occl =
  snd (interp_typed_pattern_with_occurrences ist env sigma occl)

let interp_constr_with_occurrences_and_name_as_list =
  interp_constr_in_compound_list
    (fun c -> ((AllOccurrences,c),Anonymous))
    (function ((occs,c),Anonymous) when occs == AllOccurrences -> c
      | _ -> raise Not_found)
    (fun ist env sigma (occ_c,na) ->
      let (sigma,c_interp) = interp_constr_with_occurrences ist env sigma occ_c in
      sigma, (c_interp,
       interp_fresh_name ist env na))

let interp_red_expr ist sigma env = function
  | Unfold l -> sigma , Unfold (List.map (interp_unfold ist env) l)
  | Fold l ->
    let (sigma,l_interp) = interp_constr_list ist env sigma l in
    sigma , Fold l_interp
  | Cbv f -> sigma , Cbv (interp_flag ist env f)
  | Lazy f -> sigma , Lazy (interp_flag ist env f)
  | Pattern l ->
    let (sigma,l_interp) =
      List.fold_right begin fun c (sigma,acc) ->
	let (sigma,c_interp) = interp_constr_with_occurrences ist env sigma c in
	sigma , c_interp :: acc
      end l (sigma,[])
    in
    sigma , Pattern l_interp
  | Simpl o ->
    sigma , Simpl (Option.map (interp_closed_typed_pattern_with_occurrences ist env sigma) o)
  | CbvVm o ->
    sigma , CbvVm (Option.map (interp_closed_typed_pattern_with_occurrences ist env sigma) o)
  | (Red _ |  Hnf | ExtraRedExpr _ as r) -> sigma , r

let pf_interp_red_expr ist gl = interp_red_expr ist (project gl) (pf_env gl)

let interp_may_eval f ist gl = function
  | ConstrEval (r,c) ->
      let (sigma,redexp) = pf_interp_red_expr ist gl r in
      let (sigma,c_interp) = f ist { gl with sigma=sigma } c in
      sigma , pf_reduction_of_red_expr gl redexp c_interp
  | ConstrContext ((loc,s),c) ->
      (try
	let (sigma,ic) = f ist gl c
	and ctxt = constr_of_VConstr_context (List.assoc s ist.lfun) in
	sigma , subst_meta [special_meta,ic] ctxt
      with
	| Not_found ->
	    user_err_loc (loc, "interp_may_eval",
	    str "Unbound context identifier" ++ pr_id s ++ str"."))
  | ConstrTypeOf c ->
      let (sigma,c_interp) = f ist gl c in
      sigma , pf_type_of gl c_interp
  | ConstrTerm c ->
     try
	f ist gl c
     with e ->
       debugging_exception_step ist false e (fun () ->
         str"interpretation of term " ++ pr_glob_constr_env (pf_env gl) (fst c));
       raise e

(* Interprets a constr expression possibly to first evaluate *)
let interp_constr_may_eval ist gl c =
  let (sigma,csr) =
    try
      interp_may_eval pf_interp_constr ist gl c
    with e ->
      debugging_exception_step ist false e (fun () -> str"evaluation of term");
      raise e
  in
  begin
    db_constr ist.debug (pf_env gl) csr;
    sigma , csr
  end

let rec message_of_value gl = function
  | VVoid -> str "()"
  | VInteger n -> int n
  | VIntroPattern ipat -> pr_intro_pattern (dloc,ipat)
  | VConstr_context c -> pr_constr_env (pf_env gl) c
  | VConstr c -> pr_constr_under_binders_env (pf_env gl) c
  | VRec _ | VRTactic _ | VFun _ -> str "<tactic>"
  | VList l -> prlist_with_sep spc (message_of_value gl) l

let interp_message_token ist gl = function
  | MsgString s -> str s
  | MsgInt n -> int n
  | MsgIdent (loc,id) ->
      let v =
	try List.assoc id ist.lfun
	with Not_found -> user_err_loc (loc,"",pr_id id ++ str" not found.") in
      message_of_value gl v

let interp_message_nl ist gl = function
  | [] -> mt()
  | l -> prlist_with_sep spc (interp_message_token ist gl) l ++ fnl()

let interp_message ist gl l =
  (* Force evaluation of interp_message_token so that potential errors
     are raised now and not at printing time *)
  prlist (fun x -> spc () ++ x) (List.map (interp_message_token ist gl) l)

let intro_pattern_list_of_Vlist loc env = function
  | VList l -> List.map (fun a -> loc,coerce_to_intro_pattern env a) l
  | _ -> raise Not_found

let rec interp_intro_pattern ist gl = function
  | loc, IntroOrAndPattern l ->
      loc, IntroOrAndPattern (interp_or_and_intro_pattern ist gl l)
  | loc, IntroIdentifier id ->
      loc, interp_intro_pattern_var loc ist (pf_env gl) id
  | loc, IntroFresh id ->
      loc, IntroFresh (interp_fresh_ident ist (pf_env gl) id)
  | loc, (IntroWildcard | IntroAnonymous | IntroRewrite _ | IntroForthcoming _)
      as x -> x

and interp_or_and_intro_pattern ist gl =
  List.map (interp_intro_pattern_list_as_list ist gl)

and interp_intro_pattern_list_as_list ist gl = function
  | [loc,IntroIdentifier id] as l ->
      (try intro_pattern_list_of_Vlist loc (pf_env gl) (List.assoc id ist.lfun)
       with Not_found | CannotCoerceTo _ ->
	List.map (interp_intro_pattern ist gl) l)
  | l -> List.map (interp_intro_pattern ist gl) l

let interp_in_hyp_as ist gl (id,ipat) =
  (interp_hyp ist gl id,Option.map (interp_intro_pattern ist gl) ipat)

(* Quantified named or numbered hypothesis or hypothesis in context *)
(* (as in Inversion) *)
let coerce_to_quantified_hypothesis = function
  | VInteger n -> AnonHyp n
  | VIntroPattern (IntroIdentifier id) -> NamedHyp id
  | v -> raise (CannotCoerceTo "a quantified hypothesis")

let interp_quantified_hypothesis ist = function
  | AnonHyp n -> AnonHyp n
  | NamedHyp id ->
      try try_interp_ltac_var coerce_to_quantified_hypothesis ist None(dloc,id)
      with Not_found -> NamedHyp id

let interp_binding_name ist = function
  | AnonHyp n -> AnonHyp n
  | NamedHyp id ->
      (* If a name is bound, it has to be a quantified hypothesis *)
      (* user has to use other names for variables if these ones clash with *)
      (* a name intented to be used as a (non-variable) identifier *)
      try try_interp_ltac_var coerce_to_quantified_hypothesis ist None(dloc,id)
      with Not_found -> NamedHyp id

(* Quantified named or numbered hypothesis or hypothesis in context *)
(* (as in Inversion) *)
let coerce_to_decl_or_quant_hyp env = function
  | VInteger n -> AnonHyp n
  | v ->
      try NamedHyp (coerce_to_hyp env v)
      with CannotCoerceTo _ ->
	raise (CannotCoerceTo "a declared or quantified hypothesis")

let interp_declared_or_quantified_hypothesis ist gl = function
  | AnonHyp n -> AnonHyp n
  | NamedHyp id ->
      let env = pf_env gl in
      try try_interp_ltac_var
	    (coerce_to_decl_or_quant_hyp env) ist (Some env) (dloc,id)
      with Not_found -> NamedHyp id

let interp_binding ist env sigma (loc,b,c) =
  let sigma, c = interp_open_constr None ist env sigma c in
  sigma, (loc,interp_binding_name ist b,c)

let interp_bindings ist env sigma = function
| NoBindings ->
    sigma, NoBindings
| ImplicitBindings l ->
    let sigma, l = interp_open_constr_list ist env sigma l in   
    sigma, ImplicitBindings l
| ExplicitBindings l ->
    let sigma, l = List.fold_map (interp_binding ist env) sigma l in
    sigma, ExplicitBindings l

let interp_constr_with_bindings ist env sigma (c,bl) =
  let sigma, bl = interp_bindings ist env sigma bl in
  let sigma, c = interp_open_constr None ist env sigma c in
  sigma, (c,bl)

let interp_open_constr_with_bindings ist env sigma (c,bl) =
  let sigma, bl = interp_bindings ist env sigma bl in
  let sigma, c = interp_open_constr None ist env sigma c in
  sigma, (c, bl)

let loc_of_bindings = function
| NoBindings -> Loc.ghost
| ImplicitBindings l -> loc_of_glob_constr (fst (List.last l))
| ExplicitBindings l -> pi1 (List.last l)

let interp_open_constr_with_bindings_loc ist env sigma ((c,_),bl as cb) =
  let loc1 = loc_of_glob_constr c in
  let loc2 = loc_of_bindings bl in
  let loc = if Loc.is_ghost loc2 then loc1 else Loc.merge loc1 loc2 in
  let sigma, cb = interp_open_constr_with_bindings ist env sigma cb in
  sigma, (loc,cb)

let interp_induction_arg ist gl arg =
  let env = pf_env gl and sigma = project gl in
  match arg with
  | ElimOnConstr c ->
      ElimOnConstr (interp_constr_with_bindings ist env sigma c)
  | ElimOnAnonHyp n as x -> x
  | ElimOnIdent (loc,id) ->
      try
        match List.assoc id ist.lfun with
	| VInteger n ->
	    ElimOnAnonHyp n
	| VIntroPattern (IntroIdentifier id') ->
	    if Tactics.is_quantified_hypothesis id' gl
	    then ElimOnIdent (loc,id')
	    else
	      (try ElimOnConstr (sigma,(constr_of_id env id',NoBindings))
	       with Not_found ->
		user_err_loc (loc,"",
		pr_id id ++ strbrk " binds to " ++ pr_id id' ++ strbrk " which is neither a declared or a quantified hypothesis."))
	| VConstr ([],c) ->
	    ElimOnConstr (sigma,(c,NoBindings))
	| _ -> user_err_loc (loc,"",
	      strbrk "Cannot coerce " ++ pr_id id ++
	      strbrk " neither to a quantified hypothesis nor to a term.")
      with Not_found ->
	(* We were in non strict (interactive) mode *)
	if Tactics.is_quantified_hypothesis id gl then
          ElimOnIdent (loc,id)
	else
          let c = (GVar (loc,id),Some (CRef (Ident (loc,id)))) in
          let (sigma,c) = interp_constr ist env sigma c in
          ElimOnConstr (sigma,(c,NoBindings))

(* Associates variables with values and gives the remaining variables and
   values *)
let head_with_value (lvar,lval) =
  let rec head_with_value_rec lacc = function
    | ([],[]) -> (lacc,[],[])
    | (vr::tvr,ve::tve) ->
      (match vr with
      |	None -> head_with_value_rec lacc (tvr,tve)
      | Some v -> head_with_value_rec ((v,ve)::lacc) (tvr,tve))
    | (vr,[]) -> (lacc,vr,[])
    | ([],ve) -> (lacc,[],ve)
  in
    head_with_value_rec [] (lvar,lval)

(* Gives a context couple if there is a context identifier *)
let give_context ctxt = function
  | None -> []
  | Some id -> [id,VConstr_context ctxt]

(* Reads a pattern by substituting vars of lfun *)
let use_types = false

let eval_pattern lfun ist env sigma (_,pat as c) =
  if use_types then
    snd (interp_typed_pattern ist env sigma c)
  else
    instantiate_pattern sigma lfun pat

let read_pattern lfun ist env sigma = function
  | Subterm (b,ido,c) -> Subterm (b,ido,eval_pattern lfun ist env sigma c)
  | Term c -> Term (eval_pattern lfun ist env sigma c)

(* Reads the hypotheses of a Match Context rule *)
let cons_and_check_name id l =
  if List.mem id l then
    user_err_loc (dloc,"read_match_goal_hyps",
      strbrk ("Hypothesis pattern-matching variable "^(Id.to_string id)^
      " used twice in the same pattern."))
  else id::l

let rec read_match_goal_hyps lfun ist env sigma lidh = function
  | (Hyp ((loc,na) as locna,mp))::tl ->
      let lidh' = name_fold cons_and_check_name na lidh in
      Hyp (locna,read_pattern lfun ist env sigma mp)::
	(read_match_goal_hyps lfun ist env sigma lidh' tl)
  | (Def ((loc,na) as locna,mv,mp))::tl ->
      let lidh' = name_fold cons_and_check_name na lidh in
      Def (locna,read_pattern lfun ist env sigma mv, read_pattern lfun ist env sigma mp)::
	(read_match_goal_hyps lfun ist env sigma lidh' tl)
  | [] -> []

(* Reads the rules of a Match Context or a Match *)
let rec read_match_rule lfun ist env sigma = function
  | (All tc)::tl -> (All tc)::(read_match_rule lfun ist env sigma tl)
  | (Pat (rl,mp,tc))::tl ->
      Pat (read_match_goal_hyps lfun ist env sigma [] rl, read_pattern lfun ist env sigma mp,tc)
      :: read_match_rule lfun ist env sigma tl
  | [] -> []

(* For Match Context and Match *)
exception Not_coherent_metas
exception Eval_fail of std_ppcmds

let is_match_catchable = function
  | PatternMatchingFailure | Eval_fail _ -> true
  | e -> Logic.catchable_exception e

let equal_instances gl (ctx',c') (ctx,c) =
  (* How to compare instances? Do we want the terms to be convertible?
     unifiable? Do we want the universe levels to be relevant? 
     (historically, conv_x is used) *)
  List.equal Id.equal ctx ctx' && pf_conv_x gl c' c

(* Verifies if the matched list is coherent with respect to lcm *)
(* While non-linear matching is modulo eq_constr in matches, merge of *)
(* different instances of the same metavars is here modulo conversion... *)
let verify_metas_coherence gl (ln1,lcm) (ln,lm) =
  let rec aux = function
  | (id,c as x)::tl ->
      if List.for_all (fun (id',c') -> not (Id.equal id' id) || equal_instances gl c' c) lcm
      then
	x :: aux tl
      else
	raise Not_coherent_metas
  | [] -> lcm in
  (ln@ln1,aux lm)

let adjust (l,lc) = (l,List.map (fun (id,c) -> (id,([],c))) lc)

type 'a extended_matching_result =
    { e_ctx : 'a;
      e_sub : bound_ident_map * extended_patvar_map;
      e_nxt : unit -> 'a extended_matching_result }

(* Tries to match one hypothesis pattern with a list of hypotheses *)
let apply_one_mhyp_context ist env gl lmatch (hypname,patv,pat) lhyps =
  let get_id_couple id = function
    | Name idpat -> [idpat,VConstr ([],mkVar id)]
    | Anonymous -> [] in
  let match_pat lmatch hyp pat =
    match pat with
    | Term t ->
        let lmeta = extended_matches t hyp in
        (try
            let lmeta = verify_metas_coherence gl lmatch lmeta in
            { e_ctx = [];
	      e_sub = lmeta;
	      e_nxt = fun () -> raise PatternMatchingFailure }
          with
            | Not_coherent_metas -> raise PatternMatchingFailure)
    | Subterm (b,ic,t) ->
        let rec match_next_pattern find_next () =
          let s = find_next () in
          try
            let lmeta = verify_metas_coherence gl lmatch (adjust s.m_sub) in
            { e_ctx = give_context s.m_ctx ic;
	      e_sub = lmeta;
	      e_nxt = match_next_pattern s.m_nxt }
          with
            | Not_coherent_metas -> match_next_pattern s.m_nxt ()
	in
        match_next_pattern (fun () -> match_subterm_gen b t hyp) ()
  in
  let rec apply_one_mhyp_context_rec = function
    | (id,b,hyp as hd)::tl ->
	(match patv with
	| None ->
            let rec match_next_pattern find_next () =
              try
                let s = find_next () in
		{ e_ctx = (get_id_couple id hypname @ s.e_ctx), hd;
		  e_sub = s.e_sub;
                  e_nxt = match_next_pattern s.e_nxt }
              with
                | PatternMatchingFailure -> apply_one_mhyp_context_rec tl in
            match_next_pattern (fun () ->
	      let hyp = if Option.is_empty b then hyp else refresh_universes_strict hyp in
	      match_pat lmatch hyp pat) ()
	| Some patv ->
	    match b with
	    | Some body ->
                let rec match_next_pattern_in_body next_in_body () =
                  try
                    let s1 = next_in_body() in
                    let rec match_next_pattern_in_typ next_in_typ () =
                      try
			let s2 = next_in_typ() in
		        { e_ctx = (get_id_couple id hypname@s1.e_ctx@s2.e_ctx), hd;
			  e_sub = s2.e_sub;
			  e_nxt = match_next_pattern_in_typ s2.e_nxt }
                      with
                        | PatternMatchingFailure ->
                            match_next_pattern_in_body s1.e_nxt () in
                    match_next_pattern_in_typ
                      (fun () ->
			let hyp = refresh_universes_strict hyp in
			match_pat s1.e_sub hyp pat) ()
                  with PatternMatchingFailure -> apply_one_mhyp_context_rec tl
                in
                match_next_pattern_in_body
                  (fun () -> match_pat lmatch body patv) ()
            | None -> apply_one_mhyp_context_rec tl)
    | [] ->
        db_hyp_pattern_failure ist.debug env (hypname,pat);
        raise PatternMatchingFailure
  in
    apply_one_mhyp_context_rec lhyps

(* misc *)

let mk_constr_value ist gl c =
  let (sigma,c_interp) = pf_interp_constr ist gl c in
  sigma,VConstr ([],c_interp)
let mk_open_constr_value ist gl c = 
  let (sigma,c_interp) = pf_apply (interp_open_constr None ist) gl c in
  sigma,VConstr ([],c_interp)
let mk_hyp_value ist gl c = VConstr ([],mkVar (interp_hyp ist gl c))
let mk_int_or_var_value ist c = VInteger (interp_int_or_var ist c)

let pack_sigma (sigma,c) = {it=c;sigma=sigma}

let extend_gl_hyps { it=gl ; sigma=sigma } sign =
  let hyps = Goal.V82.hyps sigma gl in
  let new_hyps = List.fold_right Environ.push_named_context_val sign hyps in
  (* spiwack: (2010/01/13) if a bug was reintroduced in [change] in is probably here *)
  Goal.V82.new_goal_with sigma gl new_hyps

(* Interprets an l-tac expression into a value *)
let rec val_interp ist gl (tac:glob_tactic_expr) =
  let value_interp ist = match tac with
  (* Immediate evaluation *)
  | TacFun (it,body) -> project gl , VFun (ist.trace,ist.lfun,it,body)
  | TacLetIn (true,l,u) -> interp_letrec ist gl l u
  | TacLetIn (false,l,u) -> interp_letin ist gl l u
  | TacMatchGoal (lz,lr,lmr) -> interp_match_goal ist gl lz lr lmr
  | TacMatch (lz,c,lmr) -> interp_match ist gl lz c lmr
  | TacArg (loc,a) -> interp_tacarg ist gl a
  (* Delayed evaluation *)
  | t -> project gl , VFun (ist.trace,ist.lfun,[],t)

  in check_for_interrupt ();
    match ist.debug with
    | DebugOn lev ->
	debug_prompt lev gl tac (fun v -> value_interp {ist with debug=v})
    | _ -> value_interp ist

and eval_tactic ist = function
  | TacAtom (loc,t) ->
      fun gl ->
	let call = LtacAtomCall t in
	let tac = (* catch error in the interpretation *)
	  catch_error (push_trace(dloc,call)ist.trace)
	    (interp_atomic ist gl) t	in
	(* catch error in the evaluation *)
	catch_error (push_trace(loc,call)ist.trace) tac gl
  | TacFun _ | TacLetIn _ -> assert false
  | TacMatchGoal _ | TacMatch _ -> assert false
  | TacId s -> fun gl ->
      let res = tclIDTAC_MESSAGE (interp_message_nl ist gl s) gl in
      db_breakpoint ist.debug s; res
  | TacFail (n,s) -> fun gl -> tclFAIL (interp_int_or_var ist n) (interp_message ist gl s) gl
  | TacProgress tac -> tclPROGRESS (interp_tactic ist tac)
  | TacShowHyps tac -> tclSHOWHYPS (interp_tactic ist tac)
  | TacAbstract (tac,ido) ->
      fun gl -> Tactics.tclABSTRACT
        (Option.map (pf_interp_ident ist gl) ido) (interp_tactic ist tac) gl
  | TacThen (t1,tf,t,tl) ->
      tclTHENS3PARTS (interp_tactic ist t1)
	(Array.map (interp_tactic ist) tf) (interp_tactic ist t) (Array.map (interp_tactic ist) tl)
  | TacThens (t1,tl) -> tclTHENS (interp_tactic ist t1) (List.map (interp_tactic ist) tl)
  | TacDo (n,tac) -> tclDO (interp_int_or_var ist n) (interp_tactic ist tac)
  | TacTimeout (n,tac) -> tclTIMEOUT (interp_int_or_var ist n) (interp_tactic ist tac)
  | TacTry tac -> tclTRY (interp_tactic ist tac)
  | TacRepeat tac -> tclREPEAT (interp_tactic ist tac)
  | TacOrelse (tac1,tac2) ->
        tclORELSE (interp_tactic ist tac1) (interp_tactic ist tac2)
  | TacFirst l -> tclFIRST (List.map (interp_tactic ist) l)
  | TacSolve l -> tclSOLVE (List.map (interp_tactic ist) l)
  | TacComplete tac -> tclCOMPLETE (interp_tactic ist tac)
  | TacArg a -> interp_tactic ist (TacArg a)
  | TacInfo tac ->
      msg_warning
	(strbrk "The general \"info\" tactic is currently not working." ++ fnl () ++
	 strbrk "Some specific verbose tactics may exist instead, such as info_trivial, info_auto, info_eauto.");
      eval_tactic ist tac

and force_vrec ist gl = function
  | VRec (lfun,body) -> val_interp {ist with lfun = !lfun} gl body
  | v -> project gl , v

and interp_ltac_reference loc' mustbetac ist gl = function
  | ArgVar (loc,id) ->
      let v = List.assoc id ist.lfun in
      let (sigma,v) = force_vrec ist gl v in
      let v = propagate_trace ist loc id v in
      sigma , if mustbetac then coerce_to_tactic loc id v else v
  | ArgArg (loc,r) ->
      let ids = extract_ids [] ist.lfun in
      let loc_info = ((if Loc.is_ghost loc' then loc else loc'),LtacNameCall r) in
      let ist =
        { lfun=[]; debug=ist.debug; avoid_ids=ids;
          trace = push_trace loc_info ist.trace } in
      val_interp ist gl (lookup_ltacref r)

and interp_tacarg ist gl arg =
  let evdref = ref (project gl) in
  let v = match arg with
    | TacVoid -> VVoid
    | Reference r ->
      let (sigma,v) = interp_ltac_reference dloc false ist gl r in
      evdref := sigma;
      v
    | Integer n -> VInteger n
    | IntroPattern ipat -> VIntroPattern (snd (interp_intro_pattern ist gl ipat))
    | ConstrMayEval c ->
      let (sigma,c_interp) = interp_constr_may_eval ist gl c in
      evdref := sigma;
      VConstr ([],c_interp)
    | MetaIdArg (loc,_,id) -> assert false
    | TacCall (loc,r,[]) ->
      let (sigma,v) = interp_ltac_reference loc true ist gl r in
      evdref := sigma;
      v
    | TacCall (loc,f,l) ->
        let (sigma,fv) = interp_ltac_reference loc true ist gl f in
	let (sigma,largs) =
	  List.fold_right begin fun a (sigma',acc) ->
	    let (sigma', a_interp) = interp_tacarg ist gl a in
	    sigma' , a_interp::acc
	  end l (sigma,[])
	in
	List.iter check_is_value largs;
	let (sigma,v) = interp_app loc ist { gl with sigma=sigma } fv largs in
	evdref:= sigma;
	v
    | TacExternal (loc,com,req,la) ->
        let (sigma,la_interp) =
	  List.fold_right begin fun a (sigma,acc) ->
	    let (sigma,a_interp) = interp_tacarg ist {gl with sigma=sigma} a in
	    sigma , a_interp::acc
	  end la (project gl,[])
	in
        let (sigma,v) = interp_external loc ist { gl with sigma=sigma } com req la_interp in
	evdref := sigma;
	v
    | TacFreshId l ->
        let id = pf_interp_fresh_id ist gl l in
	VIntroPattern (IntroIdentifier id)
    | Tacexp t ->
      let (sigma,v) = val_interp ist gl t in
      evdref := sigma;
      v
    | TacDynamic(_,t) ->
        let tg = (Dyn.tag t) in
	if String.equal tg "tactic" then
          let (sigma,v) = val_interp ist gl (tactic_out t ist) in
	  evdref := sigma;
	  v
	else if String.equal tg "value" then
          value_out t
	else if String.equal tg "constr" then
        VConstr ([],constr_out t)
	else
          anomaly_loc (dloc, "Tacinterp.val_interp",
		       (str "Unknown dynamic: <" ++ str (Dyn.tag t) ++ str ">"))
  in
  !evdref , v

(* Interprets an application node *)
and interp_app loc ist gl fv largs =
  match fv with
     (* if var=[] and body has been delayed by val_interp, then body
         is not a tactic that expects arguments.
         Otherwise Ltac goes into an infinite loop (val_interp puts
         a VFun back on body, and then interp_app is called again...) *)
    | (VFun(trace,olfun,(_::_ as var),body)
      |VFun(trace,olfun,([] as var),
         (TacFun _|TacLetIn _|TacMatchGoal _|TacMatch _| TacArg _ as body))) ->
	let (newlfun,lvar,lval)=head_with_value (var,largs) in
	if List.is_empty lvar then
	  let (sigma,v) =
	    try
	      catch_error trace
		(val_interp {ist with lfun=newlfun@olfun; trace=trace} gl) body
	    with e ->
              debugging_exception_step ist false e (fun () -> str "evaluation");
	      raise e in
	  let gl = { gl with sigma=sigma } in
          debugging_step ist
	    (fun () ->
	       str"evaluation returns"++fnl()++pr_value (Some (pf_env gl)) v);
          if List.is_empty lval then sigma,v else interp_app loc ist gl v lval
	else
          project gl , VFun(trace,newlfun@olfun,lvar,body)
    | _ ->
	user_err_loc (loc, "Tacinterp.interp_app",
          (str"Illegal tactic application."))

(* Gives the tactic corresponding to the tactic value *)
and tactic_of_value ist vle g =
  match vle with
  | VRTactic res -> res
  | VFun (trace,lfun,[],t) ->
      let tac = eval_tactic {ist with lfun=lfun; trace=trace} t in
      catch_error trace tac g
  | (VFun _|VRec _) -> error "A fully applied tactic is expected."
  | VConstr _ -> errorlabstrm "" (str"Value is a term. Expected a tactic.")
  | VConstr_context _ ->
      errorlabstrm "" (str"Value is a term context. Expected a tactic.")
  | VIntroPattern _ ->
      errorlabstrm "" (str"Value is an intro pattern. Expected a tactic.")
  | _ -> errorlabstrm "" (str"Expression does not evaluate to a tactic.")

(* Evaluation with FailError catching *)
and eval_with_fail ist is_lazy goal tac =
  try
    let (sigma,v) = val_interp ist goal tac in
    sigma ,
    (match v with
    | VFun (trace,lfun,[],t) when not is_lazy ->
	let tac = eval_tactic {ist with lfun=lfun; trace=trace} t in
	VRTactic (catch_error trace tac { goal with sigma=sigma })
    | a -> a)
  with
    | FailError (0,s) | Loc.Exc_located(_, FailError (0,s))
    | Loc.Exc_located(_,LtacLocated (_,FailError (0,s))) ->
	raise (Eval_fail (Lazy.force s))
    | FailError (lvl,s) -> raise (FailError (lvl - 1, s))
    | Loc.Exc_located(s,FailError (lvl,s')) ->
	raise (Loc.Exc_located(s,FailError (lvl - 1, s')))
    | Loc.Exc_located(s,LtacLocated (s'',FailError (lvl,s'))) ->
	raise (Loc.Exc_located(s,LtacLocated (s'',FailError (lvl - 1, s'))))

(* Interprets the clauses of a recursive LetIn *)
and interp_letrec ist gl llc u =
  let lref = ref ist.lfun in
  let lve = List.map_left (fun ((_,id),b) -> (id,VRec (lref,TacArg (dloc,b)))) llc in
  lref := lve@ist.lfun;
  let ist = { ist with lfun = lve@ist.lfun } in
  val_interp ist gl u

(* Interprets the clauses of a LetIn *)
and interp_letin ist gl llc u =
  let (sigma,lve) =
    List.fold_right begin fun ((_,id),body) (sigma,acc) ->
      let (sigma,v) = interp_tacarg ist { gl with sigma=sigma } body in
      check_is_value v;
      sigma, (id,v)::acc
    end llc (project gl,[])
  in
  let ist = { ist with lfun = lve@ist.lfun } in
  val_interp ist { gl with sigma=sigma } u

(* Interprets the Match Context expressions *)
and interp_match_goal ist goal lz lr lmr =
  let (gl,sigma) = Goal.V82.nf_evar (project goal) (sig_it goal) in
  let goal = { it = gl ; sigma = sigma } in
  let hyps = pf_hyps goal in
  let hyps = if lr then List.rev hyps else hyps in
  let concl = pf_concl goal in
  let env = pf_env goal in
  let apply_goal_sub app ist (id,c) csr mt mhyps hyps =
    let rec match_next_pattern find_next () =
      let { m_sub=lgoal; m_ctx=ctxt; m_nxt=find_next' } = find_next () in
      let lctxt = give_context ctxt id in
      try apply_hyps_context ist env lz goal mt lctxt (adjust lgoal) mhyps hyps
      with e when is_match_catchable e -> match_next_pattern find_next' () in
    match_next_pattern (fun () -> match_subterm_gen app c csr) () in
  let rec apply_match_goal ist env goal nrs lex lpt =
    begin
      let () = match lex with
      | r :: _ -> db_pattern_rule ist.debug nrs r
      | _ -> ()
      in
      match lpt with
	| (All t)::tl ->
	    begin
              db_mc_pattern_success ist.debug;
              try eval_with_fail ist lz goal t
              with e when is_match_catchable e ->
		apply_match_goal ist env goal (nrs+1) (List.tl lex) tl
	    end
	| (Pat (mhyps,mgoal,mt))::tl ->
            let mhyps = List.rev mhyps (* Sens naturel *) in
	    (match mgoal with
             | Term mg ->
		 (try
		     let lmatch = extended_matches mg concl in
		     db_matched_concl ist.debug env concl;
		     apply_hyps_context ist env lz goal mt [] lmatch mhyps hyps
		   with e when is_match_catchable e ->
		     (match e with
		       | PatternMatchingFailure -> db_matching_failure ist.debug
		       | Eval_fail s -> db_eval_failure ist.debug s
		       | _ -> db_logic_failure ist.debug e);
		     apply_match_goal ist env goal (nrs+1) (List.tl lex) tl)
	     | Subterm (b,id,mg) ->
		 (try apply_goal_sub b ist (id,mg) concl mt mhyps hyps
		   with
		     | PatternMatchingFailure ->
			 apply_match_goal ist env goal (nrs+1) (List.tl lex) tl))
	| _ ->
	    errorlabstrm "Tacinterp.apply_match_goal"
              (v 0 (str "No matching clauses for match goal" ++
		      (if ist.debug == DebugOff then
			 fnl() ++ str "(use \"Set Ltac Debug\" for more info)"
		       else mt()) ++ str"."))
    end in
    apply_match_goal ist env goal 0 lmr
      (read_match_rule (fst (extract_ltac_constr_values ist env))
	ist env (project goal) lmr)

(* Tries to match the hypotheses in a Match Context *)
and apply_hyps_context ist env lz goal mt lctxt lgmatch mhyps hyps =
  let rec apply_hyps_context_rec lfun lmatch lhyps_rest = function
    | hyp_pat::tl ->
	let (hypname, _, _ as hyp_pat) =
	  match hyp_pat with
	  | Hyp ((_,hypname),mhyp) -> hypname,  None, mhyp
	  | Def ((_,hypname),mbod,mhyp) -> hypname, Some mbod, mhyp
	in
        let rec match_next_pattern find_next =
          let s = find_next () in
	  let lids,hyp_match = s.e_ctx in
          db_matched_hyp ist.debug (pf_env goal) hyp_match hypname;
	  try
            let id_match = pi1 hyp_match in
            let nextlhyps = List.remove_assoc_in_triple id_match lhyps_rest in
            apply_hyps_context_rec (lfun@lids) s.e_sub nextlhyps tl
          with e when is_match_catchable e ->
	    match_next_pattern s.e_nxt in
        let init_match_pattern () =
          apply_one_mhyp_context ist env goal lmatch hyp_pat lhyps_rest in
        match_next_pattern init_match_pattern
    | [] ->
        let lfun = extend_values_with_bindings lmatch (lfun@ist.lfun) in
        db_mc_pattern_success ist.debug;
        eval_with_fail {ist with lfun=lfun} lz goal mt
  in
  apply_hyps_context_rec lctxt lgmatch hyps mhyps

and interp_external loc ist gl com req la =
  let f ch = extern_request ch req gl la in
  let g ch = internalise_tacarg ch in
  interp_tacarg ist gl (System.connect f g com)

  (* Interprets extended tactic generic arguments *)
and interp_genarg ist gl x =
  let evdref = ref (project gl) in
  let rec interp_genarg ist gl x =
    let gl = { gl with sigma = !evdref } in
    match genarg_tag x with
    | BoolArgType -> in_gen wit_bool (out_gen globwit_bool x)
    | IntArgType -> in_gen wit_int (out_gen globwit_int x)
    | IntOrVarArgType ->
      in_gen wit_int_or_var
        (ArgArg (interp_int_or_var ist (out_gen globwit_int_or_var x)))
    | StringArgType ->
      in_gen wit_string (out_gen globwit_string x)
    | PreIdentArgType ->
      in_gen wit_pre_ident (out_gen globwit_pre_ident x)
    | IntroPatternArgType ->
      in_gen wit_intro_pattern
        (interp_intro_pattern ist gl (out_gen globwit_intro_pattern x))
    | IdentArgType b ->
      in_gen (wit_ident_gen b)
        (pf_interp_fresh_ident ist gl (out_gen (globwit_ident_gen b) x))
    | VarArgType ->
      in_gen wit_var (interp_hyp ist gl (out_gen globwit_var x))
    | RefArgType ->
      in_gen wit_ref (pf_interp_reference ist gl (out_gen globwit_ref x))
    | SortArgType ->
      let (sigma,c_interp) =
	pf_interp_constr ist gl
	  (GSort (dloc,out_gen globwit_sort x), None)
      in
      evdref := sigma;
      in_gen wit_sort
        (destSort c_interp)
    | ConstrArgType ->
      let (sigma,c_interp) = pf_interp_constr ist gl (out_gen globwit_constr x) in
      evdref := sigma;
      in_gen wit_constr c_interp
    | ConstrMayEvalArgType ->
      let (sigma,c_interp) = interp_constr_may_eval ist gl (out_gen globwit_constr_may_eval x) in
      evdref := sigma;
      in_gen wit_constr_may_eval c_interp
    | QuantHypArgType ->
      in_gen wit_quant_hyp
        (interp_declared_or_quantified_hypothesis ist gl
           (out_gen globwit_quant_hyp x))
    | RedExprArgType ->
      let (sigma,r_interp) = pf_interp_red_expr ist gl (out_gen globwit_red_expr x) in
      evdref := sigma;
      in_gen wit_red_expr r_interp
    | OpenConstrArgType casted ->
      in_gen (wit_open_constr_gen casted)
        (interp_open_constr (if casted then Some (pf_concl gl) else None)
           ist (pf_env gl) (project gl)
           (snd (out_gen (globwit_open_constr_gen casted) x)))
    | ConstrWithBindingsArgType ->
      in_gen wit_constr_with_bindings
        (pack_sigma (interp_constr_with_bindings ist (pf_env gl) (project gl)
		       (out_gen globwit_constr_with_bindings x)))
    | BindingsArgType ->
      in_gen wit_bindings
        (pack_sigma (interp_bindings ist (pf_env gl) (project gl) (out_gen globwit_bindings x)))
    | List0ArgType ConstrArgType ->
        let (sigma,v) = interp_genarg_constr_list0 ist gl x in
	evdref := sigma;
	v
    | List1ArgType ConstrArgType ->
        let (sigma,v) = interp_genarg_constr_list1 ist gl x in
	evdref := sigma;
	v
    | List0ArgType VarArgType -> interp_genarg_var_list0 ist gl x
    | List1ArgType VarArgType -> interp_genarg_var_list1 ist gl x
    | List0ArgType _ -> app_list0 (interp_genarg ist gl) x
    | List1ArgType _ -> app_list1 (interp_genarg ist gl) x
    | OptArgType _ -> app_opt (interp_genarg ist gl) x
    | PairArgType _ -> app_pair (interp_genarg ist gl) (interp_genarg ist gl) x
    | ExtraArgType s ->
      match tactic_genarg_level s with
      | Some n ->
          (* Special treatment of tactic arguments *)
        in_gen (wit_tactic n)
	  (TacArg(dloc,valueIn(VFun(ist.trace,ist.lfun,[],
				    out_gen (globwit_tactic n) x))))
      | None ->
        let (sigma,v) = lookup_interp_genarg s ist gl x in
	evdref:=sigma;
	v
  in
  let v = interp_genarg ist gl x in
  !evdref , v

and interp_genarg_constr_list0 ist gl x =
  let lc = out_gen (wit_list0 globwit_constr) x in
  let (sigma,lc) = pf_apply (interp_constr_list ist) gl lc in
  sigma , in_gen (wit_list0 wit_constr) lc

and interp_genarg_constr_list1 ist gl x =
  let lc = out_gen (wit_list1 globwit_constr) x in
  let (sigma,lc) = pf_apply (interp_constr_list ist) gl lc in
  sigma , in_gen (wit_list1 wit_constr) lc

and interp_genarg_var_list0 ist gl x =
  let lc = out_gen (wit_list0 globwit_var) x in
  let lc = interp_hyp_list ist gl lc in
  in_gen (wit_list0 wit_var) lc

and interp_genarg_var_list1 ist gl x =
  let lc = out_gen (wit_list1 globwit_var) x in
  let lc = interp_hyp_list ist gl lc in
  in_gen (wit_list1 wit_var) lc

(* Interprets the Match expressions *)
and interp_match ist g lz constr lmr =
  let apply_match_subterm app ist (id,c) csr mt =
    let rec match_next_pattern find_next () =
      let { m_sub=lmatch; m_ctx=ctxt; m_nxt=find_next' } = find_next () in
      let lctxt = give_context ctxt id in
      let lfun = extend_values_with_bindings (adjust lmatch) (lctxt@ist.lfun) in
      try eval_with_fail {ist with lfun=lfun} lz g mt
      with e when is_match_catchable e ->
        match_next_pattern find_next' () in
    match_next_pattern (fun () -> match_subterm_gen app c csr) () in
  let rec apply_match ist sigma csr = let g = { g with sigma=sigma } in function
    | (All t)::tl ->
        (try eval_with_fail ist lz g t
         with e when is_match_catchable e -> apply_match ist sigma csr tl)
    | (Pat ([],Term c,mt))::tl ->
        (try
            let lmatch =
              try extended_matches c csr
              with e ->
                debugging_exception_step ist false e (fun () ->
                  str "matching with pattern" ++ fnl () ++
                  pr_constr_pattern_env (pf_env g) c);
                raise e in
            try
              let lfun = extend_values_with_bindings lmatch ist.lfun in
              eval_with_fail { ist with lfun=lfun } lz g mt
            with e ->
              debugging_exception_step ist false e (fun () ->
                str "rule body for pattern" ++
                pr_constr_pattern_env (pf_env g) c);
              raise e
         with e when is_match_catchable e ->
           debugging_step ist (fun () -> str "switching to the next rule");
           apply_match ist sigma csr tl)

    | (Pat ([],Subterm (b,id,c),mt))::tl ->
        (try apply_match_subterm b ist (id,c) csr mt
         with PatternMatchingFailure -> apply_match ist sigma csr tl)
    | _ ->
      errorlabstrm "Tacinterp.apply_match" (str
        "No matching clauses for match.") in
  let (sigma,csr) =
      try interp_ltac_constr ist g constr with e ->
        debugging_exception_step ist true e
          (fun () -> str "evaluation of the matched expression");
        raise e in
  let ilr = read_match_rule (fst (extract_ltac_constr_values ist (pf_env g))) ist (pf_env g) sigma lmr in
  let res =
     try apply_match ist sigma csr ilr with e ->
       debugging_exception_step ist true e (fun () -> str "match expression");
       raise e in
  debugging_step ist (fun () ->
    str "match expression returns " ++ pr_value (Some (pf_env g)) (snd res));
  res

(* Interprets tactic expressions : returns a "constr" *)
and interp_ltac_constr ist gl e =
  let (sigma, result) =
  try val_interp ist gl e with Not_found ->
    debugging_step ist (fun () ->
      str "evaluation failed for" ++ fnl() ++
      Pptactic.pr_glob_tactic (pf_env gl) e);
    raise Not_found in
  try
    let cresult = constr_of_value (pf_env gl) result in
    debugging_step ist (fun () ->
      Pptactic.pr_glob_tactic (pf_env gl) e ++ fnl() ++
      str " has value " ++ fnl() ++
      pr_constr_under_binders_env (pf_env gl) cresult);
    if not (List.is_empty (fst cresult)) then raise Not_found;
    sigma , snd cresult
  with Not_found ->
    errorlabstrm ""
      (str "Must evaluate to a closed term" ++ fnl() ++
	  str "offending expression: " ++ fnl() ++
          Pptactic.pr_glob_tactic (pf_env gl) e ++ fnl() ++ str "this is a " ++
          (match result with
            | VRTactic _ -> str "VRTactic"
            | VFun (_,il,ul,b) ->
                (str "VFun with body " ++ fnl() ++
                    Pptactic.pr_glob_tactic (pf_env gl) b ++ fnl() ++
		    str "instantiated arguments " ++ fnl() ++
                    List.fold_right
                    (fun p s ->
                      let (i,v) = p in str (Id.to_string i) ++ str ", " ++ s)
                    il (str "") ++
                    str "uninstantiated arguments " ++ fnl() ++
                    List.fold_right
                    (fun opt_id s ->
                      (match opt_id with
                          Some id -> str (Id.to_string id)
                        | None -> str "_") ++ str ", " ++ s)
                    ul (mt()))
            | VVoid -> str "VVoid"
            | VInteger _ -> str "VInteger"
            | VConstr _ -> str "VConstr"
            | VIntroPattern _ -> str "VIntroPattern"
            | VConstr_context _ -> str "VConstrr_context"
            | VRec _ -> str "VRec"
            | VList _ -> str "VList") ++ str".")

(* Interprets tactic expressions : returns a "tactic" *)
and interp_tactic ist tac gl =
  let (sigma,v) = val_interp ist gl tac in
  tactic_of_value ist v { gl with sigma=sigma }

(* Interprets a primitive tactic *)
and interp_atomic ist gl tac =
  let env = pf_env gl and sigma = project gl in
  match tac with
  (* Basic tactics *)
  | TacIntroPattern l ->
      h_intro_patterns (interp_intro_pattern_list_as_list ist gl l)
  | TacIntrosUntil hyp ->
      h_intros_until (interp_quantified_hypothesis ist hyp)
  | TacIntroMove (ido,hto) ->
      h_intro_move (Option.map (interp_fresh_ident ist env) ido)
                   (interp_move_location ist gl hto)
  | TacAssumption -> h_assumption
  | TacExact c ->
      let (sigma,c_interp) = pf_interp_casted_constr ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(h_exact c_interp)
  | TacExactNoCheck c ->
      let (sigma,c_interp) = pf_interp_constr ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(h_exact_no_check c_interp)
  | TacVmCastNoCheck c ->
      let (sigma,c_interp) = pf_interp_constr ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(h_vm_cast_no_check c_interp)
  | TacApply (a,ev,cb,cl) ->
      let sigma, l =
        List.fold_map (interp_open_constr_with_bindings_loc ist env) sigma cb
      in
      let tac = match cl with
        | None -> h_apply a ev
        | Some cl ->
            (fun l -> h_apply_in a ev l (interp_in_hyp_as ist gl cl)) in
      tclWITHHOLES ev tac sigma l
  | TacElim (ev,cb,cbo) ->
      let sigma, cb = interp_constr_with_bindings ist env sigma cb in
      let sigma, cbo = Option.fold_map (interp_constr_with_bindings ist env) sigma cbo in
      tclWITHHOLES ev (h_elim ev cb) sigma cbo
  | TacElimType c ->
      let (sigma,c_interp) = pf_interp_type ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(h_elim_type c_interp)
  | TacCase (ev,cb) ->
      let sigma, cb = interp_constr_with_bindings ist env sigma cb in
      tclWITHHOLES ev (h_case ev) sigma cb
  | TacCaseType c ->
      let (sigma,c_interp) = pf_interp_type ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(h_case_type c_interp)
  | TacFix (idopt,n) -> h_fix (Option.map (interp_fresh_ident ist env) idopt) n
  | TacMutualFix (id,n,l) ->
      let f sigma (id,n,c) =
	let (sigma,c_interp) = pf_interp_type ist { gl with sigma=sigma } c in
	sigma , (interp_fresh_ident ist env id,n,c_interp) in
      let (sigma,l_interp) =
	List.fold_right begin fun c (sigma,acc) ->
	  let (sigma,c_interp) = f sigma c in
	  sigma , c_interp::acc
	end l (project gl,[])
      in
      tclTHEN
	(tclEVARS sigma)
	(h_mutual_fix (interp_fresh_ident ist env id) n l_interp)
  | TacCofix idopt -> h_cofix (Option.map (interp_fresh_ident ist env) idopt)
  | TacMutualCofix (id,l) ->
      let f sigma (id,c) =
	let (sigma,c_interp) = pf_interp_type ist { gl with sigma=sigma } c in
	sigma , (interp_fresh_ident ist env id,c_interp) in
      let (sigma,l_interp) =
	List.fold_right begin fun c (sigma,acc) ->
	  let (sigma,c_interp) = f sigma c in
	  sigma , c_interp::acc
	end l (project gl,[])
      in
      tclTHEN
	(tclEVARS sigma)
	(h_mutual_cofix (interp_fresh_ident ist env id) l_interp)
  | TacCut c ->
      let (sigma,c_interp) = pf_interp_type ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(h_cut c_interp)
  | TacAssert (t,ipat,c) ->
      let (sigma,c) = (if Option.is_empty t then interp_constr else interp_type) ist env sigma c in
      tclTHEN
	(tclEVARS sigma)
        (Tactics.forward (Option.map (interp_tactic ist) t)
	   (Option.map (interp_intro_pattern ist gl) ipat) c)
  | TacGeneralize cl ->
      let sigma, cl = interp_constr_with_occurrences_and_name_as_list ist env sigma cl in
      tclWITHHOLES false (h_generalize_gen) sigma cl
  | TacGeneralizeDep c ->
      let (sigma,c_interp) = pf_interp_constr ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(h_generalize_dep c_interp)
  | TacLetTac (na,c,clp,b,eqpat) ->
      let clp = interp_clause ist gl clp in
      if Locusops.is_nowhere clp then
        (* We try to fully-typecheck the term *)
	let (sigma,c_interp) = pf_interp_constr ist gl c in
	tclTHEN
	  (tclEVARS sigma)
          (h_let_tac b (interp_fresh_name ist env na) c_interp clp eqpat)
      else
        (* We try to keep the pattern structure as much as possible *)
        h_let_pat_tac b (interp_fresh_name ist env na)
          (interp_pure_open_constr ist env sigma c) clp eqpat

  (* Automation tactics *)
  | TacTrivial (debug,lems,l) ->
      Auto.h_trivial ~debug
	(interp_auto_lemmas ist env sigma lems)
	(Option.map (List.map (interp_hint_base ist)) l)
  | TacAuto (debug,n,lems,l) ->
      Auto.h_auto ~debug (Option.map (interp_int_or_var ist) n)
	(interp_auto_lemmas ist env sigma lems)
	(Option.map (List.map (interp_hint_base ist)) l)

  (* Derived basic tactics *)
  | TacSimpleInductionDestruct (isrec,h) ->
      h_simple_induction_destruct isrec (interp_quantified_hypothesis ist h)
  | TacInductionDestruct (isrec,ev,(l,el,cls)) ->
      let sigma, l =
        List.fold_map (fun sigma (c,(ipato,ipats)) ->
          let c = interp_induction_arg ist gl c in
          (sigma,(c,
            (Option.map (interp_intro_pattern ist gl) ipato,
	     Option.map (interp_intro_pattern ist gl) ipats)))) sigma l in
      let sigma,el =
        Option.fold_map (interp_constr_with_bindings ist env) sigma el in
      let cls = Option.map (interp_clause ist gl) cls in
      tclWITHHOLES ev (h_induction_destruct isrec ev) sigma (l,el,cls)
  | TacDoubleInduction (h1,h2) ->
      let h1 = interp_quantified_hypothesis ist h1 in
      let h2 = interp_quantified_hypothesis ist h2 in
      Elim.h_double_induction h1 h2
  | TacDecomposeAnd c ->
      let (sigma,c_interp) = pf_interp_constr ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(Elim.h_decompose_and c_interp)
  | TacDecomposeOr c ->
      let (sigma,c_interp) = pf_interp_constr ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(Elim.h_decompose_or c_interp)
  | TacDecompose (l,c) ->
      let l = List.map (interp_inductive ist) l in
      let (sigma,c_interp) = pf_interp_constr ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(Elim.h_decompose l c_interp)
  | TacSpecialize (n,cb) ->
      let sigma, cb = interp_constr_with_bindings ist env sigma cb in
      tclWITHHOLES false (h_specialize n) sigma cb
  | TacLApply c ->
      let (sigma,c_interp) = pf_interp_constr ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(h_lapply c_interp)

  (* Context management *)
  | TacClear (b,l) -> h_clear b (interp_hyp_list ist gl l)
  | TacClearBody l -> h_clear_body (interp_hyp_list ist gl l)
  | TacMove (dep,id1,id2) ->
      h_move dep (interp_hyp ist gl id1) (interp_move_location ist gl id2)
  | TacRename l ->
      h_rename (List.map (fun (id1,id2) ->
			    interp_hyp ist gl id1,
			    interp_fresh_ident ist env (snd id2)) l)
  | TacRevert l -> h_revert (interp_hyp_list ist gl l)

  (* Constructors *)
  | TacLeft (ev,bl) ->
      let sigma, bl = interp_bindings ist env sigma bl in
      tclWITHHOLES ev (h_left ev) sigma bl
  | TacRight (ev,bl) ->
      let sigma, bl = interp_bindings ist env sigma bl in
      tclWITHHOLES ev (h_right ev) sigma bl
  | TacSplit (ev,_,bll) ->
      let sigma, bll = List.fold_map (interp_bindings ist env) sigma bll in
      tclWITHHOLES ev (h_split ev) sigma bll
  | TacAnyConstructor (ev,t) ->
      Tactics.any_constructor ev (Option.map (interp_tactic ist) t)
  | TacConstructor (ev,n,bl) ->
      let sigma, bl = interp_bindings ist env sigma bl in
      tclWITHHOLES ev (h_constructor ev (interp_int_or_var ist n)) sigma bl

  (* Conversion *)
  | TacReduce (r,cl) ->
      let (sigma,r_interp) = pf_interp_red_expr ist gl r in
      tclTHEN
	(tclEVARS sigma)
	(h_reduce r_interp (interp_clause ist gl cl))
  | TacChange (None,c,cl) ->
      let is_onhyps = match cl.onhyps with
      | None | Some [] -> true
      | _ -> false
      in
      let is_onconcl = match cl.concl_occs with
      | AllOccurrences | NoOccurrences -> true
      | _ -> false
      in
      let (sigma,c_interp) =
	if is_onhyps && is_onconcl
	 then pf_interp_type ist gl c
	 else pf_interp_constr ist gl c
      in
      tclTHEN
	(tclEVARS sigma)
	(h_change None c_interp (interp_clause ist gl cl))
  | TacChange (Some op,c,cl) ->
      let sign,op = interp_typed_pattern ist env sigma op in
      (* spiwack: (2012/04/18) the evar_map output by pf_interp_constr
	 is dropped as the evar_map taken as input (from
	 extend_gl_hyps) is incorrect.  This means that evar
	 instantiated by pf_interp_constr may be lost, there. *)
      let (_,c_interp) =
	try pf_interp_constr ist (extend_gl_hyps gl sign) c
	with Not_found | Anomaly _ (* Hack *) ->
	   errorlabstrm "" (strbrk "Failed to get enough information from the left-hand side to type the right-hand side.")
      in
      tclTHEN
	(tclEVARS sigma)
	(h_change (Some op) c_interp (interp_clause ist { gl with sigma=sigma } cl))

  (* Equivalence relations *)
  | TacReflexivity -> h_reflexivity
  | TacSymmetry c -> h_symmetry (interp_clause ist gl c)
  | TacTransitivity c ->
    begin match c with
    | None -> h_transitivity None
    | Some c ->
      let (sigma,c_interp) = pf_interp_constr ist gl c in
      tclTHEN
	(tclEVARS sigma)
	(h_transitivity (Some c_interp))
    end

  (* Equality and inversion *)
  | TacRewrite (ev,l,cl,by) ->
      let l = List.map (fun (b,m,c) ->
        let f env sigma = interp_open_constr_with_bindings ist env sigma c in
	(b,m,f)) l in
      let cl = interp_clause ist gl cl in
      Equality.general_multi_multi_rewrite ev l cl
        (Option.map (fun by -> tclCOMPLETE (interp_tactic ist by), Equality.Naive) by)
  | TacInversion (DepInversion (k,c,ids),hyp) ->
      let (sigma,c_interp) =
	match c with
	| None -> sigma , None
	| Some c ->
	  let (sigma,c_interp) = pf_interp_constr ist gl c in
	  sigma , Some c_interp
      in
      Inv.dinv k c_interp
        (Option.map (interp_intro_pattern ist gl) ids)
        (interp_declared_or_quantified_hypothesis ist gl hyp)
  | TacInversion (NonDepInversion (k,idl,ids),hyp) ->
      Inv.inv_clause k
        (Option.map (interp_intro_pattern ist gl) ids)
        (interp_hyp_list ist gl idl)
        (interp_declared_or_quantified_hypothesis ist gl hyp)
  | TacInversion (InversionUsing (c,idl),hyp) ->
      let (sigma,c_interp) = pf_interp_constr ist gl c in
      Leminv.lemInv_clause (interp_declared_or_quantified_hypothesis ist gl hyp)
        c_interp
        (interp_hyp_list ist gl idl)

  (* For extensions *)
  | TacExtend (loc,opn,l) ->
      let tac = lookup_tactic opn in
      let (sigma,args) = 
	List.fold_right begin fun a (sigma,acc) ->
	  let (sigma,a_interp) = interp_genarg ist { gl with sigma=sigma } a in
	  sigma , a_interp::acc
	end l (project gl,[])
      in
      tac args
  | TacAlias (loc,s,l,(_,body)) -> fun gl ->
    let evdref = ref gl.sigma in
    let f x = match genarg_tag x with
    | IntArgType ->
        VInteger (out_gen globwit_int x)
    | IntOrVarArgType ->
        mk_int_or_var_value ist (out_gen globwit_int_or_var x)
    | PreIdentArgType ->
	failwith "pre-identifiers cannot be bound"
    | IntroPatternArgType ->
	VIntroPattern
	  (snd (interp_intro_pattern ist gl (out_gen globwit_intro_pattern x)))
    | IdentArgType b ->
	value_of_ident (interp_fresh_ident ist env
	  (out_gen (globwit_ident_gen b) x))
    | VarArgType ->
        mk_hyp_value ist gl (out_gen globwit_var x)
    | RefArgType ->
        VConstr ([],constr_of_global
          (pf_interp_reference ist gl (out_gen globwit_ref x)))
    | SortArgType ->
        VConstr ([],mkSort (interp_sort (out_gen globwit_sort x)))
    | ConstrArgType ->
        let (sigma,v) = mk_constr_value ist gl (out_gen globwit_constr x) in
	evdref := sigma;
	v
    | OpenConstrArgType false ->
        let (sigma,v) = mk_open_constr_value ist gl (snd (out_gen globwit_open_constr x)) in
	evdref := sigma;
	v
    | ConstrMayEvalArgType ->
        let (sigma,c_interp) = interp_constr_may_eval ist gl (out_gen globwit_constr_may_eval x) in
	evdref := sigma;
	VConstr ([],c_interp)
    | ExtraArgType s when not (Option.is_empty (tactic_genarg_level s)) ->
          (* Special treatment of tactic arguments *)
	let (sigma,v) = val_interp ist gl
          (out_gen (globwit_tactic (Option.get (tactic_genarg_level s))) x)
	in
	evdref := sigma;
	v
    | List0ArgType ConstrArgType ->
        let wit = wit_list0 globwit_constr in
	let (sigma,l_interp) =
	  List.fold_right begin fun c (sigma,acc) ->
	    let (sigma,c_interp) = mk_constr_value ist { gl with sigma=sigma } c in
	    sigma , c_interp::acc
	  end (out_gen wit x) (project gl,[])
	in
	evdref := sigma;
        VList (l_interp)
    | List0ArgType VarArgType ->
        let wit = wit_list0 globwit_var in
        VList (List.map (mk_hyp_value ist gl) (out_gen wit x))
    | List0ArgType IntArgType ->
        let wit = wit_list0 globwit_int in
        VList (List.map (fun x -> VInteger x) (out_gen wit x))
    | List0ArgType IntOrVarArgType ->
        let wit = wit_list0 globwit_int_or_var in
        VList (List.map (mk_int_or_var_value ist) (out_gen wit x))
    | List0ArgType (IdentArgType b) ->
        let wit = wit_list0 (globwit_ident_gen b) in
	let mk_ident x = value_of_ident (interp_fresh_ident ist env x) in
        VList (List.map mk_ident (out_gen wit x))
    | List0ArgType IntroPatternArgType ->
        let wit = wit_list0 globwit_intro_pattern in
	let mk_ipat x = VIntroPattern (snd (interp_intro_pattern ist gl x)) in
        VList (List.map mk_ipat (out_gen wit x))
    | List1ArgType ConstrArgType ->
        let wit = wit_list1 globwit_constr in
	let (sigma, l_interp) =
	  List.fold_right begin fun c (sigma,acc) ->
	    let (sigma,c_interp) = mk_constr_value ist { gl with sigma=sigma } c in
	    sigma , c_interp::acc
	  end (out_gen wit x) (project gl,[])
	in
	evdref:=sigma;
        VList l_interp
    | List1ArgType VarArgType ->
        let wit = wit_list1 globwit_var in
        VList (List.map (mk_hyp_value ist gl) (out_gen wit x))
    | List1ArgType IntArgType ->
        let wit = wit_list1 globwit_int in
        VList (List.map (fun x -> VInteger x) (out_gen wit x))
    | List1ArgType IntOrVarArgType ->
        let wit = wit_list1 globwit_int_or_var in
        VList (List.map (mk_int_or_var_value ist) (out_gen wit x))
    | List1ArgType (IdentArgType b) ->
        let wit = wit_list1 (globwit_ident_gen b) in
	let mk_ident x = value_of_ident (interp_fresh_ident ist env x) in
        VList (List.map mk_ident (out_gen wit x))
    | List1ArgType IntroPatternArgType ->
        let wit = wit_list1 globwit_intro_pattern in
	let mk_ipat x = VIntroPattern (snd (interp_intro_pattern ist gl x)) in
        VList (List.map mk_ipat (out_gen wit x))
    | StringArgType | BoolArgType
    | QuantHypArgType | RedExprArgType
    | OpenConstrArgType _ | ConstrWithBindingsArgType
    | ExtraArgType _ | BindingsArgType
    | OptArgType _ | PairArgType _
    | List0ArgType _ | List1ArgType _
	-> error "This argument type is not supported in tactic notations."

    in
    let lfun = (List.map (fun (x,c) -> (x,f c)) l)@ist.lfun in
    let trace = push_trace (loc,LtacNotationCall s) ist.trace in
    let gl = { gl with sigma = !evdref } in
    interp_tactic { ist with lfun=lfun; trace=trace } body gl

(* Initial call for interpretation *)

let eval_tactic t gls =
  db_initialize ();
  interp_tactic { lfun=[]; avoid_ids=[]; debug=get_debug(); trace=[] }
    t gls

(* globalization + interpretation *)

let interp_tac_gen lfun avoid_ids debug t gl =
  interp_tactic { lfun=lfun; avoid_ids=avoid_ids; debug=debug; trace=[] }
    (intern_pure_tactic {
      ltacvars = (List.map fst lfun, []); ltacrecvars = [];
      gsigma = project gl; genv = pf_env gl } t) gl

let interp t = interp_tac_gen [] [] (get_debug()) t

let eval_ltac_constr gl t =
  interp_ltac_constr
    { lfun=[]; avoid_ids=[]; debug=get_debug(); trace=[] } gl
    (intern_tactic_or_tacarg (make_empty_glob_sign ()) t )

(* Used to hide interpretation for pretty-print, now just launch tactics *)
let hide_interp t ot gl =
  let ist = { ltacvars = ([],[]); ltacrecvars = [];
            gsigma = project gl; genv = pf_env gl } in
  let te = intern_pure_tactic ist t in
  let t = eval_tactic te in
  match ot with
  | None -> t gl
  | Some t' -> (tclTHEN t t') gl


(***************************************************************************)
(* Other entry points *)

let interp_redexp env sigma r =
  let ist = { lfun=[]; avoid_ids=[]; debug=get_debug (); trace=[] } in
  let gist = { fully_empty_glob_sign with genv = env; gsigma = sigma } in
  interp_red_expr ist sigma env (intern_red_expr gist r)

(***************************************************************************)
(* Embed tactics in raw or glob tactic expr *)

let globTacticIn t = TacArg (dloc,TacDynamic (dloc,tactic_in t))
let tacticIn t =
  globTacticIn (fun ist ->
    try glob_tactic (t ist)
    with e -> anomalylabstrm "tacticIn"
      (str "Incorrect tactic expression. Received exception is:" ++
       Errors.print e))

(***************************************************************************)
(* Backwarding recursive needs of tactic glob/interp/eval functions *)

let _ = Auto.set_extern_interp
  (fun l ->
    let l = List.map (fun (id,c) -> (id,VConstr ([],c))) l in
    interp_tactic {lfun=l;avoid_ids=[];debug=get_debug(); trace=[]})
