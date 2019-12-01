`include "uvm_macros.svh"

package mem_pkg;
	import uvm_pkg::*;

class mem_seq_item extends uvm_sequence_item;

	rand bit [1:0] addr;
	rand bit			 wr_en;
	rand bit			 rd_en;
	rand bit [7:0] wdata;
			 bit [7:0] rdata;

	`uvm_object_utils_begin( mem_seq_item )
		`uvm_field_int( addr, UVM_ALL_ON )
		`uvm_field_int( wr_en, UVM_ALL_ON )
		`uvm_field_int( rd_en, UVM_ALL_ON )
		`uvm_field_int( wdata, UVM_ALL_ON )
	`uvm_object_utils_end

  function new( string name = "mem_seq_item" );
		super.new( name );
	endfunction : new

	constraint wr_rd_c { wr_en != rd_en; };

endclass : mem_seq_item


class mem_sequence extends uvm_sequence#( mem_seq_item );
	`uvm_object_utils( mem_sequence )

	function new( string name = "mem_sequence" );
		super.new( name );
	endfunction : new

	`uvm_declare_p_sequencer( uvm_sequencer )

	virtual task body();
		repeat(2) begin
			req = mem_seq_item::type_id::create("req");
			wait_for_grant();
			req.randomize();
			send_request(req);
			wait_for_item_done();
		end
	endtask : body

endclass : mem_sequence

// write_sequence -"write" type
class write_sequence extends uvm_sequence#( mem_seq_item );
  `uvm_object_utils( write_sequence )

  function new( string name = "write_sequence" );
    super.new( name );
  endfunction

  virtual task body();
    `uvm_do_with( req, {req.wr_en==1;} )
  endtask
endclass : write_sequence

// read_sequence - "read" type
class read_sequence extends uvm_sequence#( mem_seq_item );
  `uvm_object_utils( read_sequence )

  function new( string name = "read_sequence" );
    super.new( name );
  endfunction

  virtual task body();
    `uvm_do_with( req, {req.rd_en==1;} )
  endtask
endclass : read_sequence

// write_read_sequence -"write" followed by "read"
class write_read_sequence extends uvm_sequence#( mem_seq_item );
  `uvm_object_utils( write_read_sequence )

  function new( string name = "write_read_sequence" );
    super.new( name );
  endfunction

  virtual task body();
    `uvm_do_with( req, {req.wr_en==1;} )
    `uvm_do_with( req, {req.rd_en==1;} )
  endtask
endclass

// wr_rd_sequence -"write" followed by "read" (sequence's inside sequences)
class wr_rd_sequence extends uvm_sequence#( mem_seq_item );
  //Declaring sequences
  write_sequence wr_seq;
  read_sequence  rd_seq;

  `uvm_object_utils( wr_rd_sequence )

  function new( string name = "wr_rd_sequence" );
    super.new( name );
  endfunction

  virtual task body();
		`uvm_do( wr_seq )
    `uvm_do( rd_seq )
  endtask
endclass

`define DRIV_IF vif.DRIVER.driver_cb

class mem_driver extends uvm_driver #( mem_seq_item );

  virtual mem_if vif;
  `uvm_component_utils( mem_driver )

  function new ( string name, uvm_component parent );
    super.new( name, parent );
  endfunction : new

  function void build_phase( uvm_phase phase );
    super.build_phase( phase );
      if(!uvm_config_db#(virtual mem_if)::get(this, "", "vif", vif))
        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  virtual task run_phase( uvm_phase phase );
    forever begin
      seq_item_port.get_next_item( req );
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase

  virtual task drive();
    `DRIV_IF.wr_en <= 0;
    `DRIV_IF.rd_en <= 0;
    @( posedge vif.DRIVER.clk );

    `DRIV_IF.addr <= req.addr;

    if( req.wr_en ) begin // write operation
      `DRIV_IF.wr_en <= req.wr_en;
      `DRIV_IF.wdata <= req.wdata;
      @( posedge vif.DRIVER.clk );
    end
    else if(req.rd_en) begin //read operation
      `DRIV_IF.rd_en <= req.rd_en;
      @( posedge vif.DRIVER.clk );
      `DRIV_IF.rd_en <= 0;
      @( posedge vif.DRIVER.clk );
      req.rdata = `DRIV_IF.rdata;
    end
  endtask : drive

endclass : mem_driver

class mem_monitor extends uvm_monitor;

  virtual mem_if vif;

  uvm_analysis_port #( mem_seq_item ) item_collected_port;

  mem_seq_item trans_collected;

  `uvm_component_utils( mem_monitor )

  function new ( string name, uvm_component parent );
    super.new( name, parent );
    trans_collected = new();
    item_collected_port = new( "item_collected_port", this );
  endfunction : new

  function void build_phase( uvm_phase phase );
    super.build_phase( phase );
    if(!uvm_config_db#(virtual mem_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  virtual task run_phase( uvm_phase phase );
    forever begin
      @(posedge vif.MONITOR.clk);
      wait(vif.monitor_cb.wr_en || vif.monitor_cb.rd_en);
        trans_collected.addr = vif.monitor_cb.addr;
      if(vif.monitor_cb.wr_en) begin
        trans_collected.wr_en = vif.monitor_cb.wr_en;
        trans_collected.wdata = vif.monitor_cb.wdata;
        trans_collected.rd_en = 0;@(posedge vif.MONITOR.clk);
      end
      if(vif.monitor_cb.rd_en) begin
        trans_collected.rd_en = vif.monitor_cb.rd_en;
        trans_collected.wr_en = 0;
        @(posedge vif.MONITOR.clk);
        @(posedge vif.MONITOR.clk);
        trans_collected.rdata = vif.monitor_cb.rdata;
      end
      item_collected_port.write( trans_collected );
    end
  endtask : run_phase

endclass : mem_monitor

class mem_agent extends uvm_agent;

  mem_driver    driver;
  mem_sequencer sequencer;
  mem_monitor   monitor;

  `uvm_component_utils( mem_agent )

  function new ( string name, uvm_component parent );
    super.new( name, parent );
  endfunction : new

  function void build_phase( uvm_phase phase );
    super.build_phase( phase );

    monitor = mem_monitor::type_id::create("monitor", this);
    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = mem_driver::type_id::create("driver", this);
      sequencer = mem_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase

  function void connect_phase( uvm_phase phase );
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : mem_agent

class mem_scoreboard extends uvm_scoreboard;

  mem_seq_item pkt_qu[$];

  bit [7:0] sc_mem [4];

  //port to receive transactions from monitor
  uvm_analysis_imp#( mem_seq_item, mem_scoreboard ) item_collected_export;

  `uvm_component_utils( mem_scoreboard )

  function new ( string name, uvm_component parent );
    super.new( name, parent );
  endfunction : new

  function void build_phase( uvm_phase phase );
    super.build_phase( phase );
      item_collected_export = new("item_collected_export", this);
      foreach(sc_mem[i]) sc_mem[i] = 8'hFF;
  endfunction: build_phase

  // receives transactions from monitor and pushes them into a queue
  virtual function void write( mem_seq_item pkt );
    //pkt.print();
    pkt_qu.push_back(pkt);
  endfunction : write

  virtual task run_phase( uvm_phase phase );
    mem_seq_item mem_pkt;

    forever begin
      wait(pkt_qu.size() > 0);
      mem_pkt = pkt_qu.pop_front();
      if(mem_pkt.wr_en) begin
        sc_mem[mem_pkt.addr] = mem_pkt.wdata;
        `uvm_info(get_type_name(),$sformatf("------:: WRITE DATA       :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Addr: %0h",mem_pkt.addr),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Data: %0h",mem_pkt.wdata),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
        end
        else if(mem_pkt.rd_en) begin
        if(sc_mem[mem_pkt.addr] == mem_pkt.rdata) begin
          `uvm_info(get_type_name(),$sformatf("------:: READ DATA Match :: ------"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Addr: %0h",mem_pkt.addr),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data:%0h Actual Data: %0h",sc_mem[mem_pkt.addr],mem_pkt.rdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
        end
        else begin
          `uvm_error(get_type_name(),"------:: READ DATA MisMatch ::------")
          `uvm_info(get_type_name(),$sformatf("Addr: %0h",mem_pkt.addr),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[mem_pkt.addr],mem_pkt.rdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
        end
      end
    end
  endtask : run_phase

endclass : mem_scoreboard

class mem_model_env extends uvm_env;

  mem_agent      mem_agnt;
  mem_scoreboard mem_scb;

  `uvm_component_utils( mem_model_env )

  function new( string name, uvm_component parent );
    super.new( name, parent );
  endfunction : new

  function void build_phase( uvm_phase phase );
    super.build_phase( phase );
    mem_agnt = mem_agent::type_id::create("mem_agnt", this);
    mem_scb  = mem_scoreboard::type_id::create("mem_scb", this);
  endfunction : build_phase

  function void connect_phase( uvm_phase phase );
    mem_agnt.monitor.item_collected_port.connect( mem_scb.item_collected_export );
  endfunction : connect_phase

endclass : mem_model_env


endpackage : mem_pkg
