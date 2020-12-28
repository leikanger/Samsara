module TEST_SAMSARA
using Samsara, Test, Conception
using Printf

""" Setting up the test system: [Ω | a b c d e] , where | represents the gate. 
Activating [c] causes the gate to open. 
(e.g. going to SAT [Ω] from SAT [a] have to go via [c] (to open the gate ||) )
"""
function create_Ω_case()
    Conception.__purge_everything!!()

    the_muex = MuExS()
    first_link = LinkedCardinalNode(:Ω, in_MuEx=the_muex)
    linear_list = Samsara.linked_list_factory(5, in_MuExS=the_muex)
    # unlocking the gate by visiting [c]
    the_key = linear_list[3]
    Conception.set_connected_concept(the_key, SAT(:gate_open))
    # Connect the gate:
    the_gate = LinkedGate(first_link, conditional=SAT(:gate_open))
    Samsara._set_node_to_E!(first_link, the_gate)
    Samsara.gate_set_connected_node!(the_gate, linear_list[1])
    Samsara._set_node_to_W!(linear_list[1], the_gate)
    # Print
    println("Creating Ω test case: ", the_muex)
    return the_muex, the_gate, the_key
end

""" Convenience-function for testing the Ω case """
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

# # # # # # # # # TESTS # # # # # # # # # # 
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
    " Døme på korleis pådrag settes ved latent_variables: Ingen krav om at det er skalar heller! "

    """
        Vi kan lage simuleringer ved å definere system mechanics i funksjonen 
        Samsara.step_system_mechanics!(sys) -- som vidare åpner for multiple dispatch ved å 
        lage andre subtyper SystemX <: AbstractSystem, og bare definere 
        Sams.step_system_mechanics!(SysX) 

        Funksjonane kan vidare undersøke om event-SAT er aktiv:  BAM! gjennom:    
        HAL.still_active(SAT) 
    """
end#testset

@testset "Tests involving LinkedLists with LinkedGate" begin
    the_muex, the_gate, the_key = create_Ω_case()
    first_link = the_muex._elements[1]
    @test isa(first_link, SAT)
    
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

    activate!(first_link)
    deactivate!(SAT(:gate_open))
    number_of_nodes = traverse_MuExS(the_muex)
    @test number_of_nodes == 1

    activate!(the_key)
    @test is_active(the_key._node)
    @test is_active(the_key._node._connectedConcept)
    activate!(first_link)
    number_of_nodes = traverse_MuExS(the_muex)
    @test number_of_nodes == 6

    # We are at last link: gate closed.
    #   Traverse list east again, passing SAT(c) => linked with SAT(:gate_open) => opened gate!
    deactivate!(SAT(:gate_open)) # CLOSE GATE
    number_of_nodes = traverse_MuExS(the_muex, direction=:West)
    @test number_of_nodes == 6   # .. still, we get 6 : Explanation:
    @test is_active(SAT(:gate_open))
    #               #       # activating the_key, along the way, opens the gate before we reach it.
    """ Traversing back activates the key, opening the gate again before we reach it. """
end
""" Ω test works as planned: See create_Ω_case() in line 10
Ω-case:     [Ω | a b c d e] , where | represents the gate. 
The gate is initially locked, but can be opened by visiting [c]
Getting to [Ω] from [a] requires that we visit [c] first.
"""
    
    # PLAN
    # - kjør random walk. Test IV for SAT(a) mtp. Ω , når gate er åpen, når gate er stengd.
    #   -> Du kan tenke: SAT(:door_open) som satA, og satB, satA som events på veg mot satOmega: 
    #       (blir nesten som Q-learning! IV-learning med state-SAT som actions!)

end#module TEST_SAMSARA
