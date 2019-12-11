`timescale 1ns/1ns

`ifdef SANITY
  `include "../verification/phase9_testcases/phase9_testbench_sanity.sv"
`elsif  BUFFER
  `include "../verification/phase9_testcases/phase9_testbench_buffer.sv"
`elsif  MAX_PAYLOAD
  `include "../verification/phase9_testcases/phase9_testbench_max_payload.sv"
`elsif  MIN_PAYLOAD
  `include "../verification/phase9_testcases/phase9_testbench_min_payload.sv"
`else
  `include "../verification/phase9_testcases/phase9_testbench_sanity.sv"
`endif

`include "../verification/phase9_testcases/phase9_assertions.sv"

`ifndef TBENCH_TOP_SV
`define TBENCH_TOP_SV

module tbench_top;
  //clock and reset signal declaration
  bit clk;
  bit reset;

  //clock generation
  always #5 clk = ~clk;

  //reset Generation
  initial begin
    reset = 1;
    #7 reset = 0;
    #25 reset = 1;
    #5 reset = 0;
  end

  //creatinng instance of interface, inorder to connect DUT and testcase
  intf i_intf(clk, reset);

  //Testcase instance, interface handle is passed to test as an argument
  testbench t1(i_intf);

  //DUT instance, interface signals are connected to the DUT ports
  dut_top dut(i_intf.dut);

  bind dut_top assertions u_dut_assertion(.i_intf(i_intf));

  //enabling the wave dump
  initial begin
  $dumpfile("dump.vcd"); $dumpvars;
  end

endmodule

`endif
