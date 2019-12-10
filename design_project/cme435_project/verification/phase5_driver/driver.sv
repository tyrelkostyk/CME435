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

// create coverage object

// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// driver constructor
function new( virtual intf.DRIVER vif, mailbox gen2drive, drive2scb, int port );
	// get the interface (DRIVER modport) from env
	this.vif = vif;

	// get the port number from env
	this.port = port;

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
			vif.cb_tb.addr_in = trans_tx.addr_in[(port*8)+7:(port*8)];
			vif.cb_tb.data_in = trans_tx.data_in[(port*8)+7:(port*8)];

		fork
			@( vif.cb_tb ) vif.bnd_plse = 1'b0;
			foreach ( trans_tx.data_in[i] ) begin
				@( vif.cb_tb ) vif.data_in = trans_tx.data_in[i];
			end
		join

		vif.bnd_plse = 1'b1;

		@( vif.cb_tb );
			vif.bnd_plse = 1'b0;

		num_transactions_sent++;

		`ifdef VERBOSE
			$display("\n%0d : ----------- PACKET NUMBER %1d | DRIVER -----------", $time, num_transactions_sent);
			trans_tx.display_downstream("[ DRIVER ]");
		`endif

		wait( vif.ack );
		wait( !vif.ack );
			case ( trans_tx.dest_addr )
				8'd1    : vif.proceed_1 <= 1'b1;
				8'd2    : vif.proceed_2 <= 1'b1;
				8'd3    : vif.proceed_3 <= 1'b1;
				8'd4    : vif.proceed_4 <= 1'b1;
				default : vif.proceed_1 <= vif.proceed_1;		// do nothing
			endcase

		@( vif.cb_tb );
			vif.proceed_1 <= 1'b0;
			vif.proceed_2 <= 1'b0;
			vif.proceed_3 <= 1'b0;
			vif.proceed_4 <= 1'b0;

		drive2scb.put( trans_tx );

	end
endtask


endclass
`endif
