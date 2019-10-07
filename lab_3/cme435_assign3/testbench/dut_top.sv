module dut_top( interface i_intf );

adder adder_core (
	.clk( i_intf.clk ),
	.reset( i_intf.reset ),
	.a( i_intf.a ),
	.b( i_intf.b ),
	.valid( i_intf ),
	.c( i_intf )
);

endmodule
