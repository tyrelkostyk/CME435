`include "phase4_generator/transaction.sv"

`ifndef DRIVER_SV
`define DRIVER_SV

class driver;


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf vif;

// create mailbox handle
mailbox gen2drive;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// driver constructor
function new( virtual intf vif, mailbox gen2drive );
	// get the interface from env
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
		// instantiate transaction object
		transaction trans;

		gen2drive.get( trans );

		@( posedge vif.clk );
			vif.valid = 1;
			vif.a 		= trans.a;
			vif.b 		= trans.b;

		@( posedge vif.clk );
			vif.valid = 0;
			trans.c 	= vif.c;

		@( posedge vif.clk );
			trans.display("[ Driver ]");

		num_transactions_sent++;
	end
endtask


endclass
`endif
