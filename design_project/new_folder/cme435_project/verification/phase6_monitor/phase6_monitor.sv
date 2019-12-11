`ifndef MONITOR_SV
`define MONITOR_SV

`include "../verification/phase6_monitor/phase6_transaction.sv"

class monitor;
  //creating virtual interface handle
  virtual intf.monitor vif;

  int port_n;

  //constructor
  function new(virtual intf.monitor vif, int port_n);
    //getting the interface
    this.vif = vif;

    this.port_n = port_n;
  endfunction

  task main();
  forever begin
    transaction trans;
    trans = new();

    @(vif.cb);
    case(port_n)
      2'd0: vif.cb.data_rd[0] <= 0;
      2'd1: vif.cb.data_rd[1] <= 0;
      2'd2: vif.cb.data_rd[2] <= 0;
      2'd3: vif.cb.data_rd[3] <= 0;
    endcase

    case(port_n)
      2'd0: wait(vif.valid_out[0]);
      2'd1: wait(vif.valid_out[1]);
      2'd2: wait(vif.valid_out[2]);
      2'd3: wait(vif.valid_out[3]);
    endcase

    case(port_n)
      2'd0: trans.data_in[7:0] = vif.data_out[7:0];
      2'd1: trans.data_in[15:8] = vif.data_out[15:8];
      2'd2: trans.data_in[23:16] = vif.data_out[23:16];
      2'd3: trans.data_in[31:24] = vif.data_out[31:24];
    endcase

    case(port_n)
      2'd0: trans.addr_in[7:0] = vif.addr_out[7:0];
      2'd1: trans.addr_in[15:8] = vif.addr_out[15:8];
      2'd2: trans.addr_in[23:16] = vif.addr_out[23:16];
      2'd3: trans.addr_in[31:24] = vif.addr_out[31:24];
    endcase

    @(vif.cb);
    case(port_n)
      2'd0: vif.cb.data_rd[0] <= 1;
      2'd1: vif.cb.data_rd[1] <= 1;
      2'd2: vif.cb.data_rd[2] <= 1;
      2'd3: vif.cb.data_rd[3] <= 1;
    endcase

    trans.display({"[ Monitor ", $sformatf("%0d",port_n)," ]"});
  end
  endtask

endclass

`endif
