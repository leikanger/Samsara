module TEST_LINKED_NODE
using Samsara, Conception, Test

@testset "LinkNode initiation" begin
    case = Samsara.LinkedNode()
    @test isa(case, Samsara.LinkedNode)
    @test isa(case, Conception.AbstractConcept)

    state_set = Conception.MuExS()
    case = Samsara.LinkedNode(in_MuEx=state_set)
    @test Conception.exists_in_MuExS(case, state_set)
end


end #module TEST_LINKED_NODE
