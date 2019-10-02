module tbench_top();

reg clock;
reg reset;
wire packet_valid;
wire [7:0] data;
wire [7:0] data_0, data_1, data_2, data_3;
wire ready_0, ready_1, ready_2, ready_3;
wire read_0, read_1, read_2, read_3;

reg mem_en;
reg mem_rd_wr;
reg [7:0] mem_data;
reg [1:0] mem_add;
reg [7:0] mem[3:0];


// instantiate testbench module
testbench test (
	clock,
	packet_valid,
	data,
	data_0, data_1, data_2, data_3,
	ready_0, ready_1, ready_2, ready_3,
	read_0, read_1, read_2, read_3,
	mem_en, mem_rd_wr, mem_add, mem_data
);


// instantiate DUT module
switch dut (
	clock,
	reset,
	packet_valid,
	data,
	data_0, data_1, data_2, data_3,
	ready_0, ready_1, ready_2, ready_3,
	read_0, read_1, read_2, read_3,
	mem_en, mem_rd_wr, mem_add, mem_data
);


// Clock generator
initial
  clock = 0;
always
begin
  #5 clock = ~clock;
end



endmodule : tbench_top
