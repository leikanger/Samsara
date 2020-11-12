using Samsara, Conception

muex = MuExS()
all_actions=(SAT(:_up__), SAT(:down_), SAT(:noop_)) #, SAT(:reset))
all_nodes  = (SAT(:a, inMuExS=muex),
              SAT(:b, inMuExS=muex),
              SAT(:c, inMuExS=muex),
              SAT(:d, inMuExS=muex),
              SAT(:E, inMuExS=muex),
              SAT(:f, inMuExS=muex),
              SAT(:g, inMuExS=muex),
              SAT(:h, inMuExS=muex),
              SAT(:i, inMuExS=muex),
              #SAT(:j, inMuExS=muex),
              #SAT(:k, inMuExS=muex)
              )
case = Samsara.CircularSys(nodes= all_nodes, actions=all_actions )

function demo(N::Int)
    @assert N>0
    global all_actions
    for i in 1:N
        next_action = rand(all_actions)
        Samsara.set_action_in!(case, next_action )
        step_system_mechanics!(case)
    end
end

function run(N::Int)
    demo(N)

    show_links_to(SAT(:E))
end

function show_links_to(to_node::SAT)
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

println("\n************************ 100 ****************************")
run(100)
println("\n************************ 20.000 *************************")
run(20000)
println("\n************************ 500.000 *************************")
run(500000)
