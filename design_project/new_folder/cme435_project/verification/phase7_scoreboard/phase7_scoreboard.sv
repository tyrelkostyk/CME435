`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`include "../verification/phase7_scoreboard/phase7_transaction.sv"

class scoreboard;
  //creating mailbox handle
  mailbox mon2scb[4], driv2scb[4];

  transaction trans_driv[4], trans_mon[4];

  //count the number of transactions
  int no_transactions;

  virtual intf.monitor vif;

  integer scb_errors = 0;

  //constructor
  function new(virtual intf.monitor vif, mailbox mon2scb[4], mailbox driv2scb[4]);
    this.vif = vif;

    //getting the mailbox handles from environment
    foreach(mon2scb[i])
      this.mon2scb[i] = mon2scb[i];

    foreach(driv2scb[i])
      this.driv2scb[i] = driv2scb[i];
  endfunction

  task port(int i);
    int driv_port;
    begin
      mon2scb[i].get(trans_mon[i]);
      trans_mon[i].display({"[ Scoreboard - Monitor ", $sformatf("%0d",i), " ]"});
      driv_port = trans_mon[i].addr_in[(i*8) +: 8];

      // check if mailbox isn't empty and data at the respective port is valid
      if(driv2scb[driv_port].num > 0 && trans_mon[i].valid_in[i])
      begin
        driv2scb[driv_port].get(trans_driv[driv_port]);
        trans_driv[driv_port].display({"[ Scoreboard - Driver ", $sformatf("%0d",driv_port)," ]"});

        // check if the driven data matches the received data from the respective ports
        if (trans_mon[i].data_in[(i*8) +: 8] != trans_driv[driv_port].data_in[(driv_port*8)  +: 8])
        begin
          scb_errors++;
          $display("ERROR: Data received at Monitor %0d does not match", i);
        end

        // check if the port addresses for where the data was driven to and the current port matches
        if (trans_driv[driv_port].addr_in[(driv_port*8) +: 8] != i)
        begin
          scb_errors++;
          $display("ERROR: Data driven by Driver %d was not received at the correct port", driv_port);
        end
      end
      else
      begin
        // if mailbox is empty but data at the respective port is valid,
        // then data was received even though it was never driven
        if (trans_mon[i].valid_in[i])
        begin
          scb_errors++;
          $display("ERROR: Monitor %0d received packet that was never driven", i);
        end
      end

      no_transactions++;
    end
  endtask

  //Compares the actual result with the expected result
  task main;
    fork
      port(0);
      port(1);
      port(2);
      port(3);
    join
  endtask

endclass

`endif
