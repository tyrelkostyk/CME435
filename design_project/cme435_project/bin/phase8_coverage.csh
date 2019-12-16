#!/bin/csh

# TODO: upgrade version of questa? If errors occur
source /CMC/scripts/mentor.questasim.10.3a.csh

# remove existing files
if ( -e work) then
	rm -r work
endif

if ( -e report/phase8_coverage) then
	rm -r report/phase8_coverage*
endif

if ( -e transcript) then
	rm -r transcript
endif

vlog dut/*.svp dut/*.sv
vlog +cover +acc +incdir+verification/phase8_coverage verification/phase8_coverage/*.sv

vsim < bin/phase8_coverage_vsim_args.txt

vcover report -details report/phase8_coverage.ucdb -file report/phase8_coverage.rpt
vcover report -html report/phase8_coverage.ucdb -htmldir report/phase8_coverage
