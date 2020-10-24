module TEST_CIRULARSYS
using Samsara, Test

@testset "circularsys initiation" begin
    CircularSys = Samsara.CircularSys
    current_index = Samsara.current_index
    step_up! = Samsara.step_up!
    step_down! = Samsara.step_down!

    case = CircularSys()
    @test isa(case, AbstractSystem)

    # default antall noder: 3
    @test length(case._all_nodes) == 3
    @test length(CircularSys(2)._all_nodes) == 2
    #@test length(case) == 2

    # current state: The index of current location
    case = CircularSys(3)
    @test system_state(case) == [1]
    @test step_up!(case) == 2
    " step_up! steps one 'up' "

    case._current_index = 3
    @test current_index(case) == 3
    @test step_up!(case) == 1
    @test current_index(case) == 1
    " step_up! steps around to beginning when rounding the end => Circular! "

    case = CircularSys(4)
    @test current_index(case) == 1
    @test step_up!(case) == 2
    @test step_up!(case) == 3
    @test step_up!(case) == 4
    @test step_up!(case) == 1
    " integration test: Step up works for a full circle "

    case = CircularSys(2)
    case._current_index = 2
    @test step_down!(case) == 1
    step_down!(case)
    @test current_index(case) == 2
    " Full round integration test for step_down! (on length(case) == 2) "
end

end#module TEST_CIRULARSYS
