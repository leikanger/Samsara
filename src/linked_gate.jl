using .Samsara, Conception
using UUIDs, Random

""" LinkedGate is a subtype of Conception.AbstractConcept 
LinkedGate is a subtype of Conception.AbstractConcept to mark that it's not supposed to become part of hte history: It is not a temporal element, since a transition throught a gate happens instantaneosly.
CTOR arguments:
    - nodeA : node that can be activated, on one side of gate.
    - nodeB : node that can be activated, on one side of gate.
    - condition : node that can be activated; gate keeper.
"""
mutable struct LinkedGate <: Conception.AbstractConcept
    _id
    pre_node::AbstractConcept
    post_node::Union{AbstractConcept, Nothing}
    _gate_is_open
    _unlocked_by_trait
    function LinkedGate(nodeA::T, nodeB::Union{T, Nothing}=nothing; 
                        conditional::Union{L, Nothing}=nothing) where
                            {T <: Conception.AbstractConcept, L <: Conception.AbstractConcept}
        new("gate", nodeA, nodeB, false, conditional)
    end
end

Conception.get_id(it::LinkedGate) = string(it)

""" show(IO, LinkeGate)
Print LinkeGate as { < > , <|> } for {opened, closed}
"""
function Base.show(io::IO, arg::LinkedGate)
    text_state = gate_is_open(arg) ? ' ' : '|'
    print(io, "<"*text_state*">")
end

""" is_open(LinkedGate) 
getter for whether gate is open or not """
function gate_is_open(the_gate::LinkedGate)
    isnothing(the_gate._unlocked_by_trait) && return the_gate._gate_is_open

    return is_active(the_gate._unlocked_by_trait)
end
" convenience: Make for readable code "
gate_is_closed(the_gate::LinkedGate) = !gate_is_open(the_gate)

""" gate_set_connected_node!*(gate, node)
Set connected node in a gate WITH NOTHING on other side // requires an uninitialized gate.
ARG:
    - gate : An uninitialized gate of type LinkedGate
    - node : Any node of type Conception.AbstractConcept ~~ struct that support activate! function.
"""
function gate_set_connected_node!(the_gate::LinkedGate, node::Conception.AbstractConcept)
    !isnothing(the_gate.post_node) && throw(ArgumentError("can't reset an allready set gate"))
    the_gate.post_node = node
end
function gate_set_connected_node!(the_gate::LinkedGate, Nothing)
    the_gate.post_node = nothing
end

""" open_gate(the_gate)
Open up the gate, such that activation of gate causes transmission from nodeA to nodeB or vice versa 
"""
function open_gate!(the_gate::LinkedGate, new_state=true)
    the_gate._gate_is_open = new_state
end


""" activate!(LinkedGate)   =>  do the gate : try to enter
activate port, i.e. try to enter
(Extends Conception.activate!(..) -- but not TemporalType, since AbstractConcept is higher. 
Therefore, I have to explicitly write Conception.activate! in the next sentence)
"""
function Conception.activate!(the_gate::LinkedGate)
    !gate_is_open(the_gate) && return
    # Letting MuExS handle eactivation, and activate!(nothing) just return, 
    #   a closed gate does not cause anything // works by default.
    # ~> isnothing(the_gate.post_node) && return # Ikkje naudsynt!

    if is_active(the_gate.pre_node)
        the_node = the_gate.pre_node
        the_other_node = the_gate.post_node
    else
        the_node = the_gate.post_node
        the_other_node = the_gate.pre_node
    end
    #println("activate gate: "*string(the_node)*"→"*string(the_other_node))
    activate!(the_other_node)
end
