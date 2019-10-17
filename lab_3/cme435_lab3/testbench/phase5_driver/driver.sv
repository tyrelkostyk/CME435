`include "testbench/phase3_base/transaction.sv"

`ifndef DRIVER_SV
`define DRIVER_SV

class driver;


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf.DRIVER vif;

// create mailbox handle
mailbox gen2drive;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// driver constructor
function new( virtual intf.DRIVER vif, mailbox gen2drive );
	// get the interface (DRIVER modport) from env
	this.vif = vif;

	// get the mailbox handle from env
	this.gen2drive = gen2drive;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions sent
int num_transactions_sent;


// ***************************** TASKS ***************************** //

// drive the transaction items to the interface signals
task main();
	forever begin
		// instantiate transaction object and grab it from generator
		transaction trans_tx;
		gen2drive.get( trans_tx );

		@( posedge vif.clk );
			vif.bnd_plse 	= 1'b1;
			vif.data_in		= trans_tx.dest_addr;

		fork
			@( posedge vif.clk ) vif.bnd_plse = 1'b0;
			foreach ( trans_tx.data_in[i] )
				@( posedge vif.clk ) vif.data_in = trans_tx.data_in[i];
		join

		vif.bnd_plse = 1'b1;

		@( posedge vif.clk );
			vif.bnd_plse = 1'b0;

		num_transactions_sent++;
		$display("\n%0d : ----------- PACKET NUMBER %1d | DRIVER -----------", $time, num_transactions_sent);
		trans_tx.display_downstream("[ DRIVER ]");

		wait( vif.ack );
		wait( !vif.ack );
			case ( trans_tx.dest_addr )
				8'd1    : vif.proceed_1 <= 1'b1;
				8'd2    : vif.proceed_2 <= 1'b1;
				8'd3    : vif.proceed_3 <= 1'b1;
				8'd4    : vif.proceed_4 <= 1'b1;
				default : vif.proceed_1 <= vif.proceed_1;		// do nothing
			endcase

		@( posedge vif.clk );
			vif.proceed_1 <= 1'b0;
			vif.proceed_2 <= 1'b0;
			vif.proceed_3 <= 1'b0;
			vif.proceed_4 <= 1'b0;

	end
endtask


endclass
`endif
