module environment(
	clock,
  packet_valid,
	data,
	data_0, data_1, data_2, data_3,
	ready_0, ready_1, ready_2, ready_3,
	read_0, read_1, read_2, read_3,
	mem_en, mem_rd_wr, mem_add, mem_data
);

input clock;
input [7:0] data_0, data_1, data_2, data_3;
input ready_0, ready_1, ready_2, ready_3;

output packet_valid;
output [7:0] data;
output read_0, read_1, read_2, read_3;
output mem_en;
output mem_rd_wr;
output [1:0] mem_add;
output [7:0] mem_data;

reg pkt_status;
reg mem_en;
reg mem_rd_wr;
reg [1:0] mem_add;
reg [7:0] mem_data;
reg [7:0] mem[3:0];


// instantiate generator module
generator gen ();

// instantiate the driver module
driver dr (
	clock,
	packet_valid,
	data,
	busy
);

// instantiate the monitor module
monitor mon (
	clock,
	data_0, data_1, data_2, data_3,
	ready_0, ready_1, ready_2, ready_3,
	read_0, read_1, read_2, read_3
);

// instantiate the monitor module
scoreboard sb ();


reg [7:0] sent_pkts [0:258];
reg [7:0] recv_pkts [0:258];
reg [7:0] sent_ports [0:258];
reg [7:0] recv_ports [0:258];


// task reset_dut();
// 	// CURRENTLY UNUSED
// 	$display("%0d : Environment : start of reset() task", $time);
//
// 	mem_en = 0;
//
// 	@( posedge clock );
// 	#2 $root.tbench_top.reset = 1;
// 	@( posedge clock );
// 	#2 $root.tbench_top.reset = 0;
//
// 	$display("%0d : Environment : end of reset_dut() task", $time);
// endtask : reset_dut


task cfg_dut();
	$display("%0d : Environment : start of cfg_dut() task", $time);

	mem[0] = $random;
	mem[1] = $random;
	mem[2] = $random;
	mem[3] = $random;

	mem_en = 1;

	@( negedge clock );
	mem_rd_wr = 1;
	mem_add = 0;
	mem_data = mem[0];

	@( negedge clock );
	mem_rd_wr = 1;
	mem_add = 1;
	mem_data = mem[1];

	@( negedge clock );
	mem_rd_wr = 1;
	mem_add = 2;
	mem_data = mem[2];

	@( negedge clock );
	mem_rd_wr = 1;
	mem_add = 3;
	mem_data = mem[3];

	@( negedge clock );
	mem_en = 0;
	mem_rd_wr = 0;
	mem_add = 0;
	mem_data = 0;

	$display("%0d : Environment : end of reset_dut() task", $time);
endtask : cfg_dut


task run();
	$display("%0d : Environment : start of run() task", $time);

	// reset events
	@( posedge clock )
		-> $root.tbench_top.reset_trigger;

	@( $root.tbench_top.reset_finished );

	repeat ( 10 )
		@( posedge clock );

	cfg_dut();

	#10;
	dr.gen_and_drive( $root.tbench_top.test.no_of_pkts );
	#10;

	#1000;
	finish();
	$display("%0d : Environment : end of run() task", $time);
endtask : run


// Error checking / counting
integer error_count = 0;
event error, error_recorded;

always @( error )
begin
	error_count = error_count + 1;
	#0 -> error_recorded;
end

// display the test results
task finish();
begin
	if ( error_count != 0 )
		$display("############# TEST FAILED (%0d) TIMES ###############", error_count);
	else
		$display("############# TEST PASSED ###############");
	$finish;
end
endtask


endmodule : environment
