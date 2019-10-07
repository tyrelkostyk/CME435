`include "interface.sv"
`include "testbench.sv"

module tbench_top;

// clock and reset signal declaration
bit clk;
bit reset;

// clock generation
always #5 clk = ~clk;

// reset Generation
initial begin
  reset = 1;
  #5 reset =0;
end

// creatinng instance of interface, inorder to connect DUT and testcase
intf i_intf ( clk, reset );

// Testcase instance, interface handle is passed to test as an argument
testbench t1 ( i_intf );

// DUT instance, interface signals are connected to the DUT ports
dut_top dut ( i_intf );

endmodule
