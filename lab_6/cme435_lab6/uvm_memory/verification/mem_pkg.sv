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

endpackage : mem_pkg
