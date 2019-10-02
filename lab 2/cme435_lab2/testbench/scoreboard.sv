module scoreboard ();

// memory for received packets
reg [0:7] sent_pkt [0:258][0:20];

integer pkt_no;

initial
pkt_no = 0;

// task to add packets to scoreboard
task add_pkt( input integer pkt_no );
	integer i;

	begin
		for ( i=0; i<258; i=i+1 )
			sent_pkt[i][pkt_no] = $root.tbench_top.test.env.gen.pkt[i];
	end

endtask


endmodule : scoreboard
