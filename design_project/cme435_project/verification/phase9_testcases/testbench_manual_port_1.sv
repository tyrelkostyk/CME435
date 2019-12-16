`include "environment.sv"

program testbench( intf i_intf );

/*
This testcase tests the DUT's ability to only accept data on only 1 of the 4 ports
available to it, and thus only driving output data from port 1. In this case, we
force the textbench to only validate the data going into port 1.
*/

// ************************* INSTANTIATIONS ************************* //

class TransPort_1 extends TransBase;

constraint port_2_c {
	valid_in[3:0] inside {2,3,6,7,10,11,14,15};
}

endclass


// declaring environment class object instance
environment #( .T(TransPort_1) ) env;


// *********************** EVENTS AND INTEGERS ********************** //

int verbose = 0;	// whether to print lots of debug statements or minimal
int test_pkt_count = 5000;	// how many packets to generate and send
int test_scb_error_override = 0;	// 1 = ignore scb error counter (for directed testing)

int port = 2;

// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

initial begin
	$display("*************** Start of testbench ***************");

	// instantiate environment object
	env = new( i_intf, test_pkt_count, verbose );

	// run the environment
	// fork
		env.run();
		// check_data_out(test_pkt_count, port);
	// join
end


// ***************************** TASKS ***************************** //

task check_data_out( int pkt_count, port );
	int portZeroAddr;
	int portZeroData;
	int portOneAddr;
	int portOneData;
	int portTwoAddr;
	int portTwoData;
	int portThreeAddr;
	int portThreeData;

	@( i_intf.clk );
	repeat ( pkt_count ) begin
		// Grab port and data values from "prev" clk cycle
		portZeroAddr 	= i_intf.addr_out[7:0];
		portZeroData 	= i_intf.data_out[7:0];
		portOneAddr		= i_intf.addr_out[15:8];
		portOneData		= i_intf.data_out[15:8];
		portTwoAddr 	= i_intf.addr_out[23:16];
		portTwoData		= i_intf.data_out[23:16];
		portThreeAddr = i_intf.addr_out[31:24];
		portThreeData	= i_intf.data_out[31:24];

		@( i_intf.clk );

		if ( i_intf.data_out[ (portZeroAddr*8) +: 8 ] == portZeroData ) begin
			$error("%0d : Testbench_manual_port_1 | Port 0 : Wrong PORT ZERO Result.\n\tExpected port 0 to not drive anything. \n", $time);
			env.scb.record_error();
		end

		if ( i_intf.data_out[ (portOneAddr*8) +: 8 ] == portOneData ) begin
			$error("%0d : Testbench_manual_port_1 | Port 1 : !!!!!! CORRECT !!!!!! PORT TWO Result.\n\tExpected port 1 to drive its data\n", $time);
			env.scb.record_error();
		end

	end
endtask : check_data_out


final
	$display("*************** End of testbench ***************");

endprogram
