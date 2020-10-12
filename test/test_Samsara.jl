module TEST_SAMSARA
using Samsara, Test

@testset "system initiation" begin
    case = Samsara.MockSystem()
    @test isa(case, Samsara.AbstractSystem)

    @test isa(case._system_state, Tuple)

    @test length(case._system_state) == 0
    @test dimentionality(case) == 0
end



end#module TEST_SAMSARA
