`include "testbench/phase3_base/transaction.sv"

`ifndef MONITOR_SV
`define MONITOR_SV

class monitor;


// ************************* INSTANTIATIONS ************************* //

// instantiate class instances
receiver recv1;
receiver recv2;
receiver recv3;
receiver recv4;

// create virtual interface handle
virtual intf.MONITOR vif;

// create mailbox handles
mailbox mon2scb;

// temp var for iterating over duration of (dut) output data
bit [4:0] tmp_data_len;

// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// monitor constructor
function new( virtual intf.MONITOR vif, mailbox mon2scb );
	// get the interface (MONITOR modport) from env
	this.vif = vif;

	// get the mailboxes from env
	this.mon2scb = mon2scb;

	// construct the receiver objects
	recv1 = new(
		vif.clk,
		1'd1,
		vif.data_out_1,
		vif.newdata_len_1,
		mon2scb );

	recv2 = new(
		vif.clk,
		1'd2,
		vif.data_out_2,
		vif.newdata_len_2,
		mon2scb );

	recv3 = new(
		vif.clk,
		1'd3,
		vif.data_out_3,
		vif.newdata_len_3,
		mon2scb );

	recv4 = new(
		vif.clk,
		1'd4,
		vif.data_out_4,
		vif.newdata_len_4,
		mon2scb );

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions sent
int num_transactions_recv = 0;


// ***************************** TASKS ***************************** //

task main();

	fork
		recv1.main();
		recv2.main();
		recv3.main();
		recv4.main();
	join_any

endtask




// task main();
// 	forever begin
// 		// instantiate transaction objects
// 		transaction trans_rx;
// 		trans_rx = new();
//
// 		// wait(	vif.newdata_len_4 || vif.newdata_len_3 || vif.newdata_len_2 || vif.newdata_len_1 );
// 		fork
// 			if ( vif.newdata_len_1 ) begin
// 				trans_rx.dest_addr = 8'd1;
// 				trans_rx.newdata_len = vif.newdata_len_1;
// 				tmp_data_len = vif.newdata_len_1;
// 				trans_rx.data_out = new[tmp_data_len];
//
// 				wait( vif.data_out_1 );
// 				for (int i=0; i<tmp_data_len; i++) begin
// 					@( posedge vif.clk );
// 					trans_rx.data_out[i] = vif.data_out_1;
// 				end
// 				num_transactions_recv++;
// 			end
//
// 			if ( vif.newdata_len_2 ) begin
// 			trans_rx.dest_addr = 8'd2;
// 				trans_rx.newdata_len = vif.newdata_len_2;
// 				tmp_data_len = vif.newdata_len_2;
// 				trans_rx.data_out = new[tmp_data_len];
//
// 				wait( vif.data_out_2 );
// 				for (int i=0; i<tmp_data_len; i++) begin
// 					@( posedge vif.clk );
// 					trans_rx.data_out[i] = vif.data_out_2;
// 				end
// 				num_transactions_recv++;
// 			end
//
// 			if ( vif.newdata_len_3 ) begin
// 				trans_rx.dest_addr = 8'd3;
// 				trans_rx.newdata_len = vif.newdata_len_3;
// 				tmp_data_len = vif.newdata_len_3;
// 				trans_rx.data_out = new[tmp_data_len];
//
// 				wait( vif.data_out_3 );
// 				for (int i=0; i<tmp_data_len; i++) begin
// 					@( posedge vif.clk );
// 					trans_rx.data_out[i] = vif.data_out_3;
// 				end
// 				num_transactions_recv++;
// 			end
//
// 			if ( vif.newdata_len_4 ) begin
// 				trans_rx.dest_addr = 8'd4;
// 				trans_rx.newdata_len = vif.newdata_len_4;
// 				tmp_data_len = vif.newdata_len_4;
// 				trans_rx.data_out = new[tmp_data_len];
//
// 				wait( vif.data_out_4 );
// 				for (int i=0; i<tmp_data_len; i++) begin
// 					@( posedge vif.clk );
// 					trans_rx.data_out[i] = vif.data_out_4;
// 				end
// 				num_transactions_recv++;
// 			end
// 		join_any
//
// 		$display("\n%0d : ----------- PACKET NUMBER %1d | MONITOR -----------", $time, num_transactions_recv);
// 		trans_rx.display_upstream("[ MONITOR ]");
//
// 		@( posedge vif.clk );
// 			// mon2scb.put( trans_rx );
//
// 	end
// endtask


endclass
`endif
