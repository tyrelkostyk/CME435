`include "testbench/transaction.sv"

`ifndef GENERATOR_SV
`define GENERATOR_SV

class generator;

// declaring transaction class
rand transaction trans;

// mailbox, to generate and send the packet to driver
mailbox gen2drive;

// constructor
function new(mailbox gen2drive);
	//getting the mailbox handle from env.
	this.gen2drive = gen2drive;

endfunction


// main task, generates (creates and randomizes) <repeat_count> number of ransaction packets
int repeat_count;

task main();

	repeat(repeat_count) begin
		trans = new();

		if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
		trans.display("[ Generator ]");

		// place a transaction message in the generator-to-driver mailbox
		gen2drive.put( trans );
	end

endtask

endclass
`endif
