(***********************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team    *)
(* <O___,, *        INRIA-Rocquencourt  &  LRI-CNRS-Orsay              *)
(*   \VV/  *************************************************************)
(*    //   *      This file is distributed under the terms of the      *)
(*         *       GNU Lesser General Public License Version 2.1       *)
(***********************************************************************)

(* $Id$ *)

(** * Finite set library *)

(** Set interfaces, inspired by the one of Ocaml. When compared with
    Ocaml, the main differences are:
    - the lack of [iter] function, useless since Coq is purely functional
    - the use of [option] types instead of [Not_found] exceptions
    - the use of [nat] instead of [int] for the [cardinal] function

    Several variants of the set interfaces are available:
    - [WSetsOn] : functorial signature for weak sets
    - [WSets]   : self-contained version of [WSets]
    - [SetsOn]  : functorial signature for ordered sets
    - [Sets]    : self-contained version of [Sets]
    - [WRawSets] : a signature for weak sets that may be ill-formed
    - [RawSets]  : same for ordered sets

    If unsure, [S = Sets] is probably what you're looking for: most other
    signatures are subsets of it, while [Sets] can be obtained from
    [RawSets] via the use of a subset type (see (W)Raw2Sets below).
*)

Require Export Bool OrderedType2 DecidableType2.
Set Implicit Arguments.
Unset Strict Implicit.

Module Type WOps (E : DecidableType).

  Definition elt := E.t.

  Parameter t : Type. (** the abstract type of sets *)

  Parameter empty : t.
  (** The empty set. *)

  Parameter is_empty : t -> bool.
  (** Test whether a set is empty or not. *)

  Parameter mem : elt -> t -> bool.
  (** [mem x s] tests whether [x] belongs to the set [s]. *)

  Parameter add : elt -> t -> t.
  (** [add x s] returns a set containing all elements of [s],
  plus [x]. If [x] was already in [s], [s] is returned unchanged. *)

  Parameter singleton : elt -> t.
  (** [singleton x] returns the one-element set containing only [x]. *)

  Parameter remove : elt -> t -> t.
  (** [remove x s] returns a set containing all elements of [s],
  except [x]. If [x] was not in [s], [s] is returned unchanged. *)

  Parameter union : t -> t -> t.
  (** Set union. *)

  Parameter inter : t -> t -> t.
  (** Set intersection. *)

  Parameter diff : t -> t -> t.
  (** Set difference. *)

  Parameter equal : t -> t -> bool.
  (** [equal s1 s2] tests whether the sets [s1] and [s2] are
  equal, that is, contain equal elements. *)

  Parameter subset : t -> t -> bool.
  (** [subset s1 s2] tests whether the set [s1] is a subset of
  the set [s2]. *)

  Parameter fold : forall A : Type, (elt -> A -> A) -> t -> A -> A.
  (** [fold f s a] computes [(f xN ... (f x2 (f x1 a))...)],
  where [x1 ... xN] are the elements of [s].
  The order in which elements of [s] are presented to [f] is
  unspecified. *)

  Parameter for_all : (elt -> bool) -> t -> bool.
  (** [for_all p s] checks if all elements of the set
  satisfy the predicate [p]. *)

  Parameter exists_ : (elt -> bool) -> t -> bool.
  (** [exists p s] checks if at least one element of
  the set satisfies the predicate [p]. *)

  Parameter filter : (elt -> bool) -> t -> t.
  (** [filter p s] returns the set of all elements in [s]
  that satisfy predicate [p]. *)

  Parameter partition : (elt -> bool) -> t -> t * t.
  (** [partition p s] returns a pair of sets [(s1, s2)], where
  [s1] is the set of all the elements of [s] that satisfy the
  predicate [p], and [s2] is the set of all the elements of
  [s] that do not satisfy [p]. *)

  Parameter cardinal : t -> nat.
  (** Return the number of elements of a set. *)

  Parameter elements : t -> list elt.
  (** Return the list of all elements of the given set, in any order. *)

  Parameter choose : t -> option elt.
  (** Return one element of the given set, or [None] if
  the set is empty. Which element is chosen is unspecified.
  Equal sets could return different elements. *)

End WOps.




(** ** Functorial signature for weak sets

    Weak sets are sets without ordering on base elements, only
    a decidable equality. *)

Module Type WSetsOn (E : DecidableType).
  (** First, we ask for all the functions *)
  Include Type WOps E.

  (** Logical predicates *)
  Parameter In : elt -> t -> Prop.
  Instance In_compat : Proper (E.eq==>eq==>iff) In.

  Definition Equal s s' := forall a : elt, In a s <-> In a s'.
  Definition Subset s s' := forall a : elt, In a s -> In a s'.
  Definition Empty s := forall a : elt, ~ In a s.
  Definition For_all (P : elt -> Prop) s := forall x, In x s -> P x.
  Definition Exists (P : elt -> Prop) s := exists x, In x s /\ P x.

  Notation "s  [=]  t" := (Equal s t) (at level 70, no associativity).
  Notation "s  [<=]  t" := (Subset s t) (at level 70, no associativity).

  Definition eq : t -> t -> Prop := Equal.
  Instance eq_equiv : Equivalence eq. (* obvious, for subtyping only *)
  Parameter eq_dec : forall s s', { eq s s' } + { ~ eq s s' }.

  (** Specifications of set operators *)

  Section Spec.
  Variable s s': t.
  Variable x y : elt.
  Variable f : elt -> bool.
  Notation compatb := (Proper (E.eq==>Logic.eq)) (only parsing).

  Parameter mem_spec : mem x s = true <-> In x s.
  Parameter equal_spec : equal s s' = true <-> s[=]s'.
  Parameter subset_spec : subset s s' = true <-> s[<=]s'.
  Parameter empty_spec : Empty empty.
  Parameter is_empty_spec : is_empty s = true <-> Empty s.
  Parameter add_spec : In y (add x s) <-> E.eq y x \/ In y s.
  Parameter remove_spec : In y (remove x s) <-> In y s /\ ~E.eq y x.
  Parameter singleton_spec : In y (singleton x) <-> E.eq y x.
  Parameter union_spec : In x (union s s') <-> In x s \/ In x s'.
  Parameter inter_spec : In x (inter s s') <-> In x s /\ In x s'.
  Parameter diff_spec : In x (diff s s') <-> In x s /\ ~In x s'.
  Parameter fold_spec : forall (A : Type) (i : A) (f : elt -> A -> A),
    fold f s i = fold_left (flip f) (elements s) i.
  Parameter cardinal_spec : cardinal s = length (elements s).
  Parameter filter_spec : compatb f ->
    (In x (filter f s) <-> In x s /\ f x = true).
  Parameter for_all_spec : compatb f ->
    (for_all f s = true <-> For_all (fun x => f x = true) s).
  Parameter exists_spec : compatb f ->
    (exists_ f s = true <-> Exists (fun x => f x = true) s).
  Parameter partition_spec1 : compatb f ->
    fst (partition f s) [=] filter f s.
  Parameter partition_spec2 : compatb f ->
    snd (partition f s) [=] filter (fun x => negb (f x)) s.
  Parameter elements_spec1 : InA E.eq x (elements s) <-> In x s.
  (** When compared with ordered sets, here comes the only
      property that is really weaker: *)
  Parameter elements_spec2w : NoDupA E.eq (elements s).
  Parameter choose_spec1 : choose s = Some x -> In x s.
  Parameter choose_spec2 : choose s = None -> Empty s.

  End Spec.

End WSetsOn.

(** ** Static signature for weak sets

    Similar to the functorial signature [WSetsOn], except that the
    module [E] of base elements is incorporated in the signature. *)

Module Type WSets.
  Declare Module E : DecidableType.
  Include Type WSetsOn E.
End WSets.

(** ** Functorial signature for sets on ordered elements

    Based on [WSetsOn], plus ordering on sets and [min_elt] and [max_elt]
    and some stronger specifications for other functions. *)

Module Type SetsOn (E : OrderedType).
  Include Type WSetsOn E.

  Parameter compare : t -> t -> comparison.
  (** Total ordering between sets. Can be used as the ordering function
  for doing sets of sets. *)

  Parameter min_elt : t -> option elt.
  (** Return the smallest element of the given set
  (with respect to the [E.compare] ordering),
  or [None] if the set is empty. *)

  Parameter max_elt : t -> option elt.
  (** Same as [min_elt], but returns the largest element of the
  given set. *)

  Parameter lt : t -> t -> Prop.

  (** Specification of [lt] *)
  Instance lt_strorder : StrictOrder lt.
  Instance lt_compat : Proper (eq==>eq==>iff) lt.

  Section Spec.
  Variable s s': t.
  Variable x y : elt.

  Parameter compare_spec : Cmp eq lt (compare s s') s s'.

  (** Additional specification of [elements] *)
  Parameter elements_spec2 : sort E.lt (elements s).

  (** Remark: since [fold] is specified via [elements], this stronger
   specification of [elements] has an indirect impact on [fold],
   which can now be proved to receive elements in increasing order.
  *)

  Parameter min_elt_spec1 : min_elt s = Some x -> In x s.
  Parameter min_elt_spec2 : min_elt s = Some x -> In y s -> ~ E.lt y x.
  Parameter min_elt_spec3 : min_elt s = None -> Empty s.

  Parameter max_elt_spec1 : max_elt s = Some x -> In x s.
  Parameter max_elt_spec2 : max_elt s = Some x -> In y s -> ~ E.lt x y.
  Parameter max_elt_spec3 : max_elt s = None -> Empty s.

  (** Additional specification of [choose] *)
  Parameter choose_spec3 : choose s = Some x -> choose s' = Some y ->
    Equal s s' -> E.eq x y.

  End Spec.

End SetsOn.


(** ** Static signature for sets on ordered elements

    Similar to the functorial signature [SetsOn], except that the
    module [E] of base elements is incorporated in the signature. *)

Module Type Sets.
  Declare Module E : OrderedType.
  Include Type SetsOn E.
End Sets.

Module Type S := Sets.


(** ** Some subtyping tests
<<
WSetsOn ---> WSets
 |           |
 |           |
 V           V
SetsOn  ---> Sets

Module S_WS (M : Sets) <: WSets := M.
Module Sfun_WSfun (E:OrderedType)(M : SetsOn E) <: WSetsOn E := M.
Module S_Sfun (M : Sets) <: SetsOn M.E := M.
Module WS_WSfun (M : WSets) <: WSetsOn M.E := M.
>>
*)



(** ** Signatures for set representations with ill-formed values.

   Motivation:

   For many implementation of finite sets (AVL trees, sorted
   lists, lists without duplicates), we use the same two-layer
   approach:

   - A first module deals with the datatype (eg. list or tree) without
   any restriction on the values we consider. In this module (named
   "Raw" in the past), some results are stated under the assumption
   that some invariant (e.g. sortedness) holds for the input sets. We
   also prove that this invariant is preserved by set operators.

   - A second module implements the exact Sets interface by
   using a subtype, for instance [{ l : list A | sorted l }].
   This module is a mere wrapper around the first Raw module.

   With the interfaces below, we give some respectability to
   the "Raw" modules. This allows the interested users to directly
   access them via the interfaces. Even better, we can build once
   and for all a functor doing the transition between Raw and usual Sets.

   Description:

   The type [t] of sets may contain ill-formed values on which our
   set operators may give wrong answers. In particular, [mem]
   may not see a element in a ill-formed set (think for instance of a
   unsorted list being given to an optimized [mem] that stops
   its search as soon as a strictly larger element is encountered).

   Unlike optimized operators, the [In] predicate is supposed to
   always be correct, even on ill-formed sets. Same for [Equal] and
   other logical predicates.

   A predicate parameter [Ok] is used to discriminate between
   well-formed and ill-formed values. Some lemmas hold only on sets
   validating [Ok]. This predicate [Ok] is required to be
   preserved by set operators. Moreover, a boolean function [isok]
   should exist for identifying (at least some of) the well-formed sets.

*)


Module Type WRawSets (E : DecidableType).
  (** First, we ask for all the functions *)
  Include Type WOps E.

  (** Is a set well-formed or ill-formed ? *)

  Parameter IsOk : t -> Prop.
  Class Ok (s:t) : Prop := { ok : IsOk s }.

  (** In order to be able to validate (at least some) particular sets as
      well-formed, we ask for a boolean function for (semi-)deciding
      predicate [Ok]. If [Ok] isn't decidable, [isok] may be the
      always-false function. *)
  Parameter isok : t -> bool.
  Instance isok_Ok `(isok s = true) : Ok s | 10.

  (** Logical predicates *)
  Parameter In : elt -> t -> Prop.
  Instance In_compat : Proper (E.eq==>eq==>iff) In.

  Definition Equal s s' := forall a : elt, In a s <-> In a s'.
  Definition Subset s s' := forall a : elt, In a s -> In a s'.
  Definition Empty s := forall a : elt, ~ In a s.
  Definition For_all (P : elt -> Prop) s := forall x, In x s -> P x.
  Definition Exists (P : elt -> Prop) s := exists x, In x s /\ P x.

  Notation "s  [=]  t" := (Equal s t) (at level 70, no associativity).
  Notation "s  [<=]  t" := (Subset s t) (at level 70, no associativity).

  Definition eq : t -> t -> Prop := Equal.
  Instance eq_equiv : Equivalence eq.

  (** First, all operations are compatible with the well-formed predicate. *)

  Instance empty_ok : Ok empty.
  Instance add_ok s x `(Ok s) : Ok (add x s).
  Instance remove_ok s x `(Ok s) : Ok (remove x s).
  Instance singleton_ok x : Ok (singleton x).
  Instance union_ok s s' `(Ok s, Ok s') : Ok (union s s').
  Instance inter_ok s s' `(Ok s, Ok s') : Ok (inter s s').
  Instance diff_ok s s' `(Ok s, Ok s') : Ok (diff s s').
  Instance filter_ok s f `(Ok s) : Ok (filter f s).
  Instance partition_ok1 s f `(Ok s) : Ok (fst (partition f s)).
  Instance partition_ok2 s f `(Ok s) : Ok (snd (partition f s)).

  (** Now, the specifications, with constraints on the input sets. *)

  Section Spec.
  Variable s s': t.
  Variable x y : elt.
  Variable f : elt -> bool.
  Notation compatb := (Proper (E.eq==>Logic.eq)) (only parsing).

  Parameter mem_spec : forall `{Ok s}, mem x s = true <-> In x s.
  Parameter equal_spec : forall `{Ok s, Ok s'},
    equal s s' = true <-> s[=]s'.
  Parameter subset_spec : forall `{Ok s, Ok s'},
    subset s s' = true <-> s[<=]s'.
  Parameter empty_spec : Empty empty.
  Parameter is_empty_spec : is_empty s = true <-> Empty s.
  Parameter add_spec : forall `{Ok s},
    In y (add x s) <-> E.eq y x \/ In y s.
  Parameter remove_spec : forall `{Ok s},
    In y (remove x s) <-> In y s /\ ~E.eq y x.
  Parameter singleton_spec : In y (singleton x) <-> E.eq y x.
  Parameter union_spec : forall `{Ok s, Ok s'},
    In x (union s s') <-> In x s \/ In x s'.
  Parameter inter_spec : forall `{Ok s, Ok s'},
    In x (inter s s') <-> In x s /\ In x s'.
  Parameter diff_spec : forall `{Ok s, Ok s'},
    In x (diff s s') <-> In x s /\ ~In x s'.
  Parameter fold_spec : forall (A : Type) (i : A) (f : elt -> A -> A),
    fold f s i = fold_left (flip f) (elements s) i.
  Parameter cardinal_spec : forall `{Ok s},
    cardinal s = length (elements s).
  Parameter filter_spec : compatb f ->
    (In x (filter f s) <-> In x s /\ f x = true).
  Parameter for_all_spec : compatb f ->
    (for_all f s = true <-> For_all (fun x => f x = true) s).
  Parameter exists_spec : compatb f ->
    (exists_ f s = true <-> Exists (fun x => f x = true) s).
  Parameter partition_spec1 : compatb f ->
    fst (partition f s) [=] filter f s.
  Parameter partition_spec2 : compatb f ->
    snd (partition f s) [=] filter (fun x => negb (f x)) s.
  Parameter elements_spec1 : InA E.eq x (elements s) <-> In x s.
  Parameter elements_spec2w : forall `{Ok s}, NoDupA E.eq (elements s).
  Parameter choose_spec1 : choose s = Some x -> In x s.
  Parameter choose_spec2 : choose s = None -> Empty s.

  End Spec.

(*
 BUG ?! When the Instance *_ok were under a section,
   this re-export was mandatory !! BUG in Global Instance ?
 Hint Resolve empty_ok add_ok remove_ok union_ok inter_ok
  diff_ok singleton_ok filter_ok partition_ok1 partition_ok2
  : typeclass_instances.
*)

End WRawSets.

(** From weak raw sets to weak usual sets *)

Module WRaw2Sets (E:DecidableType)(M:WRawSets E) <: WSets with Module E := E.

 Module E := E.
 Definition elt := E.t.

 Record t_ := Mkt {this :> M.t; is_ok : M.Ok this}.
 Definition t := t_.
 Implicit Arguments Mkt [ [is_ok] ].
 Hint Resolve is_ok : typeclass_instances.

 Definition In x s := M.In x s.(this).
 Definition Equal s s' := forall a : elt, In a s <-> In a s'.
 Definition Subset s s' := forall a : elt, In a s -> In a s'.
 Definition Empty s := forall a : elt, ~ In a s.
 Definition For_all (P : elt -> Prop) s := forall x, In x s -> P x.
 Definition Exists (P : elt -> Prop) s := exists x, In x s /\ P x.

 Definition mem x (s : t) := M.mem x s.
 Definition add x (s : t) := Mkt (M.add x s).
 Definition remove x (s : t) := Mkt (M.remove x s).
 Definition singleton x := Mkt (M.singleton x).
 Definition union (s s' : t) := Mkt (M.union s s').
 Definition inter (s s' : t) := Mkt (M.inter s s').
 Definition diff (s s' : t) := Mkt (M.diff s s').
 Definition equal (s s' : t) := M.equal s s'.
 Definition subset (s s' : t) := M.subset s s'.
 Definition empty := Mkt M.empty.
 Definition is_empty (s : t) := M.is_empty s.
 Definition elements (s : t) := M.elements s.
 Definition choose (s : t) := M.choose s.
 Definition fold (A : Type) f (s : t) : A -> A := M.fold f s.
 Definition cardinal (s : t) := M.cardinal s.
 Definition filter f (s : t) := Mkt (M.filter f s).
 Definition for_all f (s : t) := M.for_all f s.
 Definition exists_ f (s : t) := M.exists_ f s.
 Definition partition f (s : t) :=
   let p := M.partition f s in (Mkt (fst p), Mkt (snd p)).

 Instance In_compat : Proper (E.eq==>eq==>iff) In.
 Proof. repeat red. intros; apply M.In_compat; congruence. Qed.

 Definition eq : t -> t -> Prop := Equal.

 Instance eq_equiv : Equivalence eq.
 Proof. firstorder. Qed.

 Definition eq_dec : forall (s s':t), { eq s s' }+{ ~eq s s' }.
 Proof.
  intros (s,Hs) (s',Hs').
  change ({M.Equal s s'}+{~M.Equal s s'}).
  destruct (M.equal s s') as [ ]_eqn:H; [left|right];
   rewrite <- M.equal_spec; congruence.
 Defined.


 Section Spec.
  Variable s s' : t.
  Variable x y : elt.
  Variable f : elt -> bool.
  Notation compatb := (Proper (E.eq==>Logic.eq)) (only parsing).

  Lemma mem_spec : mem x s = true <-> In x s.
  Proof. exact (@M.mem_spec _ _ _). Qed.
  Lemma equal_spec : equal s s' = true <-> Equal s s'.
  Proof. exact (@M.equal_spec _ _ _ _). Qed.
  Lemma subset_spec : subset s s' = true <-> Subset s s'.
  Proof. exact (@M.subset_spec _ _ _ _). Qed.
  Lemma empty_spec : Empty empty.
  Proof. exact M.empty_spec. Qed.
  Lemma is_empty_spec : is_empty s = true <-> Empty s.
  Proof. exact (@M.is_empty_spec _). Qed.
  Lemma add_spec : In y (add x s) <-> E.eq y x \/ In y s.
  Proof. exact (@M.add_spec _ _ _ _). Qed.
  Lemma remove_spec : In y (remove x s) <-> In y s /\ ~E.eq y x.
  Proof. exact (@M.remove_spec _ _ _ _). Qed.
  Lemma singleton_spec : In y (singleton x) <-> E.eq y x.
  Proof. exact (@M.singleton_spec _ _). Qed.
  Lemma union_spec : In x (union s s') <-> In x s \/ In x s'.
  Proof. exact (@M.union_spec _ _ _ _ _). Qed.
  Lemma inter_spec : In x (inter s s') <-> In x s /\ In x s'.
  Proof. exact (@M.inter_spec _ _ _ _ _). Qed.
  Lemma diff_spec : In x (diff s s') <-> In x s /\ ~In x s'.
  Proof. exact (@M.diff_spec _ _ _ _ _). Qed.
  Lemma fold_spec : forall (A : Type) (i : A) (f : elt -> A -> A),
      fold f s i = fold_left (fun a e => f e a) (elements s) i.
  Proof. exact (@M.fold_spec _). Qed.
  Lemma cardinal_spec : cardinal s = length (elements s).
  Proof. exact (@M.cardinal_spec s _). Qed.
  Lemma filter_spec : compatb f ->
    (In x (filter f s) <-> In x s /\ f x = true).
  Proof. exact (@M.filter_spec _ _ _). Qed.
  Lemma for_all_spec : compatb f ->
    (for_all f s = true <-> For_all (fun x => f x = true) s).
  Proof. exact (@M.for_all_spec _ _). Qed.
  Lemma exists_spec : compatb f ->
    (exists_ f s = true <-> Exists (fun x => f x = true) s).
  Proof. exact (@M.exists_spec _ _). Qed.
  Lemma partition_spec1 : compatb f -> Equal (fst (partition f s)) (filter f s).
  Proof. exact (@M.partition_spec1 _ _). Qed.
  Lemma partition_spec2 : compatb f ->
      Equal (snd (partition f s)) (filter (fun x => negb (f x)) s).
  Proof. exact (@M.partition_spec2 _ _). Qed.
  Lemma elements_spec1 : InA E.eq x (elements s) <-> In x s.
  Proof. exact (@M.elements_spec1 _ _). Qed.
  Lemma elements_spec2w : NoDupA E.eq (elements s).
  Proof. exact (@M.elements_spec2w _ _). Qed.
  Lemma choose_spec1 : choose s = Some x -> In x s.
  Proof. exact (@M.choose_spec1 _ _). Qed.
  Lemma choose_spec2 : choose s = None -> Empty s.
  Proof. exact (@M.choose_spec2 _). Qed.

 End Spec.

End WRaw2Sets.

(** Same approach for ordered sets *)

Module Type RawSets (E : OrderedType).
  Include Type WRawSets E.

  Parameter compare : t -> t -> comparison.
  Parameter min_elt : t -> option elt.
  Parameter max_elt : t -> option elt.
  Parameter lt : t -> t -> Prop.

  (** Specification of [lt] *)
  Instance lt_strorder : StrictOrder lt.
  Instance lt_compat : Proper (eq==>eq==>iff) lt.

  Section Spec.
  Variable s s': t.
  Variable x y : elt.

  (** Specification of [compare] *)
  Parameter compare_spec : forall `{Ok s, Ok s'}, Cmp eq lt (compare s s') s s'.

  (** Additional specification of [elements] *)
  Parameter elements_spec2 : forall `{Ok s}, sort E.lt (elements s).

  (** Specification of [min_elt] *)
  Parameter min_elt_spec1 : min_elt s = Some x -> In x s.
  Parameter min_elt_spec2 : forall `{Ok s}, min_elt s = Some x -> In y s -> ~ E.lt y x.
  Parameter min_elt_spec3 : min_elt s = None -> Empty s.

  (** Specification of [max_elt] *)
  Parameter max_elt_spec1 : max_elt s = Some x -> In x s.
  Parameter max_elt_spec2 : forall `{Ok s}, max_elt s = Some x -> In y s -> ~ E.lt x y.
  Parameter max_elt_spec3 : max_elt s = None -> Empty s.

  (** Additional specification of [choose] *)
  Parameter choose_spec3 : forall `{Ok s, Ok s'},
    choose s = Some x -> choose s' = Some y -> Equal s s' -> E.eq x y.

  End Spec.

End RawSets.

(** From Raw to usual sets *)

Module Raw2Sets (O:OrderedType)(M:RawSets O) <: S with Module E := O.
  Include WRaw2Sets O M.

  Definition compare (s s':t) := M.compare s s'.
  Definition min_elt (s:t) := M.min_elt s.
  Definition max_elt (s:t) := M.max_elt s.
  Definition lt (s s':t) := M.lt s s'.

  (** Specification of [lt] *)
  Instance lt_strorder : StrictOrder lt.
  Proof.
  unfold lt; split; repeat red.
  intros s; eapply StrictOrder_Irreflexive; eauto.
  intros s s' s''; eapply StrictOrder_Transitive; eauto.
  Qed.

  Instance lt_compat : Proper (eq==>eq==>iff) lt.
  Proof.
  repeat red. unfold eq, lt.
  intros (s1,p1) (s2,p2) E (s1',p1') (s2',p2') E'; simpl.
  change (M.eq s1 s2) in E.
  change (M.eq s1' s2') in E'.
  rewrite E,E'; intuition.
  Qed.

  Section Spec.
  Variable s s' s'' : t.
  Variable x y : elt.

  Lemma compare_spec : Cmp eq lt (compare s s') s s'.
  Proof.
   generalize (@M.compare_spec s s' _ _).
   unfold compare; destruct M.compare; auto.
  Qed.

  (** Additional specification of [elements] *)
  Lemma elements_spec2 : sort O.lt (elements s).
  Proof. exact (@M.elements_spec2 _ _). Qed.

  (** Specification of [min_elt] *)
  Lemma min_elt_spec1 : min_elt s = Some x -> In x s.
  Proof. exact (@M.min_elt_spec1 _ _). Qed.
  Lemma min_elt_spec2 : min_elt s = Some x -> In y s -> ~ O.lt y x.
  Proof. exact (@M.min_elt_spec2 _ _ _ _). Qed.
  Lemma min_elt_spec3 : min_elt s = None -> Empty s.
  Proof. exact (@M.min_elt_spec3 _). Qed.

  (** Specification of [max_elt] *)
  Lemma max_elt_spec1 : max_elt s = Some x -> In x s.
  Proof. exact (@M.max_elt_spec1 _ _). Qed.
  Lemma max_elt_spec2 : max_elt s = Some x -> In y s -> ~ O.lt x y.
  Proof. exact (@M.max_elt_spec2 _ _ _ _). Qed.
  Lemma max_elt_spec3 : max_elt s = None -> Empty s.
  Proof. exact (@M.max_elt_spec3 _). Qed.

  (** Additional specification of [choose] *)
  Lemma choose_spec3 :
    choose s = Some x -> choose s' = Some y -> Equal s s' -> E.eq x y.
  Proof. exact (@M.choose_spec3 _ _ _ _ _ _). Qed.

  End Spec.

End Raw2Sets.


(** It is in fact possible to provide an ordering on sets with
    very little information on them (more or less only the [In]
    predicate). This generic build of ordering is in fact not
    used for the moment, we rather use a simplier version
    dedicated to sets-as-sorted-lists, see [MakeListOrdering].
*)

Module Type IN (O:OrderedType).
 Parameter Inline t : Type.
 Parameter Inline In : O.t -> t -> Prop.
 Instance In_compat : Proper (O.eq==>eq==>iff) In.
 Definition Equal s s' := forall x, In x s <-> In x s'.
 Definition Empty s := forall x, ~In x s.
End IN.

Module MakeSetOrdering (O:OrderedType)(Import M:IN O).
 Module Import MO := OrderedTypeFacts O.

 Definition eq : t -> t -> Prop := Equal.

 Instance eq_equiv : Equivalence eq.
 Proof. firstorder. Qed.

 Instance : Proper (O.eq==>eq==>iff) In.
 Proof.
 intros x x' Ex s s' Es. rewrite Ex. apply Es.
 Qed.

 Definition Below x s := forall y, In y s -> O.lt y x.
 Definition Above x s := forall y, In y s -> O.lt x y.

 Definition EquivBefore x s s' :=
   forall y, O.lt y x -> (In y s <-> In y s').

 Definition EmptyBetween x y s :=
   forall z, In z s -> O.lt z y -> O.lt z x.

 Definition lt s s' := exists x, EquivBefore x s s' /\
   ((In x s' /\ Below x s) \/
    (In x s  /\ exists y, In y s' /\ O.lt x y /\ EmptyBetween x y s')).

 Instance : Proper (O.eq==>eq==>eq==>iff) EquivBefore.
 Proof.
  unfold EquivBefore. intros x x' E s1 s1' E1 s2 s2' E2.
  setoid_rewrite E; setoid_rewrite E1; setoid_rewrite E2; intuition.
 Qed.

 Instance : Proper (O.eq==>eq==>iff) Below.
 Proof.
  unfold Below. intros x x' Ex s s' Es.
  setoid_rewrite Ex; setoid_rewrite Es; intuition.
 Qed.

 Instance : Proper (O.eq==>eq==>iff) Above.
 Proof.
  unfold Above. intros x x' Ex s s' Es.
  setoid_rewrite Ex; setoid_rewrite Es; intuition.
 Qed.

 Instance : Proper (O.eq==>O.eq==>eq==>iff) EmptyBetween.
 Proof.
  unfold EmptyBetween. intros x x' Ex y y' Ey s s' Es.
  setoid_rewrite Ex; setoid_rewrite Ey; setoid_rewrite Es; intuition.
 Qed.

 Instance lt_compat : Proper (eq==>eq==>iff) lt.
 Proof.
  unfold lt. intros s1 s1' E1 s2 s2' E2.
  setoid_rewrite E1; setoid_rewrite E2; intuition.
 Qed.

 Instance lt_strorder : StrictOrder lt.
 Proof.
  split.
  (* irreflexive *)
  intros s (x & _ & [(IN,Em)|(IN & y & IN' & LT & Be)]).
  specialize (Em x IN); order.
  specialize (Be x IN LT); order.
  (* transitive *)
  intros s1 s2 s3 (x & EQ & [(IN,Pre)|(IN,Lex)])
                  (x' & EQ' & [(IN',Pre')|(IN',Lex')]).
  (* 1) Pre / Pre --> Pre *)
  assert (O.lt x x') by (specialize (Pre' x IN); auto).
  exists x; split.
  intros y Hy; rewrite <- (EQ' y); auto; order.
  left; split; auto.
  rewrite <- (EQ' x); auto.
  (* 2) Pre / Lex *)
  elim_compare x x'; intros Hxx'.
  (* 2a) x=x' --> Pre *)
  destruct Lex' as (y & INy & LT & Be).
  exists y; split.
  intros z Hz. split; intros INz.
   specialize (Pre z INz). rewrite <- (EQ' z), <- (EQ z); auto; order.
   specialize (Be z INz Hz). rewrite (EQ z), (EQ' z); auto; order.
  left; split; auto.
  intros z Hz. transitivity x; auto; order.
  (* 2b) x<x' --> Pre *)
  exists x; split.
  intros z Hz. rewrite <- (EQ' z) by order; auto.
  left; split; auto.
  rewrite <- (EQ' x); auto.
  (* 2c) x>x' --> Lex *)
  exists x'; split.
  intros z Hz. rewrite (EQ z) by order; auto.
  right; split; auto.
  rewrite (EQ x'); auto.
  (* 3) Lex / Pre --> Lex *)
  destruct Lex as (y & INy & LT & Be).
  specialize (Pre' y INy).
  exists x; split.
  intros z Hz. rewrite <- (EQ' z) by order; auto.
  right; split; auto.
  exists y; repeat split; auto.
  rewrite <- (EQ' y); auto.
  intros z Hz LTz; apply Be; auto. rewrite (EQ' z); auto; order.
  (* 4) Lex / Lex *)
  elim_compare x x'; intros Hxx'.
  (* 4a) x=x' --> impossible *)
  destruct Lex as (y & INy & LT & Be).
  rewrite Hxx' in LT; specialize (Be x' IN' LT); order.
  (* 4b) x<x' --> Lex *)
  exists x; split.
  intros z Hz. rewrite <- (EQ' z) by order; auto.
  right; split; auto.
  destruct Lex as (y & INy & LT & Be).
  elim_compare y x'; intros Hyx'.
   (* 4ba *)
   destruct Lex' as (y' & Iny' & LT' & Be').
   exists y'; repeat split; auto. order.
   intros z Hz LTz. specialize (Be' z Hz LTz).
    rewrite <- (EQ' z) in Hz by order.
    apply Be; auto. order.
   (* 4bb *)
   exists y; repeat split; auto.
   rewrite <- (EQ' y); auto.
   intros z Hz LTz. apply Be; auto. rewrite (EQ' z); auto; order.
   (* 4bc*)
   specialize (Be x' IN' Hyx'); order.
  (* 4c) x>x' --> Lex *)
  exists x'; split.
  intros z Hz. rewrite (EQ z) by order; auto.
  right; split; auto.
  rewrite (EQ x'); auto.
 Qed.

 Lemma lt_empty_r : forall s s', Empty s' -> ~ lt s s'.
 Proof.
  intros s s' Hs' (x & _ & [(IN,_)|(_ & y & IN & _)]).
  elim (Hs' x IN).
  elim (Hs' y IN).
 Qed.

 Definition Add x s s' := forall y, In y s' <-> O.eq x y \/ In y s.

 Lemma lt_empty_l : forall x s1 s2 s2',
  Empty s1 -> Above x s2 -> Add x s2 s2' -> lt s1 s2'.
 Proof.
  intros x s1 s2 s2' Em Ab Ad.
  exists x; split.
  intros y Hy; split; intros IN.
  elim (Em y IN).
  rewrite (Ad y) in IN; destruct IN as [EQ|IN]. order.
  specialize (Ab y IN). order.
  left; split.
  rewrite (Ad x); auto.
  intros y Hy. elim (Em y Hy).
 Qed.

 Lemma lt_add_lt : forall x1 x2 s1 s1' s2 s2',
   Above x1 s1 -> Above x2 s2 -> Add x1 s1 s1' -> Add x2 s2 s2' ->
   O.lt x1 x2 -> lt s1' s2'.
  Proof.
  intros x1 x2 s1 s1' s2 s2' Ab1 Ab2 Ad1 Ad2 LT.
  exists x1; split; [ | right; split]; auto.
  intros y Hy. rewrite (Ad1 y), (Ad2 y).
  split; intros [U|U]; try order.
  specialize (Ab1 y U). order.
  specialize (Ab2 y U). order.
  rewrite (Ad1 x1); auto.
  exists x2; repeat split; auto.
  rewrite (Ad2 x2); auto.
  intros y. rewrite (Ad2 y). intros [U|U]. order.
  specialize (Ab2 y U). order.
  Qed.

  Lemma lt_add_eq : forall x1 x2 s1 s1' s2 s2',
   Above x1 s1 -> Above x2 s2 -> Add x1 s1 s1' -> Add x2 s2 s2' ->
   O.eq x1 x2 -> lt s1 s2 -> lt s1' s2'.
  Proof.
  intros x1 x2 s1 s1' s2 s2' Ab1 Ab2 Ad1 Ad2 Hx (x & EQ & Disj).
  assert (O.lt x1 x).
   destruct Disj as [(IN,_)|(IN,_)]; auto. rewrite Hx; auto.
  exists x; split.
  intros z Hz. rewrite (Ad1 z), (Ad2 z).
  split; intros [U|U]; try order.
  right; rewrite <- (EQ z); auto.
  right; rewrite (EQ z); auto.
  destruct Disj as [(IN,Em)|(IN & y & INy & LTy & Be)].
  left; split; auto.
  rewrite (Ad2 x); auto.
  intros z. rewrite (Ad1 z); intros [U|U]; try specialize (Ab1 z U); order.
  right; split; auto.
  rewrite (Ad1 x); auto.
  exists y; repeat split; auto.
  rewrite (Ad2 y); auto.
  intros z. rewrite (Ad2 z). intros [U|U]; try specialize (Ab2 z U); order.
  Qed.

End MakeSetOrdering.


Module MakeListOrdering (O:OrderedType).
 Module MO:=OrderedTypeFacts O.

 Notation t := (list O.t).
 Notation In := (InA O.eq).

 Definition eq s s' := forall x, In x s <-> In x s'.

 Instance eq_equiv : Equivalence eq.

 Inductive lt_list : t -> t -> Prop :=
    | lt_nil : forall x s, lt_list nil (x :: s)
    | lt_cons_lt : forall x y s s',
        O.lt x y -> lt_list (x :: s) (y :: s')
    | lt_cons_eq : forall x y s s',
        O.eq x y -> lt_list s s' -> lt_list (x :: s) (y :: s').
 Hint Constructors lt_list.

 Definition lt := lt_list.
 Hint Unfold lt.

 Instance lt_strorder : StrictOrder lt.
 Proof.
 split.
 (* irreflexive *)
 assert (forall s s', s=s' -> ~lt s s').
  red; induction 2.
  discriminate.
  inversion H; subst.
  apply (StrictOrder_Irreflexive y); auto.
  inversion H; subst; auto.
 intros s Hs; exact (H s s (eq_refl s) Hs).
 (* transitive *)
 intros s s' s'' H; generalize s''; clear s''; elim H.
 intros x l s'' H'; inversion_clear H'; auto.
 intros x x' l l' E s'' H'; inversion_clear H'; auto.
 constructor 2. transitivity x'; auto.
 constructor 2. rewrite <- H0; auto.
 intros.
 inversion_clear H3.
 constructor 2. rewrite H0; auto.
 constructor 3; auto. transitivity y; auto. unfold lt in *; auto.
 Qed.

 Instance lt_compat' :
  Proper (eqlistA O.eq==>eqlistA O.eq==>iff) lt.
 Proof.
 apply proper_sym_impl_iff_2; auto with *.
 intros s1 s1' E1 s2 s2' E2 H.
 revert s1' E1 s2' E2.
 induction H; intros; inversion_clear E1; inversion_clear E2.
 constructor 1.
 constructor 2. MO.order.
 constructor 3. MO.order. unfold lt in *; auto.
 Qed.

 Lemma eq_cons :
  forall l1 l2 x y,
  O.eq x y -> eq l1 l2 -> eq (x :: l1) (y :: l2).
 Proof.
  unfold eq; intros l1 l2 x y Exy E12 z.
  split; inversion_clear 1.
  left; MO.order. right; rewrite <- E12; auto.
  left; MO.order. right; rewrite E12; auto.
 Qed.
 Hint Resolve eq_cons.

 Lemma cons_Cmp : forall c x1 x2 l1 l2, O.eq x1 x2 ->
  Cmp eq lt c l1 l2 -> Cmp eq lt c (x1::l1) (x2::l2).
 Proof.
  destruct c; simpl; unfold flip; auto.
 Qed.
 Hint Resolve cons_Cmp.

End MakeListOrdering.