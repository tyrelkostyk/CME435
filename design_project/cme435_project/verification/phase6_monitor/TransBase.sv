`ifndef TRANSACTION_SV
`define	TRANSACTION_SV

class TransBase #( parameter
	int DEST_ADDR_ARRAY_LEN=4,
	int DEST_ADDR_PORTS[DEST_ADDR_ARRAY_LEN]={0,1,2,3}
);


// ************************* INSTANTIATIONS ************************* //

rand bit [31:0] addr_in;	// random dest addr; Each byte can be 0, 1, 2, or 3
rand bit [31:0] data_in;	// random payload data;

bit [31:0] addr_out;
bit [31:0] data_out;

constraint dest_addr_B1_c {
	addr_in[7:0] inside { DEST_ADDR_PORTS };
}

constraint dest_addr_B2_c {
	addr_in[15:8] inside { DEST_ADDR_PORTS };
}

constraint dest_addr_B3_c {
	addr_in[23:16] inside { DEST_ADDR_PORTS };
}

constraint dest_addr_B4_c {
	addr_in[31:24] inside { DEST_ADDR_PORTS };
}

constraint addr_in_unique_c {
	addr_in[7:0] != addr_in[15:8];
	addr_in[7:0] != addr_in[23:16];
	addr_in[7:0] != addr_in[31:24];

	addr_in[15:8] != addr_in[7:0];
	addr_in[15:8] != addr_in[23:16];
	addr_in[15:8] != addr_in[31:24];

	addr_in[23:16] != addr_in[7:0];
	addr_in[23:16] != addr_in[15:8];
	addr_in[23:16] != addr_in[31:24];

	addr_in[31:24] != addr_in[7:0];
	addr_in[31:24] != addr_in[15:8];
	addr_in[31:24] != addr_in[23:16];
}


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

function void display_downstream( string name );
	$display("\n%0d : ------------ %s ------------", $time, name);
	$display(  "%0d : ------ DOWNSTREAM PACKET START ------", $time, );
	$display(	 "%0d : -------- PORT 0 --------", $time);
	$display(  "%0d : ADDR_IN      :      %d ", $time, addr_in[7:0] );
	$display(  "%0d : DATA_IN      :      %d ", $time, data_in[7:0] );
	$display(	 "%0d : ------- PORT 1 --------", $time);
	$display(  "%0d : ADDR_IN      :      %d ", $time, addr_in[15:8] );
	$display(  "%0d : DATA_IN      :      %d ", $time, data_in[15:8] );
	$display(	 "%0d : ------- PORT 2 --------", $time);
	$display(  "%0d : ADDR_IN      :      %d ", $time, addr_in[23:16] );
	$display(  "%0d : DATA_IN      :      %d ", $time, data_in[23:16] );
	$display(	 "%0d : ------- PORT 3 --------", $time);
	$display(  "%0d : ADDR_IN      :      %d ", $time, addr_in[31:24] );
	$display(  "%0d : DATA_IN      :      %d \n", $time, data_in[31:24] );
endfunction

function void display_upstream( string name );
	$display("\n%0d : ------------ %s ------------", $time, name);
	$display(  "%0d : ------ UPSTREAM PACKET START ------", $time, );
	$display(	 "%0d : -------- PORT 0 --------", $time);
	$display(  "%0d : ADDR_OUT      :      %d ", $time, addr_out[7:0] );
	$display(  "%0d : DATA_OUT      :      %d ", $time, data_out[7:0] );
	$display(	 "%0d : -------- PORT 1 --------", $time);
	$display(  "%0d : ADDR_OUT      :      %d ", $time, addr_out[15:8] );
	$display(  "%0d : DATA_OUT      :      %d ", $time, data_out[15:8] );
	$display(	 "%0d : -------- PORT 2 --------", $time);
	$display(  "%0d : ADDR_OUT      :      %d ", $time, addr_out[23:16] );
	$display(  "%0d : DATA_OUT      :      %d ", $time, data_out[23:16] );
	$display(	 "%0d : -------- PORT 3 --------", $time);
	$display(  "%0d : ADDR_OUT      :      %d ", $time, addr_out[31:24] );
	$display(  "%0d : DATA_OUT      :      %d \n", $time, data_out[31:24] );
endfunction

endclass
`endif
