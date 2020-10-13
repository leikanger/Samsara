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

mutable struct System <: AbstractSystem
    _observable_parameters
    _latent_variables
    function System()
        # Lag eit tomt struct, oppdater med simulation-function (som er overskrevet fra utsida, 
        #   og definerer system mechanics), og returner oppdatert struct retval.
        retval = new( missing, missing )  # oppdatern i neste linje:

        step_system_mechanics!(retval)  #nothing blir overskrevet.
        retval
    end
end

step_system_mechanics! = (arg::System) -> arg._observable_parameters = (nothing, )

#### Functions ###
" system_state(sys::AbstractSystem) returns system state of sys "
function system_state(sys::AbstractSystem)
    step_system_mechanics!(sys) # update
    sys._observable_parameters  # return
end

" dimentionality(sys::AbstractSystem) returns dimentionality "
function dimentionality(sys::AbstractSystem)
    if isnothing(system_state(sys)[1]) 
        return 0
    else
        length(system_state(sys))
    end
end

# PLAN
# - Etter kvart step, oppdateres _observable_parameters. 
#       step(sys, event) => simuler, så skriv til _observable_parameters inne i step
# - _observable_parameters kan hentes ut ved observe(AbstractSystem)
# - 


export dimentionality, system_state           #EXPORT
end # module
