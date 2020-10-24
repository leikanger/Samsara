module TEST_CIRULARSYS
using Samsara, Test

@testset "circularsys initiation" begin
    CircularSys = Samsara.CircularSys
    current_index = Samsara.current_index
    current_state = Samsara.current_state
    step_up! = Samsara._step_up!
    step_down! = Samsara._step_down!

    case = CircularSys()
    @test isa(case, AbstractSystem)

    # default antall noder: 3 zeroes
    @test length(case._all_nodes) == 3
    @test length(case) == 3
    @test case._all_nodes[1] == :A  # default list of nodes: [:A, :B, :C]

    # current state: The current node in a Tuple
    case = CircularSys()
    @test system_state(case) == (:A, )
    " system_state(case) returns the value of the current node "

    case._current_index = 1
    @test step_up!(case) == 2
    " step_up! steps one 'up' "

    case._current_index = 3
    @test current_index(case) == 3
    @test step_up!(case) == 1
    @test current_index(case) == 1
    " step_up! steps around to beginning when rounding the end => Circular! "

    case = CircularSys([1:4;])
    @test current_index(case) == 1
    @test step_up!(case) == 2
    @test step_up!(case) == 3
    @test step_up!(case) == 4
    @test step_up!(case) == 1
    " integration test: Step up works for a full circle "

    case = CircularSys([:state1, :state2])
    case._current_index = 2
    @test step_down!(case) == 1
    step_down!(case)
    @test current_index(case) == 2
    @test system_state(case) == (:state2, )
    @test current_state(case) == :state2
    " Full round integration test for step_down! (on length(case) == 2) "
end

@testset "System testing: circular system with deterministic actions" begin
    
end

end#module TEST_CIRULARSYS
