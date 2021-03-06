`include "dut/pdm_core.svp"

module dut_top ( interface i_intf );

// Core Instance
pdm_core pdm_core_i (
   .clk( i_intf.clk ),
   .rst_b( i_intf.reset ),
   .bnd_plse( i_intf.bnd_plse ),
   .data_in( i_intf.data_in ),
   .ack( i_intf.ack ),
   .newdata_len_1( i_intf.newdata_len[1] ),
   .proceed_1( i_intf.proceed_1 ),
   .data_out_1( i_intf.data_out[1] ),
   .newdata_len_2( i_intf.newdata_len[2] ),
	 .proceed_2( i_intf.proceed_2 ),
   .data_out_2( i_intf.data_out[2] ),
   .newdata_len_3( i_intf.newdata_len[3] ),
   .proceed_3( i_intf.proceed_3 ),
   .data_out_3( i_intf.data_out[3] ),
	 .newdata_len_4( i_intf.newdata_len[4] ),
   .proceed_4( i_intf.proceed_4 ),
   .data_out_4( i_intf.data_out[4] )
);

endmodule
