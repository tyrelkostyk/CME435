`include "interface.sv"
`include "TransBase.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class environment #( type T=TransBase );


// ************************* INSTANTIATIONS ************************* //

// instantiate class instances
generator #(T) gen;
driver #(T) drive[4];
monitor #(T) mon[4];

// instantiate mailbox handles
mailbox gen2drive[4];	// to send the generated packets to driver
mailbox drive2scb[4];		// to send the generated packets to scoreboard
mailbox mon2scb[4];			// to share received data with the scoreboard

// instantiate semaphore handles

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
	foreach( mon2scb[i] )
		mon2scb[i] = new();

	// create the semaphores

	// construct the objects
	gen = new( gen2drive );
	foreach( drive[i] )
		drive[i] = new( vif, gen2drive[i], drive2scb[i], i );
	foreach( mon[i] )
		mon[i] = new ( vif, mon2scb[i], i );

endfunction


// ***************************** TASKS ****************************** //

task reset();
	$display("%0d : [ ENVIRONMENT ] ----- Reset Started -----", $time);

	// reset DUT signals
	vif.cb_tb.data_in 				<= 0;
	vif.cb_tb.addr_in					<= 0;
	vif.cb_tb.valid_in				<= 0;
	vif.cb_tb.data_rd					<= 0;

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
		drive[0].main();
		drive[1].main();
		drive[2].main();
		drive[3].main();
		mon[0].main();
		mon[1].main();
		mon[2].main();
		mon[3].main();
	join_any

	wait( gen.end_gen.triggered );
	foreach( drive[i] )
		wait( gen.pkt_count == drive[i].num_transactions_sent );

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
