"""
Module Samsara: 
-> The world for the agent: Day-to-day details and immediate focus of the agent 
    -- The environment HUGIN is operating in Samsara: World mechanism!
"""
module Samsara

abstract type AbstractSystem end

struct MockSystem <: AbstractSystem
    _system_state
    function MockSystem(system_parameters=())
        new(system_parameters)
    end
end

#### Functions ###
function dimentionality(sys::AbstractSystem)
    length(sys._system_state)
end


export dimentionality           #EXPORT
end # module
