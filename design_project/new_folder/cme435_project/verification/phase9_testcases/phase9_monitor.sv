`ifndef MONITOR_SV
`define MONITOR_SV

`include "../verification/phase9_testcases/phase9_transaction.sv"

class monitor #(type T=transaction);
  //creating virtual interface handle
  virtual intf.monitor vif;

  mailbox mon2scb;

  int port_n;

  //constructor
  function new(virtual intf.monitor vif, mailbox mon2scb, int port_n);
    //getting the interface
    this.vif = vif;

    this.mon2scb = mon2scb;

    this.port_n = port_n;
  endfunction

  task main();
    begin
      T trans;
      trans = new();

      @(negedge vif.clk); // allow time for DUT to produce outputs
      trans.data_in[(port_n*8) +: 8] = vif.data_out[(port_n*8) +: 8];
      trans.addr_in[(port_n*8) +: 8] = vif.addr_out[(port_n*8) +: 8];
      trans.valid_in[port_n] = vif.valid_out[port_n];

      // send data packet to scoreboard for sanity check
      mon2scb.put(trans);
      trans.display({"[ Monitor ", $sformatf("%0d",port_n)," ]"});

      // send aknowledgement to DUT that output data was read
      vif.data_rd[port_n] = vif.valid_out[port_n];
    end
  endtask

endclass

`endif
