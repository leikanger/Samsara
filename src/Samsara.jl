"""
Module Samsara: 
-> The world for the agent: Day-to-day details and immediate focus of the agent 
    -- The environment HUGIN is operating in Samsara: World mechanism!

Currently, this is a simple framework for how mechanics can be simulated:
    System mechanics is simulated by the function step_system_mechanics!(sys) som 
    skriver til state (_observable_parameters or _latent_variables) til struct [sys]
    -> (1) Du kan overskrive step_system_mechanics! fra utsida: 
    Dette er måten å lage ulike simuleringer.
    -> (2) Ved å deklarere fleire mutable struct SystemX <: AbstractSystem ∀ X,
    kan man også definere ulike system dynamikker ved overnevnte funksjon: step_system_mechanics(sys)
    -> (3) Struct har _observable_parameters og _latent_variables.
    Begge er tilgjengelig for ovenenvte funksjon!

    BAM! Skitbra!
"""
module Samsara

abstract type AbstractSystem end

#### Functions ###
" system_state(sys::AbstractSystem) returns system state of sys "
function system_state(sys::AbstractSystem)
    sys._observable_parameters  # return
end

" dimentionality(sys::AbstractSystem) returns dimentionality "
function dimensionality(sys::AbstractSystem)
    if isnothing(system_state(sys)[1]) # Ta bort?
        return 0
    else
        length(system_state(sys))
    end
end


#===========================================================================#
# Når man definerer eit nytt system, i ei anna fil, må denne koden takast
# inn i modulen i tekstform.
# -> No tar eg den med i module Samsara, siden denne skal brukes til TDD,
# men seinare kan du gjøre dette samme for nye system, lokalt i prosjektet.
# (include med local path, men siden den arver fra AbstractSystem, kan alt
# av Samsara's funksjoner brukes på den)
#===========================================================================#
include("circularsys.jl")
#===========================================================================#


"""
#===========================================================================#
# Etabler eit DemoSys : Demonstrasjon om korleis eit Env-system kan lages:
# - subtype AbstractSystem
# - Definer step_system_mechanics!(arg::NY_TYPE)
# Når du seinare skal gjøre det samme, kan dette defineres i ei eiga fil,
# som includeres i prosjektet ditt
#===========================================================================#
"""
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


export AbstractSystem, dimensionality, system_state, step_system_mechanics!           #EXPORT
end # module
