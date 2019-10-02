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
output packet_valid;
output [7:0] data;
input [7:0] data_0, data_1, data_2, data_3;
input ready_0, ready_1, ready_2, ready_3;
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


task reset_dut();
	$display("%0d : Environment : start of reset_dut() task", $time);

	$root.tbench_top.test.mem_en = 0;

	@( posedge clock );
	#2 $root.tbench_top.reset = 1;
	@( posedge clock );
	#2 $root.tbench_top.reset = 0;

	$display("%0d : Environment : end of reset_dut() task", $time);
endtask : reset_dut

reg [7:0] mem[3:0];
task cfg_dut();
	$display("%0d : Environment : start of cfg_dut() task", $time);

	mem[0] = $random;
	mem[1] = $random;
	mem[2] = $random;
	mem[3] = $random;

	mem_en = 0;

	@( posedge clock );
	#2 $root.tbench_top.reset = 1;
	@( posedge clock );
	#2 $root.tbench_top.reset = 0;

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
	reset_dut();
	cfg_dut();
	#1000 //$finish;
	finish
	$display(%0d : Environment : end of run() task", $time);
endtask : run



endmodule : environment
