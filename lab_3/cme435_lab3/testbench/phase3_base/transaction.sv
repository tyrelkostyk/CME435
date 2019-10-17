`ifndef TRANSACTION_SV
`define	TRANSACTION_SV

class transaction;


// ************************* INSTANTIATIONS ************************* //

rand bit [7:0] dest_addr;		// random dest addr. Can be 1, 2, 3, or 4
rand bit [7:0] data_in[];		// payload array; can be 4, 8, 12, or 16 bytes

bit [7:0] data_out_1[], data_out_2[], data_out_3[], data_out_4[];
bit [7:0] newdata_len_1[], newdata_len_2[], newdata_len_3[], newdata_len_4[];


constraint payload_size_c {
	data_in.size inside { 4, 8, 12, 16 };
}

constraint payload_dest_addr_c {
	dest_addr inside { [1:4] };
}

// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

function void display_trans( string name );
	$display(  "%0d : ---------- %s ----------", $time, name);
	$display(  "%0d : ----------- PACKET -----------", $time, );
	$display(  "%0d : DEST_ADDR    : %h ", $time, dest_addr);
	foreach( data_in[i] ) begin
		$display("%0d : --------- BYTE %2d ---------", $time,  i);
		$display("%0d : DATA_IN      : %3d : %h ", $time, i, data_in[i]);
		$display("%0d : DATA_OUT_1   : %3d : %h ", $time, i, data_out_1[i]);
		$display("%0d : DATA_OUT_2   : %3d : %h ", $time, i, data_out_2[i]);
		$display("%0d : DATA_OUT_3   : %3d : %h ", $time, i, data_out_3[i]);
		$display("%0d : DATA_OUT_4   : %3d : %h ", $time, i, data_out_4[i]);
	end

endfunction

endclass
`endif
