`include "testbench/phase3_base/transaction.sv"

`ifndef RECEIVER_SV
`define RECEIVER_SV

class receiver;


// ************************* INSTANTIATIONS ************************* //

bit clk, port;
bit [7:0] data;
bit [4:0] data_len;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

function new( logic clk, port, data, data_len )
	// get inputs from monitor class
	this.clk = clk;
	this.port = port;
	this.data = data;
	this.data_len = data_len;

	// get the mailboxes from env
	this.mon2scb = mon2scb;

endfunction


task main();
	forever begin
		// instantiate transaction object
		transaction trans_rx;
		trans_rx = new();
		trans_rx.dest_addr = port;

		wait(	data_len );
			trans_rx.newdata_len = data_len;
			tmp_data_len = data_len;
			trans_rx.data_out = new[tmp_data_len];

			wait( data );
				for (int i=0; i<tmp_data_len; i++) begin
					@( posedge clk );
					trans_rx.data_out[i] = data_out;
				end
				num_transactions_recv++;

		$display("\n%0d : ----------- PACKET NUMBER %1d | RECEIVER %1d -----------", $time, num_transactions_recv, port);
		trans_rx.display_upstream("[ RECEIVER ]");

		@( posedge clk );
			mon2scb.put( trans_rx );

	end
endtask
