Require Import ZArith.
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

          

Inductive CtorTree :=
  | CtorTree_E
  | CtorTree_T.

Inductive LeafCtorTree :=
  | LeafCtorTree_E.

Inductive TupLeafCtorTreeLeafCtorTree :=
  | MkLeafCtorTreeLeafCtorTree : LeafCtorTree -> LeafCtorTree -> TupLeafCtorTreeLeafCtorTree.

Inductive TupCtorTreeCtorTree :=
  | MkCtorTreeCtorTree : CtorTree -> CtorTree -> TupCtorTreeCtorTree.

Definition genLeafTree (chosen_ctor : LeafCtorTree) (stack1 : nat) (stack2 : nat) : G (Tree) :=
  match chosen_ctor with
  | LeafCtorTree_E => 
    (returnGen (E ))
  end.

Fixpoint genTree (size : nat) (chosen_ctor : CtorTree) (stack1 : nat) (stack2 : nat) : G (Tree) :=
  match size with
  | O  => match chosen_ctor with
    | CtorTree_E => 
      (returnGen (E ))
    | CtorTree_T => 
      (bindGen 
      (* Frequency2 (single-branch) *) 
      (returnGen (MkLeafCtorTreeLeafCtorTree LeafCtorTree_E LeafCtorTree_E)) 
      (fun param_variantis => (let '(MkLeafCtorTreeLeafCtorTree ctor1 ctor2) := param_variantis in

        (bindGen 
        (* GenNat1 *)
        (let _weight_1 := match (stack1, stack2) with
        | (2, 2) => 50
        | (2, 4) => 50
        | (4, 2) => 50
        | (4, 4) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (stack1, stack2) with
        | (2, 2) => 50
        | (2, 4) => 50
        | (4, 2) => 50
        | (4, 4) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (stack1, stack2) with
        | (2, 2) => 50
        | (2, 4) => 50
        | (4, 2) => 50
        | (4, 4) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_4, returnGen 4);
          (100-_weight_4, returnGen 0)
        ]) (fun n4 =>
          returnGen (n1 + n2 + n4)
        )))))) 
        (fun p1 => 
          (bindGen (genLeafTree ctor1 stack2 1) 
          (fun p2 => 
            (bindGen (genLeafTree ctor2 stack2 3) 
            (fun p3 => 
              (returnGen (T p1 p2 p3)))))))))))
    end
  | S size1 => match chosen_ctor with
    | CtorTree_E => 
      (returnGen (E ))
    | CtorTree_T => 
      (bindGen 
      (* Frequency3 *) (freq [
        (* 1 *) (match (size, stack1, stack2) with
        | (1, 2, 2) => 50
        | (1, 2, 4) => 50
        | (1, 4, 2) => 50
        | (1, 4, 4) => 50
        | (2, 0, 2) => 50
        | (2, 0, 4) => 50
        | (3, 0, 0) => 50
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_E CtorTree_E))); 
        (* 2 *) (match (size, stack1, stack2) with
        | (1, 2, 2) => 50
        | (1, 2, 4) => 50
        | (1, 4, 2) => 50
        | (1, 4, 4) => 50
        | (2, 0, 2) => 50
        | (2, 0, 4) => 50
        | (3, 0, 0) => 50
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_T CtorTree_E))); 
        (* 3 *) (match (size, stack1, stack2) with
        | (1, 2, 2) => 50
        | (1, 2, 4) => 50
        | (1, 4, 2) => 50
        | (1, 4, 4) => 50
        | (2, 0, 2) => 50
        | (2, 0, 4) => 50
        | (3, 0, 0) => 50
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_E CtorTree_T))); 
        (* 4 *) (match (size, stack1, stack2) with
        | (1, 2, 2) => 50
        | (1, 2, 4) => 50
        | (1, 4, 2) => 50
        | (1, 4, 4) => 50
        | (2, 0, 2) => 50
        | (2, 0, 4) => 50
        | (3, 0, 0) => 50
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_T CtorTree_T)))]) 
      (fun param_variantis => (let '(MkCtorTreeCtorTree ctor1 ctor2) := param_variantis in

        (bindGen 
        (* GenNat2 *)
        (let _weight_1 := match (size, stack1, stack2) with
        | (1, 2, 2) => 50
        | (1, 2, 4) => 50
        | (1, 4, 2) => 50
        | (1, 4, 4) => 50
        | (2, 0, 2) => 50
        | (2, 0, 4) => 50
        | (3, 0, 0) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (size, stack1, stack2) with
        | (1, 2, 2) => 50
        | (1, 2, 4) => 50
        | (1, 4, 2) => 50
        | (1, 4, 4) => 50
        | (2, 0, 2) => 50
        | (2, 0, 4) => 50
        | (3, 0, 0) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (size, stack1, stack2) with
        | (1, 2, 2) => 50
        | (1, 2, 4) => 50
        | (1, 4, 2) => 50
        | (1, 4, 4) => 50
        | (2, 0, 2) => 50
        | (2, 0, 4) => 50
        | (3, 0, 0) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_4, returnGen 4);
          (100-_weight_4, returnGen 0)
        ]) (fun n4 =>
          returnGen (n1 + n2 + n4)
        )))))) 
        (fun p1 => 
          (bindGen (genTree size1 ctor1 stack2 2) 
          (fun p2 => 
            (bindGen (genTree size1 ctor2 stack2 4) 
            (fun p3 => 
              (returnGen (T p1 p2 p3)))))))))))
    end
  end.

Definition gSized :=

  (bindGen 
  (* Frequency1 *) (freq [
    (* 1 *) (match (tt) with
    | tt => 50
    end,
    (returnGen CtorTree_E)); 
    (* 2 *) (match (tt) with
    | tt => 50
    end,
    (returnGen CtorTree_T))]) 
  (fun init_ctor => (genTree 3 init_ctor 0 0))).


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

Definition count_test (prop : ( Tree -> bool)) :=
  forAll gSized (fun t : Tree =>
    collect (if prop t then true else false) true).

QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test is_sticky ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test is_left_sticky ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test is_right_sticky ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test is_rl_balanced ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 4) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 4) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 4) ).

          
