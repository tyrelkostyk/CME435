`include "testbench/phase3_base/transaction.sv"
`include "testbench/phase6_monitor/receiver.sv"

`ifndef MONITOR_SV
`define MONITOR_SV

class monitor;


// ************************* INSTANTIATIONS ************************* //

// instantiate class instances
receiver recv1;
receiver recv2;
receiver recv3;
receiver recv4;

// create virtual interface handle
virtual intf.MONITOR vif;

// create mailbox handle
mailbox mon2scb;

// semaphore handles
semaphore semComm;		// prevent driving packets while receiving previous packets

// temp var for iterating over duration of (dut) output data
bit [4:0] tmp_data_len;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// monitor constructor
function new( virtual intf.MONITOR vif, mailbox mon2scb, semaphore semComm );
	// get the interface (MONITOR modport) from env
	this.vif = vif;

	// get the mailbox from env
	this.mon2scb = mon2scb;

	// getting the semaphore handles from env
	this.semComm = semComm;

	// construct the receiver objects
	recv1 = new( vif, 1, mon2scb, semComm );
	recv2 = new( vif, 2, mon2scb, semComm );
	recv3 = new( vif, 3, mon2scb, semComm );
	recv4 = new( vif, 4, mon2scb, semComm );

endfunction


// ***************************** TASKS ***************************** //

task main();

	fork
		recv1.main();
		recv2.main();
		recv3.main();
		recv4.main();
	join_any

endtask


endclass
`endif
