`include "dut/pdm_core.svp"

module dut_top ( interface i_intf );

// Core Instance
pdm_core pdm_core_i (
   .clk( i_intf.clk ),
   .rst_b( i_intf.reset ),
   .bnd_plse( i_intf.cb_dut.bnd_plse ),
   .data_in( i_intf.cb_dut.data_in ),
   .ack( i_intf.cb_dut.ack ),
   .newdata_len_1( i_intf.cb_dut.newdata_len_1 ),
   .proceed_1( i_intf.cb_dut.proceed_1 ),
   .data_out_1( i_intf.cb_dut.data_out_1 ),
   .newdata_len_2( i_intf.cb_dut.newdata_len_2 ),
	 .proceed_2( i_intf.cb_dut.proceed_2 ),
   .data_out_2( i_intf.cb_dut.data_out_2 ),
   .newdata_len_3( i_intf.cb_dut.newdata_len_3 ),
   .proceed_3( i_intf.cb_dut.proceed_3 ),
   .data_out_3( i_intf.cb_dut.data_out_3 ),
	 .newdata_len_4( i_intf.cb_dut.newdata_len_4 ),
   .proceed_4( i_intf.cb_dut.proceed_4 ),
   .data_out_4( i_intf.cb_dut.data_out_4 )
);

endmodule
