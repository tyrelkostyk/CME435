`ifndef ASSERTIONS_SV
`define ASSERTIONS_SV

module assertions( interface i_intf );

/********** ASSERT : valid_in overlaps with data_out macthing data_in **********/

/* Every posedge clk, if valid_in for a particular port is high, the data_out port
on the addressed port should match the data_in value from the original port */
property p_valid_data_in_match_data_out( port );
  disable iff ( i_intf.reset )
  @( posedge i_intf.clk )
  i_intf.valid_in[port] |->
		( i_intf.data_in[(port*8)+:8] == i_intf.data_out[ ( i_intf.addr_in[(port*8)+:8] )*8 +: 8 ] );
endproperty

// Port 1
a_valid_data_in_match_data_out_PORT1: assert property ( p_valid_data_in_match_data_out(1) )
else
	$display("##### %0t : Assertion Failed : a_valid_data_in_match_data_out_PORT1 #####", $time);
c_valid_data_in_match_data_out_PORT1: cover property ( p_valid_data_in_match_data_out(1) );

// Port 2
a_valid_data_in_match_data_out_PORT2: assert property ( p_valid_data_in_match_data_out(2) )
else
	$display("##### %0t : Assertion Failed : a_valid_data_in_match_data_out_PORT2 #####", $time);
c_valid_data_in_match_data_out_PORT2: cover property ( p_valid_data_in_match_data_out(2) );

// Port 3
a_valid_data_in_match_data_out_PORT3: assert property ( p_valid_data_in_match_data_out(3) )
else
	$display("##### %0t : Assertion Failed : a_valid_data_in_match_data_out_PORT3 #####", $time);
c_valid_data_in_match_data_out_PORT3: cover property ( p_valid_data_in_match_data_out(3) );

// Port 4
a_valid_data_in_match_data_out_PORT4: assert property ( p_valid_data_in_match_data_out(4) )
else
	$display("##### %0t : Assertion Failed : a_valid_data_in_match_data_out_PORT4 #####", $time);
c_valid_data_in_match_data_out_PORT5: cover property ( p_valid_data_in_match_data_out(4) );


/************** ASSERT : valid_in overlaps with macthing valid_out **************/

/* Every posedge clk, if valid_in for a particular port is high, the valid_out
signal on the addressed port should also be high */
property p_valid_in_match_valid_out( port );
  disable iff ( i_intf.reset )
  @( posedge i_intf.clk )
  i_intf.valid_in[port] |-> ( i_intf.valid_out[ i_intf.addr_in[(port*8)+:8] ] );
endproperty

// Port 1
a_valid_in_match_valid_out_PORT1: assert property ( p_valid_in_match_valid_out(1) )
else
	$display("##### %0t : Assertion a_valid_in_match_valid_out_PORT1 Failed #####", $time);
c_valid_in_match_valid_out_PORT1: cover property ( p_valid_in_match_valid_out(1) );

// Port 2
a_valid_in_match_valid_out_PORT2: assert property ( p_valid_in_match_valid_out(2) )
else
	$display("##### %0t : Assertion a_valid_in_match_valid_out_PORT2 Failed #####", $time);
c_valid_in_match_valid_out_PORT2: cover property ( p_valid_in_match_valid_out(2) );

// Port 3
a_valid_in_match_valid_out_PORT3: assert property ( p_valid_in_match_valid_out(3) )
else
	$display("##### %0t : Assertion a_valid_in_match_valid_out_PORT3 Failed #####", $time);
c_valid_in_match_valid_out_PORT3: cover property ( p_valid_in_match_valid_out(3) );

// Port 4
a_valid_in_match_valid_out_PORT4: assert property ( p_valid_in_match_valid_out(4) )
else
	$display("##### %0t : Assertion a_valid_in_match_valid_out_PORT4 Failed #####", $time);
c_valid_in_match_valid_out_PORT4: cover property ( p_valid_in_match_valid_out(4) );


/******* ASSERT : reset signal high should drive dut output signals to Z *******/

sequence s_reset_data_out_high_imp;
	i_intf.data_out	=== 32'hZZZZZZZZ;
endsequence

sequence s_reset_addr_out_high_imp;
	i_intf.addr_out	=== 32'hZZZZZZZZ;
endsequence

sequence s_reset_valid_out_zero;
	i_intf.valid_out	=== 4'h0;
endsequence

property p_reset_data_out_high_imp;
  @( posedge i_intf.clk ) i_intf.reset |-> s_reset_data_out_high_imp;
endproperty

property p_reset_addr_out_high_imp;
  @( posedge i_intf.clk ) i_intf.reset |-> s_reset_addr_out_high_imp;
endproperty

property p_reset_valid_out_zero;
  @( posedge i_intf.clk ) i_intf.reset |-> s_reset_valid_out_zero;
endproperty

a_reset_data_out_high_imp: assert property ( p_reset_data_out_high_imp )
else
	$display("##### %0t : Assertion *** a_reset_data_out_high_imp *** Failed #####", $time);
c_reset_data_out_high_imp: cover property ( p_reset_data_out_high_imp );

a_reset_addr_out_high_imp: assert property ( p_reset_addr_out_high_imp )
else
	$display("##### %0t : Assertion *** a_reset_addr_out_high_imp *** Failed #####", $time);
c_reset_addr_out_high_imp: cover property ( p_reset_addr_out_high_imp );

a_reset_valid_out_zero: assert property ( p_reset_valid_out_zero )
else
	$display("##### %0t : Assertion *** a_reset_valid_out_zero *** Failed #####", $time);
c_reset_valid_out_zero: cover property ( p_reset_valid_out_zero );


endmodule
`endif
