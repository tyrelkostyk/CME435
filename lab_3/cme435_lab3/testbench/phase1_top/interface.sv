`ifndef INTERFACE_SV
`define	INTERFACE_SV

interface intf( input logic clk, reset );


// ************************* INSTANTIATIONS ************************* //

logic bnd_plse, ack;
logic [7:0] data_in;
logic [7:0] data_out_1, data_out_2, data_out_3, data_out_4;
logic [4:0] newdata_len_1, newdata_len_2, newdata_len_3, newdata_len_4;
logic proceed_1, proceed_2, proceed_3, proceed_4;


// ************************ CLOCKING BLOCKS ************************* //

clocking cb_dut @( posedge clk );
	input bnd_plse, data_in, proceed_1, proceed_2, proceed_3, proceed_4;
	output ack, data_out_1, data_out_2, data_out_3, data_out_4,
				 newdata_len_1, newdata_len_2, newdata_len_3, newdata_len_4;
endclocking


// **************************** MODPORTS **************************** //

modport DUT (
	clocking cb_dut,
	input clk, reset
);


modport DRIVER (
	input clk, reset,
	input ack, data_out_1, data_out_2, data_out_3, data_out_4,
				newdata_len_1, newdata_len_2, newdata_len_3, newdata_len_4,
	output bnd_plse, data_in, proceed_1, proceed_2, proceed_3, proceed_4
);


modport MONITOR (
	input clk, reset,
	input bnd_plse, data_in, proceed_1, proceed_2, proceed_3, proceed_4,
				ack, data_out_1, data_out_2, data_out_3, data_out_4,
				newdata_len_1, newdata_len_2, newdata_len_3, newdata_len_4
);


endinterface
`endif
