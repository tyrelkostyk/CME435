#!/bin/csh

# source /CMC/scripts/mentor.questa...

# rm -r work transcript *.vcd *.wlf report/phase8*

if (! -e work) then
	vlib work
endif

vlog dut/*.svp dut/*.sv
vlog +cover +acc +incdir+verification/phase8_coverage verification/phase8_coverage/*.sv

vsim < bin/phase8_coverage_vsim_args.txt

vcover report -details report/phase8_coverage.ucdb -file report/phase8_coverage.rpt
vcover report -html report/phase8_coverage.ucdb -htmldir report/phase8_coverage
