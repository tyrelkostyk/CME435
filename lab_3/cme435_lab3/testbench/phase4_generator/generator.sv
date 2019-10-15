`include "testbench/phase3_base/transaction.sv"

`ifndef GENERATOR_SV
`define GENERATOR_SV

class generator;


// ************************* INSTANTIATIONS ************************* //

// declaring transaction object
rand transaction trans;

// mailbox handles
mailbox gen2drive;		// to generate and send the packets to driver


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// generator constructor
function new( mailbox gen2drive );
	//getting the mailbox handle from env.
	this.gen2drive = gen2drive;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

int pkt_count;
int pkts_sent = 0;

event end_gen;


// ***************************** TASKS ***************************** //

task main();
// generates (creates and randomizes) <pkt_count> transaction packets

	repeat( pkt_count ) begin
		trans = new();

		if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
		$display(  "----------- PACKET NUMBER %1d -----------", pkts_sent+1);
		trans.display_trans("[ Generator ]");

		// place a transaction message in the generator-to-driver mailbox
		gen2drive.put( trans );
		pkts_sent++;
	end
	-> end_gen;		// trigger the end of generation
endtask

endclass
`endif
