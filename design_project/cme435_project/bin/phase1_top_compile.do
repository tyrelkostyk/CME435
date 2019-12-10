onbreak {resume}
if [file exists work] { vdel -all }
vlib work
vmap work work

vlog dut/*.svp dut/*.sv
vlog +incdir+verification/phase1_top verification/phase1_top/*.sv

vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add log -r /*
run -all
if [file exists bin/phase1_top_wave.do] {
	do bin/phase1_top_wave.do
}
