`ifndef TESTBENCH_SANITY_SV
`define TESTBENCH_SANITY_SV

`include "../verification/phase9_testcases/phase9_environment.sv"
`include "../verification/phase9_testcases/phase9_transaction.sv"

program testbench(intf i_intf);
  //declaring environment instance
  environment #(transaction) env;

  initial
  begin
    //creating environment
    env = new(i_intf.driver, i_intf.monitor);

    //setting the repeat count of generator such as 5, means to generate 5 packets
    env.gen.repeat_count = 1000;

    $display("******************* Start of testcase ****************");

    //calling run of env, it in turns calls other main tasks.
    env.run();
  end

endprogram

`endif
