`ifndef COVERAGE_SV
`define COVERAGE_SV

`include "../verification/phase8_coverage/phase8_transaction.sv"

class coverage;
  transaction trans;

  covergroup driv_cg;
    port_0_address : coverpoint trans.addr_in[7:0] {
      bins port_0 = {0};
      bins port_1 = {1};
      bins port_2 = {2};
      bins port_3 = {3};
    }
    port_1_address : coverpoint trans.addr_in[15:8] {
      bins port_0 = {0};
      bins port_1 = {1};
      bins port_2 = {2};
      bins port_3 = {3};
    }
    port_2_address : coverpoint trans.addr_in[23:16] {
      bins port_0 = {0};
      bins port_1 = {1};
      bins port_2 = {2};
      bins port_3 = {3};
    }
    port_3_address : coverpoint trans.addr_in[31:24] {
      bins port_0 = {0};
      bins port_1 = {1};
      bins port_2 = {2};
      bins port_3 = {3};
    }
    port_0_data : coverpoint trans.data_in[7:0] {
      bins low = {[0:50]};
      bins med = {[51:150]};
      bins high = {[151:255]};
    }
    port_1_data : coverpoint trans.data_in[15:8] {
      bins low = {[0:50]};
      bins med = {[51:150]};
      bins high = {[151:255]};
    }
    port_2_data : coverpoint trans.data_in[23:16] {
      bins low = {[0:50]};
      bins med = {[51:150]};
      bins high = {[151:255]};
    }
    port_3_data : coverpoint trans.data_in[31:24] {
      bins low = {[0:50]};
      bins med = {[51:150]};
      bins high = {[151:255]};
    }
  endgroup

  function new();
    driv_cg = new();
  endfunction : new

  task sample(transaction trans);
    this.trans = trans;
    driv_cg.sample();
  endtask : sample

endclass

`endif
