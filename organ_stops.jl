using Base.Iterators
using DataStructures
using StaticArrays

struct State{N}
    value::SVector{N, Int8}
end

struct Movement{N}
    value::SVector{N, Int8}
end

State(x...) = State(SVector{length(x), Int8}(x...))
Movement(x...) = Movement(SVector{length(x), Int8}(x...))

function Base.ones(::Type{State{N}})::State{N} where {N}
    return State(ones(SVector{N, Int8}))
end

function Base.zeros(::Type{State{N}})::State{N} where {N}
    return State(zeros(SVector{N, Int8}))
end

function is_valid(state::State)::Bool
    return all(0 .<= state.value .<= 1)
end

Base.show(io::IO, state::State) = for el in state.value print(io, el) end
function Base.show(io::IO, movement::Movement)
    for el in movement.value
        char = if el == -1
            '-'
        elseif el == 0
            '.'
        elseif el == 1
            '+'
        end
        print(io, char)
    end
end

function Base.:(+)(state::State{N}, movement::Movement{N})::State{N} where {N}
    return State(state.value + movement.value)
end

"""
Get all movements in increasing order of applicability.

That is, movements near the start of the list contain fewer 'no change' actions, and as such
are usable in fewer situations.
"""
function get_all_movements(n::Integer)
    actions = (-1, 0, 1)
    all_movements = collect(product((actions for _ in 1:n)...))
    all_movements = [Movement(movement...) for movement in @view all_movements[:]]
    sort!(all_movements; by=x -> sum(abs.(x.value)), rev=true)
    result = MutableLinkedList()
    for movement in all_movements
        push!(result, movement)
    end
    return result
end

function get_movement_cycle(initial::State{N})::Vector{Movement{N}} where {N}
    movement_cycle = Movement{N}[]
    all_movements = get_all_movements(N)
    state = initial
    while !isempty(all_movements)
        found = false
        for (i, movement) in enumerate(all_movements)
            new_state = state + movement
            if is_valid(new_state)
                delete!(all_movements, i)
                push!(movement_cycle, movement)
                state = new_state
                found = true
                break
            end
        end
        found || error("Was not able to find lower bound cycle!")
    end
    state == initial || error("Did not end in the initial state!")
    return movement_cycle
end

print_movements(state, cycle) = print_movements(stdout, state, cycle)

function print_movements(io::IO, state::State{N}, cycle::Vector{Movement{N}}) where {N}
    for movement in cycle
        println(io, "$state    $movement")
        state += movement
        is_valid(state) || error("Invalid movement $movement from $state")
    end
    println(io, state)
    return nothing
end

for n in 1:7
    initial = zeros(State{n})
    movement_cycle = get_movement_cycle(initial)
    open(joinpath("output", "movements_$n.txt"); write=true) do io
        print_movements(io, initial, movement_cycle)
    end
end
