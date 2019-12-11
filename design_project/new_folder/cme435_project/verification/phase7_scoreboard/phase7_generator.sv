`ifndef GENERATOR_SV
`define GENERATOR_SV

`include "../verification/phase7_scoreboard/phase7_transaction.sv"

class generator;
  //declaring transaction class
  rand transaction trans;

  //repeat count, to specify number of items to generate
  int repeat_count;

  //mailbox, to generate and send the packet to driver
  mailbox gen2driv[4];

  //event, to indicate the end of transaction generation
  event ended;

  virtual intf.driver vif;

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
      trans.display("[ Generator ]");
      foreach(gen2driv[i]) gen2driv[i].put(trans);
      -> ended; //trigger end of generation
  endtask

endclass

`endif
