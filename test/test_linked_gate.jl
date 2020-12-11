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

    Samsara.open_gate!(case)
    @test Samsara.gate_is_open(case) == true
    Samsara.open_gate!(case, false)
    @test Samsara.gate_is_open(case) == false
    Samsara.open_gate!(case, true)
    @test Samsara.gate_is_open(case) == true
    """ explicit opening and closing the gate """

    # When a gate:closed is activated, we "are" still at pre-node.
    # When a gate:open is activated, we move to post-node.
    #   => NOTE that pre-node and post-node changes: update this to be nodeL and nodeR instead.. 
    #   - when in n1, activate! causes n2
    #   - when in n2, activate! causes n1
    # Conditionals define whether gate is open or closed.
    #   - Conditional is of type TemporalType (something that can be activated)
    #   - Considional can be set by a function
    #   - Conditional can be set by ctor.
    #   - Conditional 


end 

end # module
