`ifndef TESTBENCH_BUFFER_SV
`define TESTBENCH_BUFFER_SV

`include "../verification/phase9_testcases/phase9_environment.sv"
`include "../verification/phase9_testcases/phase9_transaction.sv"

class transaction_max_payload extends transaction;

constraint data_in_fixed{
  data_in[31:24] inside {255};
  data_in[23:16] inside {255};
  data_in[15:8] inside {255};
  data_in[7:0] inside {255};
}

endclass

program testbench(intf i_intf);
  //declaring environment instance
  environment #(transaction_max_payload) env;

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
