`ifndef TRANSACTION_SV
`define	TRANSACTION_SV

class transaction;

rand bit [3:0] a;
rand bit [3:0] b;
bit [6:0] c;


function void display( string name );
	$display("- %s ",name); 
	$display("-------------------------");
	$display("- a = %0d, b = %0d",a,b);
	$display("- c = %0d",c);
endfunction

endclass
`endif
