module TEST_LINKED_GATE
using Samsara, Conception, Test


@testset "LinkedGate" begin
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


    # Conditionals define whether gate is open or closed.
    #   - Conditional is of type TemporalType (something that can be activated)
    #   - Considional can be set by a function
    #   - Conditional can be set by ctor.
    #   - Conditional 
end


end # module
