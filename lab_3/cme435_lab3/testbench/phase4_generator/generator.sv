`include "testbench/phase3_base/transaction.sv"

`ifndef GENERATOR_SV
`define GENERATOR_SV

class generator;


// ************************* INSTANTIATIONS ************************* //

// declaring transaction object
rand transaction trans_gen;

// mailbox handles
mailbox gen2drive;		// to generate and send the packets to driver
mailbox gen2mon;			// to generate and send the dest_addr to monitor


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// generator constructor
function new( mailbox gen2drive, gen2mon );
	// getting the mailbox handles from env.
	this.gen2drive = gen2drive;
	this.gen2mon = gen2mon;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

int pkt_count;
int num_transactions_gen = 0;

event end_gen;


// ***************************** TASKS ***************************** //

task main();
// generates (creates and randomizes) <pkt_count> transaction packets

	repeat( pkt_count ) begin
		trans_gen = new();

		if( !trans_gen.randomize() ) $fatal("Gen:: trans_gen randomization failed");
		num_transactions_gen++;
		$display(  "----------- PACKET NUMBER %1d -----------", num_transactions_gen);
		trans_gen.display_trans("[ GENERATOR ]");

		// send the transaction message via mailbox to the driver and monitor
		gen2drive.put( trans_gen );
		gen2mon.put( trans_gen );
	end
	-> end_gen;		// trigger the end of generation
endtask

endclass
`endif
