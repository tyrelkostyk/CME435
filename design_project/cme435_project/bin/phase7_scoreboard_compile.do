onbreak {resume}
if [file exists work] { vdel -all }
vlib work
vmap work work

vlog dut/*.svp dut/*.sv
vlog +incdir+verification/phase7_scoreboard verification/phase7_scoreboard/*.sv

vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add log -r /*
run -all

if [file exists bin/wave.do] {
	do bin/wave.do
}
