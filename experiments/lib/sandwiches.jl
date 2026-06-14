function sandwich(::Type{STLC})
    (
        "From QuickChick Require Import QuickChick. Import QcNotation.
From Coq Require Import Bool ZArith List. Import ListNotations.
From ExtLib Require Import Monad.
From ExtLib.Data.Monads Require Import OptionMonad.
Import MonadNotation.

From STLC Require Import Impl Spec.",
        "Definition test_prop_SinglePreserve :=
        forAll gSized (fun (e: Expr) =>
          prop_SinglePreserve e).

        (*! QuickChick test_prop_SinglePreserve. *)

        Definition test_prop_MultiPreserve :=
        forAll gSized (fun (e: Expr) =>
          prop_MultiPreserve e).

        (*! QuickChick test_prop_MultiPreserve. *)
                  "
    )
end

function sandwichmaybestlc()
    (
        "From QuickChick Require Import QuickChick. Import QcNotation.
From Coq Require Import Bool ZArith List. Import ListNotations.
From ExtLib Require Import Monad.
From ExtLib.Data.Monads Require Import OptionMonad.
Import MonadNotation.

From STLC Require Import Impl Spec.",
        "Definition test_prop_SinglePreserve :=
        forAllMaybe gSized (fun (e: Expr) =>
          prop_SinglePreserve e).

        (*! QuickChick test_prop_SinglePreserve. *)

        Definition test_prop_MultiPreserve :=
        forAllMaybe gSized (fun (e: Expr) =>
          prop_MultiPreserve e).

        (*! QuickChick test_prop_MultiPreserve. *)
                  "
    )
end

function sandwich(::Type{BST})
    (
        "From QuickChick Require Import QuickChick. Import QcNotation.
From Coq Require Import List. Import ListNotations.
From Coq Require Import ZArith.
From ExtLib Require Import Monad.
Import MonadNotation.

From BST Require Import Impl.
From BST Require Import Spec.",
        "Definition manual_shrink_tree := 
        fun x : Tree =>
        let
          fix aux_shrink (x' : Tree) : list Tree :=
            match x' with
            | E => []
            | T p0 p1 p2 p3 =>
                ([p0] ++
                 map (fun shrunk : Tree => T shrunk p1 p2 p3) (aux_shrink p0) ++
                 []) ++
                (map (fun shrunk : nat => T p0 shrunk p2 p3) (shrink p1) ++ []) ++
                (map (fun shrunk : nat => T p0 p1 shrunk p3) (shrink p2) ++ []) ++
                ([p3] ++
                 map (fun shrunk : Tree => T p0 p1 p2 shrunk) (aux_shrink p3) ++
                 []) ++ []
            end in
        aux_shrink x.


        #[global]
        Instance shrTree : Shrink (Tree) := 
        {| shrink x := manual_shrink_tree x |}.

        Definition test_prop_InsertValid   :=
        forAll gSized (fun (t: Tree)  =>
        forAll arbitrary (fun (k: nat)  =>
        forAll arbitrary (fun (v: nat) =>
        prop_InsertValid t k v)))
        .

        (*! QuickChick test_prop_InsertValid. *)

        Definition test_prop_DeleteValid   :=
        forAll gSized (fun (t: Tree)  =>
        forAll arbitrary (fun (k: nat) =>
        prop_DeleteValid t k))
        .

        (*! QuickChick test_prop_DeleteValid. *)


        Definition test_prop_UnionValid    :=
        forAll gSized (fun (t1: Tree)  =>
        forAll gSized (fun (t2: Tree) =>
        prop_UnionValid t1 t2))
        .

        (*! QuickChick test_prop_UnionValid. *)

        Definition test_prop_InsertPost    :=
        forAll gSized (fun (t: Tree)  =>
        forAll arbitrary (fun (k: nat)  =>
        forAll arbitrary (fun (k': nat)  =>
        forAll arbitrary (fun (v: nat) =>
        prop_InsertPost t k k' v))))
        .

        (*! QuickChick test_prop_InsertPost. *)

        Definition test_prop_DeletePost    :=
        forAll gSized (fun (t: Tree)  =>
        forAll arbitrary (fun (k: nat)  =>
        forAll arbitrary (fun (k': nat) =>
        prop_DeletePost t k k')))
        .

        (*! QuickChick test_prop_DeletePost. *)

        Definition test_prop_UnionPost   :=
        forAll gSized (fun (t: Tree)  =>
        forAll gSized (fun (t': Tree)  =>
        forAll arbitrary (fun (k: nat) =>
        prop_UnionPost t t' k)))
        .

        (*! QuickChick test_prop_UnionPost. *)

        Definition test_prop_InsertModel   :=
        forAll gSized (fun (t: Tree)  =>
        forAll arbitrary (fun (k: nat)  =>
        forAll arbitrary (fun (v: nat) =>
        prop_InsertModel t k v)))
        .

        (*! QuickChick test_prop_InsertModel. *)

        Definition test_prop_DeleteModel   :=
        forAll gSized (fun (t: Tree)  =>
        forAll arbitrary (fun (k: nat) =>
        prop_DeleteModel t k))
        .

        (*! QuickChick test_prop_DeleteModel. *)

        Definition test_prop_UnionModel    :=
        forAll gSized (fun (t: Tree)  =>
        forAll gSized (fun (t': Tree) =>
        prop_UnionModel t t'))
        .

        (*! QuickChick test_prop_UnionModel. *)

        Definition test_prop_InsertInsert    :=
        forAll gSized (fun (t: Tree)  =>
        forAll arbitrary (fun (k: nat)  =>
        forAll arbitrary (fun (k': nat)  =>
        forAll arbitrary (fun (v: nat)  =>
        forAll arbitrary (fun (v': nat) =>
        prop_InsertInsert t k k' v v')))))
        .

        (*! QuickChick test_prop_InsertInsert. *)

        Definition test_prop_InsertDelete    :=
        forAll gSized (fun (t: Tree)  =>
        forAll arbitrary (fun (k: nat)  =>
        forAll arbitrary (fun (k': nat)  =>
        forAll arbitrary (fun (v: nat) =>
        prop_InsertDelete t k k' v))))
        .

        (*! QuickChick test_prop_InsertDelete. *)

        Definition test_prop_InsertUnion   :=
        forAll gSized (fun (t: Tree)  =>
        forAll gSized (fun (t': Tree)  =>
        forAll arbitrary (fun (k: nat)  =>
        forAll arbitrary (fun (v: nat) =>
        prop_InsertUnion t t' k v))))
        .

        (*! QuickChick test_prop_InsertUnion. *)

        Definition test_prop_DeleteInsert    :=
        forAll gSized (fun (t: Tree)  =>
        forAll arbitrary (fun (k: nat)  =>
        forAll arbitrary (fun (k': nat)  =>
        forAll arbitrary (fun (v': nat) =>
        prop_DeleteInsert t k k' v'))))
        .

        (*! QuickChick test_prop_DeleteInsert. *)

        Definition test_prop_DeleteDelete    :=
        forAllShrink gSized shrink (fun (t: Tree)  =>
        forAllShrink arbitrary shrink (fun (k: nat)  =>
        forAllShrink arbitrary shrink (fun (k': nat) =>
        whenFail' (fun tt => show (t, k, k', delete k t, delete k' t, delete k (delete k' t), delete k' (delete k t)))
        (prop_DeleteDelete t k k'))))
        .

        (*! QuickChick test_prop_DeleteDelete. *)

        Definition test_prop_DeleteUnion   :=
        forAll gSized (fun (t: Tree)  =>
        forAll gSized (fun (t': Tree)  =>
        forAll arbitrary (fun (k: nat) =>
        prop_DeleteUnion t t' k)))
        .

        (*! QuickChick test_prop_DeleteUnion. *)

        Definition test_prop_UnionDeleteInsert   :=
        forAll gSized (fun (t :Tree)  =>
        forAll gSized (fun (t': Tree)  =>
        forAll arbitrary (fun (k: nat)  =>
        forAll arbitrary (fun (v: nat) =>
        prop_UnionDeleteInsert t t' k v))))
        .

        (*! QuickChick test_prop_UnionDeleteInsert. *)

        Definition test_prop_UnionUnionIdem    :=
        forAll gSized (fun (t: Tree) =>
        prop_UnionUnionIdem t)
        .

        (*! QuickChick test_prop_UnionUnionIdem. *)

        Definition test_prop_UnionUnionAssoc   :=
        forAll gSized (fun (t1: Tree)  =>
        forAll gSized (fun (t2: Tree)  =>
        forAll gSized (fun (t3: Tree) =>
        prop_UnionUnionAssoc t1 t2 t3)))
        .

        (*! QuickChick test_prop_UnionUnionAssoc. *)
             "
    )
end

function sandwich(::Type{RBT})
    (
        "Require Import ZArith.
From QuickChick Require Import QuickChick.
From ExtLib Require Import Monad.
From ExtLib.Data.Monads Require Import OptionMonad.
Import QcNotation.
Import MonadNotation.
From Coq Require Import List.
Import ListNotations.

From RBT Require Import Impl Spec.",
        "(* --------------------- Tests --------------------- *)

        Definition test_prop_InsertValid :=  
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
            forAll arbitrary (fun v =>
                (prop_InsertValid t k v)))).

        (*! QuickChick test_prop_InsertValid. *)

        Definition test_prop_DeleteValid :=  
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
                prop_DeleteValid t k)).

        (*! QuickChick test_prop_DeleteValid. *)

        Definition test_prop_InsertPost :=  
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
            forAll arbitrary (fun k' =>
             forAll arbitrary (fun v =>
                prop_InsertPost t k k' v)))).

        (*! QuickChick test_prop_InsertPost. *)

        Definition test_prop_DeletePost := 
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
            forAll arbitrary (fun k' =>
                prop_DeletePost t k k'))).

        (*! QuickChick test_prop_DeletePost. *)
            
        Definition test_prop_InsertModel :=  
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
            forAll arbitrary (fun v =>
                prop_InsertModel t k v))).

        (*! QuickChick test_prop_InsertModel. *)
            
        Definition test_prop_DeleteModel :=  
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
                    prop_DeleteModel t k)).

        (*! QuickChick test_prop_DeleteModel. *)

        Definition test_prop_InsertInsert :=  
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
            forAll arbitrary (fun k' =>
            forAll arbitrary (fun v =>
            forAll arbitrary (fun v' =>     
                prop_InsertInsert t k k' v v'))))).

        (*! QuickChick test_prop_InsertInsert. *)
            
        Definition test_prop_InsertDelete := 
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
            forAll arbitrary (fun k' =>
            forAll arbitrary (fun v =>
                prop_InsertDelete t k k' v)))).

        (*! QuickChick test_prop_InsertDelete. *)
            
        Definition test_prop_DeleteInsert := 
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
            forAll arbitrary (fun k' =>
            forAll arbitrary (fun v' =>
                prop_DeleteInsert t k k' v')))).

        (*! QuickChick test_prop_DeleteInsert. *)
            
        Definition test_prop_DeleteDelete :=  
            forAll gSized (fun t =>    
            forAll arbitrary (fun k =>
            forAll arbitrary (fun k' =>
                prop_DeleteDelete t k k'))).

        (*! QuickChick test_prop_DeleteDelete. *)
                  "
    )
end

function sandwich(::Type{ST})
    (
        "Require Import ZArith.
From QuickChick Require Import QuickChick.
From ExtLib Require Import Monad.
From ExtLib.Data.Monads Require Import OptionMonad.
Import QcNotation.
Import MonadNotation.
From Coq Require Import List.
Import ListNotations.

Inductive Tree :=
  | E : Tree 
  | T : nat -> Tree -> Tree -> Tree.

          ", "
Fixpoint is_sticky (t : Tree) : bool :=
  match t with 
  | T _ (T _ _ _) (T _ _ _) => false
  | T _ l r => is_sticky l && is_sticky r
  | E => true 
  end.

Fixpoint is_left_sticky (t : Tree) : bool :=
  match t with 
  | T _ E E => true
  | T _ l E => is_left_sticky l
  | T _ _ _ => false
  | E => true 
  end.

Fixpoint is_right_sticky (t : Tree) : bool :=
  match t with 
  | T _ E E => true
  | T _ E r => is_right_sticky r
  | T _ _ _ => false
  | E => true 
  end.

Fixpoint count_sticks (t : Tree) : nat * nat :=
  match t with
  | E => (0, 0)
  | T _ l r =>
    let '(ll, lr) := count_sticks l in
    let '(rl, rr) := count_sticks r in
    let left_here :=
      match l, r with
      | T _ _ _, E => 1
      | _, _ => 0
      end in
    let right_here :=
      match l, r with
      | E, T _ _ _ => 1
      | _, _ => 0
      end in
    (left_here + ll + rl, right_here + lr + rr)
  end.

Definition count_left_sticks (t : Tree) : nat := fst (count_sticks t).
Definition count_right_sticks (t : Tree) : nat := snd (count_sticks t).

Definition is_rl_balanced (t : Tree) : bool :=
  let '(l, r) := count_sticks t in
  Nat.eqb l r.

Fixpoint get_height (t : Tree) : nat :=
  match t with
  | E => 0
  | T _ l r => 1 + max (get_height l) (get_height r)
  end.

Definition is_height_x (x : nat ) (t : Tree)  : bool := Nat.eqb (get_height t) x.
Definition is_sticky_and_height_x (x : nat ) (t : Tree)  : bool := is_sticky t && (Nat.eqb (get_height t) x).
Definition is_prop_and_height_x (p : (Tree -> bool)) (x : nat ) (t : Tree)  : bool := p t && (Nat.eqb (get_height t) x).

#[export] Instance genTreeInst : Gen Tree := {| arbitrary := gSized |}.
#[export] Instance shrinkTree : Shrink Tree := {| shrink := fun _ => [] |}.
#[export] Instance arbTree : Arbitrary Tree := {}.

Derive (Show) for Tree. 

Definition test_is_sticky := forAll gSized (fun t : Tree => is_sticky t).
Definition test_is_left_sticky := forAll gSized (fun t : Tree => is_left_sticky t).
Definition test_is_right_sticky := forAll gSized (fun t : Tree => is_right_sticky t).

(*QuickChick test_is_sticky.*)

Definition numRuns := 1000.

Definition count_sticky (prop : ( Tree -> bool)) :=
  forAll gSized (fun t : Tree =>
    collect (if prop t then true else false) true).

QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky is_sticky ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky is_left_sticky ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky is_right_sticky ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky is_rl_balanced ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_height_x 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_height_x 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_height_x 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_height_x 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_height_x 4) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_sticky_and_height_x 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_sticky_and_height_x 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_sticky_and_height_x 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_sticky_and_height_x 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_sticky_and_height_x 4) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_rl_balanced 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_rl_balanced 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_rl_balanced 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_rl_balanced 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_rl_balanced 4) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_left_sticky 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_left_sticky 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_left_sticky 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_left_sticky 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_left_sticky 4) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_right_sticky 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_right_sticky 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_right_sticky 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_right_sticky 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_sticky (is_prop_and_height_x is_right_sticky 4) ).

          "
    )
end