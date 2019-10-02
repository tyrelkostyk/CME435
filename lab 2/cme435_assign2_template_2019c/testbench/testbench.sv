module testbench (
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

reg mem_en;
reg mem_rd_wr;
reg [1:0] mem_add;
reg [7:0] mem_data;
reg [7:0] mem[3:0];


environment env (
	clock,
	packet_valid,
	data,
	data_0, data_1, data_2, data_3,
	ready_0, ready_1, ready_2, ready_3,
	read_0, read_1, read_2, read_3,
	mem_en, mem_rd_wr, mem_add, mem_data
);



initial
begin
	$display("******************* Start of testcases ****************");
	env.run();
	#1000 $stop;
end

final
	$display("******************** End of testcases *****************");


endmodule : testbench
