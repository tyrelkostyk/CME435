`include "testbench/phase2_environment/environment.sv"
`include "testbench/phase3_base/transaction.sv"

program testbench_MIN_payload( intf i_intf );

// declaring extended transaction classes for directed testing
class TransMin extends TransBase;
	constraint payload_size_c { data_in.size == 4; }
endclass

// declaring environment class object instance
environment #( .T(TransMin) ) env;

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
