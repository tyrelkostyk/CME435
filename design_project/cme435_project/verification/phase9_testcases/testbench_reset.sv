`include "environment.sv"

program testbench( intf i_intf );

/*
*/

// ************************* INSTANTIATIONS ************************* //

// declaring environment class object instance
environment env;


// *********************** EVENTS AND INTEGERS ********************** //

int verbose = 0;	// whether to print lots of debug statements or minimal
int test_pkt_count = 5000;	// how many packets to generate and send
int test_scb_error_override = 0;	// 1 = ignore scb error counter (for directed testing)


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

initial begin
	$display("*************** Start of testbench ***************");

	// instantiate environment object
	env = new( i_intf, test_pkt_count, verbose );

	// run the environment
	env.run();
end


final
	$display("*************** End of testbench ***************");

endprogram
