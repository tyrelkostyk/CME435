`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

`include "../verification/phase3_base/phase3_transaction.sv"

class environment;

  //virtual interface
  virtual intf.driver input_vif;
  virtual intf.monitor output_vif;

  //constructor
  function new(virtual intf.driver input_vif,
               virtual intf.monitor output_vif);
    //get the interface from test
    this.input_vif = input_vif;
    this.output_vif = output_vif;
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
