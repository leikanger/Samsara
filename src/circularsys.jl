using Samsara

mutable struct CircularSys <: Samsara.AbstractSystem
    _all_nodes
    _current_index::Int
    _latent_variables
    function CircularSys(nodes =[:A, :B, :C])
        _all_nodes = nodes
        retval = new(_all_nodes, 1, nothing)
        step_system_mechanics!(retval)
        return retval
    end
end

"""
system_state(sys::CircularSys) 
returnerer full system state for CircularSys -- a Tuple of observable_param 
"""
function system_state(sys::CircularSys)
    (sys._all_nodes[sys._current_index], )
end

""" 
current_state(sys::CircularSys)
Returns the current state, where we are currently located, only.
"""
current_state(sys::CircularSys) = sys._all_nodes[current_index(sys)]
current_index(sys::CircularSys) = sys._current_index
current_action(sys::CircularSys)= sys._latent_variables
function set_action_in(sys::CircularSys, action)
    if action in [:up, :down]
        sys._latent_variables = action
    else
        sys._latent_variables = nothing
        throw(ArgumentError("trying to do illegal action for CircularSys"))
    end
end

" Dispatch Base.length for this struct: "
function Base.length(sys::CircularSys)
    length(sys._all_nodes)
end

""" 
function step_up!(sys::CircularSys)
Step one up. 
Return next, i.e. index of stepping one step "up".
When at max-position, go around to beginning 
"""
function _step_up!(sys::CircularSys)
    sys._current_index == length(sys) && (return sys._current_index = 1)
    sys._current_index+=1
end

""" 
function step_down!(sys::CircularSys)
Step one down. 
Return next index, i.e. index of stepping one step "down"
When at min-position, go around to the end
"""
function _step_down!(sys::CircularSys)
    sys._current_index == 1 && (return sys._current_index = length(sys))
    sys._current_index-=1
end

""" ======== Definerer system mechanics ===========
Gjennom function step_system_mechanics!(CircularSys) 
kan vi definere korleis systemet funker.
"""
function step_system_mechanics!(sys::CircularSys)
    next_action = sys._latent_variables
    next_action == :up   && (_step_up!(sys))
    next_action == :down && (_step_down!(sys))
    #:else:              && *stay where you are*
         
    current_state(sys)
end
