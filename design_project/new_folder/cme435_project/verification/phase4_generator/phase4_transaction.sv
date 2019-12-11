`ifndef TRANSACTION_SV
`define TRANSACTION_SV

class transaction;
rand bit [31:0] data_in;
rand bit [31:0] addr_in;
rand bit [3:0] valid_in;
bit [3:0] data_rd;

constraint addr_in_random{
  addr_in[31:24] inside {[0:3]};
  addr_in[23:16] inside {[0:3]};
  addr_in[15:8] inside {[0:3]};
  addr_in[7:0] inside {[0:3]};
}

constraint unique_addr_in{
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

function void display(string name);
  $display("- %s ",name);
  $display("-------------------------");

  $write("data_in: ");
  $write("%d %d %d %d", data_in[31:24], data_in[23:16], data_in[15:8], data_in[7:0]);

  $display("");
  $write("addr_in: ");
  $write("%d %d %d %d", addr_in[31:24], addr_in[23:16], addr_in[15:8], addr_in[7:0]);

  $display("");
  $display("-------------------------");
endfunction

endclass

`endif
