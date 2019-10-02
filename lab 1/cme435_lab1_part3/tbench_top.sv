
`timescale 1us / 1us

module tbench_top;

// create the clock and reset lines
reg clk, reset;

// create the simulated lines (from testbench, into up down counter)
wire [7:0] UDC_output, UDC_input;
wire [1:0] sel;

// instantiate up down counter
up_down_counter UDC_DUT (.data_out(UDC_output),
												 .data_in(UDC_input),
												 .s_in(sel),
												 .clk_in(clk),
												 .reset_in(reset));

// instantiate testbench
testbench testbench (.UDC_output(UDC_output),
										 .UDC_input(UDC_input),
										 .s_out(sel),
										 .clk_in(clk),
										 .reset_in(reset));

// posedge clk signal every full clock cycle
initial
  begin
    clk = 0;
    forever #0.5 clk = ~clk;
  end

initial	// Test stimulus
  begin
		// t = 0us
    reset = 0;

		repeat(275) begin
			@( posedge clk );
		end

		// t = 550us
		@( negedge clk ) reset = 1;

		repeat(25) begin
			@( posedge clk );
		end

		// t = 600us
		@( negedge clk ) reset = 0;

  end

endmodule
