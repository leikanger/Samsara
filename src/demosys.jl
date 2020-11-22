using .Samsara

#===========================================================================#
# Etabler eit DemoSys : Demonstrasjon om korleis eit Env-system kan lages:
# - subtype AbstractSystem
# - Definer step_system_mechanics!(arg::NY_TYPE)
# Når du seinare skal gjøre det samme, kan dette defineres i ei eiga fil,
# som includeres i prosjektet ditt
#
# Merk at tester for DemoSys er å finne i test_Samsara
#===========================================================================#
mutable struct DemoSys <: AbstractSystem
    _observable_parameters
    _latent_variables
    function DemoSys(observable_param =(1,) , latent_param =nothing)
        latent_param == nothing && (latent_param = 10)
        # Lag eit tomt struct, oppdater med simulation-function (som er overskrevet fra utsida, 
        #   og definerer system mechanics), og returner oppdatert struct retval.
        new( observable_param, latent_param )
    end
end

""" Dette er måten man definerer system mechanics: Man definerer step_system_mechanics!(arg)
der arg er av type som definerer kva system det er snakk om. DemoSys har tidsdynamikk som øker
lineært for sys._observable_parameters og minker for sys._latent_variables
ARG: sys: stuct med info nok for å tilfredstille Markov property.
RETURN: sys._observable_param -- observerbar state.
"""
function step_system_mechanics!(arg::DemoSys)
    arg._observable_parameters = arg._observable_parameters .+ arg._latent_variables
    arg._latent_variables -= 1
    return arg._observable_parameters
end

function set_action_in!(sys::DemoSys, action)
    @warn "not implemented in DemoSys"
end
