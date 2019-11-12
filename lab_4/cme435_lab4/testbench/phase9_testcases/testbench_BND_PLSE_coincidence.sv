`include "testbench/phase2_environment/environment.sv"

program testbench_BND_PLSE_coincidence( intf i_intf );

// declaring environment class object instance
environment env;

initial begin
	// instantiate environment object
	env = new( i_intf );
	$display("*************** Start of testbench ***************");

	// global envs go here
	env.gen.pkt_count = 1000;		// how many packets to generate and send

	fork
		env.run();
		check_BND_PLSE(env.gen.pkt_count);
	join
end

task check_BND_PLSE( input int pkt_count );
	repeat( pkt_count ) begin
		wait ( i_intf.bnd_plse == 1'b1 );
			if ( i_intf.data_in != env.gen.trans_gen.dest_addr ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced env.gen.trans_gen.dest_addr==%0d, but got data_in==%0d.", $time, env.gen.trans_gen.dest_addr, i_intf.data_in);
				env.scb.record_error();
			end
			// else
				// $display("%0d : Testbench : Correct Result! data_in is %0d", $time, i_intf.data_in);

		@( posedge i_intf.clk );

		wait ( i_intf.bnd_plse == 1'b1 );
			if ( i_intf.data_in != env.gen.trans_gen.data_in[env.gen.trans_gen.data_in.size-1] ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced env.gen.trans_gen.data_in[%0d]==%0d, but got data_in==%0d.", $time, env.gen.trans_gen.data_in.size-1,env.gen.trans_gen.data_in[env.gen.trans_gen.data_in.size-1], i_intf.data_in);
				env.scb.record_error();
			end
			// else
				// $display("%0d : Testbench : Correct Result! data_in is %0d", $time, i_intf.data_in);

		@( posedge i_intf.clk );

	end
endtask


final
	$display("*************** End of testbench ***************");


endprogram
