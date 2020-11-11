using Samsara, Conception

muex = MuExS()
all_actions=(SAT(:up), SAT(:down), SAT(:noop))
case = Samsara.CircularSys(nodes=(SAT(:a, inMuExS=muex), 
                                  SAT(:b, inMuExS=muex), 
                                  SAT(:c, inMuExS=muex)),
                           actions=all_actions )
activate!(it::SAT) = Conception.activate!(it)
@show case

function demo()
    global all_actions
    for i in 1:700
        set_action_in(case, rand(all_actions) )
        step_system_mechanics!(case)
    end
end




function run()

    demo()

    for it in SAT(:a)._incoming_asscon
        @show it
    end
end

run()
