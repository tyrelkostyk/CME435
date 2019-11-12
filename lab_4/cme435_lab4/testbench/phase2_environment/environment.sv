`include "testbench/phase1_top/interface.sv"
`include "testbench/phase3_base/transaction.sv"
`include "testbench/phase4_generator/generator.sv"
`include "testbench/phase5_driver/driver.sv"
`include "testbench/phase6_monitor/monitor.sv"
`include "testbench/phase7_scoreboard/scoreboard.sv"

`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class environment #( type T=TransBase );


// ************************* INSTANTIATIONS ************************* //

// instantiate class instances
generator #(T) gen;
driver drive;
monitor mon;
scoreboard scb;

// instantiate mailbox handles
mailbox gen2drive;		// to send the generated packets to driver
mailbox drive2scb;		// to send the generated packets to scoreboard
mailbox mon2scb;			// to share received data with the scoreboard

// instantiate semaphore handles
semaphore semComm;		// prevent driving packets until incoming packets are all received

// instantiate virtual interfaces
virtual intf vif;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

// environment constructor
function new( virtual intf vif );
  // get the interface from test
  this.vif = vif;

	// create the mailboxes (Same handle shared across objects)
	gen2drive = new();
	mon2scb = new();
	drive2scb = new();

	// create the semaphores
	semComm = new(1);		// binary semaphore (mutex)

	// construct the objects
	gen = new( gen2drive, semComm );
	drive = new( vif, gen2drive, drive2scb );
	mon = new( vif, mon2scb, semComm );
	scb = new( drive2scb, mon2scb );

endfunction


// ***************************** TASKS ****************************** //

task reset();
	wait( vif.reset );
	$display("[ ENVIRONMENT ] ----- Reset Started -----");

	// reset DUT signals
	vif.bnd_plse 				<= 0;
	vif.data_in					<= 0;
	vif.proceed_1				<= 0;
	vif.proceed_2				<= 0;
	vif.proceed_3				<= 0;
	vif.proceed_4				<= 0;

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

	// join_any bc some never exit (forever loop)
	fork
		gen.main();
		drive.main();
		mon.main();
		scb.main();
	join_any

	// put necessary wait statements here
	wait( gen.end_gen.triggered );
	wait( gen.pkt_count == drive.num_transactions_sent );
	wait( gen.pkt_count == scb.num_transactions_recv );

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
	#250 finish();
endtask


task finish();
begin
	if ( scb.error_count != 0 )
		$display("%0d : ############# TEST FAILED (%0d) TIMES ###############", $time, scb.error_count);
	else
		$display("%0d : ############# TEST PASSED ###############", $time);

	$finish;
end
endtask


endclass
`endif
