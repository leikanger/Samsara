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
    """ after "activating" the gate, i.e. opening it, the gate is open """

    # When a gate:closed is activated, we "are" still at pre-node.
    # When a gate:open is activated, we move to post-node.
    # Conditionals define whether gate is open or closed.
    #   - Conditional is of type TemporalType (something that can be activated)
    #   - Considional can be set by a function
    #   - Conditional can be set by ctor.
    #   - Conditional 


end 

end # module
