module TEST_SAMSARA
using Samsara, Test

@testset "system initiation" begin
    case = Samsara.System()
    @test isa(case, Samsara.AbstractSystem)

    @test isa(system_state(case), Tuple)

    # System state is nothing, since no system_dynamics was supplied in ctor 
    @test system_state(case) == (nothing, )
    @test dimentionality(case) == 0

    """ The way to define system mechnics is by multiple dispatch: Define system_mechanics! as function.
    It is important that the Samsara-function is written, not a local function here..
        -> redefine Samsara.step_system_mechanics!(arg::System)
    """
    # 1D system mechnics: Supplied λ-function returns a scalar.
    function Samsara.step_system_mechanics!(arg::Samsara.System)
        arg._observable_parameters = (1.0)
    end
    case_1D = Samsara.System()
    @test dimentionality(case_1D) == 1
    @test system_state(case_1D) == (1.0)

    # 2D system mechanics by sending in some 2D function:
    function Samsara.step_system_mechanics!(arg::Samsara.System)
        arg._observable_parameters = (1.0, 2.0)
    end
    case_2D = Samsara.System()  # dimentionality is defined by Samsara.step_system_mechanics!(System)
    @test dimentionality(case_2D) == 2
    @test system_state(case_2D) == (1.0, 2.0)
    
    # System mechanics med _latent_variables
    function Samsara.step_system_mechanics!(sys::Samsara.System)
        if ismissing(sys._latent_variables)
            sys._latent_variables = (1,1)
        end
        sys._observable_parameters = (55*sys._latent_variables[1], 123*sys._latent_variables[2])
    end
    case_2D = Samsara.System()
    @test system_state(case_2D) == (55, 123)
    @test case_2D._latent_variables == (1, 1)
    case_2D._latent_variables = (2, 2)
    @test system_state(case_2D) == (110, 246)

    # System function that takes input:    some_SAT_activation||
    some_SAT_activation = 0.0
    function Samsara.step_system_mechanics!(sys::Samsara.System)
        sys._latent_variables = some_SAT_activation
        if sys._latent_variables == 1.0
            sys._observable_parameters = (55)
        else
            sys._observable_parameters = (0.0)
        end
    end
    case = Samsara.System()
    @test system_state(case) == 0.0
    some_SAT_activation = 1.0
    @test system_state(case) == 55
    """
        Vi kan lage simuleringer ved å definere system mechanics i funksjonen 
        Samsara.step_system_mechanics!(sys) -- som vidare åpner for multiple dispatch ved å lage andre
        subtyper SystemX <: AbstractSystem, og bare definere Sams.step_system_mechanics!(SysX) !!!

        Funksjonane kan vidare undersøke om event-SAT er aktiv:  BAM! gjennom:    HAL.still_active(SAT) 
    """
end#testset

end#module TEST_SAMSARA
