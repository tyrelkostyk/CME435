interface hi_if();
endinterface: hi_if

module hi_wrapper(hi_if intf);
endmodule: hi_wrapper

module tbench_top;

  import uvm_pkg::*;

  hi_if intf();
  hi_wrapper dut(.*);
  
endmodule  