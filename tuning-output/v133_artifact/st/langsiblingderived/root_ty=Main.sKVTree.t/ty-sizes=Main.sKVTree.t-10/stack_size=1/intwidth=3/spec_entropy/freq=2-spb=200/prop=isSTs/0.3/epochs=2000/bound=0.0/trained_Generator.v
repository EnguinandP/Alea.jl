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

Definition genLeafTree (chosen_ctor : LeafCtorTree) (stack1 : nat) : G (Tree) :=
  match chosen_ctor with
  | LeafCtorTree_E => 
    (returnGen (E ))
  end.

Fixpoint genTree (size : nat) (chosen_ctor : CtorTree) (stack1 : nat) : G (Tree) :=
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
        (let _weight_1 := match (stack1) with
        | (2) => 19
        | (4) => 26
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (stack1) with
        | (2) => 53
        | (4) => 64
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (stack1) with
        | (2) => 80
        | (4) => 43
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
          (bindGen (genLeafTree ctor1 1) 
          (fun p2 => 
            (bindGen (genLeafTree ctor2 3) 
            (fun p3 => 
              (returnGen (T p1 p2 p3)))))))))))
    end
  | S size1 => match chosen_ctor with
    | CtorTree_E => 
      (returnGen (E ))
    | CtorTree_T => 
      (bindGen 
      (* Frequency3 *) (freq [
        (* 1 *) (match (size, stack1) with
        | (1, 2) => 4
        | (1, 4) => 2
        | (2, 2) => 1
        | (2, 4) => 1
        | (3, 2) => 0
        | (3, 4) => 1
        | (4, 2) => 0
        | (4, 4) => 0
        | (5, 2) => 0
        | (5, 4) => 0
        | (6, 2) => 0
        | (6, 4) => 0
        | (7, 2) => 0
        | (7, 4) => 0
        | (8, 2) => 0
        | (8, 4) => 0
        | (9, 0) => 0
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_E CtorTree_E))); 
        (* 2 *) (match (size, stack1) with
        | (1, 2) => 89
        | (1, 4) => 94
        | (2, 2) => 89
        | (2, 4) => 91
        | (3, 2) => 93
        | (3, 4) => 83
        | (4, 2) => 94
        | (4, 4) => 89
        | (5, 2) => 95
        | (5, 4) => 92
        | (6, 2) => 95
        | (6, 4) => 93
        | (7, 2) => 92
        | (7, 4) => 96
        | (8, 2) => 91
        | (8, 4) => 93
        | (9, 0) => 93
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_T CtorTree_E))); 
        (* 3 *) (match (size, stack1) with
        | (1, 2) => 92
        | (1, 4) => 87
        | (2, 2) => 92
        | (2, 4) => 91
        | (3, 2) => 88
        | (3, 4) => 94
        | (4, 2) => 87
        | (4, 4) => 93
        | (5, 2) => 83
        | (5, 4) => 91
        | (6, 2) => 76
        | (6, 4) => 88
        | (7, 2) => 92
        | (7, 4) => 26
        | (8, 2) => 91
        | (8, 4) => 89
        | (9, 0) => 93
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_E CtorTree_T))); 
        (* 4 *) (match (size, stack1) with
        | (1, 2) => 0
        | (1, 4) => 0
        | (2, 2) => 0
        | (2, 4) => 0
        | (3, 2) => 0
        | (3, 4) => 0
        | (4, 2) => 0
        | (4, 4) => 0
        | (5, 2) => 0
        | (5, 4) => 0
        | (6, 2) => 0
        | (6, 4) => 0
        | (7, 2) => 0
        | (7, 4) => 0
        | (8, 2) => 0
        | (8, 4) => 0
        | (9, 0) => 0
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_T CtorTree_T)))]) 
      (fun param_variantis => (let '(MkCtorTreeCtorTree ctor1 ctor2) := param_variantis in

        (bindGen 
        (* GenNat2 *)
        (let _weight_1 := match (size, stack1) with
        | (1, 2) => 31
        | (1, 4) => 82
        | (2, 2) => 72
        | (2, 4) => 43
        | (3, 2) => 52
        | (3, 4) => 48
        | (4, 2) => 29
        | (4, 4) => 53
        | (5, 2) => 19
        | (5, 4) => 32
        | (6, 2) => 61
        | (6, 4) => 77
        | (7, 2) => 22
        | (7, 4) => 37
        | (8, 2) => 42
        | (8, 4) => 73
        | (9, 0) => 26
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (size, stack1) with
        | (1, 2) => 30
        | (1, 4) => 50
        | (2, 2) => 89
        | (2, 4) => 47
        | (3, 2) => 65
        | (3, 4) => 60
        | (4, 2) => 54
        | (4, 4) => 60
        | (5, 2) => 28
        | (5, 4) => 63
        | (6, 2) => 46
        | (6, 4) => 59
        | (7, 2) => 48
        | (7, 4) => 86
        | (8, 2) => 64
        | (8, 4) => 49
        | (9, 0) => 61
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (size, stack1) with
        | (1, 2) => 73
        | (1, 4) => 62
        | (2, 2) => 29
        | (2, 4) => 64
        | (3, 2) => 79
        | (3, 4) => 41
        | (4, 2) => 80
        | (4, 4) => 40
        | (5, 2) => 74
        | (5, 4) => 40
        | (6, 2) => 45
        | (6, 4) => 59
        | (7, 2) => 77
        | (7, 4) => 34
        | (8, 2) => 69
        | (8, 4) => 44
        | (9, 0) => 52
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
          (bindGen (genTree size1 ctor1 2) 
          (fun p2 => 
            (bindGen (genTree size1 ctor2 4) 
            (fun p3 => 
              (returnGen (T p1 p2 p3)))))))))))
    end
  end.

Definition gSized :=

  (bindGen 
  (* Frequency1 *) (freq [
    (* 1 *) (match (tt) with
    | tt => 0
    end,
    (returnGen CtorTree_E)); 
    (* 2 *) (match (tt) with
    | tt => 90
    end,
    (returnGen CtorTree_T))]) 
  (fun init_ctor => (genTree 9 init_ctor 0))).


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
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 5) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 6) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 7) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 8) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 9) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_height_x 10) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 4) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 5) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 6) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 7) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 8) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 9) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_sticky_and_height_x 10) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_rl_balanced 4) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_left_sticky 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_left_sticky 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_left_sticky 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_left_sticky 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_left_sticky 4) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_right_sticky 0) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_right_sticky 1) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_right_sticky 2) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_right_sticky 3) ).
QuickChickWith (updMaxSuccess stdArgs numRuns) (count_test (is_prop_and_height_x is_right_sticky 4) ).

          
