`include "testbench/phase4_generator/transaction.sv"

`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class scoreboard;


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf vif;

// create mailbox handles
mailbox mon2scb;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// monitor constructor
function new( mailbox mon2scb );
	// get the mailbox handle from env
	this.mon2scb = mon2scb;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions received
int num_transactions_recv;


// ***************************** TASKS ***************************** //

task main();
	transaction trans;
	forever begin
		mon2scb.get( trans );

		if ( ( trans.a + trans.b ) == trans.c )
			$display("%0d : Scoreboard : Result is as expected", $time);
		else
			$error("%0d : Scoreboard : Wrong  Result.\n\tExpeced:  %0d  Actual:  %0d", $time, (trans.a+trans.b), trans.c);

		num_transactions_recv++;
		trans.display("[ Scoreboard ]");
	end
endtask


endclass
`endif
