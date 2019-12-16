`include "dut/dut_top.sv"
`include "assertions.sv"

module tbench_top;

// clock and reset signal declaration
bit clk;
bit reset;

// clock generation
always #5 clk = ~clk;

// reset Generation
initial begin
  reset = 0;
  #5 reset = 1;
	#5 reset = 0;
end

// creatinng instance of interface, in order to connect DUT and testcase
intf i_intf ( clk, reset );

// Testcase instance, interface handle is passed to test as an argument
testbench test ( i_intf );

// DUT instance, interface signals are connected to the DUT ports
dut_top dut ( i_intf.DUT );

bind dut_top assertions assert_dut( i_intf );

endmodule
