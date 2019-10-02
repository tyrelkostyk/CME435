
module up_down_counter (
	data_out,		// data output
	data_in,		// data input
	s_in,				// mode control, 00: preset parallel data input
							// 							 01: increment
							//							 10: decrement
							//							 11: hold
	clk_in,			// clock input
	reset_in		// reset input
);

output [7:0] data_out;
reg [7:0] data_out;

input [7:0] data_in;
input [1:0] s_in;
input clk_in, reset_in;


// data_out control
always @ ( posedge clk_in )

	if ( reset_in )
		// synchronous reset
		data_out = 8'h00;
	else
		case ( s_in )
			2'b00: data_out = data_in;
			2'b01:
				// reset to 0 instead of overflowing to -128
				if ( data_out < 8'd127 )
					data_out = data_out + 8'h01;
				else
					data_out = 8'h00;
			2'b10: data_out = data_out - 8'h01;
			2'b11: data_out = data_out;
		endcase

endmodule
