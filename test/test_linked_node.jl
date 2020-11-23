module TEST_LINKED_NODE
using Samsara, Conception, Test

@testset "LinkNode initiation" begin
    case = Samsara.LinkedNode()
    @test isa(case, Samsara.LinkedNode)
    @test isa(case, Conception.AbstractConcept)
    " LinkedNode lager en struct av type Conception.AbstractConcept --- som også SAT gjør... "

    state_set = Conception.MuExS()
    case = Samsara.LinkedNode(in_MuEx=state_set)
    @test Conception.exists_in_MuExS(case, state_set)
    " Lage en LinkedNode => registreres i arg: [in_MuEx] "
end


end #module TEST_LINKED_NODE
