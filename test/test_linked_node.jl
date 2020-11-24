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

end

@testset "linked_list_factory(N)" begin
    caseList = Samsara.linked_list_factory(1)
    @test length(caseList) == 1
    @test isa(caseList[1], LinkedNode)
    @test isa(caseList, Vector{LinkedNode})
    " factory with N=1 creates list of 1 linked_node "

    caseList = Samsara.linked_list_factory(3)
    @test length(caseList) == 3
end


end #module TEST_LINKED_NODE
