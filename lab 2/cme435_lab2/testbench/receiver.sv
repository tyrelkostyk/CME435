module receiver(clk, data, ready, read, port);

input clk;
input [7:0] data;
input ready;
input port;

output read;

reg read;
wire [7:0] port;

reg [0:7] mem [0:259];		// local memory for storing input (DUT output) data
integer j, delay;

// start collecting packet
always @( posedge ready )
begin
	if ( $root.tbench_top.test.oversized_delay == 1)
		delay = {$random}%30+1;
	else
		delay = {$random}%5+1;

	repeat( delay )
		@( negedge clk );

	j = 0;

	@( negedge clk );

	read = 1'b1;
	while ( ready == 1'b1 )
		begin
			@( negedge clk);
			mem[j] = data;	// this is received data

			// send received data / port to environment for verification
			$root.tbench_top.test.env.recv_pkts[j] = data;
			$root.tbench_top.test.env.recv_ports[j] = port;

			j = j+1;
			$display(" RECV BYTE at PORT[%d] %b", port, data);
		end

	read = 1'b0;

end


endmodule : receiver
