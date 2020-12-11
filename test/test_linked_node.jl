module TEST_LINKED_NODE
using Samsara, Conception, Test

@testset "LinkNode initiation" begin
    caseNode = Samsara.LinkedCardinalNode()
    @test isa(caseNode, Samsara.LinkedCardinalNode)
    @test isa(caseNode, Samsara.EuclideanNode)
    @test isa(caseNode, Conception.Time.TemporalType)
        " LinkedCardinalNode lager en struct av type Conception.AbstractConcept --- som også SAT gjør... "

    @test LinkedCardinalNode("test")._id == "test"

    state_set = Conception.MuExS()
    caseNode = Samsara.LinkedCardinalNode(in_MuEx=state_set)
    @test Conception.exists_in_MuExS(caseNode, state_set)
    " Lage en LinkedCardinalNode => registreres i arg: [in_MuEx] "

    @show(caseNode)

    @test isnothing(caseNode._node_W)
    @test isnothing(caseNode._node_E)
    " Default neste node (i retning E og W) er nothing "

    node1 = LinkedCardinalNode("1")
    node3 = LinkedCardinalNode("3")
    caseNode = LinkedCardinalNode(node_to_E = node3, node_to_W = node1)
    @test isa(caseNode._node_E, Conception.AbstractConcept)
    @test caseNode._node_E == node3
    @test isa(caseNode._node_W, Conception.AbstractConcept)
    @test caseNode._node_W == node1
    " LinkedCardinalNode can have node to West and node to East, set by constructor "
    
    other_node = LinkedCardinalNode() 
    @test LinkedCardinalNode()._id != other_node._id
    " Constructed LinkedCardinalNode without id-arg are assigned unique id values "

    node1 = LinkedCardinalNode(:1)
    @assert node1._node_W === nothing
    @assert node1._node_E === nothing
    node2 = LinkedCardinalNode(:2)

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
    """ LinkedCardinalNode arber fra Conception.TemporalType, og er meint for å 
    kunne bruke funksjonane i Conception.jl/srt/trait.jl 
    (sjå også time.jl i Conception.jl om TemporalType)
    """
    muex = Conception.MuExS()
    n1 = LinkedCardinalNode(in_MuEx=muex)
    @test length(muex._elements) == 1
    activate!(n1)
    @test is_active(n1)
    @test muex._active_element == n1
    " LinkedCardinalNode fungerer som TemporalType, dvs. likestilt med SAT! "

    muex_stateset = Conception.MuExS()

    # 
    # TODO Må være medlem av MuExS! Hopper dit no..
end

@testset "linked_list_factory(N)" begin
    caseList = Samsara.linked_list_factory(1)
    @test length(caseList) == 1
    @test isa(caseList[1], LinkedCardinalNode)
    " factory with N=1 creates list of 1 linked_node "

    caseList = Samsara.linked_list_factory(3)
    @test isa(caseList, Vector{LinkedCardinalNode})
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
    for item in caseList
        @test item ∈ muex._elements
    end
    """ LL_factory(N, in_MuExS) lager elementer i muex [in_MuExS] -- 
    det er enkelt å sette MuExS ved arg i LL_factory """

    for item in caseList
        activate!(item)
        @test Conception.the_active_event_of(muex) == item
        " The activating an item causes that item to be active in that muex.. (verifying  "
    end
    for i in 2:length(caseList)
        @test length(caseList[i]._incoming_asscon) == 0
    end
    """ .. but the lenght of incoming asscons are 0 (since no concurrent event happened
    while traversing the linked state-list """

    for item in caseList
        activate!(item)
        activate!(SAT(:some_action))
        @test Conception.the_active_event_of(muex) == item
    end
    for i in 2:length(caseList)
        @test caseList[i]._incoming_asscon[1].nodeL == caseList[i-1]
        @test caseList[i]._incoming_asscon[1].nodeR == SAT(:some_action)
    end
    """ incoming asscons is sorted, such that the first element is the most recent in history;
    This test verifies that each element has 
        * the most recent item in the linked list as nodeL
        * the concurrent event with that node is SAT(:some_action)  (as nodeR)
    """

    for item in caseList
        @show item, item._incoming_asscon
    end
    @show caseList
    # TODO lag bra automatiserte testar for forrige opplegget! TODO
end

end #module TEST_LINKED_NODE
