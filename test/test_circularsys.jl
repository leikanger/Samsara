module TEST_CIRULARSYS
using ..Samsara, Test

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

    case = CircularSys( nodes=(1,2,3,4) )
    @test current_index(case) == 1
    @test step_up!(case) == 2
    @test step_up!(case) == 3
    @test step_up!(case) == 4
    @test step_up!(case) == 1
    " integration test: Step up works for a full circle "

    case = CircularSys( nodes=(:state1, :state2) )
    case._current_index = 2
    @test step_down!(case) == 1
    step_down!(case)
    @test current_index(case) == 2
    @test system_state(case) == (:state2, )
    @test current_state(case) == :state2
    " Full round integration test for step_down! (on length(case) == 2) "
end

@testset "System testing: circular system with deterministic actions" begin
    CircularSys    = Samsara.CircularSys
    current_state  = Samsara.current_state
    current_action = Samsara.current_action
    set_action_in!  = Samsara.set_action_in!

    case_system = CircularSys( nodes=(:s1, :s2, :s3) )
    @assert current_state(case_system) == :s1
    @assert case_system._latent_variables == nothing
    @test current_action(case_system) == nothing
    " Sircular system have _latent_variables of type action "

    @assert current_state(case_system) == :s1
    case_system._latent_variables = :up
    step_system_mechanics!(case_system)
    @test current_state(case_system) == :s2
    case_system._latent_variables = :down
    step_system_mechanics!(case_system)
    @test current_state(case_system) == :s1
    " System mechanics works as dictated by _latent_variables i.e. action "

    set_action_in!(case_system, :up)
    @test current_action(case_system) == :up
    set_action_in!(case_system, :down)
    @test current_action(case_system) == :down
    set_action_in!(case_system, :everything_else)
    @test current_action(case_system) == nothing
    " helper-funciton set_action_in!(System, action) "

    set_action_in!(case_system, :up)
    @assert current_state(case_system) == :s1
    @test step_system_mechanics!(case_system) == :s2
    set_action_in!(case_system, :down)
    @test step_system_mechanics!(case_system) == :s1
    set_action_in!(case_system, nothing)
    @test step_system_mechanics!(case_system) == :s1
    " System works as expected for actions :up and :down, and nothing "
end

@testset "Action space : configuable to be whatever" begin
    set_action_in! = Samsara.set_action_in!
    current_action = Samsara.current_action
    current_state = Samsara.current_state

    case = Samsara.CircularSys( nodes=(:s1, :s2, :s3), actions = (:auke, :minke, :drikke_kaffe) )
    @test case._all_actions == (:auke, :minke, :drikke_kaffe)
    " The action set, i.e. what represents the 3 actions [:up, :down, nothing] can be set by ctor arg "

    #too_few_actions = (:første, :andre)
    #@test_throws ArgumentError Samsara.CircularSys( nodes=(:s1, :s2, :s3), actions = too_few_actions)
    #too_many_actions = (:første, :andre, :a3, :4, :a5)
    #@test_throws ArgumentError Samsara.CircularSys( nodes=(:s1, :s2, :s3), actions = too_many_actions)
    " The set of actions have to be exactly 2: representing :up, :down, and :notning: "

    case = Samsara.CircularSys( nodes=(:s1, :s2, :s3), actions = ("auke", :minke, 42) )
    set_action_in!(case, "auke") 
    current_action(case) == "auke"
    @assert current_state(case) == :s1
    @test step_system_mechanics!(case) == :s2
    @assert current_state(case) == :s2
    set_action_in!(case, :minke) 
    @test step_system_mechanics!(case) == :s1
    set_action_in!(case, "Trallalalala, drikke kaffe!")  # (ikkje lista som gyldige actions)
    @test step_system_mechanics!(case) == :s1
    " Actions kan være kva faen det vil, så lenge det følger (opp, ned, ingenting)-konvensjonen ! "
end

end#module TEST_CIRULARSYS
