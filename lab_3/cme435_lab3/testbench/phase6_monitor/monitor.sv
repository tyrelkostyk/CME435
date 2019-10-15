`include "phase4_generator/transaction.sv"

`ifndef MONITOR_SV
`define MONITOR_SV

class monitor;


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf vif;

// create mailbox handles
mailbox mon2scb;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// monitor constructor
function new( virtual intf vif, mailbox mon2scb );
	// get the interface
	this.vif = vif;

	// get the mailbox handles
	this.mon2scb = mon2scb;

endfunction


// ***************************** TASKS ***************************** //

task main();
	forever begin
		transaction trans;
		trans = new();

		@( posedge vif.clk );
			wait( vif.valid );
			trans.a		= vif.a;
			trans.b		= vif.b;

		@( posedge vif.clk );
			trans.c 	= vif.c;

		@( posedge vif.clk );
			mon2scb.put( trans );
			trans.display("[ monitor ]");
	end
endtask


endclass
`endif
