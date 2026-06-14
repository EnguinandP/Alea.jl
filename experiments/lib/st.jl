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
    function is_sticky(t)
        @match(t, [
            T(v, left, right) -> begin
                @dice_ite if (matches(left, :T) & matches(right, :T))
                    false
                else
                    is_sticky(left) & is_sticky(right)
                end
            end,
            E() -> true
        ])
    end
    is_sticky(t)
end

# > shaped tree, with size 4

function satisfies_zigzag(t::sKVTree.t)
    function zigs_and_zags(node::sKVTree.t, step::Int)
        @match(node, [
            E() -> true,
            T(v, left, right) -> begin
                if step <= 2
                    @dice_ite if matches(left, :E) & matches(right, :T)
                        zigs_and_zags(right, step + 1)
                    else
                        false
                    end
                elseif step <= 4
                    @dice_ite if matches(left, :T) & matches(right, :E)
                        if step == 4
                            true
                        else
                            zigs_and_zags(left, step + 1)
                        end
                    else
                        false
                    end
                else
                    true
                end
            end
        ])
    end

    zigs_and_zags(t, 1)
end

# > shaped tree, arbitrary size, arbitary pivot

function satisfies_zigzag_arbitrary_pivot(t::sKVTree.t)
    # Checks spine follows pattern: right* then left*
    # has_switched_to_left tracks whether we've seen a left step yet
    function zigs_and_zags(node::sKVTree.t, has_switched_to_left::Bool)
        @match(node, [
            E() -> true,
            T(v, left, right) -> begin
                is_right_step = matches(left, :E) & matches(right, :T)
                is_left_step = matches(left, :T) & matches(right, :E)
                both_empty = matches(left, :E) & matches(right, :E)
                
                @dice_ite if is_right_step
                    @dice_ite if has_switched_to_left
                        false
                    else
                        zigs_and_zags(right, false)
                    end
                elseif is_left_step
                    zigs_and_zags(left, true)
                elseif both_empty
                    true
                else
                    # 2 children
                    false
                end
            end
        ])
    end

    zigs_and_zags(t, false)
end
