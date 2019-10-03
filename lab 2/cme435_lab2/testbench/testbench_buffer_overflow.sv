module testbench_buffer_overflow(
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


integer randomize_payload_size = 0;		// 0 for fixed, 1 for random
integer no_of_pkts = 10;							// how many packets
integer size_of_payload = 5;					// size of payload in bytes (used if not randomized)
integer randomize_DA = 0;							// 0 for fixed, 1 for random
integer fixed_DA_port = 2;						// can be 0-3
integer oversized_delay = 1;					// 0 for regular delay, 1 for large delay


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
integer pkt_no = 0;

always @( negedge read_0 or negedge read_1 or negedge read_2 or negedge read_3 )
begin
	for ( i=0; i<env.gen.len+4; i=i+1 )
	begin
		if ( env.sent_ports[i] != env.recv_ports[i] )
			begin
				-> env.error;
				@( env.error_recorded );
				$display("*** ERROR! *** [%0d] - [PKT %0d]: SENT PORT [%0d] DOESN'T MATCH RECEIVED PORT [%0d] AT PACKET BYTE # %0d **** :(", $time, pkt_no, env.sent_ports[i], env.recv_ports[i], i);
			end
		else
			$display("Success! [%0d] - [PKT %0d]: Sent port [%0d] matches received port [%0d] at packet byte # %0d :)", $time, pkt_no, env.sent_ports[i], env.recv_ports[i], i);

		if ( env.sent_pkts[i] != env.recv_pkts[i] )
			begin
				-> env.error;
				@( env.error_recorded );
				$display("*** ERROR! *** [%0d] - [PKT %0d]: SENT DATA [%b] DOESN'T MATCH RECEIVED DATA [%b] AT PACKET BYTE # %0d **** :(", $time, pkt_no, env.sent_pkts[i], env.recv_pkts[i], i);
			end
		else
			$display("Success! [%0d] - [PKT %0d]: Sent data [%b] matches received data [%b] at packet byte # %0d :)", $time, pkt_no, env.sent_pkts[i], env.recv_pkts[i], i);
	end
	pkt_no = pkt_no + 1;
end

initial
begin
	$display("******************* Start of testcases ****************");
	env.run();
end

final
	$display("******************** End of testcases *****************");

endmodule : testbench_buffer_overflow
