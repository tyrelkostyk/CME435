`ifndef TRANSACTION_SV
`define	TRANSACTION_SV

class transaction;


// ************************* INSTANTIATIONS ************************* //

rand bit [7:0] data_in;

bit [7:0] data_out_1, data_out_2, data_out_3, data_out_4;


// ******************* FUNCTIONS AND CONSTRUCTORS ******************* //

function void display_trans( string name );
	$display("- %s ",name);
	$display("-------------------------");
	$display("- a = %0d, b = %0d",a,b);
	$display("- c = %0d",c);
endfunction

endclass
`endif
