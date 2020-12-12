using .Samsara, Conception
using UUIDs, Random

""" EuclideanNode is a (linked-list type) node with one one node in 
each cartinal direction: N, S, E, W
 ~> Implies some Euclidean properties
"""
abstract type EuclideanNode <: Conception.Time.TemporalType end

""" LinkedCardinalNode is a node in a linked list, representing the states of a simulation.
Each node has a number of possible transitions, of which can be effectuated by events.
This is perfect for emulating a system for IV-learning.

Each link is of type Conception.TemporalType (like SAT): 
    can be activated, 
    have activation time, 
    and be a part of a MuExS.
"""
mutable struct LinkedCardinalNode <: EuclideanNode
    _id
    _last_activation_interval
    _member_of_MuEx::Vector{Conception.MuExS}
     _incoming_asscon # Trengs denne?
    _node_E::Union{Conception.Conception.TemporalType, Nothing}
    _node_W::Union{Conception.Conception.TemporalType, Nothing}

    function LinkedCardinalNode(id=missing;
                        node_to_E =nothing,
                        node_to_W =nothing,
                        in_MuEx::Union{AbstractMuExS, Nothing}=nothing)
        # Id
        # Id can be anything, e.g. (parameter, value)-tuple?
        if ismissing(id)
            uuid = UUIDs.uuid1(Random.MersenneTwister())
            id = "N_"*SubString(string(uuid), 1:8)
        end
        # MuExS
        set_of_MuExS = AbstractMuExS[]
        !isnothing(in_MuEx) && push!(set_of_MuExS, in_MuEx)
        # Init
        the_node = new(id, Tuple{}(), set_of_MuExS, AssociativeLink[], node_to_E, node_to_W)

        Conception.add_element_to_MuExS!(in_MuEx, the_node)

        return the_node
    end
end

""" show(IO, LinkeNode)
Print LinkeNode with node_to_W and node_to_E, with '|' if absent.
"""
function Base.show(io::IO, arg::LinkedCardinalNode)
    if isnothing(arg._node_E)
        text_nE = "|"
    else
        text_nE = string(arg._node_E._id)
    end
    if isnothing(arg._node_W)
        text_nW = "|"
    else
        text_nW = string(arg._node_W._id)
    end
    print(io, "[ "*text_nE*"→|"*string(arg._id)*"|→"*text_nW*" ]")
end

""" _set_node_to_W!(nodeA, nodeB)
Set note to the west of nodeA to become nodeB. Note that nodeB can be Nothing 
"""
function _set_node_to_W!(nodeA::LinkedCardinalNode, nodeB::Union{LinkedCardinalNode, Nothing})
    nodeA._node_W = nodeB
end

""" _set_node_to_E!(nodeA, nodeB)
Set note to the west of nodeA to become nodeB. Note that nodeB can be Nothing 
"""
function _set_node_to_E!(nodeA::LinkedCardinalNode, nodeB::Union{LinkedCardinalNode, Nothing})
    nodeA._node_E = nodeB
end

""" east_of(node)
return the node that lies to the east of node::LinkedCardinalNode)
"""
function east_of(node::LinkedCardinalNode)
    return node._node_E
end

""" west_of(node)
return the node that lies to the west of node::LinkedCardinalNode)
"""
function west_of(node::LinkedCardinalNode)
    return node._node_W
end

function linked_list_factory(N::Int; in_MuExS =nothing)
    retList = LinkedCardinalNode[]
    # first item      ( N > 0 )
    previous_node = LinkedCardinalNode("n1", in_MuEx=in_MuExS)
    push!(retList, previous_node)
    N == 1 && return retList
    # .. then the rest ( N > 1 ) 
    #  split is made for the sake of registering _node_E
    for i in 2:N
        the_node = LinkedCardinalNode("n"*string(i), in_MuEx=in_MuExS)
        push!(retList, the_node)
        _set_node_to_E!(the_node, previous_node)
        _set_node_to_W!(previous_node, the_node)
        previous_node = the_node
    end
    retList
end
