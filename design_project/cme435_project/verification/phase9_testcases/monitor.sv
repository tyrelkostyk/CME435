`include "TransBase.sv"

`ifndef MONITOR_SV
`define MONITOR_SV

class monitor #( type T=TransBase );


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf.MONITOR vif;

// initialize port bit, packet count
int port, pkt_count, verbose;

// create mailbox handle
mailbox mon2scb;

// semaphore handles


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

function new( virtual intf.MONITOR vif, mailbox mon2scb, int port, pkt_count, verbose );
	// get interface, port, and packet count from env class
	this.vif = vif;
	this.port = port;
	this.pkt_count = pkt_count;
	this.verbose = verbose;

	// get the mailbox from env
	this.mon2scb = mon2scb;

	// getting the semaphore handles from env

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions sent
int num_transactions_recv = 0;


// ***************************** TASKS ***************************** //

task main();
	repeat( pkt_count ) begin
		// instantiate transaction object
		T trans_rx;
		trans_rx = new();

		// wait(	vif.cb_tb.valid_out[port] );
		@( negedge vif.clk ); // allow time for DUT to produce outputs			//TODO: posedge
			trans_rx.addr_out[ (port*8) +:8 ] = vif.addr_out[ (port*8) +:8 ];
			trans_rx.data_out[ (port*8) +:8 ] = vif.data_out[ (port*8) +:8 ];
			trans_rx.valid_out[port] = vif.valid_out[port];

		num_transactions_recv++;

		mon2scb.put( trans_rx );

		vif.cb_tb.data_rd[port] <= vif.valid_out[port];	// enable this port to receive data

		if ( verbose ) begin
			$display("\n%0d : -------- PACKET NUMBER %1d | MONITOR | PORT %0d --------", $time, num_transactions_recv, port);
			trans_rx.display_upstream("[ MONITOR ]");
		end

	end
endtask

endclass
`endif
