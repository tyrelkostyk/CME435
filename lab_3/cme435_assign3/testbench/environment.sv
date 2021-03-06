`include "testbench/interface.sv"
`include "testbench/transaction.sv"
`include "testbench/generator.sv"
`include "testbench/driver.sv"
`include "testbench/monitor.sv"
`include "testbench/scoreboard.sv"

`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class environment;


// ************************* INSTANTIATIONS ************************* //

// instantiate class instances
generator gen;
driver drive;
monitor mon;
scoreboard scb;

// instantiate mailbox handles
mailbox gen2drive;			// to generate and send the packets to driver
mailbox mon2scb;				// to share received data with the scoreboard

// instantiate virtual interfaces
virtual intf vif;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// environment constructor
function new( virtual intf vif );
  // get the interface from test
  this.vif = vif;

	// create the mailboxes (Same handle will be shared across objects)
	gen2drive = new();
	mon2scb = new();

	// construct the objects
	gen = new( gen2drive );
	drive = new( vif, gen2drive );
	mon = new( vif, mon2scb );
	scb = new( mon2scb );

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// Error checking / counting
integer error_count = 0;


// ***************************** TASKS ****************************** //

task reset();
	wait( vif.reset );		// TODO: where is vif.reset defined?
	$display("[ ENVIRONMENT ] ----- Reset Started -----");

	vif.a 		<= 0;
	vif.b 		<= 0;
	vif.valid <= 0;

	wait( !vif.reset );
	$display("[ ENVIRONMENT ] ----- Reset Ended   -----");
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
		mon.main();
		scb.main();
	join_any

	wait( gen.end_gen.triggered );
	wait( gen.repeat_count == drive.num_transactions_sent );
	wait( gen.repeat_count == scb.num_transactions_recv );

	$display("%0d : Environment : End of test() task", $time);
endtask


task post_test();
	$display("%0d : Environment : Start of post_test() task", $time);
	$display("%0d : Environment : End of post_test() task", $time);
endtask


task run();
	$display("%0d : Environment : Start of post_test() task", $time);

	pre_test();

	test();

	post_test();

	$display("%0d : Environment : End of post_test() task", $time);
	#1000 finish();
endtask


task finish();
begin
	if ( error_count != 0 )
		$display("%0d : ############# TEST FAILED (%0d) TIMES ###############", $time, error_count);
	else
		$display("%0d : ############# TEST PASSED ###############", $time);

	$finish;
end
endtask


// TODO: implement calling this somewhere (can you do that?)
task record_error();
	error_count = error_count + 1;
endtask



endclass
`endif
