`include "TransBase.sv"

`ifndef MONITOR_SV
`define MONITOR_SV

class monitor #( type T=TransBase );


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf.MONITOR vif;

// initialize port bit
int port;

// create mailbox handle
mailbox mon2scb;

// semaphore handles


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

function new( virtual intf.MONITOR vif, mailbox mon2scb, int port );
	// get interface and port from env class
	this.vif = vif;
	this.port = port;

	// get the mailbox from env
	this.mon2scb = mon2scb;

	// getting the semaphore handles from env

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions sent
int num_transactions_recv = 0;


// ***************************** TASKS ***************************** //

task main();
	forever begin
		// instantiate transaction object
		T trans_rx;
		trans_rx = new();

		wait(	vif.cb_tb.valid_out[port] );
			trans_rx.addr_out[ (port*8) +:8 ] = vif.cb_tb.addr_out[ (port*8) +:8 ];
			trans_rx.data_out[ (port*8) +:8 ] = vif.cb_tb.data_out[ (port*8) +:8 ];
			vif.cb_tb.data_rd[port] <= 1;	// enable this port to receive data

		num_transactions_recv++;

		// `ifdef VERBOSE
			$display("\n%0d : -------- PACKET NUMBER %1d | MONITOR | PORT %0d --------", $time, num_transactions_recv, port);
			trans_rx.display_upstream("[ MONITOR ]");
		// `endif

		@( vif.cb_tb );
			mon2scb.put( trans_rx );

	end
endtask

endclass
`endif
