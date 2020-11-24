using .Samsara, Conception
using UUIDs, Random

""" LinkedNode is a node in a linked list, representing the states of a simulation.
Each node has a number of possible transitions, of which can be effectuated by events.
This is perfect for emulating a system for IV-learning.

Each link is of type Conception.TemporalType (like SAT): 
    can be activated, 
    have activation time, 
    and be a part of a MuExS.
"""
mutable struct LinkedNode <: Conception.TemporalType
    _id
    _last_activation_interval
    _member_of_MuEx::Vector{Conception.MuExS}
    # _incoming_asscon # Trengs denne?
    _node_E::Union{Conception.Conception.TemporalType, Nothing}
    _node_W::Union{Conception.Conception.TemporalType, Nothing}

    function LinkedNode(id=missing;
                        node_to_E =nothing,
                        node_to_W =nothing,
                        in_MuEx::Union{AbstractMuExS, Nothing}=nothing)
        # Id
        # Id can be anything, e.g. (parameter, value)-tuple?
        if ismissing(id)
            uuid = UUIDs.uuid1(Random.MersenneTwister())
            id = "N_"*SubString(string(uuid), 1:6)
        end
        # MuExS
        set_of_MuExS = AbstractMuExS[]
        !isnothing(in_MuEx) && push!(set_of_MuExS, in_MuEx)
        # Init
        the_node = new(id, Tuple{}(), set_of_MuExS, node_to_E, node_to_W)

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

""" _set_node_to_W!(nodeA, nodeB)
Set note to the west of nodeA to become nodeB. Note that nodeB can be Nothing 
"""
function _set_node_to_W!(nodeA::LinkedNode, nodeB::Union{LinkedNode, Nothing})
    nodeA._node_W = nodeB
end

""" _set_node_to_E!(nodeA, nodeB)
Set note to the west of nodeA to become nodeB. Note that nodeB can be Nothing 
"""
function _set_node_to_E!(nodeA::LinkedNode, nodeB::Union{LinkedNode, Nothing})
    nodeA._node_E = nodeB
end

function linked_list_factory(N::Int)
    retList = LinkedNode[]
    # first item
    previous_node = LinkedNode("n_1")
    push!(retList, previous_node)
    # .. then the rest -> for the sake of registering _node_E
    for i in 2:N
        the_node = LinkedNode("n"*string(i))
        push!(retList, the_node)
        _set_node_to_E!(the_node, previous_node)
        _set_node_to_W!(previous_node, the_node)
        previous_node = the_node
    end
    retList
end
