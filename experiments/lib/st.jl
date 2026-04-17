module sKVTree
using Dice
using Main: Nat
@type t = Leaf() | Node(Nat.t, t, t)
end

type_to_coq(::Type{sKVTree.t}) = "Tree"

function tree_size(e::sKVTree.t)
    match(e, [
        :Leaf => () -> DistUInt32(0),
        :Node => (v, l, r) -> DistUInt32(1) + tree_size(l) + tree_size(r),
    ])
end

function depth(e::sKVTree.t)
    @match e [
        Leaf() -> DistUInt32(0),
        Node(v, l, r) -> DistUInt32(1) + max(depth(l), depth(r))
    ]
end


# all nodes are stick nodes
function satisfies_stickyness(t::sKVTree.t)
    function count_sticky_not_sticky(t)
        @match(t, [
            Leaf() -> (DistUInt32(0), DistUInt32(0)),
            Node(v, left, right) -> begin
                left_sticky, left_not_sticky = count_sticky_not_sticky(left)
                right_sticky, right_not_sticky = count_sticky_not_sticky(right)
                self_sticky, self_not_sticky = @dice_ite if (matches(left, :Leaf) & matches(right, :Node)) | (matches(left, :Node) & matches(right, :Leaf))
                    DistUInt32(1), DistUInt32(0)
                else
                    DistUInt32(0), DistUInt32(1)
                end
                (
                    self_sticky + left_sticky + right_sticky,
                    self_not_sticky + left_not_sticky + right_not_sticky,
                )
            end
        ])
    end
    sticky, not_sticky = count_sticky_not_sticky(t)
    prob_equals(not_sticky, DistUInt32(0))
end