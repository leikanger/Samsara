module TEST_LINK_NODE
using Samsara, Test

@testset "LinkNode initiation" begin
    case = Samsara.LinkNode()
    @test isa(case, Samsara.LinkNode)
end


end #module TEST_LINK_NODE
