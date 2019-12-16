#!/bin/csh

# TODO: upgrade version of questa? If errors occur
source /CMC/scripts/mentor.questasim.10.3a.csh

set testcase_list="sanity_check buffer_overflow manual_port_1 reset"

if ($#argv == 0) then
	echo "No coverage mode specified. Please give -cc or -fc for code coverage or functional coverage (respectively)."
	exit
endif

if ($#argv == 1) then
  if ("$argv[1]" == "-cc") then
    set COV_OPT="-directive -codeAll"
		set COV="cx"
		set COVDIR="cx_coverage"
	else	if ("$argv[1]" == "-fc") then
		set COV_OPT="-cvg"
		set COV="fx"
		set COVDIR="fx_coverage"
	else
		echo "Invalid option. Please give -cc or -fc for code coverage or functional coverage (respectively)."
		exit
  endif

	# remove existing files
	if ( -e work) then
		rm -r work
	endif

	if ( -e transcript) then
		rm -r transcript
	endif

	if ( -e report/$COVDIR) then
		rm -r report/$COVDIR*
	endif
	mkdir report/$COVDIR

	vlib work

	vlog dut/*.svp dut/*.sv
	vlog +cover=t +acc +incdir+verification/regression_test verification/regression_test/driver.sv
	vlog +cover=t +acc +incdir+verification/regression_test verification/regression_test/environment.sv
	vlog +cover=t +acc +incdir+verification/regression_test verification/regression_test/generator.sv
	vlog +cover=t +acc +incdir+verification/regression_test verification/regression_test/interface.sv
	vlog +cover=t +acc +incdir+verification/regression_test verification/regression_test/TransBase.sv
	vlog +cover=t +acc +incdir+verification/regression_test verification/regression_test/monitor.sv
	vlog +cover=t +acc +incdir+verification/regression_test verification/regression_test/scoreboard.sv
	vlog +cover=t +acc +incdir+verification/regression_test verification/regression_test/tbench_top.sv

	foreach testcase ($testcase_list)
		vlog +cover=t +acc +incdir+verification/regression_test verification/regression_test/testbench_$testcase.sv
		vsim -coverage tbench_top -c -do "coverage exclude -srcfile TransBase.sv; coverage exclude -du work.intf -togglenode {addr_in[7:2]} {addr_in[15:10]} {addr_in[23:18]} {addr_in[31:26]} {addr_out[7:2]} {addr_out[15:10]} {addr_out[23:18]} {addr_out[31:26]} {rcv_rdy[3:0]}; coverage exclude -du work.testbench {pkt_count[31:0]} {verbose[31:0]}; coverage exclude -du work.xswitch -togglenode {addr_in[7:2]} {addr_in[15:10]} {addr_in[23:18]} {addr_in[31:26]} {addr_out[7:2]} {addr_out[15:10]} {addr_out[23:18]} {addr_out[31:26]} {rcv_rdy[3:0]}; coverage exclude -srcfile generator.sv -linerange 50 53-56; coverage exclude -srcfile driver.sv -linerange 66-69; coverage exclude -srcfile monitor.sv -linerange 66-69; coverage exclude -srcfile scoreboard.sv -linerange 57 69 74-76; coverage save -onexit $COV_OPT report/$COVDIR/regression_$testcase.ucdb; run -all; exit"

	end

	vcover merge -64 report/$COVDIR/xswitch_$COV.ucdb report/$COVDIR/*.ucdb

	vcover report -details report/$COVDIR/xswitch_$COV.ucdb -file report/$COVDIR/xswitch_$COV.rpt
	vcover report -html report/$COVDIR/xswitch_$COV.ucdb -htmldir report/$COVDIR/xswitch_$COV
	exit
endif

if ($#argv == 2) then
	echo "Invalid entry; too many arguments specified. Please give -cc or -fc for code coverage or functional coverage (respectively)."
endif
