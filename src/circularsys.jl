using Samsara

"""
mutable struct CircularSys <: AbstractSystem
This system is an implementation of circular double linked list,
where one can step both up and down: 
Deterministic transmission :up => +1 and :down => -1

Constructor takes argument of type: Tuple{Any}, writing to _all_nodes::Tuple
Private functions _step_up! and _step_down! are used by step_system_mechanics!(CircularSys)
"""
mutable struct CircularSys <: Samsara.AbstractSystem
    _all_nodes
    _current_index::Int
    _all_actions      # key => value     value is [:up, :down, :nothing]
    _latent_variables
    function CircularSys(;nodes =(:A, :B, :C), actions = (:up, :down, nothing) )
        _all_nodes = nodes
        if length(actions) != 3
            throw(ArgumentError("Wrong number of actions: 3 actions are required for CircularSys, "*
                                "in an order representing the following:   :up, :down, :no-op"))
        end
        retval = new(_all_nodes, 1, actions, nothing)
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
    if action in sys._all_actions
        sys._latent_variables = action
    else
        sys._latent_variables = nothing
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
    next_action == sys._all_actions[1] && (_step_up!(sys))
    next_action == sys._all_actions[2] && (_step_down!(sys))
    #:else:              && *stay where you are*
         
    current_state(sys)
end
