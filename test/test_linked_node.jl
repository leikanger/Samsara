module TEST_LINKED_NODE
using Samsara, Conception, Test

@testset "LinkNode initiation" begin
    case = Samsara.LinkedNode()
    @test isa(case, Samsara.LinkedNode)
    @test isa(case, Conception.AbstractConcept)
end


end #module TEST_LINKED_NODE
