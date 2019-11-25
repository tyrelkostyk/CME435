onbreak {resume}
vlib work
vmap work work

vlog dut/*.sv
vlog verification/*.sv

vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add log -r /*
run -all
if [file exists wave.do] { do wave.do }
