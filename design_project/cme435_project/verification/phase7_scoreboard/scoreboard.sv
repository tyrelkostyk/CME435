`include "TransBase.sv"

`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class scoreboard #( type T=TransBase );


// ************************* INSTANTIATIONS ************************* //

// create mailbox handles
mailbox drive2scb[4];
mailbox mon2scb[4];


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// monitor constructor
function new( mailbox drive2scb[4], mon2scb[4] );
	// get the mailbox handle from env
	foreach( mon2scb[i] ) this.mon2scb[i] = mon2scb[i];
	// this.mon2scb = mon2scb;
	foreach( drive2scb[i] ) this.drive2scb[i] = drive2scb[i];
	// this.drive2scb = drive2scb;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions received
int num_transactions_recv = 0;

// Error checking / counting
int error_count = 0;
int scb_error_override;

event port0_eval, port1_eval, port2_eval, port3_eval;

// ***************************** TASKS ***************************** //

task evaluate_port( int port );
	T trans_tx;		// the driven transaction
	T trans_rx;		// the received transaction
	int portSrc;	// the source port that this port's data came from (i)

	forever begin
		// receive driven and received transactions (blocking delay via mailboxes)
		drive2scb[port].get( trans_tx );
		mon2scb[port].get( trans_rx );

		// determine source port to check data and dest validity
		portSrc = trans_rx.addr_out[ (port*8) +: 8 ];

		if ( scb_error_override != 1 ) begin
			// if ( trans_rx.valid_out[port] ) begin
			if ( trans_rx.valid_out[portSrc] ) begin
				if ( trans_tx.data_in[ (portSrc*8) +: 8 ] != trans_rx.data_out[ (port*8) +: 8 ] ) begin
					$error("%0d : Scoreboard | Port %0d : Wrong  Result.\n\tExpeced:  %0d  Actual:  %0d | portSrc = %0d | valid_in = %0b", $time, port, trans_tx.data_in[ (portSrc*8) +: 8 ], trans_rx.data_out[ (port*8) +: 8 ], portSrc, trans_tx.valid_in);
					record_error();
				end

				// if ( trans_tx.addr_in[ (port*8) +: 8 ] != trans_rx.addr_out[ (port*8) +: 8 ] ) begin
				// 	$error("%0d : Scoreboard | Port %0d : Wrong  Result.\n\tExpeced:  %0d  Actual:  %0d", $time, port, trans_tx.addr_in[ (port*8) +: 8 ], trans_rx.addr_out[ (port*8) +: 8 ]);
				// 	record_error();
				// end
			end
		end


		num_transactions_recv++;

		// `ifdef VERBOSE
			$display("\n%0d : ----------- PACKET NUMBER %1d | PORT %0d | SCOREBOARD FINISHED -----------", $time, (num_transactions_recv/4)+1, port);
		// `endif

	end
endtask : evaluate_port


task main();

	fork
		evaluate_port( 0 );
		evaluate_port( 1 );
		evaluate_port( 2 );
		evaluate_port( 3 );
	join

endtask : main


task record_error();
	if ( scb_error_override != 1 )
		error_count = error_count + 1;
endtask : record_error


endclass
`endif
