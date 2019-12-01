`include "uvm_macros.svh"

interface hi_if();
endinterface: hi_if

module hi_wrapper(hi_if intf);
endmodule: hi_wrapper

import uvm_pkg::*;

// hello environment
class hello_env extends uvm_env;
  `uvm_component_utils(hello_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10;
    `uvm_info(get_type_name(), "Hello World!", UVM_NONE)
    phase.drop_objection(this);
  endtask: run_phase

endclass: hello_env

// hello base test
class hello_base_test extends uvm_test;
  `uvm_component_utils(hello_base_test)

  hello_env hello_env_h;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    hello_env_h = hello_env::type_id::create("hello_env_h", this);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "HelloWorld!", UVM_NONE)
  endtask : run_phase

endclass : hello_base_test

module tbench_top;

  import uvm_pkg::*;

  hi_if intf();
  hi_wrapper dut(.*);

  initial begin
    run_test("hello_base_test");
  end

endmodule
