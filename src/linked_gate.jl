using .Samsara, Conception
using UUIDs, Random

""" LinkedGate is a subtype of Conception.AbstractConcept 
LinkedGate is a subtype of Conception.AbstractConcept to mark that it's not supposed to become part of hte history: It is not a temporal element, since a transition throught a gate happens instantaneosly.
"""
mutable struct LinkedGate <: Conception.AbstractConcept
    pre_node
    post_node
    function LinkedGate(nodeA::T, nodeB::T) where {T <: Conception.AbstractConcept}
        new(nodeA, nodeB)
    end
end




