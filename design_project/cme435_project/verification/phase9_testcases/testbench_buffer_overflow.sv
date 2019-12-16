`include "environment.sv"

program testbench( intf i_intf );

/*
This testcase tests the scenario where every port is stuck outputing to the same
port every cycle, and the data sizes are the max size. This tests for any possible
buffer overflow.
*/

// ************************* INSTANTIATIONS ************************* //

// declaring extended transaction classes for directed testing
class TransBuffer extends TransBase;
constraint dest_addr_fixed {
  addr_in[31:24] inside {3};
  addr_in[23:16] inside {2};
  addr_in[15:8] inside {1};
  addr_in[7:0] inside {0};
}

constraint data_in_fixed {
  data_in[31:24] inside {[250:255]};
  data_in[23:16] inside {[250:255]};
  data_in[15:8] inside {[250:255]};
  data_in[7:0] inside {[250:255]};
}
endclass


// declaring environment class object instance
environment #( .T(TransBuffer) ) env;


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
