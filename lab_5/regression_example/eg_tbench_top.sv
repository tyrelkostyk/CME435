`ifdef TEST_SANITY
  `include "test_sanity.sv"
`elsif TEST_MULTI_REQ
  `include "test_multi_req.sv"
`else // default
  `include "test_sanity.sv"
`endif

module tbench_top();

reg             clk;    
// add signals, variables...   

// Clock generator
logic clk = 0;
always #10 clk = ~clk;

/*
// run regression test by using $plusargs
string testname;

initial begin
  if ($value$plusargs("TESTNAME=%s", testname)) begin
    $display("Running %0s", testname);
    if (testname == "arbiter_test_sanity") begin
      //$display("Running %0s", testname);
      `include "arbiter_test_sanity.sv"
    end
    else if (testname == "artiber_test_multi_req") begin
      //$display("Running %0s", testname);
      `include "arbiter_test_multi_req.sv"
    end
    else
      $display("Testcase %0s unrecognizable", testname);
  end
end
*/

testbench test (
// add interface and ports...    
);

arbiter dut (
// add interface and ports...   
);

endmodule
