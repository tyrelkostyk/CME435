onbreak {resume}
if [file exists work] { vdel -all }
vlib work
vmap work work

vlog dut/*.svp
vlog testbench/phase1_top/*.sv
vlog testbench/phase2_environment/*.sv
vlog testbench/phase3_base/*.sv

vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add log -r /*
run -all
if [file exists wave.do] { do wave.do }
