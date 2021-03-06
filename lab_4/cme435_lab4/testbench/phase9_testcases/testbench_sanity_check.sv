`include "testbench/phase2_environment/environment.sv"

program testbench_sanity_check( intf i_intf );

// ************************* INSTANTIATIONS ************************* //

// declaring environment class object instance
environment env;


// *********************** EVENTS AND INTEGERS ********************** //

int test_pkt_count = 5000;					// how many packets to generate and send
int test_scb_error_override = 0;	// 1 == ignore scb error counter (for manual testing)


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

initial begin
	// instantiate environment object
	env = new( i_intf );
	$display("*************** Start of testbench ***************");

	// global envs go here
	env.gen.pkt_count = test_pkt_count;		// how many packets to generate and send
	env.scb.scb_error_override = test_scb_error_override;

	env.run();
end


final
	$display("*************** End of testbench ***************");

endprogram
