`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

`include "../verification/phase6_monitor/phase6_transaction.sv"
`include "../verification/phase6_monitor/phase6_generator.sv"
`include "../verification/phase6_monitor/phase6_driver.sv"
`include "../verification/phase6_monitor/phase6_monitor.sv"

class environment;
  //generator, driver instance
  generator gen;
  driver driv[4];
  monitor mon[4];

  //mailbox handles
  mailbox gen2driv[4];

  //virtual interface
  virtual intf.driver input_vif;
  virtual intf.monitor output_vif;

  //constructor
  function new(virtual intf.driver input_vif,
               virtual intf.monitor output_vif);
    //get the interface from test
    this.input_vif = input_vif;
    this.output_vif = output_vif;

    //creating the mailbox (Same handle will be shared across generator, driver)
    foreach(gen2driv[i])
      gen2driv[i]= new();

    //creating generator, driver, monitor
    gen = new(input_vif,gen2driv);
    foreach(gen2driv[i])
      this.driv[i] = new(input_vif,gen2driv[i],i);
    foreach(mon[i])
      this.mon[i] = new(output_vif,i);
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
    $display("%0d : Environment : start of post_test()", $time);
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
    join_any
    wait(gen.ended.triggered); // optional
    wait(gen.repeat_count == driv[0].no_transactions ||
         gen.repeat_count == driv[1].no_transactions ||
         gen.repeat_count == driv[2].no_transactions ||
         gen.repeat_count == driv[3].no_transactions);
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
