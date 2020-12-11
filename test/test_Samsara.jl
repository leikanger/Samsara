module TEST_SAMSARA
using Samsara, Test, Conception

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

@testset "Tests involving LinkedLists with LinkedGate" begin
    the_muex = MuExS()
    LinkedCardinalNode(:Ω, in_MuEx=the_muex)
    # TODO Make it possible to create LinkedGate ctor without end-nodes (and then add end-nodes after..)
    # Default end-node if arg=nothing?
    # TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO 
    LinkedGate(id=:door, in_MuExS=the_muex)
    linear_list = Samsara.linked_list_factory(5, in_MuExS=the_muex)
    @show the_muex
end

end#module TEST_SAMSARA
