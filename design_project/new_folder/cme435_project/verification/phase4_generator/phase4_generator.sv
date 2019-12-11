`ifndef GENERATOR_SV
`define GENERATOR_SV

`include "../verification/phase4_generator/phase4_transaction.sv"

class generator;
  //declaring transaction class
  rand transaction trans;

  //repeat count, to specify number of items to generate
  int repeat_count;

  //event, to indicate the end of transaction generation
  event ended;

  virtual intf.driver vif;

  //constructor
  function new(virtual intf.driver vif);
    this.vif = vif;
  endfunction

  //main task, generates (creates and randomizes) transaction packets
  task main();
    repeat(repeat_count) begin
      trans = new();

      if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
      trans.display("[ Generator ]");
    end
    -> ended; //trigger end of generation
  endtask

endclass

`endif
