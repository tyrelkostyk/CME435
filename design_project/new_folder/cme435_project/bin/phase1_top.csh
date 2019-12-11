#!/bin/csh

rm -r work transcript *.vcd

vlib work

vlog +acc ../verification/phase1_top/*.sv ../dut/*.svp
vsim -vopt tbench_top -c -do "run -all; exit"
