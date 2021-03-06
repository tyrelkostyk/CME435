`ifndef TRANSACTION_SV
`define	TRANSACTION_SV

class TransBase #( parameter
	int MAX_PAYLOAD_SIZE=16,
	int MIN_PAYLOAD_SIZE=4,
	int PS_ARRAY_LEN=4,
	int PAYLOAD_SIZE_ARRAY[PS_ARRAY_LEN]={4,8,12,16},
	int DA_ARRAY_LEN=4,
	int DEST_ADDR_PORTS_ARRAY[DA_ARRAY_LEN]={1,2,3,4}
);


// ************************* INSTANTIATIONS ************************* //

rand bit [7:0] dest_addr;		// random dest addr. Can be 1, 2, 3, or 4
rand bit [7:0] data_in[];		// payload array; can be 4, 8, 12, or 16 bytes

bit [7:0] data_out[];
bit [4:0] newdata_len;


constraint payload_size_c {
	// data_in.size inside { 4, 8, 12, 16 };
	data_in.size inside { PAYLOAD_SIZE_ARRAY };
}

constraint payload_dest_addr_c {
	// dest_addr inside { [1:4] };
	dest_addr inside { DEST_ADDR_PORTS_ARRAY };
}


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

function void display_downstream( string name );
	$display("\n%0d : ------------ %s ------------", $time, name);
	$display(  "%0d : ------ DOWNSTREAM PACKET START ------", $time, );
	$display(  "%0d : DEST_ADDR    :      %d ", $time, dest_addr);
	foreach( data_in[i] ) begin
		$display("%0d : ------- BYTE %2d -------", $time,  i);
		$display("%0d : DATA_IN      :      %d ", $time, data_in[i]);
	end
endfunction

function void display_upstream( string name );
	$display("\n%0d : ------------ %s ------------", $time, name);
	$display(  "%0d : ------ UPSTREAM PACKET START ------", $time, );
	$display(  "%0d : DEST_ADDR    :      %d ", $time, dest_addr);
	$display(  "%0d : NEWDATA_LEN  :       %d ", $time, newdata_len);
	foreach( data_out[i] ) begin
		$display("%0d : ------- BYTE %2d -------", $time,  i);
		$display("%0d : DATA_OUT     :      %d ", $time, data_out[i]);
	end
endfunction

endclass
`endif
