`include "testbench/phase9_testcases/testbench_sanity_check.sv"
`include "testbench/phase9_testcases/testbench_MAX_payload.sv"
`include "testbench/phase9_testcases/testbench_MIN_payload.sv"
`include "testbench/phase9_testcases/testbench_buffer_overflow.sv"
`include "testbench/phase9_testcases/testbench_BND_PLSE_coincidence.sv"
`include "testbench/phase9_testcases/testbench_reset.sv"

`timescale 1ns/1ns

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
testbench_sanity_check test ( i_intf );
// testbench_MAX_payload test ( i_intf );
// testbench_MIN_payload test ( i_intf );
// testbench_buffer_overflow test ( i_intf );
// testbench_BND_PLSE_coincidence test ( i_intf );
// testbench_reset test ( i_intf );

// DUT instance, interface signals are connected to the DUT ports
dut_top dut ( i_intf.DUT );

endmodule
