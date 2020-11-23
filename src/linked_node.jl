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
    _node_E::Union{Conception.Conception.TemporalType, Nothing}
    _node_W::Union{Conception.Conception.TemporalType, Nothing}
    function LinkedNode(identifier=missing;
                        node_to_E =nothing,
                        node_to_W =nothing,
                        in_MuEx::Union{AbstractMuExS, Nothing}=nothing)
        set_of_MuExS = AbstractMuExS[]
        !isnothing(in_MuEx) && push!(set_of_MuExS, in_MuEx)
        # Init
        the_node = new(identifier, set_of_MuExS, node_to_E, node_to_W)

        Conception.add_element_to_MuExS!(in_MuEx, the_node)

        return the_node
    end
end

""" show(IO, LinkeNode)
Print LinkeNode with node_to_W and node_to_E, with '|' if absent.
"""
function Base.show(io::IO, arg::LinkedNode)
    if isnothing(arg._node_E)
        text_nE = "|"
    else
        text_nE = string(arg._node_E)
    end
    if isnothing(arg._node_W)
        text_nW = "|"
    else
        text_nW = string(arg._node_W)
    end
    print(io, "  node: "*string(arg._id)*" [ "*text_nE*" → "*text_nW*" ]")
end

function linked_list_factory(N::Int)
end
