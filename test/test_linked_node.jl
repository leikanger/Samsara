module TEST_LINKED_NODE
using Samsara, Conception, Test

@testset "LinkNode initiation" begin
    caseNode = Samsara.LinkedNode()
    @test isa(caseNode, Samsara.LinkedNode)
    @test isa(caseNode, Conception.AbstractConcept)
    " LinkedNode lager en struct av type Conception.AbstractConcept --- som også SAT gjør... "

    @test LinkedNode("test")._id == "test"

    state_set = Conception.MuExS()
    caseNode = Samsara.LinkedNode(in_MuEx=state_set)
    @test Conception.exists_in_MuExS(caseNode, state_set)
    " Lage en LinkedNode => registreres i arg: [in_MuEx] "

    @show(caseNode)

    @test isnothing(caseNode._node_W)
    @test isnothing(caseNode._node_E)
    " Default neste node (i retning E og W) er nothing "

    node1 = LinkedNode("1")
    node3 = LinkedNode("3")
    caseNode = LinkedNode(node_to_E = node3, node_to_W = node1)
    @test isa(caseNode._node_E, Conception.AbstractConcept)
    @test caseNode._node_E == node3
    @test isa(caseNode._node_W, Conception.AbstractConcept)
    @test caseNode._node_W == node1
    " LinkedNode can have node to West and node to East, set by constructor "
    
    other_node = LinkedNode() 
    @test LinkedNode()._id != other_node._id
    " Constructed LinkedNode without id-arg are assigned unique id values "

    node1 = LinkedNode(:1)
    @assert node1._node_W === nothing
    @assert node1._node_E === nothing
    node2 = LinkedNode(:2)

    Samsara._set_node_to_W!(node1, node2)
    @test node1._node_W == node2
    " set node to W with function _set_node_to_W!(nodeA, nodeB) "

    Samsara._set_node_to_W!(node1, nothing)
    @test node1._node_W === nothing
    " set node to W with function _set_node_to_W!(nodeA, nothing) "

    Samsara._set_node_to_E!(node2, node1)
    @test node2._node_E == node1
    Samsara._set_node_to_E!(node2, nothing)
    @test node2._node_E === nothing
    " set node to W with function _set_node_to_W!(nodeA, nodeB) "
end

@testset "Conception.TemporalType funksjonalitet" begin
    """ LinkedNode arber fra Conception.TemporalType, og er meint for å 
    kunne bruke funksjonane i Conception.jl/srt/trait.jl 
    (sjå også time.jl i Conception.jl om TemporalType)
    """
    muex = Conception.MuExS()
    n1 = LinkedNode(in_MuEx=muex)
    @test length(muex._elements) == 1
    activate!(n1)
    @test is_active(n1)
    @test muex._active_element == n1
    " LinkedNode fungerer som TemporalType, dvs. likestilt med SAT! "

    muex_stateset = Conception.MuExS()

    # 
    # TODO Må være medlem av MuExS! Hopper dit no..
end

@testset "linked_list_factory(N)" begin
    caseList = Samsara.linked_list_factory(1)
    @test length(caseList) == 1
    @test isa(caseList[1], LinkedNode)
    " factory with N=1 creates list of 1 linked_node "

    caseList = Samsara.linked_list_factory(3)
    @test isa(caseList, Vector{LinkedNode})
    @test length(caseList) == 3
    " With N = 3    =>     factory makes list of 3 nodes "

    @test caseList[1]._node_W == caseList[2]
    @test caseList[2]._node_E == caseList[1]
    " Element 1 er East for node 2, og element 2 er West for node 1 "

    caseList = Samsara.linked_list_factory(5)
    for i in 2:length(caseList)-1
        @test caseList[i]._node_W == caseList[i+1]
        @test caseList[i]._node_E == caseList[i-1]
    end
    @test caseList[1]._node_W == caseList[2]
    @test caseList[end]._node_E == caseList[end-1]
    " linked_list_factory(N) integration test: creates a doubly-linked list of N elements "

    muex = Conception.MuExS()
    caseList = Samsara.linked_list_factory(3, in_MuExS=muex)
    @show muex
    #@show caseList
    for item in caseList
        @test item ∈ muex._elements
    end
    """ LL_factory(N, in_MuExS) lager elementer i muex [in_MuExS] -- 
    det er enkelt å sette MuExS ved arg i LL_factory """

    for item in caseList
        activate!(item)
        activate!(SAT(:some_action))
        deactivate!(SAT(:some_action))
        @test Conception.the_active_event_of(muex) == item
    end
    for item in caseList
        @show item, item._incoming_asscon
    end
    @show caseList
    # TODO lag bra automatiserte testar for forrige opplegget! TODO
end


end #module TEST_LINKED_NODE
