`include "testbench/phase2_environment/environment.sv"
`include "testbench/phase3_base/transaction.sv"

program testbench_MAX_payload( intf i_intf );

// declaring extended transaction classes for directed testing
class TransMax extends TransBase;
	constraint payload_size_c { data_in.size == 16; }
endclass

// declaring environment class object instance
environment #( .T(TransMax) ) env;

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
