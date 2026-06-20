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

Inductive LeafCtorTree :=
  | LeafCtorTree_E.

Inductive CtorTree :=
  | CtorTree_E
  | CtorTree_T.

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
        | (2) => 42
        | (4) => 48
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (stack1) with
        | (2) => 36
        | (4) => 42
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (stack1) with
        | (2) => 45
        | (4) => 29
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
        | (1, 2) => 10
        | (1, 4) => 14
        | (2, 2) => 10
        | (2, 4) => 10
        | (3, 0) => 10
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_E CtorTree_E))); 
        (* 2 *) (match (size, stack1) with
        | (1, 2) => 24
        | (1, 4) => 18
        | (2, 2) => 11
        | (2, 4) => 10
        | (3, 0) => 12
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_T CtorTree_E))); 
        (* 3 *) (match (size, stack1) with
        | (1, 2) => 27
        | (1, 4) => 12
        | (2, 2) => 90
        | (2, 4) => 10
        | (3, 0) => 90
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_E CtorTree_T))); 
        (* 4 *) (match (size, stack1) with
        | (1, 2) => 90
        | (1, 4) => 90
        | (2, 2) => 10
        | (2, 4) => 90
        | (3, 0) => 10
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_T CtorTree_T)))]) 
      (fun param_variantis => (let '(MkCtorTreeCtorTree ctor1 ctor2) := param_variantis in

        (bindGen 
        (* GenNat2 *)
        (let _weight_1 := match (size, stack1) with
        | (1, 2) => 57
        | (1, 4) => 52
        | (2, 2) => 67
        | (2, 4) => 77
        | (3, 0) => 37
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (size, stack1) with
        | (1, 2) => 63
        | (1, 4) => 46
        | (2, 2) => 58
        | (2, 4) => 29
        | (3, 0) => 33
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (size, stack1) with
        | (1, 2) => 46
        | (1, 4) => 56
        | (2, 2) => 41
        | (2, 4) => 43
        | (3, 0) => 65
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
    | tt => 10
    end,
    (returnGen CtorTree_E)); 
    (* 2 *) (match (tt) with
    | tt => 90
    end,
    (returnGen CtorTree_T))]) 
  (fun init_ctor => (genTree 3 init_ctor 0))).


Fixpoint is_sticky (t : Tree) : bool :=
  match t with 
  | T _ (T _ _ _) (T _ _ _) => false
  | T _ l r => is_sticky r && is_sticky l 
  | E => true 
  end.

#[export] Instance genTreeInst : Gen Tree := {| arbitrary := gSized |}.
#[export] Instance shrinkTree : Shrink Tree := {| shrink := fun _ => [] |}.
#[export] Instance arbTree : Arbitrary Tree := {}.

Derive (Show) for Tree. 

Definition test_is_sticky := forAll gSized (fun t : Tree => is_sticky t).

QuickChick test_is_sticky.

Definition numRuns := 1000.

Definition count_test :=
  forAll gSized (fun t : Tree =>
    collect (if is_sticky t then true else false) true).

QuickChickWith (updMaxSuccess stdArgs numRuns) count_test.

Sample gSized.