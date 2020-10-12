"""
Module Samsara: 
-> The world for the agent: Day-to-day details and immediate focus of the agent 
    -- The environment HUGIN is operating in Samsara: World mechanism!
"""
module Samsara

abstract type AbstractSystem end

struct MockSystem <: AbstractSystem
    _system_dynamics_callback
    _system_parameters
    function MockSystem(;system_dynamics=()->(nothing, ))
        new(system_dynamics, system_dynamics())
    end
end

#### Functions ###
" system_state(sys::AbstractSystem) returns system state of sys "
function system_state(sys::AbstractSystem)
    sys._system_parameters
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
Update _system_parameters from _system_dynamics_callback.
"""
function _update_system_simulation!(sys::AbstractSystem)
    _system_parameters = sys._system_dynamics_callback()
end

# PLAN
# - Etter kvart step, oppdateres _system_parameters. 
#       step(sys, event) => simuler, så skriv til _system_parameters inne i step
# - _system_parameters kan hentes ut ved observe(AbstractSystem)
# - 


export dimentionality, system_state           #EXPORT
end # module
