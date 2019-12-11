`ifndef ASSERTIONS_SV
`define ASSERTIONS_SV

module assertions(interface i_intf);

property p_data_in(port_n);
  disable iff (i_intf.reset)
  @(negedge i_intf.clk)
  i_intf.valid_in[port_n] |=> (($past(i_intf.data_in[(port_n*8)+:8],1) == i_intf.data_out[($past(i_intf.addr_in[(port_n*8)+:8],1)*8)+:8] &&
                                i_intf.valid_out[$past(i_intf.addr_in[(port_n*8)+:8],1)]));
endproperty

generate
  for(genvar i=0; i<4; i++)
  begin
    a_data_in: assert property (p_data_in(i))
    else
      $display("############### Assertion a_data_in FAILED at %0t ns ###############", $time);
    c_data_in: cover property (p_data_in(i));
  end
endgenerate

property p_addr_in(port_n);
  disable iff (i_intf.reset)
  @(negedge i_intf.clk)
  i_intf.valid_in[port_n] |=> (i_intf.addr_out[($past(i_intf.addr_in[(port_n*8)+:8],1)*8)+:8] == port_n &&
                               i_intf.valid_out[$past(i_intf.addr_in[(port_n*8)+:8],1)]);
endproperty

generate
  for(genvar i=0; i<4; i++)
  begin
    a_addr_in: assert property (p_addr_in(i))
    else
      $display("############### Assertion a_addr_in FAILED at %0t ns ###############", $time);
    c_addr_in: cover property (p_addr_in(i));
  end
endgenerate

property p_reset;
  @(posedge i_intf.clk)
  i_intf.reset |-> (i_intf.data_out === 32'hZZZZ &&
                    i_intf.addr_out === 32'hZZZZ &&
                    i_intf.valid_out == 4'b0000);
endproperty

a_reset: assert property (p_reset)
  else
    $display("############### Assertion a_reset FAILED at %0t ns ############### ", $time);

c_reset: cover property(p_reset);

endmodule

`endif
