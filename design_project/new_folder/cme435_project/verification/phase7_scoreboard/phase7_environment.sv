`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

`include "../verification/phase7_scoreboard/phase7_transaction.sv"
`include "../verification/phase7_scoreboard/phase7_generator.sv"
`include "../verification/phase7_scoreboard/phase7_driver.sv"
`include "../verification/phase7_scoreboard/phase7_monitor.sv"
`include "../verification/phase7_scoreboard/phase7_scoreboard.sv"

class environment;
  //generator, driver instance
  generator gen;
  driver driv[4];
  monitor mon[4];
  scoreboard scb;

  //mailbox handles
  mailbox gen2driv[4], mon2scb[4], driv2scb[4];

  //virtual interface
  virtual intf.driver input_vif;
  virtual intf.monitor output_vif;

  //constructor
  function new(virtual intf.driver input_vif,
               virtual intf.monitor output_vif);
    //get the interface from test
    this.input_vif = input_vif;
    this.output_vif = output_vif;

    //creating the mailbox (Same handle will be shared across generator, driver, monitor, scoreboard)
    foreach(gen2driv[i]) gen2driv[i]= new();
    foreach(driv2scb[i]) driv2scb[i]= new();
    foreach(mon2scb[i]) mon2scb[i]= new();

    //creating generator, driver, monitor, scoreboard
    gen = new(input_vif,gen2driv);
    foreach(driv[i]) this.driv[i] = new(input_vif,gen2driv[i],driv2scb[i],i);
    foreach(mon[i]) this.mon[i] = new(output_vif,mon2scb[i],i);
    scb = new(output_vif,mon2scb,driv2scb);
  endfunction

  task pre_test();
    $display("%0d : Environment : start of pre_test()", $time);
    reset();
    $display("%0d : Environment : end of pre_test()", $time);
  endtask

  task reset();
    wait(input_vif.reset);
    $display("[ ENVIRONMENT ] ----- Reset Started -----");

    input_vif.data_in <= 0;
    input_vif.addr_in <= 0;
    input_vif.valid_in <= 0;
    output_vif.data_rd <= 0;

    wait(!input_vif.reset);
    $display("[ ENVIRONMENT ] ----- Reset Ended -----");
  endtask

  task test();
    $display("%0d : Environment : start of test()", $time);
    $display("%0d : Environment : end of test()", $time);
  endtask

  task post_test();
    transaction empty;
    $display("%0d : Environment : start of post_test()", $time);

    repeat(gen.repeat_count)
    begin
      fork
        gen.main();
        driv[0].main();
        driv[1].main();
        driv[2].main();
        driv[3].main();
        mon[0].main();
        mon[1].main();
        mon[2].main();
        mon[3].main();
        scb.main();
      join
      // clear unused mailboxes
      foreach(driv2scb[i]) if(driv2scb[i].num > 0) driv2scb[i].get(empty);
    end

    wait((gen.repeat_count*4) == (driv[0].no_transactions+
                                  driv[1].no_transactions+
                                  driv[2].no_transactions+
                                  driv[3].no_transactions));
    wait((gen.repeat_count*4) == scb.no_transactions);
    
    $display("ERRORS FROM SCOREBOARD = %0d", scb.scb_errors);
    $display("%0d : Environment : end of post_test()", $time);
  endtask

  //run task
  task run;
    $display("%0d : Environment : start of run()", $time);
    pre_test();
    test();
    post_test();
    $display("%0d : Environment : end of run()", $time);
    $finish;
  endtask

endclass

`endif