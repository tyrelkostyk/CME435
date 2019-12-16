`include "TransBase.sv"

`ifndef DRIVER_SV
`define DRIVER_SV

class driver #( type T=TransBase );


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf.DRIVER vif;

// create mailbox handle
mailbox gen2drive;
mailbox drive2scb;

// create port integer
int port, verbose;

// create coverage object


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// driver constructor
function new( virtual intf.DRIVER vif, mailbox gen2drive, drive2scb, int port, verbose );
	// get the interface (DRIVER modport) from env
	this.vif = vif;

	// get the port number from env
	this.port = port;
	this.verbose = verbose;

	// get the mailbox handles from env
	this.gen2drive = gen2drive;
	this.drive2scb = drive2scb;

	// instantiate covergroups

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions sent
int num_transactions_sent = 0;


// ***************************** TASKS ***************************** //

// drive the transaction items to the interface signals
task main();
	forever begin
		// instantiate transaction object and grab it from generator
		T trans_tx;
		gen2drive.get( trans_tx );

		@( vif.cb_tb );
			vif.cb_tb.valid_in[port] <= trans_tx.valid_in[port];
			vif.cb_tb.addr_in[ (port*8) +:8 ] <= trans_tx.addr_in[ (port*8) +:8 ];
			vif.cb_tb.data_in[ (port*8) +:8 ] <= trans_tx.data_in[ (port*8) +:8 ];

		num_transactions_sent++;

		if ( verbose ) begin
			$display("\n%0d : -------- PACKET NUMBER %1d | DRIVER | PORT %0d --------", $time, num_transactions_sent, port);
			trans_tx.display_downstream("[ DRIVER ]");
		end

		drive2scb.put( trans_tx );

	end
endtask


endclass
`endif
