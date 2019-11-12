`include "testbench/phase2_environment/environment.sv"

`timescale 1ns/1ns

// ************************* INSTANTIATIONS ************************* //

program testbench_reset( intf i_intf );

// declaring environment class object instance
environment env;


// *********************** EVENTS AND INTEGERS ********************** //
int test_pkt_count = 100;					// how many packets to generate and send
int test_scb_error_override = 1;	// 1 == ignore scb error counter


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

initial begin
	// instantiate environment object
	env = new( i_intf );
	$display("*************** Start of testbench ***************");

	// global vars go here
	env.gen.pkt_count = test_pkt_count;
	env.scb.scb_error_override = test_scb_error_override;

	fork
		env.run();
		check_reset(env.gen.pkt_count);
	join
end


// ***************************** TASKS ***************************** //

task check_reset( input int pkt_count );
	wait ( i_intf.ack == 1'b1 );

		#5 $root.tbench_top.reset = 1'b0;
		// env.reset();
		#5 $root.tbench_top.reset = 1'b1;

		if ( i_intf.ack != 1'b0 ) begin
			$error("%0d : Testbench : Wrong  Result.\n\tExpeced ACK to be low, but got ACK==%0b.", $time, i_intf.ack);
			env.scb.record_error();
		end
		foreach ( i_intf.newdata_len[i] )
			if ( i_intf.newdata_len[i] != 1'b0 ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced i_intf.newdata_len[i] to be low, but got i_intf.newdata_len[i]==%0b.", $time, i_intf.newdata_len[i]);
				env.scb.record_error();
		end
		foreach ( i_intf.data_out[i] )
			if ( i_intf.data_out[i] != 1'b0 ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced i_intf.data_out[i] to be low, but got i_intf.data_out[i]==%0b.", $time, i_intf.data_out[i]);
				env.scb.record_error();
		end

	@( posedge i_intf.clk );

	wait ( i_intf.newdata_len );

		#5 $root.tbench_top.reset = 1'b0;
		// env.reset();
		#5 $root.tbench_top.reset = 1'b1;

		if ( i_intf.ack != 1'b0 ) begin
			$error("%0d : Testbench : Wrong  Result.\n\tExpeced ACK to be low, but got ACK==%0b.", $time, i_intf.ack);
			env.scb.record_error();
		end
		foreach ( i_intf.newdata_len[i] )
			if ( i_intf.newdata_len[i] != 1'b0 ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced i_intf.newdata_len[i] to be low, but got i_intf.newdata_len[i]==%0b.", $time, i_intf.newdata_len[i]);
				env.scb.record_error();
		end
		foreach ( i_intf.data_out[i] )
			if ( i_intf.data_out[i] != 1'b0 ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced i_intf.data_out[i] to be low, but got i_intf.data_out[i]==%0b.", $time, i_intf.data_out[i]);
				env.scb.record_error();
		end

	@( posedge i_intf.clk );

	wait ( i_intf.data_out );

		#5 $root.tbench_top.reset = 1'b0;
		// env.reset();
		#5 $root.tbench_top.reset = 1'b1;

		if ( i_intf.ack != 1'b0 ) begin
			$error("%0d : Testbench : Wrong  Result.\n\tExpeced ACK to be low, but got ACK==%0b.", $time, i_intf.ack);
			env.scb.record_error();
		end
		foreach ( i_intf.newdata_len[i] )
			if ( i_intf.newdata_len[i] != 1'b0 ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced i_intf.newdata_len[i] to be low, but got i_intf.newdata_len[i]==%0b.", $time, i_intf.newdata_len[i]);
				env.scb.record_error();
		end
		foreach ( i_intf.data_out[i] )
			if ( i_intf.data_out[i] != 1'b0 ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced i_intf.data_out[i] to be low, but got i_intf.data_out[i]==%0b.", $time, i_intf.data_out[i]);
				env.scb.record_error();
		end

	@( posedge i_intf.clk );

	wait ( i_intf.data_out );
		repeat (env.gen.trans_gen.data_in.size/2) @( posedge i_intf.clk );

		#5 $root.tbench_top.reset = 1'b0;
		// env.reset();
		#5 $root.tbench_top.reset = 1'b1;

		if ( i_intf.ack != 1'b0 ) begin
			$error("%0d : Testbench : Wrong  Result.\n\tExpeced ACK to be low, but got ACK==%0b.", $time, i_intf.ack);
			env.scb.record_error();
		end
		foreach ( i_intf.newdata_len[i] )
			if ( i_intf.newdata_len[i] != 1'b0 ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced i_intf.newdata_len[i] to be low, but got i_intf.newdata_len[i]==%0b.", $time, i_intf.newdata_len[i]);
				env.scb.record_error();
		end
		foreach ( i_intf.data_out[i] )
			if ( i_intf.data_out[i] != 1'b0 ) begin
				$error("%0d : Testbench : Wrong  Result.\n\tExpeced i_intf.data_out[i] to be low, but got i_intf.data_out[i]==%0b.", $time, i_intf.data_out[i]);
				env.scb.record_error();
		end

endtask


final
	$display("*************** End of testbench ***************");


endprogram
