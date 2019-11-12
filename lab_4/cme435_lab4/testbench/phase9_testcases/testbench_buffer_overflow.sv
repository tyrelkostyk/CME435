`include "testbench/phase2_environment/environment.sv"
`include "testbench/phase3_base/transaction.sv"

program testbench_buffer_overflow( intf i_intf );

// declaring extended transaction classes for directed testing
class TransMaxMin extends TransBase;
	constraint payload_size_c { data_in.size inside {4,16}; }
	constraint payload_dest_addr_c { dest_addr == 1; }
endclass

// declaring environment class object instance
environment #( .T(TransMaxMin) ) env;

initial begin
	// instantiate environment object
	env = new( i_intf );
	$display("*************** Start of testbench ***************");

	// global envs go here
	env.gen.pkt_count = 5000;		// how many packets to generate and send

	env.run();
end


final
	$display("*************** End of testbench ***************");


endprogram
