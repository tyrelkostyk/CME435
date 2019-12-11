`ifndef INTERFACE_SV
`define INTERFACE_SV

interface intf(input logic clk, reset);

  logic [31:0] data_in, data_out, addr_in, addr_out;
  logic [3:0] valid_in, valid_out, rcv_rdy, data_rd;

  clocking cb@(posedge clk);
      output data_in;
      output addr_in;
      output valid_in;
      output data_rd;
  endclocking

  modport driver(clocking cb, input clk, output reset, input rcv_rdy,
                 output data_in, output addr_in, output valid_in);

  modport monitor(clocking cb, input clk, input reset,
                  input data_out, input addr_out, input valid_out,
                  output data_rd);

  modport dut(clocking cb, input clk, input reset,
              input addr_in, input data_in, input valid_in, output rcv_rdy,
              output addr_out, output data_out, output valid_out, input data_rd);

endinterface

`endif
