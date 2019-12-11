`ifndef INTERFACE_SV
`define	INTERFACE_SV

interface intf( input logic clk, reset );


// ************************* INSTANTIATIONS ************************* //

logic [31:0]	addr_in, addr_out;
logic [31:0]	data_in, data_out;
logic [3:0]		valid_in, valid_out;
logic [3:0]		rcv_rdy, data_rd;

// ************************ CLOCKING BLOCKS ************************* //

clocking cb_tb @( posedge clk );
	input 	clk;
	output 	addr_in, data_in, valid_in, data_rd;
	input 	addr_out, data_out, valid_out, rcv_rdy;
endclocking

// **************************** MODPORTS **************************** //

modport DUT (
	input 	clk, reset,
	input 	addr_in, data_in, valid_in, data_rd,
	output 	addr_out, data_out, valid_out, rcv_rdy
);


modport DRIVER (
	clocking cb_tb,
	input clk
);


modport MONITOR (
	clocking cb_tb,
	input clk,
	input addr_out, data_out, valid_out, rcv_rdy,
	output addr_in, data_in, valid_in, data_rd
);


endinterface
`endif
