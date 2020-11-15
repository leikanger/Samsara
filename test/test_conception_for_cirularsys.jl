using Samsara, Conception
using Printf

function run(N::Int; number_of_nodes = nothing)
    case = init(number_of_nodes)
    demo(N, case)

    println("\n\n\n")
    all_data = []
    for it in case._all_nodes
        println("____________"*string(it)*"_____________________________________________")
        show_links_to(it, case)
        push!(all_data, get_maxvalue_histogram_to(case._all_nodes, it))
    end
    all_data
end

function demo(N::Int, case)
    @assert N>0
    all_actions = case._all_actions
    all_nodes = case._all_nodes
    for i in 1:N
        next_action = rand(all_actions)
        Samsara.set_action_in!(case, next_action)
        step_system_mechanics!(case)
    end
end

function init(theN =nothing)
    muex = MuExS()
    all_actions=(SAT(:_up__), SAT(:down_), SAT(:noop_)) #, SAT(:reset))
    all_nodes = SAT[]
    if isnothing(theN)
        all_nodes  = [ SAT(:a, inMuExS=muex),
                       SAT(:b, inMuExS=muex),
                       SAT(:c, inMuExS=muex),
                       SAT(:d, inMuExS=muex),
                       SAT(:e, inMuExS=muex),
                       SAT(:f, inMuExS=muex),
                       SAT(:g, inMuExS=muex),
                       SAT(:h, inMuExS=muex),
                       SAT(:i, inMuExS=muex),
                     ]
    elseif isa(theN, Int)
        for i in 1:theN
            theName = @sprintf("node_%2d",i-1)
            theSAT = SAT(theName, inMuExS=muex)
            push!(all_nodes, theSAT)
        end
        for it in all_nodes
            @show it
        end
    else
        throw(ArgumentError("Wrong argument to init(theN)"))
    end
    case = Samsara.CircularSys(nodes= all_nodes, actions=all_actions )
end






function show_links_to(to_node::SAT, in_environment::Samsara.AbstractSystem)
    all_nodes = in_environment._all_nodes

    lista = sort(to_node._incoming_asscon, rev=true)
    for node in all_nodes
        println("__________________"*string(node)*" ⟶ "*string(to_node)*"__________________")
        show_all_elem_of(lista, node)
    end
end

function show_all_elem_of(lista::Vector, element)
    for it in lista
        (it.nodeL == element) && @show it
    end
end

# lag en maksvektor:
function get_maxvalue_histogram_to(node_lista::Vector, to_node::SAT)
    histrogram = Union{Missing, Float64}[]
    for it in node_lista
        push!(histrogram, get_maxvalue_from(to_node._incoming_asscon, it))
    end
    histrogram
end
function get_maxvalue_from(lista::Vector, node::SAT)
    all_elements = []
    for it in lista
        (it.nodeL == node) && push!(all_elements, association(it))
    end
    sort!(all_elements)
    
    if length(all_elements) > 0
    @show all_elements
        return all_elements[end]
    else
        return missing
    end
end


println("\n************************ 100 ****************************")
run(100)
println("\n************************ 20.000 *************************")
data20K = run(20000, number_of_nodes=100)
#println("\n************************ 500.000 *************************")
#@show data100K = run(100000)
