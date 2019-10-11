`include "testbench/environment.sv"

program testbench( intf i_intf );

// declaring environment class object instance
environment env;


initial begin
	// instantiate environment object
	env = new( i_intf );
	$display("*************** Start of testbench ***************");

	// repeat_count is how many packets to generate
	env.gen.repeat_count = 5;

	env.run();
end


final
	$display("*************** End of testbench ***************");


endprogram
