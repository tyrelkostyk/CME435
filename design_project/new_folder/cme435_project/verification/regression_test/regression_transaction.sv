`ifndef TRANSACTION_SV
`define TRANSACTION_SV

class transaction;
randc bit [31:0] data_in;
randc bit [31:0] addr_in;
randc bit [3:0] valid_in;
randc bit [3:0] data_rd;
bit [3:0] rcv_rdy;

constraint addr_in_random{
  addr_in[31:24] inside {[0:3]};
  addr_in[23:16] inside {[0:3]};
  addr_in[15:8] inside {[0:3]};
  addr_in[7:0] inside {[0:3]};
}

constraint unique_addr_in{
  addr_in[15:8] != addr_in[7:0];
  addr_in[15:8] != addr_in[23:16];
  addr_in[15:8] != addr_in[31:24];

  addr_in[7:0] != addr_in[15:8];
  addr_in[7:0] != addr_in[23:16];
  addr_in[7:0] != addr_in[31:24];

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

  $write("data_in: %d %d %d %d", data_in[31:24], data_in[23:16], data_in[15:8], data_in[7:0]);

  $display("");
  $write("addr_in: %d %d %d %d", addr_in[31:24], addr_in[23:16], addr_in[15:8], addr_in[7:0]);

  if ((name == "[ Driver 0 ]") || (name == "[ Driver 1 ]") ||
      (name == "[ Driver 2 ]") || (name == "[ Driver 3 ]")||
      (name == "[ Scoreboard - Driver 0 ]") ||
      (name == "[ Scoreboard - Driver 1 ]") ||
      (name == "[ Scoreboard - Driver 2 ]") ||
      (name == "[ Scoreboard - Driver 3 ]"))
  begin
    $display("");
    $write("rcv_rdy:   %d   %d   %d   %d", rcv_rdy[3], rcv_rdy[2], rcv_rdy[1], rcv_rdy[0]);
  end

  $display("");
  $display("-------------------------");
endfunction

endclass

`endif
