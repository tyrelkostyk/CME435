`include "TransBase.sv"

`ifndef GENERATOR_SV
`define GENERATOR_SV

class generator #( type T=TransBase );

// ************************* INSTANTIATIONS ************************* //

// declaring transaction object
rand T trans_gen;

// mailbox handles
mailbox gen2drive[4];		// to generate and send the packets to driver

int pkt_count;	// num packets to generate. Defined in testbench
int verbose;

// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// generator constructor
function new( mailbox gen2drive[4], int pkt_count, verbose );
	// getting the mailbox handles from env
	foreach( gen2drive[i] )
		this.gen2drive[i] = gen2drive[i];

	this.pkt_count = pkt_count;
	this.verbose = verbose;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

int num_transactions_gen = 0;	// num packets generated

event end_gen;	// tell environment when generation has stopped


// ***************************** TASKS ***************************** //

task main();
// generates (creates and randomizes) <pkt_count> transaction packets

	repeat( pkt_count ) begin
		trans_gen = new();

		if( !trans_gen.randomize() ) $fatal("Gen:: trans_gen randomization failed");
		num_transactions_gen++;

		if ( verbose ) begin
			$display("\n%0d : ----------- PACKET NUMBER %1d | GENERATOR -----------", $time, num_transactions_gen);
			trans_gen.display_downstream("[ GENERATOR ]");
		end

		// send the transaction message via mailbox to the driver and scoreboard
		foreach( gen2drive[i] )
			gen2drive[i].put( trans_gen );

	end
	-> end_gen;		// trigger the end of generation
endtask

endclass
`endif