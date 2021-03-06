using .Samsara, Conception
using UUIDs, Random

""" EuclideanNode is a (linked-list type) node with one one node in 
each cartinal direction: N, S, E, W
 ~> Implies some Euclidean properties
"""
abstract type EuclideanNode <: Conception.Time.TemporalType end


_all_known_CartinalNodes = Samsara.EuclideanNode[]

""" LinkedCardinalNode is a node in a linked list, representing the states of a simulation.
Each node has a number of possible transitions, of which can be effectuated by events.
This is perfect for emulating a system for IV-learning.

Each link is of type Conception.TemporalType (like SAT): 
    can be activated, 
    have activation time, 
    and be a part of a MuExS.
"""
mutable struct LinkedCardinalNode <: EuclideanNode
    _node::Conception.AbstractConcept
    _node_E::Union{Conception.Conception.AbstractConcept, Nothing}
    _node_W::Union{Conception.Conception.AbstractConcept, Nothing}

    function LinkedCardinalNode(id=nothing;
                        node_to_E =nothing,
                        node_to_W =nothing,
                        connected_T=nothing,
                        in_MuEx::Union{AbstractMuExS, Nothing}=nothing)
        # Id
        the_SAT = SAT(id, inMuExS=in_MuEx, connected_with=connected_T)

        LinkedCardinalNode(the_SAT, node_to_E=node_to_E, node_to_W=node_to_W)
        
        #= # Init
        the_node = new(the_SAT, node_to_E, node_to_W)

        #Conception.add_element_to_MuExS!(in_MuEx, the_node)

        push!(_all_known_CartinalNodes, the_node)
        return the_node
        =#
    end
    function LinkedCardinalNode(sat_arg::SAT;
                        node_to_E =nothing,
                        node_to_W =nothing)
        the_node = new(sat_arg, node_to_E, node_to_W)
        push!(_all_known_CartinalNodes, the_node)
        the_node
    end
end

function Conception.get_id(it::LinkedCardinalNode)
    get_id(it._node)
end

Conception.is_active(it::LinkedCardinalNode) = is_active(it._node)
Conception.exists_in_MuExS(caseNode::LinkedCardinalNode, state_set::Conception.MuExS) = Conception.exists_in_MuExS(caseNode._node, state_set)


" member of muex, forwarded to node "
member_of_MuExS(it::LinkedCardinalNode) = it._node.member_of_MuExS

function Conception.activate!(it::LinkedCardinalNode)
    activate!(it._node)
end
function Conception.set_connected_concept(it::LinkedCardinalNode, with::Conception.AbstractConcept)
    Conception.set_connected_concept(it._node, with)
end

""" show(IO, LinkeNode)
Print LinkeNode with node_to_W and node_to_E, with '|' if absent.
"""
function Base.show(io::IO, arg::LinkedCardinalNode)
    if isnothing(arg._node_E)
        text_nE = "|"
    else
        text_nE = string(get_id(arg._node_E))
    end
    if isnothing(arg._node_W)
        text_nW = "|"
    else
        text_nW = string(get_id(arg._node_W))
    end
    print(io, "[ "*text_nE*"→|"*string(get_id(arg._node))*"|→"*text_nW*" ]")
end

""" _set_node_to_W!(nodeA, nodeB)
Set note to the west of nodeA to become nodeB. Note that nodeB can be Nothing 
"""
function _set_node_to_W!(nodeA::Conception.AbstractConcept, 
                         nodeB::Union{Conception.AbstractConcept, Nothing})
    nodeA._node_W = nodeB
end

""" _set_node_to_E!(nodeA, nodeB)
Set note to the west of nodeA to become nodeB. Note that nodeB can be Nothing 
"""
function _set_node_to_E!(nodeA::Conception.AbstractConcept, 
                         nodeB::Union{Conception.AbstractConcept, Nothing})
    nodeA._node_E = nodeB
end

" Find link that contains SAT "
function find_link_with_SAT(node::SAT)
    for it in _all_known_CartinalNodes
        if it._node == node
            return it
        end
    end
    return nothing
end

""" east_of(node)
return the node that lies to the east of node::LinkedCardinalNode)
"""
function east_of(node::LinkedCardinalNode)
    return node._node_E
end
""" east_of(node) implemented for SAT (the content) """
function east_of(node::SAT)
    east_of(find_link_with_SAT(node))
end

""" node(it::LinkedCardinalNode)
return the actual SAT of a LinkedCardinalNode
"""
function the_node(it::LinkedCardinalNode)
    it._node
end

""" west_of(node)
return the node that lies to the west of node::LinkedCardinalNode)
"""
function west_of(node::LinkedCardinalNode)
    return node._node_W
end
""" west_of(node) implemented for SAT (the content) """
function west_of(node::SAT)
    west_of(find_link_with_SAT(node))
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
        the_node = LinkedCardinalNode(SAT("n"*string(i), inMuExS=in_MuExS))
        #the_node = LinkedCardinalNode("n"*string(i), in_MuEx=in_MuExS)
        push!(retList, the_node)
        _set_node_to_W!(the_node, previous_node)
        _set_node_to_E!(previous_node, the_node)
        previous_node = the_node
    end
    retList
end
