#!/bin/csh

rm -r work transcript *.vcd *.wlf ../report/phase8*

vlib work

vlog +acc ../verification/phase8_coverage/*.sv ../dut/*.svp
vsim -coverage tbench_top -c -do "coverage save -onexit ../report/phase8_coverage.ucdb; run -all; exit"

vcover report -details ../report/phase8_coverage.ucdb -file ../report/phase8_coverage.rpt
vcover report -html ../report/phase8_coverage.ucdb -htmldir ../report/phase8_coverage
