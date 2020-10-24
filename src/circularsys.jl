using Samsara

mutable struct CircularSys <: Samsara.AbstractSystem
    _all_nodes
    _current_index::Int
    function CircularSys(nodes =[:A, :B, :C])
        _all_nodes = nodes
        new(_all_nodes, 1)
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

