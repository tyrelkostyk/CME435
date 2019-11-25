module tbench_top;

  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  
  initial begin
    reset = 1;
    #5 reset =0;
  end
  
  mem_if intf(clk,reset);
  
  memory_top DUT (intf);
  
endmodule
