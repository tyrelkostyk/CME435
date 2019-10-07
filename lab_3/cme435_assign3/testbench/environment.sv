`include "testbench/interface.sv"
`include "testbench/transaction.sv"
`include "testbench/generator.sv"

`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class environment;

// instantiate generator class
generator gen;

// instantiate mailbox handle
mailbox gen2drive;

// instantiate virtual interface
virtual intf vif;

// constructor
function new( virtual intf vif );
  // get the interface from test
  this.vif = vif;

	// creating the mailbox (Same handle will be shared across generator and driver)
	gen2drive = new();

	// create generator
	gen = new( gen2drive );
endfunction


task reset();
	wait( vif.reset );
	$display("[ ENVIRONMENT ] ----- Reset Started -----");

	vif.a <= 0;
	vif.b <= 0;
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
	$finish;
endtask


endclass
`endif
