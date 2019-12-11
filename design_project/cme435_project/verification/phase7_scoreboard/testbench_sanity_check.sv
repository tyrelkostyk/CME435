`include "environment.sv"

program testbench( intf i_intf );

// ************************* INSTANTIATIONS ************************* //

// declaring environment class object instance
environment env;


// *********************** EVENTS AND INTEGERS ********************** //

int test_pkt_count = 25;	// how many packets to generate and send
int test_scb_error_override = 0;	// 1 = ignore scb error counter (for directed testing)


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

initial begin
	$display("*************** Start of testbench ***************");

	// instantiate environment object
	env = new( i_intf );

	// global envs go here
	env.gen.pkt_count = test_pkt_count;		// how many packets to generate and send

	// run the environment
	env.run();
end


final
	$display("*************** End of testbench ***************");

endprogram
