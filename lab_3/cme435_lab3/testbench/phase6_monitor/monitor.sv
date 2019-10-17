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
function new( virtual intf.MONITOR vif, mailbox gen2mon, mon2scb );
	// get the interface (MONITOR modport) from env
	this.vif = vif;

	// get the mailboxes from env
	this.mon2scb = mon2scb;
	this.gen2mon = gen2mon;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions sent
int num_transactions_recv = 0;


// ***************************** TASKS ***************************** //

task main();
	forever begin
		// instantiate transaction objects
		transaction trans_gen, trans_rx;
		trans_rx = new();
		gen2mon.get( trans_gen );						// grab the generated object

		wait(	vif.newdata_len_4 || vif.newdata_len_3 || vif.newdata_len_2 || vif.newdata_len_1 );
			if ( vif.newdata_len_1 )
				for (int i=0; i<vif.newdata_len_1; i++) begin
					@( posedge vif.clk );
					trans_rx.data_out_1[i] = vif.data_out_1;
				end

			else if ( vif.newdata_len_2 )
				for (int i=0; i<vif.newdata_len_2; i++) begin
					@( posedge vif.clk );
					trans_rx.data_out_2[i] = vif.data_out_2;
				end

			else if ( vif.newdata_len_3 )
				for (int i=0; i<vif.newdata_len_3; i++) begin
					@( posedge vif.clk );
					trans_rx.data_out_3[i] = vif.data_out_3;
				end

			else if ( vif.newdata_len_4 )
				for (int i=0; i<vif.newdata_len_4; i++) begin
					@( posedge vif.clk );
					trans_rx.data_out_4[i] = vif.data_out_4;
				end



		@( posedge vif.clk );
			mon2scb.put( trans_rx );

		num_transactions_recv++;
		$display("%0d : ----------- PACKET NUMBER %1d -----------", $time, num_transactions_recv);
		trans_rx.display_trans("[ MONITOR ]");

	end
endtask


endclass
`endif
