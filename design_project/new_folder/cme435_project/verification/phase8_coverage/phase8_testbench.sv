`ifndef TESTBENCH_SV
`define TESTBENCH_SV

`include "../verification/phase8_coverage/phase8_environment.sv"

program testbench(intf i_intf);
  //declaring environment instance
  environment env;

  initial
  begin
    //creating environment
    env = new(i_intf.driver, i_intf.monitor);

    //setting the repeat count of generator such as 5, means to generate 5 packets
    env.gen.repeat_count = 10;

    $display("******************* Start of testcase ****************");

    //calling run of env, it in turns calls other main tasks.
    env.run();
  end

endprogram

`endif
