`ifndef GENERATOR_SV
`define GENERATOR_SV

`include "../verification/phase9_testcases/phase9_transaction.sv"
`include "../verification/phase9_testcases/phase9_coverage.sv"

class generator #(type T=transaction);
  //declaring transaction class
  rand T trans;

  //repeat count, to specify number of items to generate
  int repeat_count;

  //mailbox, to generate and send the packet to driver
  mailbox gen2driv[4];

  //event, to indicate the end of transaction generation
  event ended;

  virtual intf.driver vif;

  coverage cov = new();

  //constructor
  function new(virtual intf.driver vif, mailbox gen2driv[4]);
    this.vif = vif;

    //getting the mailbox handle from env.
    foreach(gen2driv[i]) this.gen2driv[i] = gen2driv[i];
  endfunction

  //main task, generates (creates and randomizes) transaction packets
  task main();
      trans = new();
      if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
      cov.sample(trans);
      trans.display("[ Generator ]");
      foreach(gen2driv[i]) gen2driv[i].put(trans);
      -> ended; //trigger end of generation
  endtask

endclass

`endif
