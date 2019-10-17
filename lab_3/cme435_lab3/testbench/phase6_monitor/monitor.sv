`include "testbench/phase3_base/transaction.sv"

`ifndef MONITOR_SV
`define MONITOR_SV

class monitor;


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf.MONITOR vif;

// create mailbox handles
mailbox mon2scb;
mailbox gen2mon;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// monitor constructor
function new( virtual intf.MONITOR vif, mailbox gen2mon, mailbox mon2scb );
	// get the interface (MONITOR modport) from env
	this.vif = vif;

	// get the mailboxes from env
	this.mon2scb = mon2scb;
	this.gen2mon = gen2mon;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions sent
int num_transactions_recv;


// ***************************** TASKS ***************************** //

task main();
	forever begin
		// instantiate transaction object and grab it from generator
		transaction trans_gen;
		gen2mon.get( trans_gen );

		// instantiate transaction object and grab it from generator
		transaction trans_rx;
		trans_rx = new();

		foreach ( trans_gen.data_in[i] )
			case ( trans_gen.dest_addr )
				8'd1    : trans_rx.data_out_1 <= vif.data_out_1;
				8'd2    : trans_rx.data_out_2 <= vif.data_out_2;
				8'd3    : trans_rx.data_out_3 <= vif.data_out_3;
				8'd4    : trans_rx.data_out_4 <= vif.data_out_4;
				default : trans_rx.data_out_1 <= trans_rx.data_out_1;		// do nothing
			endcase



		@( posedge vif.clk );
			mon2scb.put( trans_rx );

		num_transactions_recv++;
		$display("%0d : ----------- PACKET NUMBER %1d -----------", $time, num_transactions_recv);
		trans_rx.display_trans("[ MONITOR ]");

	end
endtask


endclass
`endif
