onbreak {resume}
if [file exists work] { vdel -all }
vlib work
vmap work work

vlog dut/*.svp
vlog testbench/phase1_top/*.sv
vlog testbench/phase2_environment/*.sv
vlog testbench/phase3_base/*.sv
vlog testbench/phase4_generator/*.sv
vlog testbench/phase5_driver/*.sv
vlog testbench/phase6_monitor/*.sv
vlog testbench/phase7_scoreboard/*.sv
vlog testbench/phase9_testcases/*.sv

vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add log -r /*
run -all
if [file exists wave.do] { do wave.do }
