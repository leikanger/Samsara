"""
Module Samsara: 
-> The world for the agent: Day-to-day details and immediate focus of the agent 
    -- The environment HUGIN is operating in Samsara: World mechanism!

System mechanics is simulated by the function step_simulation!(sys) som skriver til state til struct sys.
    (1) Det er mulig å overskrive step_system_mechanics! fra utsida: 
    Dette er måten å lage ulike simuleringer.
    (2) System har state gjennom _observable_parameters og _latent_variables.
    Begge er tilgjengelig for ovenenvte funksjon!
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
