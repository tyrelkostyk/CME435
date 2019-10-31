`include "testbench/phase3_base/transaction.sv"

`ifndef GENERATOR_SV
`define GENERATOR_SV

class generator;


// ************************* INSTANTIATIONS ************************* //

// declaring transaction object
rand transaction trans_gen;

// mailbox handles
mailbox gen2drive;		// to generate and send the packets to driver

// semaphore handles
semaphore semComm;		// prevent driving packets while receiving previous packets


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// generator constructor
function new( mailbox gen2drive, semaphore semComm );
	// getting the mailbox handles from env
	this.gen2drive = gen2drive;

	// getting the semaphore handles from env
	this.semComm = semComm;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

int pkt_count;
int num_transactions_gen = 0;

event end_gen;


// ***************************** TASKS ***************************** //

task main();
// generates (creates and randomizes) <pkt_count> transaction packets

	repeat( pkt_count ) begin
		semComm.get();		// block until comm line is open
		trans_gen = new();

		if( !trans_gen.randomize() ) $fatal("Gen:: trans_gen randomization failed");
		num_transactions_gen++;
		$display("\n%0d : ----------- PACKET NUMBER %1d | GENERATOR -----------", $time, num_transactions_gen);
		// trans_gen.display_downstream("[ GENERATOR ]");

		// send the transaction message via mailbox to the driver and scoreboard
		gen2drive.put( trans_gen );

	end
	-> end_gen;		// trigger the end of generation
endtask

endclass
`endif
