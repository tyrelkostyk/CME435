onbreak {resume}
if [file exists work] { vdel -all }
vlib work
vmap work work

vlog dut/*.svp dut/*.sv
vlog +incdir+verification/phase3_base verification/phase3_base/*.sv

vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add log -r /*
run -all

if [file exists bin/phase3_base_wave.do] {
	do bin/phase3_base_wave.do
}
