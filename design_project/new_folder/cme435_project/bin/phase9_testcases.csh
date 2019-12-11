#!/bin/csh

set testcase_list="sanity buffer max_payload min_payload"

if ($#argv == 1) then
  if ("$argv[1]" == "-l") then
    foreach testcase ($testcase_list)
      echo $testcase
    end
  endif
endif

if ($#argv == 2) then
  if ("$argv[1]" == "-t") then
    set testcase_uc = `echo $argv[2] | tr "[:lower:]" "[:upper:]"`

    rm -r work transcript *.vcd *.wlf ../report/phase9*

    vlib work

    vlog +cover=t +acc ../dut/xswitch.svp
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_coverage.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_driver.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_dut_top.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_environment.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_generator.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_interface.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_monitor.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_scoreboard.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_tbench_top.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_transaction.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_transaction_buffer.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_assertions.sv
    vlog +cover=t +acc ../verification/phase9_testcases/phase9_testbench_$argv[2].sv

    vsim -coverage tbench_top -c -do "coverage save -onexit ../report/phase9_testcases_$argv[2].ucdb; run -all; exit"

    vcover report -details ../report/phase9_testcases_$argv[2].ucdb -file ../report/phase9_testcases_$argv[2].rpt
    vcover report -html ../report/phase9_testcases_$argv[2].ucdb -htmldir ../report/phase9_testcases_$argv[2]
  endif
endif
