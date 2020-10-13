"""
Module Samsara: 
-> The world for the agent: Day-to-day details and immediate focus of the agent 
    -- The environment HUGIN is operating in Samsara: World mechanism!
"""
module Samsara

abstract type AbstractSystem end

struct System <: AbstractSystem
    _system_dynamics_callback
    _observable_parameters
    function System(;system_dynamics=()->(nothing, ))
        new(system_dynamics, system_dynamics())
    end
end

#### Functions ###
" system_state(sys::AbstractSystem) returns system state of sys "
function system_state(sys::AbstractSystem)
    sys._observable_parameters
end

" dimentionality(sys::AbstractSystem) returns dimentionality "
function dimentionality(sys::AbstractSystem)
    if isnothing(system_state(sys)[1]) 
        return 0
    else
        length(system_state(sys))
    end
end

""" _update_system_simulation(sys::AbstractSystem)
Update _observable_parameters from _system_dynamics_callback.
"""
function _update_system_simulation!(sys::AbstractSystem)
    _observable_parameters = sys._system_dynamics_callback()
end

# PLAN
# - Etter kvart step, oppdateres _observable_parameters. 
#       step(sys, event) => simuler, så skriv til _observable_parameters inne i step
# - _observable_parameters kan hentes ut ved observe(AbstractSystem)
# - 


export dimentionality, system_state           #EXPORT
end # module
