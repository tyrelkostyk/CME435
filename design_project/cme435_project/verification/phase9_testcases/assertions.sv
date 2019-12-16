`ifndef ASSERTIONS_SV
`define ASSERTIONS_SV

module assertions( interface i_intf );

property p_valid_data_in_match_data_out( port );
  disable iff ( i_intf.reset )
  @( posedge i_intf.clk )
  i_intf.valid_in[port] |->
		( ( i_intf.data_in[(port*8)+:8] == i_intf.data_out[ ( i_intf.addr_in[(port*8)+:8] )*8 +: 8 ] )
		&& ( i_intf.valid_out[ i_intf.addr_in[(port*8)+:8] ] ) );
endproperty

a_valid_data_in_match_data_out_PORT1: assert property ( p_valid_data_in_match_data_out(1) )
else
	$display("##### %0t : Assertion Failed : a_valid_data_in_match_data_out_PORT1 #####", $time);
c_valid_data_in_match_data_out_PORT1: cover property ( p_valid_data_in_match_data_out(1) );

endmodule

`endif
