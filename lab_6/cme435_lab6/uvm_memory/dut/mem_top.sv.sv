module memory_top (interface intf);
  
  memory memory_core (
    .clk(intf.clk),
    .reset(intf.clk),
    .addr(intf.addr),
    .wr_en(intf.wr_en),
    .rd_en(intf.rd_en),
    .wdata(intf.wdata),
    .rdata(intf.rdata)
  );

endmodule