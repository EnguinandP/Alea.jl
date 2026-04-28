Require Import ZArith.
From QuickChick Require Import QuickChick.
From ExtLib Require Import Monad.
From ExtLib.Data.Monads Require Import OptionMonad.
Import QcNotation.
Import MonadNotation.
From Coq Require Import List.
Import ListNotations.

          

Inductive CtorTree :=
  | CtorTree_E
  | CtorTree_T.

Inductive LeafCtorTree :=
  | LeafCtorTree_E.

Inductive TupCtorTreeCtorTree :=
  | MkCtorTreeCtorTree : CtorTree -> CtorTree -> TupCtorTreeCtorTree.

Inductive TupLeafCtorTreeLeafCtorTree :=
  | MkLeafCtorTreeLeafCtorTree : LeafCtorTree -> LeafCtorTree -> TupLeafCtorTreeLeafCtorTree.

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
        | (2) => 50
        | (4) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (stack1) with
        | (2) => 50
        | (4) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (stack1) with
        | (2) => 50
        | (4) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_4, returnGen 4);
          (100-_weight_4, returnGen 0)
        ]) (fun n4 =>
        (let _weight_8 := match (stack1) with
        | (2) => 50
        | (4) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_8, returnGen 8);
          (100-_weight_8, returnGen 0)
        ]) (fun n8 =>
          returnGen (n1 + n2 + n4 + n8)
        )))))))) 
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
        | (1, 2) => 50
        | (1, 4) => 50
        | (2, 2) => 50
        | (2, 4) => 50
        | (3, 0) => 50
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_E CtorTree_E))); 
        (* 2 *) (match (size, stack1) with
        | (1, 2) => 50
        | (1, 4) => 50
        | (2, 2) => 50
        | (2, 4) => 50
        | (3, 0) => 50
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_T CtorTree_E))); 
        (* 3 *) (match (size, stack1) with
        | (1, 2) => 50
        | (1, 4) => 50
        | (2, 2) => 50
        | (2, 4) => 50
        | (3, 0) => 50
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_E CtorTree_T))); 
        (* 4 *) (match (size, stack1) with
        | (1, 2) => 50
        | (1, 4) => 50
        | (2, 2) => 50
        | (2, 4) => 50
        | (3, 0) => 50
        | _ => 500
        end,
        (returnGen (MkCtorTreeCtorTree CtorTree_T CtorTree_T)))]) 
      (fun param_variantis => (let '(MkCtorTreeCtorTree ctor1 ctor2) := param_variantis in

        (bindGen 
        (* GenNat2 *)
        (let _weight_1 := match (size, stack1) with
        | (1, 2) => 50
        | (1, 4) => 50
        | (2, 2) => 50
        | (2, 4) => 50
        | (3, 0) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_1, returnGen 1);
          (100-_weight_1, returnGen 0)
        ]) (fun n1 =>
        (let _weight_2 := match (size, stack1) with
        | (1, 2) => 50
        | (1, 4) => 50
        | (2, 2) => 50
        | (2, 4) => 50
        | (3, 0) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_2, returnGen 2);
          (100-_weight_2, returnGen 0)
        ]) (fun n2 =>
        (let _weight_4 := match (size, stack1) with
        | (1, 2) => 50
        | (1, 4) => 50
        | (2, 2) => 50
        | (2, 4) => 50
        | (3, 0) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_4, returnGen 4);
          (100-_weight_4, returnGen 0)
        ]) (fun n4 =>
        (let _weight_8 := match (size, stack1) with
        | (1, 2) => 50
        | (1, 4) => 50
        | (2, 2) => 50
        | (2, 4) => 50
        | (3, 0) => 50
        | _ => 500
        end
        in
        bindGen (freq [
          (_weight_8, returnGen 8);
          (100-_weight_8, returnGen 0)
        ]) (fun n8 =>
          returnGen (n1 + n2 + n4 + n8)
        )))))))) 
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
    | tt => 50
    end,
    (returnGen CtorTree_E)); 
    (* 2 *) (match (tt) with
    | tt => 50
    end,
    (returnGen CtorTree_T))]) 
  (fun init_ctor => (genTree 3 init_ctor 0))).


