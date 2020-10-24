using Samsara

mutable struct CircularSys <: Samsara.AbstractSystem
    _all_nodes
    _current_index::Int
    function CircularSys(number_of_nodes =3)
        _all_nodes = zeros(number_of_nodes)
        new(_all_nodes, 1)
    end
end

function system_state(sys::CircularSys)
    [sys._current_index]
end
current_index(sys::CircularSys) = system_state(sys)[1]

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
function step_up!(sys::CircularSys)
    sys._current_index == length(sys) && (return sys._current_index = 1)
    sys._current_index+=1
end

""" 
function step_down!(sys::CircularSys)
Step one down. 
Return next index, i.e. index of stepping one step "down"
When at min-position, go around to the end
"""
function step_down!(sys::CircularSys)
    sys._current_index == 1 && (return sys._current_index = length(sys))
    sys._current_index-=1
end

