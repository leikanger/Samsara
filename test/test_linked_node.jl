module TEST_LINKED_NODE
using Samsara, Test

@testset "LinkNode initiation" begin
    case = Samsara.LinkedNode()
    @test isa(case, Samsara.LinkedNode)
end


end #module TEST_LINKED_NODE
