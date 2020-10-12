module TEST_SAMSARA
using Samsara, Test

@testset "system initiation" begin
    case = Samsara.MockSystem()
    @test isa(case, Samsara.AbstractSystem)
end



end#module TEST_SAMSARA
