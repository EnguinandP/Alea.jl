# Setup

Follow [README.md#julia-setup](README.md#julia-setup).

Recommended: to run and tinker with the tutorials line-by-line, also install the
Julia VSCode extension.

# Learning generator probabilities in Dice

Once the setup is complete, see [`tutorial/tour_1_core.jl`](tutorial/tour_1_core.jl) for a quick start to Loaded Dice. Then, see [`tutorial/tour_2_learning.jl`](tutorial/tour_2_learning.jl) for an introduction to learning probabilities.

The following related programs are included. The expected output of each is in a comment at the bottom of the file.
- Generator for nat lists ([`examples/demo_natlist.jl`](examples/demo_natlist.jl))
  - Given a generator for nat lists with a hole dependent on size, chooses probabilities such that the list has a particular distribution on lengths.
- Generator for binary search trees ([`examples/demo_bst.jl`](examples/demo_bst.jl))
  - Given a generator for binary search trees with a hole dependent on size, chooses probabilities such that the tree has uniform depth.
  - 50 example generated BSTs are visible at [`examples/samples/bst.txt`](examples/samples/bst.txt)

# Tool overview

The main part of the tool is the Julia embedding of Loaded Dice, which is
documented in detail by the tour-style tutorials mentioned above, and the
testsuite in `lib/Dice.jl/test`.

The core contribution of our paper is, beyond presenting this system, is to use
it to tune generators for PBT. We provide two thorough examples, tuning a
generator for binary search trees to have a uniform distribution over tree
depths, and tuning a generator for lists of natural numbers to have a particular
distribution over list lengths, in `examples/`.

# Capabilities

1. Constructs for constructing Loaded Dice programs (e.g. `@dice_ite`,
`DistUInt32`, as described in `tour_1_core.jl`, and algebraic datatypes as
described in `examples/demo_natlist.jl`).
2. The implementation of various objective functions (in
`lib/Dice.jl/src/autodiff_pr/losses.jl` e.g. `kl_divergence` as used in
`examples/demo_natlist`).
3. A function to optimize the weights of generators based on differentiating the
probabilities it generates particular values: `train!` as used in both examples.
