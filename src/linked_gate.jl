using .Samsara, Conception
using UUIDs, Random

""" LinkedGate is a subtype of Conception.AbstractConcept 
LinkedGate is a subtype of Conception.AbstractConcept to mark that it's not supposed to become part of hte history: It is not a temporal element, since a transition throught a gate happens instantaneosly.
"""
mutable struct LinkedGate <: Conception.AbstractConcept
    pre_node
    post_node
    _gate_is_open
    function LinkedGate(nodeA::T, nodeB::T) where {T <: Conception.AbstractConcept}
        new(nodeA, nodeB, false)
    end
end

""" is_open(LinkedGate) 
getter for whether gate is open or not """
function gate_is_open(the_gate::LinkedGate)
    the_gate._gate_is_open
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

    if is_active(the_gate.pre_node)
        the_node = the_gate.pre_node
        the_other_node = the_gate.post_node
    else
        the_node = the_gate.post_node
        the_other_node = the_gate.pre_node
    end

    deactivate!(the_node)
    activate!(the_other_node)
end
