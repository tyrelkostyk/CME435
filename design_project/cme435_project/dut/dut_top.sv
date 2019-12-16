`include "dut/xswitch.svp"

module dut_top ( interface i_intf );

xswitch dut_core (
	.clk( i_intf.clk ),
	.reset( i_intf.reset ),
	.data_in( i_intf.data_in ),
	.addr_in( i_intf.addr_in ),
	.rcv_rdy( i_intf.rcv_rdy ),
	.valid_in( i_intf.valid_in ),
	.data_out( i_intf.data_out ),
	.addr_out( i_intf.addr_out ),
	.data_rd( i_intf.data_rd ),
	.valid_out( i_intf.valid_out )
);

endmodule
