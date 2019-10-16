`include "testbench/phase3_base/transaction.sv"

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
		// instantiate transaction object
		transaction trans;

		gen2drive.get( trans );

		@( posedge vif.clk );
			vif.bnd_plse 	= 1;
			vif.data_in		= trans.dest_addr;

		foreach( trans.data_in[i] ) begin
			@( posedge vif.clk );
				if ( i == trans.data_in.size() - 1 )		// last byte
					vif.bnd_plse 	= 1;
				else
					vif.bnd_plse 	= 0;

				vif.data_in			= trans.data_in[i];
		end

		@( posedge vif.clk );
			$display(  "----------- PACKET NUMBER %1d -----------", num_transactions_sent+1);
			trans.display_trans("[ Driver ]");

		num_transactions_sent++;
	end
endtask


endclass
`endif
