#!/bin/csh

./rm_files.sh

if (! -e work) then
	vlib work
endif

if (! -e code_coverage) then
	mkdir code_coverage
endif

vlog dut/*.svp
vlog dut/*.sv

vlog -coveropt 3 +cover testbench/phase1_top/*.sv
vlog -coveropt 3 +cover testbench/phase2_environment/*.sv
vlog -coveropt 3 +cover testbench/phase3_base/*.sv
vlog -coveropt 3 +cover testbench/phase4_generator/*.sv
vlog -coveropt 3 +cover testbench/phase5_driver/*.sv
vlog -coveropt 3 +cover testbench/phase6_monitor/*.sv
vlog -coveropt 3 +cover testbench/phase7_scoreboard/*.sv
vlog -coveropt 3 +cover testbench/phase9_testcases/*.sv


set testcase_list="testbench_bnd_plse_coincidence testbench_max_payload testbench_min_payload testbench_buffer_overflow testbench_sanity_check testbench_reset"
foreach testcase ($testcase_list)
  set testcase_uc = `echo $testcase | tr "[:lower:]" "[:upper:]"`
  vlog -coveropt 3 +cover +acc +define+$testcase_uc testbench/phase9_testcases/$testcase.sv
  vopt +acc tbench_top -o tbench_top_opt
  vsim -coverage -vopt tbench_top_opt -c -do "coverage save -onexit -directive -codeAll code_coverage/$testcase.ucdb;run -all; exit"
end

vcover merge -64 code_coverage/pdm_cov.ucdb code_coverage/*.ucdb

vcover report code_coverage/pdm_cov.ucdb -file code_coverage/pdm_cov.rpt

vcover report -html code_coverage/pdm_cov.ucdb -htmldir code_coverage/pdm_cov_html

