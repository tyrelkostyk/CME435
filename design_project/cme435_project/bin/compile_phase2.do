onbreak {resume}
if [file exists work] { vdel -all }
vlib work
vmap work work

vlog dut/*.svp dut/*.sv
vlog +incdir+verification/phase2_environment verification/phase2_environment/*.sv

vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add log -r /*
run -all

if [file exists bin/phase2_environment_wave.do] {
	do bin/phase2_environment_wave.do
}
