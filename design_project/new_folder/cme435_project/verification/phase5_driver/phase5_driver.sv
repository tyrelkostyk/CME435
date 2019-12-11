`ifndef DRIVER_SV
`define DRIVER_SV

`include "../verification/phase5_driver/phase5_transaction.sv"

class driver;
  //used to count the number of transactions
  int no_transactions;

  //creating virtual interface handle
  virtual intf.driver vif;

  //creating mailbox handle
  mailbox gen2driv;

  int port_n;

  //constructor
  function new(virtual intf.driver vif, mailbox gen2driv, int port_n);
    //getting the interface
    this.vif = vif;

    //getting the mailbox handles from environment
    this.gen2driv = gen2driv;

    this.port_n = port_n;
  endfunction

  //drive the transaction items to interface signals
  task main();
    forever
    begin
      transaction trans;
      gen2driv.get(trans);

      case(port_n)
        2'd0: vif.cb.data_in[7:0] = trans.data_in[7:0];
        2'd1: vif.cb.data_in[15:8] = trans.data_in[15:8];
        2'd2: vif.cb.data_in[23:16] = trans.data_in[23:16];
        2'd3: vif.cb.data_in[31:24] = trans.data_in[31:24];
      endcase

      case(port_n)
        2'd0: vif.cb.addr_in[7:0] = trans.addr_in[7:0];
        2'd1: vif.cb.addr_in[15:8] = trans.addr_in[15:8];
        2'd2: vif.cb.addr_in[23:16] = trans.addr_in[23:16];
        2'd3: vif.cb.addr_in[31:24] = trans.addr_in[31:24];
      endcase

      case(port_n)
        2'd0: vif.cb.valid_in[0] = trans.valid_in[0];
        2'd1: vif.cb.valid_in[1] = trans.valid_in[1];
        2'd2: vif.cb.valid_in[2] = trans.valid_in[2];
        2'd3: vif.cb.valid_in[3] = trans.valid_in[3];
      endcase

      @(posedge vif.cb);
      trans.display({"[ Driver ", $sformatf("%0d",port_n),"]"});
      no_transactions++;
    end
  endtask

endclass

`endif
