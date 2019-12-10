`include "interface.sv"
`include "TransBase.sv"
`include "generator.sv"

`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class environment #( type T=TransBase );


// ************************* INSTANTIATIONS ************************* //

// instantiate class instances
generator #(T) gen;
driver #(T) drive[4];

// instantiate mailbox handles
mailbox gen2drive[4];	// to send the generated packets to driver
mailbox drive2scb[4];		// to send the generated packets to scoreboard

// instantiate semaphore handles
semaphore semComm[4];	// prevent driving packets until incoming packets are all received

// instantiate virtual interfaces
virtual intf vif;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// environment constructor
function new( virtual intf vif );
  // get the interface from test
  this.vif = vif;

	// create the mailboxes (Same handle shared across objects)
	foreach( gen2drive[i] )
		gen2drive[i] = new();
	foreach( drive2scb[i] )
		drive2scb[i] = new();

	// create the semaphores
	foreach( semComm[i] )
		semComm[i] = new(1);		// binary semaphore (mutex)

	// construct the objects
	gen = new( gen2drive, semComm );
	foreach( drive[i] )
		drive[i] = new( vif, gen2drive[i], drive2scb[i], i );

endfunction


// ***************************** TASKS ****************************** //

task reset();
	$display("%0d : [ ENVIRONMENT ] ----- Reset Started -----", $time);

	// reset DUT signals
	vif.data_in 				<= 0;
	vif.addr_in					<= 0;
	vif.valid_in				<= 0;
	vif.data_rd					<= 0;

	$display("%0d : [ ENVIRONMENT ] ----- Reset Ended   -----", $time);
endtask


task pre_test();
	$display("%0d : Environment : Start of pre_test() task", $time);
	reset();
	$display("%0d : Environment : End of pre_test() task", $time);
endtask


task test();
	$display("%0d : Environment : Start of test() task", $time);

	fork
		gen.main();
		drive.main();
	join_any

	wait( gen.end_gen.triggered );
	wait( gen.pkt_count == drive.num_transactions_sent );
	// repeat (25) @( vif.cb_tb );	// simulate generator

	$display("%0d : Environment : End of test() task", $time);
endtask


task post_test();
	$display("%0d : Environment : Start of post_test() task", $time);
	$display("%0d : Environment : End of post_test() task", $time);
endtask


task run();
	$display("%0d : Environment : Start of run() task", $time);

	pre_test();
	test();
	post_test();

	// repeat (25) @( vif.cb_tb );
	$display("%0d : Environment : End of run() task", $time);
	finish();
endtask


task finish();
	$finish;
endtask


endclass
`endif
