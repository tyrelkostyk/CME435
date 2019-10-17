`include "testbench/phase2_environment/environment.sv"

program testbench( intf i_intf );

// declaring environment class object instance
environment env;


initial begin
	// instantiate environment object
	env = new( i_intf );
	$display("*************** Start of testbench ***************");

	// global envs go here
	env.gen.pkt_count = 5;		// how many packets to generate and send

	env.run();
end


final
	$display("*************** End of testbench ***************");


endprogram
