`include "uvm_macros.svh"

package test_pkg;

import uvm_pkg::*;
import mem_pkg::*;

class mem_model_base_test extends uvm_test;

  `uvm_component_utils(mem_model_base_test)

  mem_model_env env;

  function new(string name = "mem_model_base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = mem_model_env::type_id::create("env", this);
  endfunction : build_phase

  virtual function void end_of_elaboration();
    //print the topology
    print();
  endfunction

  function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);

    svr = uvm_report_server::get_server();
    if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      `uvm_info(get_type_name(), "----TEST FAIL          ----", UVM_NONE)
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      `uvm_info(get_type_name(), "----TEST PASS           ----", UVM_NONE)
      `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction endclass : mem_model_base_test

  //mem_write_read_test
  class mem_wr_rd_test extends mem_model_base_test;
    `uvm_component_utils(mem_wr_rd_test)

    wr_rd_sequence seq;

    function new(string name = "mem_wr_rd_test",uvm_component parent=null);
      super.new(name,parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      seq = wr_rd_sequence::type_id::create("seq");
    endfunction : build_phase

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
        seq.start(env.mem_agnt.sequencer);
      phase.drop_objection(this);

      //set a drain-time for the environment if desired
      phase.phase_done.set_drain_time(this, 50);
    endtask : run_phase

  endclass : mem_wr_rd_test

endpackage : test_pkg
