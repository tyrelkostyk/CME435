`include "testbench/phase3_base/TransBase.sv"

`ifndef COVERAGE_SV
`define COVERAGE_SV

class coverage;
	TransBase trans;

	covergroup drive_cg;
		address : coverpoint trans.dest_addr {
			bins port_1 = {1};
			bins port_2 = {2};
			bins port_3 = {3};
			bins port_4 = {4};
		}

		data_in_size : coverpoint trans.newdata_len {
			bins len_four = {4};
			bins len_eight = {8};
			bins len_twelve = {12};
			bins len_sixteen = {16};
		}
		cross address, data_in_size;
	endgroup

	covergroup data_cg with function sample(int data_in);
		data : coverpoint data_in {
			bins low = {[0:50]};
			bins mid = {[51:150]};
			bins high = {[151:255]};
		}
	endgroup

	function new();
		drive_cg = new();
		data_cg = new();
	endfunction : new

	task sample( TransBase trans );
		this.trans = new();
		drive_cg.sample();
	endtask : sample

endclass

`endif
