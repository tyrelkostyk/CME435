`include "environment.sv"

program testbench( intf i_intf );

// ************************* INSTANTIATIONS ************************* //

// declaring environment class object instance
environment env;


// *********************** EVENTS AND INTEGERS ********************** //


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

initial begin
	$display("*************** Start of testbench ***************");

	// instantiate environment object
	env = new( i_intf );

	// global envs go here

	// run the environment
	env.run();
end


final
	$display("*************** End of testbench ***************");

endprogram
