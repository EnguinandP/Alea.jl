# Demo of using BDD MLE to learn flip probs for a BST of uniform depth

using Dice

@inductive DistTree DistLeaf() DistBranch(DistUInt32, DistTree, DistTree)

function depth(l::DistTree)
    @match(l, [
        DistLeaf() -> DistUInt32(0),
        DistBranch(x, l, r) -> begin
            dl, dr = depth(l), depth(r)
            @dice_ite if dl > dr
                DistUInt32(1) + dl
            else
                DistUInt32(1) + dr
            end
        end
    ])
end

# counts the number of sticky nodes
function sticky_nodes(l::DistTree)
    @match(l, [
        DistLeaf() -> DistUInt32(0),
        DistBranch(x, left, right) -> begin
            self = @dice_ite if (matches(left, :DistLeaf) & matches(right, :DistBranch)) | (matches(left, :DistBranch) & matches(right, :DistLeaf))
                DistUInt32(1)
            else
                DistUInt32(0)
            end
            self + sticky_nodes(left) + sticky_nodes(right)
        end
    ])
end

var_vals = Valuation()
adnodes_of_interest = Dict{String,ADNode}()
function register_weight!(s)
    var = Var("$(s)_before_sigmoid")
    var_vals[var] = 0
    weight = sigmoid(var)
    adnodes_of_interest[s] = weight
    weight
end


sticky_var_vals = Valuation()
sticky_adnodes_of_interest = Dict{String,ADNode}()
function sticky_register_weight!(s)
    sticky_var = Var("$(s)_before_sigmoid")
    sticky_var_vals[sticky_var] = 0
    weight = sigmoid(sticky_var)
    sticky_adnodes_of_interest[s] = weight
    weight
end

# Return bst_tree
function gen_bst(size, lo, hi)
    @dice_ite if size == 0 || flip(register_weight!("sz$(size)"))
        DistLeaf()
    else
        x = unif(lo, hi)
        DistBranch(x, gen_bst(size - 1, lo, x), gen_bst(size - 1, x, hi))
    end
end


# Return tree
function gen_tree(size)
    @dice_ite if size == 0 || flip(sticky_register_weight!("sz$(size)"))
        DistLeaf()
    else
        # data doesn't matter
        x = DistUInt32(0)
        DistBranch(x, gen_tree(size - 1), gen_tree(size - 1))
    end
end


# Top-level size/fuel. For gen_bst, this is the max depth.
INIT_SIZE = 3

# Dataset over the desired property to match. Below is a uniform distribution
# over sizes.
DATASET = [DistUInt32(x) for x in 0:INIT_SIZE]

# max num of nodes = 2^NIT_SIZE - 1
MAX_NODES = 2^INIT_SIZE - 1
MAX_STICKY_NODES = 2
DATASET_stick = [DistUInt32(x) for x in 0:MAX_STICKY_NODES]

# Use Dice to build computation graph
tree = gen_bst(
    INIT_SIZE,
    DistUInt32(1),
    DistUInt32(2 * INIT_SIZE),
)
tree_depth = depth(tree)


# computation graph for sticky trees
stickytree = gen_tree(INIT_SIZE)
stickytree_nodes = sticky_nodes(stickytree)

println()
println("Sticky Node Distribution before training:")
display(pr_mixed(sticky_var_vals)(stickytree_nodes))
println()

println("Distribution before training:")
display(pr_mixed(var_vals)(tree_depth))
println()



# training part

train!(var_vals, mle_loss([prob_equals(tree_depth, x) for x in DATASET]), epochs=1000, learning_rate=0.3)
train!(sticky_var_vals, mle_loss([prob_equals(stickytree_nodes, x) for x in DATASET_stick]), epochs=1000, learning_rate=0.3)

# Done!
println("Learned flip probability for each size:")
vals = compute(var_vals, values(adnodes_of_interest))
show(Dict(s => vals[adnode] for (s, adnode) in adnodes_of_interest))
println()
println()

println("In sticky trees Learned flip probability for each size:")
sticky_vals = compute(sticky_var_vals, values(sticky_adnodes_of_interest))
show(Dict(s => sticky_vals[sticky_adnode] for (s, sticky_adnode) in sticky_adnodes_of_interest))
println()
println()

println("Distribution over depths after training:")
display(pr_mixed(var_vals)(tree_depth))
println()

println("Sticky Node Distribution after training:")
display(pr_mixed(sticky_var_vals)(stickytree_nodes))
println()

println("A few sampled trees:")
with_concrete_ad_flips(var_vals, tree) do
    for _ in 1:3
        print_tree(sample_default_rng(tree))
        println()
    end
end

#==
Distribution before training:
DataStructures.DefaultOrderedDict{Any, Any, Float64} with 4 entries:
  0 => 0.5
  3 => 0.304688
  1 => 0.125
  2 => 0.0703125

Learned flip probability for each size:
Dict("sz1" => 0.7522142306508817, "sz2" => 0.5773502691896257, "sz3" => 0.25000000000000006)

Distribution over depths after training:
DataStructures.DefaultOrderedDict{Any, Any, Float64} with 4 entries:
  0 => 0.25
  3 => 0.25
  1 => 0.25
  2 => 0.25

A few sampled trees:
Branch
├── 2
├── Branch
│   ├── 2
│   ├── Leaf
│   └── Leaf
└── Branch
    ├── 5
    ├── Leaf
    └── Branch
        ├── 6
        ├── Leaf
        └── Leaf

Branch
├── 3
├── Leaf
└── Branch
    ├── 3
    ├── Leaf
    └── Branch
        ├── 3
        ├── Leaf
        └── Leaf

Branch
├── 2
├── Leaf
└── Leaf
==#
