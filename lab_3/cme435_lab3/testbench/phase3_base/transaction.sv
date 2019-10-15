`ifndef TRANSACTION_SV
`define	TRANSACTION_SV

class transaction;


// ************************* INSTANTIATIONS ************************* //

rand bit [7:0] dest_addr;		// random dest addr. Can be 1, 2, 3, or 4
rand bit [7:0] data_in[];		// payload array; can be 4, 8, 12, or 16 bytes

bit [7:0] data_out_1[], data_out_2[], data_out_3[], data_out_4[];


constraint payload_size_c {
	data_in.size inside { 4, 8, 12, 16 };
}

constraint payload_dest_addr_c {
	dest_addr inside { [1:4] };
}

// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

function void display_trans( string name );
	$display(  "------- %s -------", name);
	$display(  "----------- PACKET -----------");
	$display(  "DEST_ADDR    : %h ", dest_addr);
	foreach( data_in[i] ) begin
		$display("--------- PACKET[%3d] ---------", i);
		$display("DATA_IN      : %3d : %h ", i, data_in[i]);
		$display("DATA_OUT_1   : %3d : %h ", i, data_out_1[i]);
		$display("DATA_OUT_2   : %3d : %h ", i, data_out_2[i]);
		$display("DATA_OUT_3   : %3d : %h ", i, data_out_3[i]);
		$display("DATA_OUT_4   : %3d : %h ", i, data_out_4[i]);
	end

endfunction

endclass
`endif
