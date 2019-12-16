`include "environment.sv"

program testbench( intf i_intf );

/*
This sanity check testcase checks for all the normal funcions of the DUT. It
confirms that an initial reset works, and that the input and output protocols work
as expected within the nominal conditions.
*/

// ************************* INSTANTIATIONS ************************* //

// declaring environment class object instance
environment env;


// *********************** EVENTS AND INTEGERS ********************** //

int verbose = 0;	// whether to print lots of debug statements or minimal
int test_pkt_count = 50;	// how many packets to generate and send
int test_scb_error_override = 0;	// 1 = ignore scb error counter (for directed testing)


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

initial begin
	$display("*************** Start of testbench ***************");

	// enable the dut bugs
	// $root.tbench_top.dut.dut_core.enable_dut_bugs(11216033);

	// instantiate environment object
	env = new( i_intf, test_pkt_count, verbose );

	// run the environment
	env.run();
end


final
	$display("*************** End of testbench ***************");

endprogram
