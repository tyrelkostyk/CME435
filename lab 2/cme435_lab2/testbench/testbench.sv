module testbench(
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

// 0 for fixed, 1 for random
integer randomize_payload_size = 0;


environment env (
	clock,
	packet_valid,
	data,
	data_0, data_1, data_2, data_3,
	ready_0, ready_1, ready_2, ready_3,
	read_0, read_1, read_2, read_3,
	mem_en, mem_rd_wr, mem_add, mem_data
);

integer i;

always @( negedge read_0 or read_1 or read_2 or read_3 )
	for ( i=0; i<env.size_of_payload+3; i=i+1 )
	begin
		if ( env.sent_ports[i] != env.recv_ports[i] )
			begin
				-> env.error;
				$display("*** ERROR! *** SENT PORT [%0d] DOESN'T MATCH RECEIVED PORT [%0d] AT PACKET BYTE # %0d **** :(", env.sent_ports[i], env.recv_ports[i], i);
			end
		else
			$display("Success! Sent port [%0d] matches received port [%0d] at packet byte # %0d :)", env.sent_ports[i], env.recv_ports[i], i);

		if ( env.sent_pkts[i] != env.recv_pkts[i] )
			begin
				-> env.error;
				$display("*** ERROR! *** SENT DATA [%b] DOESN'T MATCH RECEIVED DATA [%b] AT PACKET BYTE # %0d **** :(", env.sent_pkts[i], env.recv_pkts[i], i);
			end
		else
			$display("Success! Sent data [%b] matches received data [%b] at packet byte # %0d :)", env.sent_pkts[i], env.recv_pkts[i], i);
	end

initial
begin
	$display("******************* Start of testcases ****************");
	env.run();
end

final
	$display("******************** End of testcases *****************");

endmodule : testbench
