`include "environment.sv"

program testbench( intf i_intf );

/*
This testcase aims to validate a mid-operation asynchronous reset signal. A reset
signal will be asserted some time after the dut has already begin normal operation
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

	// enable the dut bugs
	// $root.tbench_top.dut.dut_core.enable_dut_bugs(11216033);

	// instantiate environment object
	env = new( i_intf, test_pkt_count, verbose );

	fork
		// run the environment
		env.run();
	join
end

task force_reset;
test_scb_error_override = 1;
#250 	$root.tbench_top.reset <= 1'b1;	// force reset high to test dut's response
#50		$root.tbench_top.reset <= 1'b0;	// force reset low to test dut's ability to continue
#10		test_scb_error_override = 0;
endtask : force_reset


final
	$display("*************** End of testbench ***************");

endprogram
