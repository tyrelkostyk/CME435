#!/bin/csh

# TODO: upgrade version of questa? If errors occur
source /CMC/scripts/mentor.questasim.10.3a.csh

set testcase_list="sanity_check buffer_overflow"

if ($#argv == 0) then
	echo "No coverage mode specified. Please give -cc or -fc for code coverage or functional coverage (respectively)"
endif

if ($#argv == 1) then
  if ("$argv[1]" == "-cc") then
    set COV_OPT="-directive -codeAll"
		set COV="cc"
		rm -r report/cx_coverage*
		mkdir report/cx_coverage
	else	if ("$argv[1]" == "-fc") then
		set COV_OPT="-cvg"
		set COV="fc"
		rm -r report/fx_coverage*
		mkdir report/fx_coverage
	else
		echo "Invalid option. Please give -cc or -fc for code coverage or functional coverage (respectively)"
		exit
  endif

	# remove existing files
	if ( -e work) then
		rm -r work
	endif

	if ( -e transcript) then
		rm -r transcript
	endif

	vlib work

	vlog dut/*.svp dut/*.sv
	vlog +cover +acc +incdir+verification/regression verification/regression/driver.sv
	vlog +cover +acc +incdir+verification/regression verification/regression/environment.sv
	vlog +cover +acc +incdir+verification/regression verification/regression/generator.sv
	vlog +cover +acc +incdir+verification/regression verification/regression/interface.sv
	vlog +cover +acc +incdir+verification/regression verification/regression/TransBase.sv
	vlog +cover +acc +incdir+verification/regression verification/regression/monitor.sv
	vlog +cover +acc +incdir+verification/regression verification/regression/scoreboard.sv
	vlog +cover +acc +incdir+verification/regression verification/regression/tbench_top.sv

	foreach testcase ($testcase_list)
		vlog +cover +acc +incdir+verification/regression verification/regression/testbench_$testcase.sv
		vsim -coverage +acc tbench_top -c -do "coverage exclude -srcfile TransBase.sv; coverage exclude -du work.intf -togglenode {addr_in[7:2]} {addr_in[15:10]} {addr_in[23:18]} {addr_in[31:26]} {addr_out[7:2]} {addr_out[15:10]} {addr_out[23:18]} {addr_out[31:26]} {rcv_rdy[3:0]}; coverage exclude -du work.testbench {pkt_count[31:0]} {verbose[31:0]}; coverage exclude -du work.xswitch -togglenode {addr_in[7:2]} {addr_in[15:10]} {addr_in[23:18]} {addr_in[31:26]} {addr_out[7:2]} {addr_out[15:10]} {addr_out[23:18]} {addr_out[31:26]} {rcv_rdy[3:0]}; coverage exclude -srcfile generator.sv -linerange 50 53-56; coverage exclude -srcfile driver.sv -linerange 66-69; coverage exclude -srcfile monitor.sv -linerange 66-69; coverage exclude -srcfile scoreboard.sv -linerange 57 69 74-76; coverage save -onexit $COV_OPT report/regression_$testcase.ucdb; run -all; exit"

	end

	vcover report -details report/xswitch_$COV.ucdb -file report/regression_$test.rpt
	vcover report -html report/xswitch_$COV.ucdb -htmldir report/regression_$test

endif

if ($#argv == 2) then
		echo "Invalid option. Please use the -l option to show the list of available testcases, or -t <testcase> to run a specific testcase."
endif
