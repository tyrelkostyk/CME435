// module dut_top( interface i_intf );
module dut_top( intf.DUT i_intf );
// use the DUT modport of the intf interface

adder adder_core (
	.clk( i_intf.clk ),
	.reset( i_intf.reset ),
	.a( i_intf.a ),
	.b( i_intf.b ),
	.valid( i_intf.valid ),
	.c( i_intf.c )
);

endmodule
