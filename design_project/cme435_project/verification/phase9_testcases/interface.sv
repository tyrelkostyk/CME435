`ifndef INTERFACE_SV
`define	INTERFACE_SV

interface intf( input logic clk, reset );


// ************************* INSTANTIATIONS ************************* //

logic [31:0]	addr_in, addr_out;
logic [31:0]	data_in, data_out;
logic [3:0]		valid_in, valid_out;
logic [3:0]		rcv_rdy, data_rd;


// ************************ CLOCKING BLOCKS ************************* //

clocking cb_tb @( posedge clk );
	input 	clk;
	output 	addr_in, data_in, valid_in, data_rd;
	input 	addr_out, data_out, valid_out, rcv_rdy;
endclocking


// **************************** MODPORTS **************************** //

modport DUT (
	input 	clk, reset,
	input 	addr_in, data_in, valid_in, data_rd,
	output 	addr_out, data_out, valid_out, rcv_rdy
);


modport DRIVER (
	clocking cb_tb,
	input clk
);


modport MONITOR (
	clocking cb_tb,
	input clk,
	input addr_out, data_out, valid_out, rcv_rdy,
	output addr_in, data_in, valid_in, data_rd
);


// **************************** COVERAGE **************************** //

covergroup intf_cg @( posedge clk );
  port_0_addr : coverpoint addr_in[7:0] {
    bins port_0 = {0};
    bins port_1 = {1};
    bins port_2 = {2};
    bins port_3 = {3};
  }

  port_1_addr : coverpoint addr_in[15:8] {
    bins port_0 = {0};
    bins port_1 = {1};
    bins port_2 = {2};
    bins port_3 = {3};
  }

  port_2_addr : coverpoint addr_in[23:16] {
    bins port_0 = {0};
    bins port_1 = {1};
    bins port_2 = {2};
    bins port_3 = {3};
  }
  port_3_addr : coverpoint addr_in[31:24] {
    bins port_0 = {0};
    bins port_1 = {1};
    bins port_2 = {2};
    bins port_3 = {3};
  }

  port_0_data : coverpoint data_in[7:0] {
    bins low = {[0:50]};
    bins med = {[51:150]};
    bins high = {[151:255]};
  }

  port_1_data : coverpoint data_in[15:8] {
    bins low = {[0:50]};
    bins med = {[51:150]};
    bins high = {[151:255]};
  }

  port_2_data : coverpoint data_in[23:16] {
    bins low = {[0:50]};
    bins med = {[51:150]};
    bins high = {[151:255]};
  }

  port_3_data : coverpoint data_in[31:24] {
    bins low = {[0:50]};
    bins med = {[51:150]};
    bins high = {[151:255]};
  }

	reset : coverpoint reset {
		bins low = {0};
		bins high = {1};
	}

endgroup

intf_cg cg = new();

endinterface
`endif
