#!/bin/csh

# TODO: upgrade version of questa? If errors occur
source /CMC/scripts/mentor.questasim.10.3a.csh

set testcase_list="sanity_check buffer_overflow reset manual_port_1"

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

		# remove existing files
		if ( -e work) then
			rm -r work
		endif

		if ( -e report/phase9_testcases_$test) then
			rm -r report/phase9_testcases_$test*
		endif
		mkdir report/phase9_testcases_$test

		if ( -e transcript) then
			rm -r transcript
		endif

    vlib work

		vlog dut/*.svp dut/*.sv
		vlog +cover +acc +incdir+verification/phase9_testcases verification/phase9_testcases/driver.sv
		vlog +cover +acc +incdir+verification/phase9_testcases verification/phase9_testcases/environment.sv
		vlog +cover +acc +incdir+verification/phase9_testcases verification/phase9_testcases/generator.sv
		vlog +cover +acc +incdir+verification/phase9_testcases verification/phase9_testcases/interface.sv
		vlog +cover +acc +incdir+verification/phase9_testcases verification/phase9_testcases/TransBase.sv
		vlog +cover +acc +incdir+verification/phase9_testcases verification/phase9_testcases/monitor.sv
		vlog +cover +acc +incdir+verification/phase9_testcases verification/phase9_testcases/scoreboard.sv
		vlog +cover +acc +incdir+verification/phase9_testcases verification/phase9_testcases/tbench_top.sv
		vlog +cover +acc +incdir+verification/phase9_testcases verification/phase9_testcases/testbench_$test.sv

		vsim -coverage +acc tbench_top -c -do "coverage exclude -srcfile TransBase.sv; coverage exclude -du work.intf -togglenode {addr_in[7:2]} {addr_in[15:10]} {addr_in[23:18]} {addr_in[31:26]} {addr_out[7:2]} {addr_out[15:10]} {addr_out[23:18]} {addr_out[31:26]} {rcv_rdy[3:0]}; coverage exclude -du work.testbench {pkt_count[31:0]} {verbose[31:0]}; coverage exclude -du work.xswitch -togglenode {addr_in[7:2]} {addr_in[15:10]} {addr_in[23:18]} {addr_in[31:26]} {addr_out[7:2]} {addr_out[15:10]} {addr_out[23:18]} {addr_out[31:26]} {rcv_rdy[3:0]}; coverage exclude -srcfile generator.sv -linerange 50 53-56; coverage exclude -srcfile driver.sv -linerange 66-69; coverage exclude -srcfile monitor.sv -linerange 66-69; coverage exclude -srcfile scoreboard.sv -linerange 57 69 74-76; coverage save -onexit -directive -codeAll -cvg report/phase9_testcases_$test/phase9_testcases_$test.ucdb; run -all; exit"


    vcover report -details report/phase9_testcases_$test/phase9_testcases_$test.ucdb -file report/phase9_testcases_$test/phase9_testcases_$test.rpt
    vcover report -html report/phase9_testcases_$test/phase9_testcases_$test.ucdb -htmldir report/phase9_testcases_$test/phase9_testcases_$test

	else
		echo "Invalid option. Please use the -l option to show the list of available testcases, or -t <testcase> to run a specific testcase."
	endif
endif
