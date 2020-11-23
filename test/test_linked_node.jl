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

    @test isnothing(caseNode._node_W)
    @test isnothing(caseNode._node_E)
    " Default neste node (i retning E og W) er nothing "

#    nW = LinkedNode()
#    nW = LinkedNode()
#    caseNode = 
    #@test isa(caseNode._node_W, Conception.AbstractConcept)
end


end #module TEST_LINKED_NODE
