`include "testbench/phase3_base/TransBase.sv"

`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class scoreboard;


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf vif;

// create mailbox handles
mailbox drive2scb;
mailbox mon2scb;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// monitor constructor
function new( mailbox drive2scb, mon2scb );
	// get the mailbox handle from env
	this.mon2scb = mon2scb;
	this.drive2scb = drive2scb;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions received
int num_transactions_recv;

// Error checking / counting
int error_count = 0;
int scb_error_override;


// ***************************** TASKS ***************************** //

task main();
	TransBase trans_tx;
	TransBase trans_rx;

	forever begin
		drive2scb.get( trans_tx );
		mon2scb.get( trans_rx );

		if ( scb_error_override != 1 ) begin
			if ( trans_tx.dest_addr != trans_rx.dest_addr ) begin
				$error("%0d : Scoreboard : Wrong  Result.\n\tExpeced:  %0d  Actual:  %0d", $time, trans_tx.dest_addr, trans_rx.dest_addr);
				record_error();
			end

			if ( trans_tx.data_in.size != trans_rx.newdata_len ) begin
				$error("%0d : Scoreboard : Wrong  Result.\n\tExpeced:  %0d  Actual:  %0d", $time, trans_tx.data_in.size, trans_rx.newdata_len);
				record_error();
			end

			foreach( trans_tx.data_in[i] ) begin
				if ( trans_tx.data_in[i] != trans_rx.data_out[i] ) begin
					$error("%0d : Scoreboard : Wrong  Result.\n\tExpeced:  %0d  Actual:  %0d", $time, trans_tx.data_in[i], trans_rx.data_out[i]);
					record_error();
				end
			end
		end

		num_transactions_recv++;

		`ifdef VERBOSE
			$display("\n%0d : ----------- PACKET NUMBER %1d | SCOREBOARD FINISHED -----------", $time, num_transactions_recv);
		`endif

	end
endtask


task record_error();
	if ( scb_error_override != 1 )
		error_count = error_count + 1;
endtask


endclass
`endif
