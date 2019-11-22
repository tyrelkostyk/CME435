#!/bin/csh

./rm_ffiles.sh

if (! -e work) then
	vlib work
endif

if (! -e fx_coverage) then
	mkdir fx_coverage
endif

vlog -coveropt 3 +cover=t dut/*.svp
vlog -coveropt 3 +cover=t dut/*.sv

vlog testbench/phase1_top/*.sv
vlog testbench/phase2_environment/*.sv
vlog testbench/phase3_base/*.sv
vlog testbench/phase4_generator/*.sv
vlog testbench/phase5_driver/*.sv
vlog testbench/phase6_monitor/*.sv
vlog testbench/phase7_scoreboard/*.sv
vlog testbench/phase8_coverage/*.sv
vlog testbench/phase9_testcases/*.sv

set testcase_list="testbench_bnd_plse_coincidence testbench_max_payload testbench_min_payload testbench_buffer_overflow testbench_sanity_check testbench_reset"
foreach testcase ($testcase_list)
  set testcase_uc = `echo $testcase | tr "[:lower:]" "[:upper:]"`
  vlog -coveropt 3 +cover=t +acc +define+$testcase_uc testbench/phase9_testcases/$testcase.sv
  vopt +acc tbench_top -o tbench_top_opt
  vsim -coverage -vopt tbench_top_opt -c -do "coverage save -onexit -directive -codeAll fx_coverage/$testcase.ucdb;run -all; exit"
end

vcover merge -64 fx_coverage/pdm_cov.ucdb fx_coverage/*.ucdb

vcover report fx_coverage/pdm_cov.ucdb -file fx_coverage/pdm_cov.rpt

vcover report -html fx_coverage/pdm_cov.ucdb -htmldir fx_coverage/pdm_cov_html

