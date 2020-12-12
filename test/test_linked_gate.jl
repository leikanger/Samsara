module TEST_LINKED_GATE
using Samsara, Conception, Test


@testset "LinkedGate construction -- with end-nodes" begin
    n1, n2 = SAT(:preNode), SAT(:postNode)
    case = LinkedGate(n1, n2)

    @test isa(LinkedGate(n1, n2), Conception.AbstractConcept)
    """ Definere plass for LinkedGate mtp. typehierarki """

    @test case.pre_node == n1
    @test case.post_node == n2
    """ We can create a linked gate with pre-node and post-node by ctor """

    @test Samsara.gate_is_open(case) == false 
    """ default value for a gate is 'closed' """
end

@testset "LinkedGate with only one side -- empty end-node" begin
    fromSAT = SAT(:from)
    case = LinkedGate(fromSAT)
    @test case.pre_node == fromSAT
    @test isnothing(case.post_node)
    " gate can also be contructed with only one side defined "

    Samsara.gate_set_connected_node!(case, SAT(:to))
    @test case.post_node == SAT(:to)
    " We can set post-node by gate_set_connected_node!(gate, node) "

    @test_throws ArgumentError Samsara.gate_set_connected_node!(case, SAT(:whatever))  
    " Cannot reset an allready set gate.. "

    Samsara.gate_set_connected_node!(case, nothing)
    @test isnothing(case.post_node)
    " ... unless we set it to nothing "

end

@testset "LinkedGate function: Opening, closing, activating, etc" begin
    Conception.__purge_everything!!()

    the_muex= MuExS()
    n1 = SAT(:preNode, inMuExS=the_muex)
    n2 = SAT(:postNode, inMuExS=the_muex)
    activate!(n1)
    @assert Conception.the_active_event_of(the_muex) == n1
    case = LinkedGate(n1, n2)
    """ Setting up the situation: 
    - Gate n1 ⟶ n2      (n1 and n2 are MuExS)
    - We're in n1, before the gate. 
    """

    Samsara.open_gate!(case)
    @test Samsara.gate_is_open(case) == true
    Samsara.open_gate!(case, false)
    @test Samsara.gate_is_open(case) == false
    Samsara.open_gate!(case, true)
    @test Samsara.gate_is_open(case) == true
    """ explicit opening and closing the gate """

    Samsara.open_gate!(case, true)
    activate!(case)
    @test Conception.the_active_event_of(the_muex) == n2
    activate!(case)
    @test Conception.the_active_event_of(the_muex) == n1
    activate!(case)
    activate!(case)
    @test Conception.the_active_event_of(the_muex) == n1
    """ activate OPEN gate => move throught it """

    oneSidedCase = LinkedGate(n1)
    Samsara.open_gate!(oneSidedCase)
    @assert is_active(n1)
    activate!(oneSidedCase)
    @test is_active(n1)
    """ One-sided case (with nodeB = nothing) does not transfer to 'other side': All ok """
    
    Samsara.open_gate!(case, false)
    @assert Conception.the_active_event_of(the_muex) == n1
    activate!(case)
    @test Conception.the_active_event_of(the_muex) == n1
    """ activate CLOSED gate => nothing happens """
end 

@testset "LinkedGate that is gated by an AbstractConcept activation" begin
    Conception.__purge_everything!!()
    the_muex= MuExS()
    n1 = SAT(:preNode, inMuExS=the_muex)
    n2 = SAT(:postNode, inMuExS=the_muex)
    activate!(n1)
    @assert Conception.the_active_event_of(the_muex) == n1
    some_SAT = SAT(:conditional_SAT)
    case = LinkedGate(n1, n2, conditional=some_SAT)
    @test case._conditioned_on_trait == some_SAT
    """ Setting up the situation: 
    - Gate n1 ⟶ n2 | cSAT     (n1 and n2 are MuExS, cSAT is not.)
    - We're in n1, before the gate. 
    """

    case = LinkedGate(n1, n2, conditional=SAT(:some_condition))
    @test Samsara.gate_is_closed(case)
    activate!(SAT(:some_condition))
    @test Samsara.gate_is_open(case)
    deactivate!(SAT(:some_condition))
    @test Samsara.gate_is_closed(case)
    """ The gate can be conditioned on some external trait: some SAT from ctor ~10 lines up 
    When the gated SAT --SAT(:some_condition) in the example-- is active, gate is open 
    """
end


end # module
