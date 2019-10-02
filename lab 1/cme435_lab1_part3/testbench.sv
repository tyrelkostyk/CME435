
module testbench (
	UDC_output,		// output data from the up down counter
	UDC_input,		// input data being simulated and sent to the up down counter
	s_out,				// simulated mode control being sent to the up down counter,
								// 							 00: preset parallel data input
								// 							 01: increment
								//							 10: decrement
								//							 11: hold
	clk_in,				// clock input
	reset_in			// reset input
);

output reg [7:0] UDC_input;
output reg [1:0] s_out;

input [7:0] UDC_output;
input clk_in, reset_in;


// Set initial values
initial
  begin
	$display("********** TestBench Initializes Here! **********");
		// initially, just count up from 0
    s_out = 2'b01;
		UDC_input = 8'h00;
  end

initial begin

	repeat(128) begin
		@( posedge clk_in );
	end

	// TEST CASE 1: TEST COUNTING UP //
	// t = 256us, count = 127
	@( negedge clk_in) assert ( UDC_output == 8'd127 )
		else $error("TEST CASE 1: UDC_output at time 256us was %0d, not 127.", UDC_output);

	// TEST CASE 2: TEST OVERFLOW //
	// t = 258us, count = 0 (after overflow)
	@( negedge clk_in) assert ( UDC_output == 8'd0 )
		else $error("TEST CASE 2: UDC_output at time 258us was %0d, not 0.", UDC_output);

	repeat(100) begin
		@( posedge clk_in );
	end

	// TEST CASE 3: TEST COUNTING UP (AGAIN) //
	// t = 458us, count = 100
	@( negedge clk_in) assert ( UDC_output == 8'd100 )
		else $error("TEST CASE 3: UDC_output at time 458us was %0d, not 100.", UDC_output);

	// start decrementing
	s_out = 2'b10;

	repeat(25) begin
		@( posedge clk_in );
	end

	// TEST CASE 4: TEST COUNTING DOWN //
	// t = 508us, count = 75 (decremented 25 from 100)
	@( negedge clk_in) assert ( UDC_output == 8'd75 )
		else $error("TEST CASE 4: UDC_output at time 508us was %0d, not 75.", UDC_output);

	// wait
	s_out = 2'b11;

	repeat(20) begin
		@( posedge clk_in );
	end

	// TEST CASE 5: TEST HOLDING //
	// t = 548us, count = 75 (after holding)
	@( negedge clk_in) assert ( UDC_output == 8'd75 )
		else $error("TEST CASE 5: UDC_output at time 548us was %0d, not 75.", UDC_output);

	repeat(10) begin
		@( posedge clk_in );
	end

	// TEST CASE 6: TEST RESET //
	// t = 568us, count = 0 (after reset @ t = 550)
	@( negedge clk_in) assert ( UDC_output == 8'd0 )
		else $error("TEST CASE 6: UDC_output at time 568us was %0d, not 0.", UDC_output);

	// reset goes low at t = 600us; s_out is still 2'b11 (hold)
	repeat(41) begin
		@( posedge clk_in );
	end

	// TEST CASE 7: TEST HOLDING AFTER RESET //
	// t = 650us, count = 0 (after reset and holding)
	@( negedge clk_in) assert ( UDC_output == 8'd0 )
		else $error("TEST CASE 7: UDC_output at time 650us was %0d, not 0.", UDC_output);

	// load data in
	UDC_input = 8'd100;
	s_out = 2'b00;

	// TEST CASE 8: TEST LOADING IN DATA //
	// t = 652us, count = 100 (after loading in preset value)
	@( negedge clk_in) assert ( UDC_output == 8'd100 )
		else $error("TEST CASE 8: UDC_output at time 652us was %0d, not 100.", UDC_output);


	$display("********** Successfully finished testbench! **********");
	$display("********** If no errors were reported above this line, all tests have passed Successfully! **********");

end




endmodule
