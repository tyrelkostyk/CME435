module tbench_top;

  import uvm_pkg::*;

  bit clk;
  bit reset;

  always #5 clk = ~clk;

  initial begin
    reset = 1;
    #5 reset =0;
  end

  mem_if intf(clk,reset);

  memory_top DUT (intf);

  initial begin
    uvm_config_db#(virtual mem_if)::set(uvm_root::get(),"*","vif",intf);
    //$dumpfile("dump.vcd");
    //$dumpvars;
  end

  initial begin
    run_test();
  end

endmodule
