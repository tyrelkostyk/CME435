`include "testbench/phase3_base/transaction.sv"

`ifndef RECEIVER_SV
`define RECEIVER_SV

class receiver;


// ************************* INSTANTIATIONS ************************* //

// create virtual interface handle
virtual intf.MONITOR vif;

// initialize port bit
logic [4:0] port;

// create mailbox handle
mailbox mon2scb;

// semaphore handles
semaphore semComm;		// prevent driving packets while receiving previous packets

// temp var for iterating over duration of (dut) output data
logic [4:0] tmp_data_len;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

function new( virtual intf.MONITOR vif, logic [4:0] port, mailbox mon2scb, semaphore semComm );
	// get interface and port from monitor class
	this.vif = vif;
	this.port = port;

	// get the mailbox from env
	this.mon2scb = mon2scb;

	// getting the semaphore handles from env
	this.semComm = semComm;

endfunction


// *********************** EVENTS AND INTEGERS ********************** //

// keep track of the number of transactions sent
int num_transactions_recv = 0;


// ***************************** TASKS ***************************** //


task main();
	forever begin
		// instantiate transaction object
		transaction trans_rx;
		trans_rx = new();
		trans_rx.dest_addr = port;

		wait(	vif.newdata_len[port] );
			trans_rx.newdata_len = vif.newdata_len[port];
			tmp_data_len = vif.newdata_len[port];
			trans_rx.data_out = new[tmp_data_len];

			repeat(4) @( posedge vif.clk );
				for (int i=0; i<tmp_data_len; i++) begin
					@( posedge vif.clk );
					trans_rx.data_out[i] = vif.data_out[port];
				end

		num_transactions_recv++;
		// trans_rx.display_upstream("[ RECEIVER ]");

		@( posedge vif.clk );
			mon2scb.put( trans_rx );
			semComm.put();		// release comm line

	end
endtask

endclass
`endif
