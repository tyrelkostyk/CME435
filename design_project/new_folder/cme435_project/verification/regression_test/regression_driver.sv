`ifndef DRIVER_SV
`define DRIVER_SV

`include "../verification/regression/regression_transaction.sv"

class driver #(type T=transaction);
  //used to count the number of transactions
  int no_transactions;

  //creating virtual interface handle
  virtual intf.driver vif;

  //creating mailbox handle
  mailbox gen2driv, driv2scb;

  int port_n;

  //constructor
  function new(virtual intf.driver vif, mailbox gen2driv, mailbox driv2scb, int port_n);
    //getting the interface
    this.vif = vif;

    //getting the mailbox handles from environment
    this.gen2driv = gen2driv;
    this.driv2scb = driv2scb;

    this.port_n = port_n;
  endfunction

  //drive the transaction items to interface signals
  task main();
    begin
      T trans_gen, trans_driv;
      gen2driv.get(trans_gen);
      trans_driv = new();

      // get data of packet to be driven
      trans_driv.data_in[(port_n*8) +: 8] = trans_gen.data_in[(port_n*8) +: 8];
      trans_driv.valid_in[port_n] = trans_gen.valid_in[port_n];
      trans_driv.addr_in[(port_n*8) +: 8] = trans_gen.addr_in[(port_n*8) +: 8];
      trans_driv.rcv_rdy[port_n] = vif.rcv_rdy[port_n];

      // send data packet to scoreboard for sanity check
      driv2scb.put(trans_driv);
      trans_driv.display({"[ Driver ", $sformatf("%0d",port_n)," ]"});

      // drive data packet to DUT using the interface
      vif.cb.data_in[(port_n*8) +: 8] <= trans_gen.data_in[(port_n*8) +: 8];
      vif.cb.addr_in[(port_n*8) +: 8] <= trans_gen.addr_in[(port_n*8) +: 8];
      vif.cb.valid_in[port_n] <= trans_gen.valid_in[port_n];

      no_transactions++;
    end
  endtask

endclass

`endif
