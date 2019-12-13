#!/bin/csh

set testcase_list="sanity_check buffer_overflow"

if ($#argv == 0) then
	echo "No testcase specified: running testbench_sanity_check"
	set test="sanity_check"
endif

if ($#argv == 1) then
  if ("$argv[1]" == "-l") then
    foreach testcase ($testcase_list)
      echo $testcase
    end
	else
		echo "Invalid option. Please use the -l option to show the list of available testcases, or -t <testcase> to run a specific testcase."
  endif
endif

if ($#argv == 2) then
  if ("$argv[1]" == "-t") then
		set test="$argv[2]"

		# remove existing files (experimental - even needed?)
		if ( -e work) then
			rm -r work
		endif

		if ( -e report/phase9*) then
			rm -r report/phase9*
		endif

		if ( -e transcript) then
			rm -r transcript
		endif

    vlib work

		vlog dut/*.svp dut/*.sv
		vlog +incdir+verification/phase9_testcases verification/phase9_testcases/driver.sv
		vlog +incdir+verification/phase9_testcases verification/phase9_testcases/environment.sv
		vlog +incdir+verification/phase9_testcases verification/phase9_testcases/generator.sv
		vlog +incdir+verification/phase9_testcases verification/phase9_testcases/interface.sv
		vlog +incdir+verification/phase9_testcases verification/phase9_testcases/TransBase.sv
		vlog +incdir+verification/phase9_testcases verification/phase9_testcases/monitor.sv
		vlog +incdir+verification/phase9_testcases verification/phase9_testcases/scoreboard.sv
		vlog +incdir+verification/phase9_testcases verification/phase9_testcases/tbench_top.sv
		vlog +incdir+verification/phase9_testcases verification/phase9_testcases/testbench_$test.sv

		vsim < bin/phase9_testcases_vsim_args.txt

    vcover report -details report/phase9_testcases_$test.ucdb -file report/phase9_testcases_$test.rpt
    vcover report -html report/phase9_testcases_$test.ucdb -htmldir report/phase9_testcases_$test

	else
		echo "Invalid option. Please use the -l option to show the list of available testcases, or -t <testcase> to run a specific testcase."
	endif
endif
