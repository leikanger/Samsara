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


include("demosys.jl")
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

export Samsara, AbstractSystem, dimensionality, system_state, step_system_mechanics!, set_action_in!           #EXPORT
#export EuclideanNode

include("linked_node.jl")
export LinkedCardinalNode

include("linked_gate.jl")
export LinkedGate

end # module
