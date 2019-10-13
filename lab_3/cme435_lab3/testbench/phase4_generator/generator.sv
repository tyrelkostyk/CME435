`include "testbench/transaction.sv"

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

int repeat_count;

event end_gen;


// ***************************** TASKS ***************************** //

task main();
// main task, generates (creates and randomizes) <repeat_count> number of ransaction packets

	repeat( repeat_count ) begin
		trans = new();

		if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
		trans.display("[ Generator ]");

		// place a transaction message in the generator-to-driver mailbox
		gen2drive.put( trans );
	end
	-> end_gen;		// trigger the end of generation
endtask

endclass
`endif
