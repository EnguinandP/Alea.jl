Require Import ZArith.
From QuickChick Require Import QuickChick.
From ExtLib Require Import Monad.
From ExtLib.Data.Monads Require Import OptionMonad.
Import QcNotation.
Import MonadNotation.
From Coq Require Import List.
Import ListNotations.

From RBT Require Import Impl.

Inductive CtorTree :=
  | CtorTree_E
  | CtorTree_T.

Inductive LeafCtorColor :=
  | LeafCtorColor_R
  | LeafCtorColor_B.

Inductive LeafCtorTree :=
  | LeafCtorTree_E.

Inductive TupLeafCtorColorLeafCtorTreeLeafCtorTree :=
  | MkLeafCtorColorLeafCtorTreeLeafCtorTree : LeafCtorColor -> LeafCtorTree -> LeafCtorTree -> TupLeafCtorColorLeafCtorTreeLeafCtorTree.

Inductive TupLeafCtorColorCtorTreeCtorTree :=
  | MkLeafCtorColorCtorTreeCtorTree : LeafCtorColor -> CtorTree -> CtorTree -> TupLeafCtorColorCtorTreeCtorTree.

Definition genLeafColor (chosen_ctor : LeafCtorColor) (stack1 : nat) (stack2 : nat) : G (Color) :=
  match chosen_ctor with
  | LeafCtorColor_R => 
    (returnGen (R ))
  | LeafCtorColor_B => 
    (returnGen (B ))
  end.

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
      (* Frequency2 *) (freq [
        (* 1 *) (match (stack1, stack2) with
        | (4, 4) => 50
        | (4, 6) => 50
        | (6, 4) => 50
        | (6, 6) => 50
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorLeafCtorTreeLeafCtorTree LeafCtorColor_R LeafCtorTree_E LeafCtorTree_E))); 
        (* 2 *) (match (stack1, stack2) with
        | (4, 4) => 50
        | (4, 6) => 50
        | (6, 4) => 50
        | (6, 6) => 50
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorLeafCtorTreeLeafCtorTree LeafCtorColor_B LeafCtorTree_E LeafCtorTree_E)))]) 
      (fun param_variantis => (let '(MkLeafCtorColorLeafCtorTreeLeafCtorTree ctor1 ctor2 ctor3) := param_variantis in

        (bindGen (genLeafColor ctor1 stack2 1) 
        (fun p1 => 
          (bindGen (genLeafTree ctor2 stack2 3) 
          (fun p2 => 
            (bindGen 
            (* GenZ1 *)
            (let _weight_1 := match (stack1, stack2) with
            | (4, 4) => 50
            | (4, 6) => 50
            | (6, 4) => 50
            | (6, 6) => 50
            | _ => 500
            end
            in
            bindGen (freq [
              (_weight_1, returnGen 1%Z);
              (100-_weight_1, returnGen 0%Z)
            ]) (fun n1 =>
            (let _weight_2 := match (stack1, stack2) with
            | (4, 4) => 50
            | (4, 6) => 50
            | (6, 4) => 50
            | (6, 6) => 50
            | _ => 500
            end
            in
            bindGen (freq [
              (_weight_2, returnGen 2%Z);
              (100-_weight_2, returnGen 0%Z)
            ]) (fun n2 =>
            (let _weight_4 := match (stack1, stack2) with
            | (4, 4) => 50
            | (4, 6) => 50
            | (6, 4) => 50
            | (6, 6) => 50
            | _ => 500
            end
            in
            bindGen (freq [
              (_weight_4, returnGen 4%Z);
              (100-_weight_4, returnGen 0%Z)
            ]) (fun n4 =>
              returnGen (n1 + n2 + n4)%Z
            )))))) 
            (fun p3 => 
              (bindGen 
              (* GenZ3 *)
              (let _weight_1 := match (stack1, stack2) with
              | (4, 4) => 50
              | (4, 6) => 50
              | (6, 4) => 50
              | (6, 6) => 50
              | _ => 500
              end
              in
              bindGen (freq [
                (_weight_1, returnGen 1%Z);
                (100-_weight_1, returnGen 0%Z)
              ]) (fun n1 =>
              (let _weight_2 := match (stack1, stack2) with
              | (4, 4) => 50
              | (4, 6) => 50
              | (6, 4) => 50
              | (6, 6) => 50
              | _ => 500
              end
              in
              bindGen (freq [
                (_weight_2, returnGen 2%Z);
                (100-_weight_2, returnGen 0%Z)
              ]) (fun n2 =>
              (let _weight_4 := match (stack1, stack2) with
              | (4, 4) => 50
              | (4, 6) => 50
              | (6, 4) => 50
              | (6, 6) => 50
              | _ => 500
              end
              in
              bindGen (freq [
                (_weight_4, returnGen 4%Z);
                (100-_weight_4, returnGen 0%Z)
              ]) (fun n4 =>
                returnGen (n1 + n2 + n4)%Z
              )))))) 
              (fun p4 => 
                (bindGen (genLeafTree ctor3 stack2 5) 
                (fun p5 => 
                  (returnGen (T p1 p2 p3 p4 p5)))))))))))))))
    end
  | S size1 => match chosen_ctor with
    | CtorTree_E => 
      (returnGen (E ))
    | CtorTree_T => 
      (bindGen 
      (* Frequency3 *) (freq [
        (* 1 *) (match (size, stack1, stack2) with
        | (1, 4, 4) => 50
        | (1, 4, 6) => 50
        | (1, 6, 4) => 50
        | (1, 6, 6) => 50
        | (2, 4, 4) => 50
        | (2, 4, 6) => 50
        | (2, 6, 4) => 50
        | (2, 6, 6) => 50
        | (3, 4, 4) => 50
        | (3, 4, 6) => 50
        | (3, 6, 4) => 50
        | (3, 6, 6) => 50
        | (4, 4, 4) => 50
        | (4, 4, 6) => 50
        | (4, 6, 4) => 50
        | (4, 6, 6) => 50
        | (5, 4, 4) => 50
        | (5, 4, 6) => 50
        | (5, 6, 4) => 50
        | (5, 6, 6) => 50
        | (6, 4, 4) => 50
        | (6, 4, 6) => 50
        | (6, 6, 4) => 50
        | (6, 6, 6) => 50
        | (7, 4, 4) => 50
        | (7, 4, 6) => 52
        | (7, 6, 4) => 52
        | (7, 6, 6) => 50
        | (8, 0, 4) => 90
        | (8, 0, 6) => 90
        | (9, 0, 0) => 90
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorCtorTreeCtorTree LeafCtorColor_R CtorTree_E CtorTree_E))); 
        (* 2 *) (match (size, stack1, stack2) with
        | (1, 4, 4) => 50
        | (1, 4, 6) => 50
        | (1, 6, 4) => 50
        | (1, 6, 6) => 50
        | (2, 4, 4) => 50
        | (2, 4, 6) => 50
        | (2, 6, 4) => 50
        | (2, 6, 6) => 50
        | (3, 4, 4) => 50
        | (3, 4, 6) => 50
        | (3, 6, 4) => 50
        | (3, 6, 6) => 50
        | (4, 4, 4) => 50
        | (4, 4, 6) => 50
        | (4, 6, 4) => 50
        | (4, 6, 6) => 50
        | (5, 4, 4) => 50
        | (5, 4, 6) => 50
        | (5, 6, 4) => 50
        | (5, 6, 6) => 50
        | (6, 4, 4) => 50
        | (6, 4, 6) => 50
        | (6, 6, 4) => 50
        | (6, 6, 6) => 50
        | (7, 4, 4) => 50
        | (7, 4, 6) => 50
        | (7, 6, 4) => 50
        | (7, 6, 6) => 50
        | (8, 0, 4) => 10
        | (8, 0, 6) => 10
        | (9, 0, 0) => 90
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorCtorTreeCtorTree LeafCtorColor_B CtorTree_E CtorTree_E))); 
        (* 3 *) (match (size, stack1, stack2) with
        | (1, 4, 4) => 50
        | (1, 4, 6) => 50
        | (1, 6, 4) => 50
        | (1, 6, 6) => 50
        | (2, 4, 4) => 50
        | (2, 4, 6) => 50
        | (2, 6, 4) => 50
        | (2, 6, 6) => 50
        | (3, 4, 4) => 50
        | (3, 4, 6) => 50
        | (3, 6, 4) => 50
        | (3, 6, 6) => 50
        | (4, 4, 4) => 50
        | (4, 4, 6) => 50
        | (4, 6, 4) => 50
        | (4, 6, 6) => 50
        | (5, 4, 4) => 50
        | (5, 4, 6) => 50
        | (5, 6, 4) => 50
        | (5, 6, 6) => 50
        | (6, 4, 4) => 50
        | (6, 4, 6) => 50
        | (6, 6, 4) => 50
        | (6, 6, 6) => 50
        | (7, 4, 4) => 50
        | (7, 4, 6) => 50
        | (7, 6, 4) => 50
        | (7, 6, 6) => 50
        | (8, 0, 4) => 10
        | (8, 0, 6) => 10
        | (9, 0, 0) => 10
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorCtorTreeCtorTree LeafCtorColor_R CtorTree_T CtorTree_E))); 
        (* 4 *) (match (size, stack1, stack2) with
        | (1, 4, 4) => 50
        | (1, 4, 6) => 50
        | (1, 6, 4) => 50
        | (1, 6, 6) => 50
        | (2, 4, 4) => 50
        | (2, 4, 6) => 50
        | (2, 6, 4) => 50
        | (2, 6, 6) => 50
        | (3, 4, 4) => 50
        | (3, 4, 6) => 50
        | (3, 6, 4) => 50
        | (3, 6, 6) => 50
        | (4, 4, 4) => 50
        | (4, 4, 6) => 50
        | (4, 6, 4) => 50
        | (4, 6, 6) => 50
        | (5, 4, 4) => 50
        | (5, 4, 6) => 50
        | (5, 6, 4) => 50
        | (5, 6, 6) => 50
        | (6, 4, 4) => 50
        | (6, 4, 6) => 50
        | (6, 6, 4) => 50
        | (6, 6, 6) => 50
        | (7, 4, 4) => 50
        | (7, 4, 6) => 50
        | (7, 6, 4) => 50
        | (7, 6, 6) => 50
        | (8, 0, 4) => 10
        | (8, 0, 6) => 10
        | (9, 0, 0) => 28
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorCtorTreeCtorTree LeafCtorColor_B CtorTree_T CtorTree_E))); 
        (* 5 *) (match (size, stack1, stack2) with
        | (1, 4, 4) => 50
        | (1, 4, 6) => 50
        | (1, 6, 4) => 50
        | (1, 6, 6) => 50
        | (2, 4, 4) => 50
        | (2, 4, 6) => 50
        | (2, 6, 4) => 50
        | (2, 6, 6) => 50
        | (3, 4, 4) => 50
        | (3, 4, 6) => 50
        | (3, 6, 4) => 50
        | (3, 6, 6) => 50
        | (4, 4, 4) => 50
        | (4, 4, 6) => 50
        | (4, 6, 4) => 50
        | (4, 6, 6) => 50
        | (5, 4, 4) => 50
        | (5, 4, 6) => 50
        | (5, 6, 4) => 50
        | (5, 6, 6) => 50
        | (6, 4, 4) => 50
        | (6, 4, 6) => 50
        | (6, 6, 4) => 50
        | (6, 6, 6) => 50
        | (7, 4, 4) => 50
        | (7, 4, 6) => 50
        | (7, 6, 4) => 50
        | (7, 6, 6) => 50
        | (8, 0, 4) => 10
        | (8, 0, 6) => 10
        | (9, 0, 0) => 10
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorCtorTreeCtorTree LeafCtorColor_R CtorTree_E CtorTree_T))); 
        (* 6 *) (match (size, stack1, stack2) with
        | (1, 4, 4) => 50
        | (1, 4, 6) => 50
        | (1, 6, 4) => 50
        | (1, 6, 6) => 50
        | (2, 4, 4) => 50
        | (2, 4, 6) => 50
        | (2, 6, 4) => 50
        | (2, 6, 6) => 50
        | (3, 4, 4) => 50
        | (3, 4, 6) => 50
        | (3, 6, 4) => 50
        | (3, 6, 6) => 50
        | (4, 4, 4) => 50
        | (4, 4, 6) => 50
        | (4, 6, 4) => 50
        | (4, 6, 6) => 50
        | (5, 4, 4) => 50
        | (5, 4, 6) => 50
        | (5, 6, 4) => 50
        | (5, 6, 6) => 50
        | (6, 4, 4) => 50
        | (6, 4, 6) => 50
        | (6, 6, 4) => 50
        | (6, 6, 6) => 50
        | (7, 4, 4) => 50
        | (7, 4, 6) => 50
        | (7, 6, 4) => 50
        | (7, 6, 6) => 50
        | (8, 0, 4) => 10
        | (8, 0, 6) => 10
        | (9, 0, 0) => 29
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorCtorTreeCtorTree LeafCtorColor_B CtorTree_E CtorTree_T))); 
        (* 7 *) (match (size, stack1, stack2) with
        | (1, 4, 4) => 50
        | (1, 4, 6) => 50
        | (1, 6, 4) => 50
        | (1, 6, 6) => 50
        | (2, 4, 4) => 50
        | (2, 4, 6) => 50
        | (2, 6, 4) => 50
        | (2, 6, 6) => 50
        | (3, 4, 4) => 50
        | (3, 4, 6) => 50
        | (3, 6, 4) => 50
        | (3, 6, 6) => 50
        | (4, 4, 4) => 50
        | (4, 4, 6) => 50
        | (4, 6, 4) => 50
        | (4, 6, 6) => 50
        | (5, 4, 4) => 50
        | (5, 4, 6) => 50
        | (5, 6, 4) => 50
        | (5, 6, 6) => 50
        | (6, 4, 4) => 50
        | (6, 4, 6) => 50
        | (6, 6, 4) => 50
        | (6, 6, 6) => 50
        | (7, 4, 4) => 50
        | (7, 4, 6) => 50
        | (7, 6, 4) => 50
        | (7, 6, 6) => 50
        | (8, 0, 4) => 10
        | (8, 0, 6) => 10
        | (9, 0, 0) => 10
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorCtorTreeCtorTree LeafCtorColor_R CtorTree_T CtorTree_T))); 
        (* 8 *) (match (size, stack1, stack2) with
        | (1, 4, 4) => 50
        | (1, 4, 6) => 50
        | (1, 6, 4) => 50
        | (1, 6, 6) => 50
        | (2, 4, 4) => 50
        | (2, 4, 6) => 50
        | (2, 6, 4) => 50
        | (2, 6, 6) => 50
        | (3, 4, 4) => 50
        | (3, 4, 6) => 50
        | (3, 6, 4) => 50
        | (3, 6, 6) => 50
        | (4, 4, 4) => 50
        | (4, 4, 6) => 50
        | (4, 6, 4) => 50
        | (4, 6, 6) => 50
        | (5, 4, 4) => 50
        | (5, 4, 6) => 50
        | (5, 6, 4) => 50
        | (5, 6, 6) => 50
        | (6, 4, 4) => 50
        | (6, 4, 6) => 50
        | (6, 6, 4) => 50
        | (6, 6, 6) => 50
        | (7, 4, 4) => 50
        | (7, 4, 6) => 50
        | (7, 6, 4) => 50
        | (7, 6, 6) => 50
        | (8, 0, 4) => 10
        | (8, 0, 6) => 10
        | (9, 0, 0) => 10
        | _ => 500
        end,
        (returnGen (MkLeafCtorColorCtorTreeCtorTree LeafCtorColor_B CtorTree_T CtorTree_T)))]) 
      (fun param_variantis => (let '(MkLeafCtorColorCtorTreeCtorTree ctor1 ctor2 ctor3) := param_variantis in

        (bindGen (genLeafColor ctor1 stack2 2) 
        (fun p1 => 
          (bindGen (genTree size1 ctor2 stack2 4) 
          (fun p2 => 
            (bindGen 
            (* GenZ2 *)
            (let _weight_1 := match (size, stack1, stack2) with
            | (1, 4, 4) => 50
            | (1, 4, 6) => 50
            | (1, 6, 4) => 50
            | (1, 6, 6) => 50
            | (2, 4, 4) => 50
            | (2, 4, 6) => 50
            | (2, 6, 4) => 50
            | (2, 6, 6) => 50
            | (3, 4, 4) => 50
            | (3, 4, 6) => 50
            | (3, 6, 4) => 50
            | (3, 6, 6) => 50
            | (4, 4, 4) => 50
            | (4, 4, 6) => 50
            | (4, 6, 4) => 50
            | (4, 6, 6) => 50
            | (5, 4, 4) => 50
            | (5, 4, 6) => 50
            | (5, 6, 4) => 50
            | (5, 6, 6) => 50
            | (6, 4, 4) => 50
            | (6, 4, 6) => 50
            | (6, 6, 4) => 50
            | (6, 6, 6) => 50
            | (7, 4, 4) => 50
            | (7, 4, 6) => 47
            | (7, 6, 4) => 47
            | (7, 6, 6) => 50
            | (8, 0, 4) => 10
            | (8, 0, 6) => 89
            | (9, 0, 0) => 51
            | _ => 500
            end
            in
            bindGen (freq [
              (_weight_1, returnGen 1%Z);
              (100-_weight_1, returnGen 0%Z)
            ]) (fun n1 =>
            (let _weight_2 := match (size, stack1, stack2) with
            | (1, 4, 4) => 50
            | (1, 4, 6) => 50
            | (1, 6, 4) => 50
            | (1, 6, 6) => 50
            | (2, 4, 4) => 50
            | (2, 4, 6) => 50
            | (2, 6, 4) => 50
            | (2, 6, 6) => 50
            | (3, 4, 4) => 50
            | (3, 4, 6) => 50
            | (3, 6, 4) => 50
            | (3, 6, 6) => 50
            | (4, 4, 4) => 50
            | (4, 4, 6) => 50
            | (4, 6, 4) => 50
            | (4, 6, 6) => 50
            | (5, 4, 4) => 50
            | (5, 4, 6) => 50
            | (5, 6, 4) => 50
            | (5, 6, 6) => 50
            | (6, 4, 4) => 50
            | (6, 4, 6) => 50
            | (6, 6, 4) => 50
            | (6, 6, 6) => 50
            | (7, 4, 4) => 50
            | (7, 4, 6) => 51
            | (7, 6, 4) => 51
            | (7, 6, 6) => 50
            | (8, 0, 4) => 10
            | (8, 0, 6) => 90
            | (9, 0, 0) => 46
            | _ => 500
            end
            in
            bindGen (freq [
              (_weight_2, returnGen 2%Z);
              (100-_weight_2, returnGen 0%Z)
            ]) (fun n2 =>
            (let _weight_4 := match (size, stack1, stack2) with
            | (1, 4, 4) => 50
            | (1, 4, 6) => 50
            | (1, 6, 4) => 50
            | (1, 6, 6) => 50
            | (2, 4, 4) => 50
            | (2, 4, 6) => 50
            | (2, 6, 4) => 50
            | (2, 6, 6) => 50
            | (3, 4, 4) => 50
            | (3, 4, 6) => 50
            | (3, 6, 4) => 50
            | (3, 6, 6) => 50
            | (4, 4, 4) => 50
            | (4, 4, 6) => 50
            | (4, 6, 4) => 50
            | (4, 6, 6) => 50
            | (5, 4, 4) => 50
            | (5, 4, 6) => 50
            | (5, 6, 4) => 50
            | (5, 6, 6) => 50
            | (6, 4, 4) => 50
            | (6, 4, 6) => 50
            | (6, 6, 4) => 50
            | (6, 6, 6) => 50
            | (7, 4, 4) => 50
            | (7, 4, 6) => 49
            | (7, 6, 4) => 53
            | (7, 6, 6) => 50
            | (8, 0, 4) => 10
            | (8, 0, 6) => 90
            | (9, 0, 0) => 53
            | _ => 500
            end
            in
            bindGen (freq [
              (_weight_4, returnGen 4%Z);
              (100-_weight_4, returnGen 0%Z)
            ]) (fun n4 =>
              returnGen (n1 + n2 + n4)%Z
            )))))) 
            (fun p3 => 
              (bindGen 
              (* GenZ4 *)
              (let _weight_1 := match (size, stack1, stack2) with
              | (1, 4, 4) => 50
              | (1, 4, 6) => 50
              | (1, 6, 4) => 50
              | (1, 6, 6) => 50
              | (2, 4, 4) => 50
              | (2, 4, 6) => 50
              | (2, 6, 4) => 50
              | (2, 6, 6) => 50
              | (3, 4, 4) => 50
              | (3, 4, 6) => 50
              | (3, 6, 4) => 50
              | (3, 6, 6) => 50
              | (4, 4, 4) => 50
              | (4, 4, 6) => 50
              | (4, 6, 4) => 50
              | (4, 6, 6) => 50
              | (5, 4, 4) => 50
              | (5, 4, 6) => 50
              | (5, 6, 4) => 50
              | (5, 6, 6) => 50
              | (6, 4, 4) => 50
              | (6, 4, 6) => 50
              | (6, 6, 4) => 50
              | (6, 6, 6) => 50
              | (7, 4, 4) => 50
              | (7, 4, 6) => 51
              | (7, 6, 4) => 49
              | (7, 6, 6) => 50
              | (8, 0, 4) => 59
              | (8, 0, 6) => 57
              | (9, 0, 0) => 49
              | _ => 500
              end
              in
              bindGen (freq [
                (_weight_1, returnGen 1%Z);
                (100-_weight_1, returnGen 0%Z)
              ]) (fun n1 =>
              (let _weight_2 := match (size, stack1, stack2) with
              | (1, 4, 4) => 50
              | (1, 4, 6) => 50
              | (1, 6, 4) => 50
              | (1, 6, 6) => 50
              | (2, 4, 4) => 50
              | (2, 4, 6) => 50
              | (2, 6, 4) => 50
              | (2, 6, 6) => 50
              | (3, 4, 4) => 50
              | (3, 4, 6) => 50
              | (3, 6, 4) => 50
              | (3, 6, 6) => 50
              | (4, 4, 4) => 50
              | (4, 4, 6) => 50
              | (4, 6, 4) => 50
              | (4, 6, 6) => 50
              | (5, 4, 4) => 50
              | (5, 4, 6) => 50
              | (5, 6, 4) => 50
              | (5, 6, 6) => 50
              | (6, 4, 4) => 50
              | (6, 4, 6) => 50
              | (6, 6, 4) => 50
              | (6, 6, 6) => 50
              | (7, 4, 4) => 50
              | (7, 4, 6) => 49
              | (7, 6, 4) => 53
              | (7, 6, 6) => 50
              | (8, 0, 4) => 48
              | (8, 0, 6) => 48
              | (9, 0, 0) => 34
              | _ => 500
              end
              in
              bindGen (freq [
                (_weight_2, returnGen 2%Z);
                (100-_weight_2, returnGen 0%Z)
              ]) (fun n2 =>
              (let _weight_4 := match (size, stack1, stack2) with
              | (1, 4, 4) => 50
              | (1, 4, 6) => 50
              | (1, 6, 4) => 50
              | (1, 6, 6) => 50
              | (2, 4, 4) => 50
              | (2, 4, 6) => 50
              | (2, 6, 4) => 50
              | (2, 6, 6) => 50
              | (3, 4, 4) => 50
              | (3, 4, 6) => 50
              | (3, 6, 4) => 50
              | (3, 6, 6) => 50
              | (4, 4, 4) => 50
              | (4, 4, 6) => 50
              | (4, 6, 4) => 50
              | (4, 6, 6) => 50
              | (5, 4, 4) => 50
              | (5, 4, 6) => 50
              | (5, 6, 4) => 50
              | (5, 6, 6) => 50
              | (6, 4, 4) => 50
              | (6, 4, 6) => 50
              | (6, 6, 4) => 50
              | (6, 6, 6) => 50
              | (7, 4, 4) => 50
              | (7, 4, 6) => 49
              | (7, 6, 4) => 47
              | (7, 6, 6) => 50
              | (8, 0, 4) => 34
              | (8, 0, 6) => 42
              | (9, 0, 0) => 53
              | _ => 500
              end
              in
              bindGen (freq [
                (_weight_4, returnGen 4%Z);
                (100-_weight_4, returnGen 0%Z)
              ]) (fun n4 =>
                returnGen (n1 + n2 + n4)%Z
              )))))) 
              (fun p4 => 
                (bindGen (genTree size1 ctor3 stack2 6) 
                (fun p5 => 
                  (returnGen (T p1 p2 p3 p4 p5)))))))))))))))
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
  (fun init_ctor => (genTree 9 init_ctor 0 0))).

(* --------------------- Tests --------------------- *)

(* -- "No red node has a red parent." *)
Fixpoint noRedRed (t: Tree) : bool :=
    let fix blackRoot (t: Tree) : bool :=
        match t with
        | (T R _ _ _ _) => false
        | _ => true
        end in
    match t with
    | E => true
    | (T B a _ _ b) => noRedRed a && noRedRed b
    | (T R a _ _ b) => blackRoot a && blackRoot b && noRedRed a && noRedRed b
    end.
    

(* -- "Every path from the root to an empty node contains the same number of black nodes." *)
Definition consistentBlackHeight  (t: Tree) : bool :=
    let fix go (t: Tree) : (bool * Z) :=
        match t with
        | E => (true, 1%Z)
        | T rb a x _ b =>
            let (aBool, aHeight) := go a in
            let (bBool, bHeight) := go b in
            let isBlack (rb: Color) : Z :=
                match rb with
                | B => 1%Z
                | R => 0%Z
                end in
            
        (andb (andb aBool bBool) (Z.eqb aHeight bHeight), (aHeight + isBlack rb)%Z)
        end in
    fst (go t).

(* Definition numRuns := 1000. *)

Definition isRBTunordered (t: Tree) : bool :=
  consistentBlackHeight t && noRedRed t
.

Definition count_test (prop : ( Tree -> bool)) :=
  forAll gSized (fun t : Tree =>
    collect (if prop t then true else false) true).


QuickChickWith (updMaxSuccess stdArgs 1000) (count_test isRBTunordered).
              
