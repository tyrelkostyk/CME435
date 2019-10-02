onbreak {resume}
if [file exists work] {
		vdel -all
}
vlib work
vmap work work
vlog *.sv
vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt
add wave -noupdate /tbench_top/clk
add wave -noupdate /tbench_top/reset
add wave -noupdate -radix decimal /tbench_top/UDC_output
add wave -noupdate -radix decimal /tbench_top/UDC_input
add wave -noupdate -radix binary /tbench_top/sel
add log -r /*
run 1000
do wave.do
