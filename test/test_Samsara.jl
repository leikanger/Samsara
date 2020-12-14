module TEST_SAMSARA
using Samsara, Test, Conception
using Printf

@testset "system initiation" begin
    DemoSys = Samsara.DemoSys

    case = DemoSys()
    @test isa(case, Samsara.AbstractSystem)

    @test isa(system_state(case), Tuple)

    case = DemoSys((1), 1)
    @test system_state(case) == (1)
    @test dimensionality(case) == 1
    " Observable state is defined by argument: In DemoSys, this is of type Tuple "
    
    case = DemoSys((1,1), 3)
    @test system_state(case) == (1, 1)
    @test dimensionality(case) == 2
    """
    Create a struct of type DemoSys, with observable_param = (1,1) and latent_param = 3:
        - system_state(case) = (observable_param)
        - dimentionality(case) = length(observable_param)
    """

    step_system_mechanics!(case) # update
    @test system_state(case) == (4, 4)
    step_system_mechanics!(case) # update
    @test system_state(case) == (6, 6)
    """
    DemoSys have defined system mechanics in step_system_mechanics!(DemoSys) 
        --> other systems can be created by inheriting AbstractSystem and by 
        multiple dispatch of function step_system_mechanics!
    """

    function Samsara.step_system_mechanics!(arg::DemoSys)
        arg._observable_parameters = (0)
    end
    Samsara.step_system_mechanics!(case) # update
    @test dimensionality(case) == 1
    " It is possible to redefine system mechanics, although this is discouraged.. "

    case = DemoSys( (10.0, 10.0), (0.0, 0.0) )
    function Samsara.step_system_mechanics!(arg::DemoSys)
        arg._observable_parameters = arg._observable_parameters .+ arg._latent_variables
    end
    Samsara.step_system_mechanics!(case) # update
    @test system_state(case) == (10.0, 10.0)
    case._latent_variables = (1.0, -5.0)
    Samsara.step_system_mechanics!(case) # update
    @test system_state(case) == (11.0, 5.0)
    " Døme på korleis pådrag kan settes ved latent_variables: Ingen krav om at det er skalar heller! "



    """
        Vi kan lage simuleringer ved å definere system mechanics i funksjonen 
        Samsara.step_system_mechanics!(sys) -- som vidare åpner for multiple dispatch ved å lage andre
        subtyper SystemX <: AbstractSystem, og bare definere Sams.step_system_mechanics!(SysX) !!!

        Funksjonane kan vidare undersøke om event-SAT er aktiv:  BAM! gjennom:    HAL.still_active(SAT) 
    """
end#testset

function traverse_MuExS(the_muex::Conception.MuExS; direction =:East)
    the_item = Conception.the_active_event_of(the_muex)
    number_of_nodes = 0
    while !isnothing(the_item) 
        number_of_nodes+=1
        last_item = the_item
        direction == :West && activate!(Samsara.west_of(the_item))
        direction == :East && activate!(Samsara.east_of(the_item))
        if last_item == (the_item = Conception.the_active_event_of(the_muex))
            break
        end
    end
    return number_of_nodes
end

""" Setting up the test system: [Ω | a b c d e] , where | represents the gate. 
Activating [c] causes the gate to open. 
"""
function create_Ω_case()
    Conception.__purge_everything!!()

    the_muex = MuExS()
    first_link = LinkedCardinalNode(:Ω, in_MuEx=the_muex)
    linear_list = Samsara.linked_list_factory(5, in_MuExS=the_muex)
    # unlocking the gate by visiting [c]
    Conception.set_connected_concept(linear_list[3]._node, SAT(:gate_open))
    # Connect the gate:
    the_gate = LinkedGate(first_link, conditional=SAT(:gate_open))
    Samsara._set_node_to_E!(first_link, the_gate)
    Samsara.gate_set_connected_node!(the_gate, linear_list[1])
    Samsara._set_node_to_W!(linear_list[1], the_gate)
    # Print
    println("Creating Ω test case: ", the_muex)
    return the_muex, the_gate
end


@testset "Tests involving LinkedLists with LinkedGate" begin
    the_muex, the_gate = create_Ω_case()
    first_link = the_muex._elements[1]

    activate!(first_link)
    Samsara.open_gate!(the_gate, false)
    number_of_nodes = traverse_MuExS(the_muex)
    @test number_of_nodes == 1
    """ Gate:CLOSED -- iteration through the goes through all elements BEFORE gate. """

    activate!(first_link)
    activate!(SAT(:gate_open))
    number_of_nodes = traverse_MuExS(the_muex)
    @test number_of_nodes == 6
    """ Gate:OPEN -- iteration through the goes through all elements gate. """

    # We are at last link: Traverse back, but to a closed gate:
    deactivate!(SAT(:gate_open))
    # Samsara.open_gate!(the_gate, false)  // dette er effekta av forrige statement
    number_of_nodes = traverse_MuExS(the_muex, direction=:West)
    @test number_of_nodes == 5
    """ Gate:CLOSED -- Traverse back (to the gate). """

    # Traverse list east again, passing SAT(c) => linked with SAT(:gate_open) => opened gate!
    #traverse_MuExS(the_muex, direction=:East)
    #@test is_active(SAT(:gate_open))
    
    # PLAN
    # - kjør random walk. Test IV for SAT(a) mtp. Ω , når gate er åpen, når gate er stengd.
    #   -> Du kan tenke: SAT(:door_open) som satA, og satB, satA som events på veg mot satOmega: 
    #       (blir nesten som Q-learning! IV-learning med state-SAT som actions!)
end

end#module TEST_SAMSARA
