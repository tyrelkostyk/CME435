onbreak {resume}
if [file exists work] { vdel -all }
vlib work
vmap work work

vlog dut/*.svp dut/*.sv
vlog +incdir+verification/phase9_testcases verification/phase9_testcases/driver.sv
vlog +incdir+verification/phase9_testcases verification/phase9_testcases/environment.sv
vlog +incdir+verification/phase9_testcases verification/phase9_testcases/generator.sv
vlog +incdir+verification/phase9_testcases verification/phase9_testcases/interface.sv
vlog +incdir+verification/phase9_testcases verification/phase9_testcases/TransBase.sv
vlog +incdir+verification/phase9_testcases verification/phase9_testcases/monitor.sv
vlog +incdir+verification/phase9_testcases verification/phase9_testcases/scoreboard.sv
vlog +incdir+verification/phase9_testcases verification/phase9_testcases/tbench_top.sv
vlog +incdir+verification/phase9_testcases verification/phase9_testcases/testbench_buffer_overflow.sv

vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add log -r /*
run -all

if [file exists bin/wave.do] {
	do bin/wave.do
}
