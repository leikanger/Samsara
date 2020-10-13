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
    
    # 3D function that takes action: :1, :2, :3
    function some_2D_function()
        # Vi trenger _latent_parameters som kan brukes for å lagre ikkje-observerbare parametre: Desse kan brukes når man aktiverer SAT? action :1 aktiverer SAT(:1) -- gjennom latent param.?? 
        # TODO Tenke litt her!
    end

    # TODO Send inn action!
end



end#module TEST_SAMSARA
