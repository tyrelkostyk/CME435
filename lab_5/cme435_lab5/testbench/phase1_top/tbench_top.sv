`include "dut/dut_top.sv"

`ifdef TESTBENCH_SANITY_CHECK
	`include "testbench/phase9_testcases/testbench_sanity_check.sv"
`elsif TESTBENCH_MAX_PAYLOAD
	`include "testbench/phase9_testcases/testbench_MAX_payload.sv"
`elsif TESTBENCH_MIN_PAYLOAD
	`include "testbench/phase9_testcases/testbench_MIN_payload.sv"
`elsif TESTBENCH_BUFFER_OVERFLOW
	`include "testbench/phase9_testcases/testbench_buffer_overflow.sv"
`elsif TESTBENCH_BND_PLSE_COINCIDENCE
	`include "testbench/phase9_testcases/testbench_BND_PLSE_coincidence.sv"
`elsif TESTBENCH_RESET
	`include "testbench/phase9_testcases/testbench_reset.sv"
`else	//DEFAULT
	// `include "testbench/phase9_testcases/testbench_sanity_check.sv"
	`include "testbench/phase9_testcases/testbench_reset.sv"
`endif

`timescale 1ns/1ns

`define VERBOSE 1

module tbench_top;

// clock and reset signal declaration
bit clk;
bit reset;

// clock generation
always #5 clk = ~clk;

// reset Generation
initial begin
  reset = 1;
  #5 reset = 0;
	#5 reset = 1;
end

// creatinng instance of interface, in order to connect DUT and testcase
intf i_intf ( clk, reset );

// Testcase instance, interface handle is passed to test as an argument
testbench test ( i_intf );

// DUT instance, interface signals are connected to the DUT ports
dut_top dut ( i_intf.DUT );

endmodule
