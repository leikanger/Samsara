using .Samsara, Conception

""" LinkedNode is a node in a linked list, representing the states of a simulation.
Each node has a number of possible transitions, of which can be effectuated by events.
This is perfect for emulating a system for IV-learning.

Each link is of type Conception.TemporalType (like SAT): 
    can be activated, 
    have activation time, 
    and be a part of a MuExS.
"""
struct LinkedNode <: Conception.TemporalType
    _id
    _member_of_MuEx
    function LinkedNode(;in_MuEx::Union{Conception.MuExS, Nothing}=nothing)
        set_of_MuExS = AbstractMuExS[]
        !isnothing(in_MuEx) && push!(set_of_MuExS, in_MuEx)
        the_node = new(:id, set_of_MuExS)

        Conception.add_element_to_MuExS!(in_MuEx, the_node)

        return the_node
    end
end


