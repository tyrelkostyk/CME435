
program testbench( intf i_intf );

// ************************* INSTANTIATIONS ************************* //


// *********************** EVENTS AND INTEGERS ********************** //


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

initial begin
	$display("*************** Start of testbench ***************");

	repeat (50) @( i_intf.cb_tb );
end


final
	$display("*************** End of testbench ***************");

endprogram
