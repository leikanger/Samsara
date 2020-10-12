module TEST_SAMSARA
using Samsara, Test

@testset "system initiation" begin
    case = Samsara.System()
    @test isa(case, Samsara.AbstractSystem)

    @test isa(system_state(case), Tuple)

    # System state is nothing, since no system_dynamics was supplied in ctor 
    @test system_state(case) == (nothing, )
    @test dimentionality(case) == 0

    # 1D system mechnics: Supplied λ-function returns a scalar.
    case_1D = Samsara.System(system_dynamics=()->(1.0))
    @test dimentionality(case_1D) == 1
    Samsara._update_system_simulation!(case_1D)
    @test system_state(case_1D) == (1.0)

    # 2D system mechanics by sending in some 2D function:
    function some_2D_function()
        return (1.0, 2.0)
    end
    case_2D = Samsara.System(system_dynamics=some_2D_function)
    @test dimentionality(case_2D) == 2
    Samsara._update_system_simulation!(case_2D)
    @test system_state(case_2D) == (1.0, 2.0)
    
    # 3D function that takes action: :1, :2, :3
    function some_2D_function()
        # Vi trenger _latent_parameters som kan brukes for å lagre ikkje-observerbare parametre: Desse kan brukes når man aktiverer SAT? action :1 aktiverer SAT(:1) ?? 
        # TODO Tenke litt her!
    end

    # TODO Send inn action!
end



end#module TEST_SAMSARA
