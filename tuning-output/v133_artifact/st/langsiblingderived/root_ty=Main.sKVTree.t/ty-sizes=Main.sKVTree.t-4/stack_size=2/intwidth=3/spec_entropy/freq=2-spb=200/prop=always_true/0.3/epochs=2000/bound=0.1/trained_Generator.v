Require Import ZArith.
From QuickChick Require Import QuickChick.
From ExtLib Require Import Monad.
From ExtLib.Data.Monads Require Import OptionMonad.
Import QcNotation.
Import MonadNotation.
From Coq Require Import List.
Import ListNotations.

          

Inductive LeafCtorTree :=
  | LeafCtorTree_Leaf.

Inductive CtorTree :=
  | CtorTree_Leaf
  | CtorTree_Node.

Inductive TupLeafCtorTreeLeafCtorTree :=
  | MkLeafCtorTreeLeafCtorTree : LeafCtorTree -> LeafCtorTree -> TupLeafCtorTreeLeafCtorTree.

Inductive TupCtorTreeCtorTree :=
  | MkCtorTreeCtorTree : CtorTree -> CtorTree -> TupCtorTreeCtorTree.

Definition genLeafTree (chosen_ctor : LeafCtorTree) (stack1 : nat) (stack2 : nat) : G (Tree) :=
  match chosen_ctor with
  | LeafCtorTree_Leaf => 
    (returnGen (Leaf ))
  end.

Fixpoint genTree (size : nat) (chosen_ctor : CtorTree) (stack1 : nat) (stack2 : nat) : G (Tree) :=
  match size with
  | O  => match chosen_ctor with
    | CtorTree_Leaf => 
      (returnGen (Leaf ))
    | CtorTree_Node => 
      (bindGen 
      (* Frequency2 (single-branch) *) 
      (returnGen (MkLeafCtorTreeLeafCtorTree LeafCtorTree_Leaf LeafCtorTree_Leaf)) 
      (fun param_variantis => (let '(MkLeafCtorTreeLeafCtorTree ctor1 ctor2) := param_variantis in

        (bindGen 
        (* GenNat1 *)
        (let _weight_1 := match (stack1, stack2) with
        | (2, 2) => 37
        | (2, 4) => 74
        | (4, 2) => 48
        | (4, 4) => 52
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (stack1, stack2) with
        | (2, 2) => 73
        | (2, 4) => 37
        | (4, 2) => 45
        | (4, 4) => 31
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (stack1, stack2) with
        | (2, 2) => 70
        | (2, 4) => 27
        | (4, 2) => 28
        | (4, 4) => 65
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
              (returnGen (Node p1 p2 p3)))))))))))
    end
  | S size1 => match chosen_ctor with
    | CtorTree_Leaf => 
      (returnGen (Leaf ))
    | CtorTree_Node => 
      (bindGen 
      (* Frequency3 *) (freq [
        (* 1 *) (match (size, stack1, stack2) with
        | (1, 2, 2) => 10
        | (1, 2, 4) => 12
        | (1, 4, 2) => 10
        | (1, 4, 4) => 12
        | (2, 0, 2) => 10
        | (2, 0, 4) => 10
        | (3, 0, 0) => 10
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_Leaf CtorTree_Leaf))); 
        (* 2 *) (match (size, stack1, stack2) with
        | (1, 2, 2) => 15
        | (1, 2, 4) => 39
        | (1, 4, 2) => 14
        | (1, 4, 4) => 70
        | (2, 0, 2) => 11
        | (2, 0, 4) => 12
        | (3, 0, 0) => 10
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_Node CtorTree_Leaf))); 
        (* 3 *) (match (size, stack1, stack2) with
        | (1, 2, 2) => 32
        | (1, 2, 4) => 16
        | (1, 4, 2) => 35
        | (1, 4, 4) => 21
        | (2, 0, 2) => 10
        | (2, 0, 4) => 15
        | (3, 0, 0) => 10
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_Leaf CtorTree_Node))); 
        (* 4 *) (match (size, stack1, stack2) with
        | (1, 2, 2) => 89
        | (1, 2, 4) => 88
        | (1, 4, 2) => 90
        | (1, 4, 4) => 89
        | (2, 0, 2) => 90
        | (2, 0, 4) => 90
        | (3, 0, 0) => 90
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_Node CtorTree_Node)))]) 
      (fun param_variantis => (let '(MkCtorTreeCtorTree ctor1 ctor2) := param_variantis in

        (bindGen 
        (* GenNat2 *)
        (let _weight_1 := match (size, stack1, stack2) with
        | (1, 2, 2) => 51
        | (1, 2, 4) => 38
        | (1, 4, 2) => 35
        | (1, 4, 4) => 56
        | (2, 0, 2) => 45
        | (2, 0, 4) => 69
        | (3, 0, 0) => 51
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (size, stack1, stack2) with
        | (1, 2, 2) => 12
        | (1, 2, 4) => 25
        | (1, 4, 2) => 48
        | (1, 4, 4) => 56
        | (2, 0, 2) => 83
        | (2, 0, 4) => 31
        | (3, 0, 0) => 38
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (size, stack1, stack2) with
        | (1, 2, 2) => 58
        | (1, 2, 4) => 85
        | (1, 4, 2) => 28
        | (1, 4, 4) => 74
        | (2, 0, 2) => 59
        | (2, 0, 4) => 47
        | (3, 0, 0) => 36
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
              (returnGen (Node p1 p2 p3)))))))))))
    end
  end.

Definition gSized :=

  (bindGen 
  (* Frequency1 *) (freq [
    (* 1 *) (match (tt) with
    | tt => 10
    end,
    (returnGen CtorTree_Leaf)); 
    (* 2 *) (match (tt) with
    | tt => 90
    end,
    (returnGen CtorTree_Node))]) 
  (fun init_ctor => (genTree 3 init_ctor 0 0))).


