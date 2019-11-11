`ifndef INTERFACE_SV
`define	INTERFACE_SV

interface intf( input logic clk, reset );


// ************************* INSTANTIATIONS ************************* //

logic bnd_plse, ack;
logic [7:0] data_in;
logic [7:0] data_out [4:1];
logic [4:0] newdata_len [4:1];
logic proceed_1, proceed_2, proceed_3, proceed_4;


// ************************ CLOCKING BLOCKS ************************* //

clocking cb_dut @( posedge clk );
endclocking


// **************************** MODPORTS **************************** //

modport DUT (
	input clk, reset,
	input bnd_plse, data_in, proceed_1, proceed_2, proceed_3, proceed_4,
	output ack, data_out, newdata_len
);


modport DRIVER (
	input clk, reset,
	input ack, data_out, newdata_len,
	output bnd_plse, data_in, proceed_1, proceed_2, proceed_3, proceed_4
);


modport MONITOR (
	input clk, reset,
	input bnd_plse, data_in, proceed_1, proceed_2, proceed_3, proceed_4,
				ack, data_out, newdata_len
);


endinterface
`endif
