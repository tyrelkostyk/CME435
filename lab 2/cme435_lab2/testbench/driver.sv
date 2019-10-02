module driver(clock, packet_valid, data, busy);

input busy;
input clock;

output reg packet_valid;
output reg [7:0] data;


// define a task to generate packets and call the drive task
task gen_and_drive( input integer no_of_pkts );
	integer i;
	integer delay;

	begin
		for ( i=0; i<no_of_pkts; i=i+1 )
			begin
				delay = {$random()}%4;
				$display("DRIVER gen and drive pkt_no = %d delay %d", i, delay);

				repeat (delay)
					@( negedge clock );

				gen.randomize();			// randomize the packet
				gen.packing(); 				// pack the packet
				drive_packet();				// call the drive_packet task
			end
	end
endtask


task drive_packet();
	integer i;

	begin
		$display("DRIVER Starting to drive packet to port %0d len %0d ", gen.Da, gen.len);

		repeat (4)
			@( negedge clock );

		for ( i=0; i<gen.len+4; i=i+1)
			begin
				@( negedge clock );
				packet_valid = 1;
				data[7:0] = gen.pkt[i];			// fill output data packet with generated packet
				$display("[DRIVER] data %b at i %d", gen.pkt[i], i);

				// sb.sent_pkt[i] = gen.pkt[i]	// record generated (sent) packet in scoreboard

				// send sent data / port to environment for verification
				$root.tbench_top.test.env.sent_pkts[i] = gen.pkt[i];
				$root.tbench_top.test.env.sent_ports[i] = gen.rand_port;
			end

			@( negedge clock );

			packet_valid = 0;

			@( negedge clock );
	end
endtask


endmodule : driver
