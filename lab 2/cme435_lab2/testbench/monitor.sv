module monitor(
  clock,
	data_0, data_1, data_2, data_3,
	ready_0, ready_1, ready_2, ready_3,
	read_0, read_1, read_2, read_3
);

input clock;
input [7:0] data_0, data_1, data_2, data_3;
input ready_0, ready_1, ready_2, ready_3;

output read_0, read_1, read_2, read_3;


// instantiate the receiver modules
receiver rec0 (
	.clk(clock),
	.data(data_0),
	.ready(ready_0),
	.read(read_0),
	.port(8'd0)
);

receiver rec1 (
	.clk(clock),
	.data(data_1),
	.ready(ready_1),
	.read(read_1),
	.port(8'd1)
);

receiver rec2 (
	.clk(clock),
	.data(data_2),
	.ready(ready_2),
	.read(read_2),
	.port(8'd2)
);

receiver rec3 (
	.clk(clock),
	.data(data_3),
	.ready(ready_3),
	.read(read_3),
	.port(8'd3)
);


endmodule: monitor
