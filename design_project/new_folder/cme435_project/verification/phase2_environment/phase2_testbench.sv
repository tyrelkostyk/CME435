`ifndef TESTBENCH_SV
`define TESTBENCH_SV

`include "../verification/phase2_environment/phase2_environment.sv"

program testbench(intf i_intf);
  //declaring environment instance
  environment env;

  initial
  begin
    //creating environment
    env = new(i_intf.driver, i_intf.monitor);

    $display("******************* Start of testcase ****************");

    //calling run of env, it in turns calls other main tasks.
    env.run();
  end

endprogram

`endif
