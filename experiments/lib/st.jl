module sKVTree
using Dice
using Main: Nat
@type t = E() | T(Nat.t, t, t)
end

type_to_coq(::Type{sKVTree.t}) = "Tree"

function tree_size(e::sKVTree.t)
    match(e, [
        :E => () -> DistUInt32(0),
        :T => (v, l, r) -> DistUInt32(1) + tree_size(l) + tree_size(r),
    ])
end

function depth(e::sKVTree.t)
    @match e [
        E() -> DistUInt32(0),
        T(v, l, r) -> DistUInt32(1) + max(depth(l), depth(r))
    ]
end


# all nodes are stick nodes
function satisfies_stickyness(t::sKVTree.t)
    function count_sticky_not_sticky(t)
        @match(t, [
            E() -> (DistUInt32(0), DistUInt32(0)),
            T(v, left, right) -> begin
                left_sticky, left_not_sticky = count_sticky_not_sticky(left)
                right_sticky, right_not_sticky = count_sticky_not_sticky(right)
                self_sticky, self_not_sticky = @dice_ite if (matches(left, :E) & matches(right, :T)) | (matches(left, :T) & matches(right, :E))
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

function satisfies_stickyness_simple(t::sKVTree.t)
    function check_sticky(t)
        @match(t, [
            T(v, left, right) -> begin
                if (matches(left, :T) & matches(right, :T))
                    false
                else
                    check_sticky(left) & check_sticky(right)
                end
            end,
            E() -> true
        ])
    end
    check_sticky(t)
end