rm -rf work *.vcd *.wlf *.ini
vlib work
vmap work work
vlog +acc ../verification/phase7_scoreboard/*.sv ../dut/*.svp
vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add wave -radix hexadecimal -position insertpoint sim:/tbench_top/i_intf/clk
add wave -radix hexadecimal -position insertpoint sim:/tbench_top/i_intf/reset
#Combine signals in data out for easy to read ports

add wave -radix hexadecimal -color "orange" {AI3 {sim:/tbench_top/i_intf/addr_in[31]\
																		sim:/tbench_top/i_intf/addr_in[30]\
																		sim:/tbench_top/i_intf/addr_in[29]\
																		sim:/tbench_top/i_intf/addr_in[28]\
																		sim:/tbench_top/i_intf/addr_in[27]\
																		sim:/tbench_top/i_intf/addr_in[26]\
																		sim:/tbench_top/i_intf/addr_in[25]\
																		sim:/tbench_top/i_intf/addr_in[24]}}

add wave -radix hexadecimal -color "orange" {AI2 {sim:/tbench_top/i_intf/addr_in[23]\
																		sim:/tbench_top/i_intf/addr_in[22]\
																		sim:/tbench_top/i_intf/addr_in[21]\
																		sim:/tbench_top/i_intf/addr_in[20]\
																		sim:/tbench_top/i_intf/addr_in[19]\
																		sim:/tbench_top/i_intf/addr_in[18]\
																		sim:/tbench_top/i_intf/addr_in[17]\
																		sim:/tbench_top/i_intf/addr_in[16]}}

add wave -radix hexadecimal -color "orange" {AI1 {sim:/tbench_top/i_intf/addr_in[15]\
																		sim:/tbench_top/i_intf/addr_in[14]\
																		sim:/tbench_top/i_intf/addr_in[13]\
																		sim:/tbench_top/i_intf/addr_in[12]\
																		sim:/tbench_top/i_intf/addr_in[11]\
																		sim:/tbench_top/i_intf/addr_in[10]\
																		sim:/tbench_top/i_intf/addr_in[9]\
																		sim:/tbench_top/i_intf/addr_in[8]}}

add wave -radix hexadecimal -color "orange" {AI0 {sim:/tbench_top/i_intf/addr_in[7]\
																		sim:/tbench_top/i_intf/addr_in[6]\
																		sim:/tbench_top/i_intf/addr_in[5]\
																		sim:/tbench_top/i_intf/addr_in[4]\
																		sim:/tbench_top/i_intf/addr_in[3]\
																		sim:/tbench_top/i_intf/addr_in[2]\
																		sim:/tbench_top/i_intf/addr_in[1]\
																		sim:/tbench_top/i_intf/addr_in[0]}}


add wave -radix hexadecimal -color "orange red" {DI3 {sim:/tbench_top/i_intf/data_in[31]\
																		sim:/tbench_top/i_intf/data_in[30]\
																		sim:/tbench_top/i_intf/data_in[29]\
																		sim:/tbench_top/i_intf/data_in[28]\
																		sim:/tbench_top/i_intf/data_in[27]\
																		sim:/tbench_top/i_intf/data_in[26]\
																		sim:/tbench_top/i_intf/data_in[25]\
																		sim:/tbench_top/i_intf/data_in[24]}}

add wave -radix hexadecimal -color "orange red" {DI2 {sim:/tbench_top/i_intf/data_in[23]\
																		sim:/tbench_top/i_intf/data_in[22]\
																		sim:/tbench_top/i_intf/data_in[21]\
																		sim:/tbench_top/i_intf/data_in[20]\
																		sim:/tbench_top/i_intf/data_in[19]\
																		sim:/tbench_top/i_intf/data_in[18]\
																		sim:/tbench_top/i_intf/data_in[17]\
																		sim:/tbench_top/i_intf/data_in[16]}}

add wave -radix hexadecimal -color "orange red" {DI1 {sim:/tbench_top/i_intf/data_in[15]\
																		sim:/tbench_top/i_intf/data_in[14]\
																		sim:/tbench_top/i_intf/data_in[13]\
																		sim:/tbench_top/i_intf/data_in[12]\
																		sim:/tbench_top/i_intf/data_in[11]\
																		sim:/tbench_top/i_intf/data_in[10]\
																		sim:/tbench_top/i_intf/data_in[9]\
																		sim:/tbench_top/i_intf/data_in[8]}}

add wave -radix hexadecimal -color "orange red" {DI0 {sim:/tbench_top/i_intf/data_in[7]\
																		sim:/tbench_top/i_intf/data_in[6]\
																		sim:/tbench_top/i_intf/data_in[5]\
																		sim:/tbench_top/i_intf/data_in[4]\
																		sim:/tbench_top/i_intf/data_in[3]\
																		sim:/tbench_top/i_intf/data_in[2]\
																		sim:/tbench_top/i_intf/data_in[1]\
																		sim:/tbench_top/i_intf/data_in[0]}}


add wave -radix binary -position insertpoint sim:/tbench_top/i_intf/valid_in
add wave -radix binary -position insertpoint sim:/tbench_top/i_intf/rcv_rdy

add wave -radix hexadecimal -color "light blue" {DO3 {sim:/tbench_top/i_intf/data_out[31]\
																		sim:/tbench_top/i_intf/data_out[30]\
																		sim:/tbench_top/i_intf/data_out[29]\
																		sim:/tbench_top/i_intf/data_out[28]\
																		sim:/tbench_top/i_intf/data_out[27]\
																		sim:/tbench_top/i_intf/data_out[26]\
																		sim:/tbench_top/i_intf/data_out[25]\
																		sim:/tbench_top/i_intf/data_out[24]}}

add wave -radix hexadecimal -color "light blue" {DO2 {sim:/tbench_top/i_intf/data_out[23]\
																		sim:/tbench_top/i_intf/data_out[22]\
																		sim:/tbench_top/i_intf/data_out[21]\
																		sim:/tbench_top/i_intf/data_out[20]\
																		sim:/tbench_top/i_intf/data_out[19]\
																		sim:/tbench_top/i_intf/data_out[18]\
																		sim:/tbench_top/i_intf/data_out[17]\
																		sim:/tbench_top/i_intf/data_out[16]}}

add wave -radix hexadecimal -color "light blue" {DO1 {sim:/tbench_top/i_intf/data_out[15]\
																		sim:/tbench_top/i_intf/data_out[14]\
																		sim:/tbench_top/i_intf/data_out[13]\
																		sim:/tbench_top/i_intf/data_out[12]\
																		sim:/tbench_top/i_intf/data_out[11]\
																		sim:/tbench_top/i_intf/data_out[10]\
																		sim:/tbench_top/i_intf/data_out[9]\
																		sim:/tbench_top/i_intf/data_out[8]}}

add wave -radix hexadecimal -color "light blue" {DO0 {sim:/tbench_top/i_intf/data_out[7]\
																		sim:/tbench_top/i_intf/data_out[6]\
																		sim:/tbench_top/i_intf/data_out[5]\
																		sim:/tbench_top/i_intf/data_out[4]\
																		sim:/tbench_top/i_intf/data_out[3]\
																		sim:/tbench_top/i_intf/data_out[2]\
																		sim:/tbench_top/i_intf/data_out[1]\
																		sim:/tbench_top/i_intf/data_out[0]}}

add wave -radix hexadecimal -color "purple" {AO3 {sim:/tbench_top/i_intf/addr_out[31]\
																		sim:/tbench_top/i_intf/addr_out[30]\
																		sim:/tbench_top/i_intf/addr_out[29]\
																		sim:/tbench_top/i_intf/addr_out[28]\
																		sim:/tbench_top/i_intf/addr_out[27]\
																		sim:/tbench_top/i_intf/addr_out[26]\
																		sim:/tbench_top/i_intf/addr_out[25]\
																		sim:/tbench_top/i_intf/addr_out[24]}}

add wave -radix hexadecimal -color "purple" {AO2 {sim:/tbench_top/i_intf/addr_out[23]\
																		sim:/tbench_top/i_intf/addr_out[22]\
																		sim:/tbench_top/i_intf/addr_out[21]\
																		sim:/tbench_top/i_intf/addr_out[20]\
																		sim:/tbench_top/i_intf/addr_out[19]\
																		sim:/tbench_top/i_intf/addr_out[18]\
																		sim:/tbench_top/i_intf/addr_out[17]\
																		sim:/tbench_top/i_intf/addr_out[16]}}

add wave -radix hexadecimal -color "purple" {AO1 {sim:/tbench_top/i_intf/addr_out[15]\
																		sim:/tbench_top/i_intf/addr_out[14]\
																		sim:/tbench_top/i_intf/addr_out[13]\
																		sim:/tbench_top/i_intf/addr_out[12]\
																		sim:/tbench_top/i_intf/addr_out[11]\
																		sim:/tbench_top/i_intf/addr_out[10]\
																		sim:/tbench_top/i_intf/addr_out[9]\
																		sim:/tbench_top/i_intf/addr_out[8]}}

add wave -radix hexadecimal -color "purple" {AO0 {sim:/tbench_top/i_intf/addr_out[7]\
																		sim:/tbench_top/i_intf/addr_out[6]\
																		sim:/tbench_top/i_intf/addr_out[5]\
																		sim:/tbench_top/i_intf/addr_out[4]\
																		sim:/tbench_top/i_intf/addr_out[3]\
																		sim:/tbench_top/i_intf/addr_out[2]\
																		sim:/tbench_top/i_intf/addr_out[1]\
																		sim:/tbench_top/i_intf/addr_out[0]}}

add wave -radix binary -position insertpoint sim:/tbench_top/i_intf/valid_out
add wave -radix binary -position insertpoint sim:/tbench_top/i_intf/data_rd

config wave -signalnamewidth 1

add log -r /*
run -a
