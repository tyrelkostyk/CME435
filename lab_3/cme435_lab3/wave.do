onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbench_top/dut/i_intf/clk
add wave -noupdate /tbench_top/dut/i_intf/reset
add wave -noupdate -divider {Input Interface}
add wave -noupdate /tbench_top/dut/i_intf/bnd_plse
add wave -noupdate -color Red /tbench_top/dut/i_intf/ack
add wave -noupdate -color Gold -itemcolor Gold -radix unsigned /tbench_top/dut/i_intf/data_in
add wave -noupdate -divider {Output Port 1 Interface}
add wave -noupdate /tbench_top/dut/i_intf/proceed_1
add wave -noupdate -radix unsigned /tbench_top/dut/i_intf/newdata_len_1
add wave -noupdate -color Gold -itemcolor Gold -radix unsigned /tbench_top/dut/i_intf/data_out_1
add wave -noupdate -divider {Output Port 2 Interface}
add wave -noupdate /tbench_top/dut/i_intf/proceed_2
add wave -noupdate -radix unsigned /tbench_top/dut/i_intf/newdata_len_2
add wave -noupdate -color Gold -itemcolor Gold -radix unsigned /tbench_top/dut/i_intf/data_out_2
add wave -noupdate -divider {Output Port 3 Interface}
add wave -noupdate /tbench_top/dut/i_intf/proceed_3
add wave -noupdate -radix unsigned /tbench_top/dut/i_intf/newdata_len_3
add wave -noupdate -color Gold -itemcolor Gold -radix unsigned /tbench_top/dut/i_intf/data_out_3
add wave -noupdate -divider {Output Port 4 Interface}
add wave -noupdate /tbench_top/dut/i_intf/proceed_4
add wave -noupdate -radix unsigned /tbench_top/dut/i_intf/newdata_len_4
add wave -noupdate -color Gold -itemcolor Gold -radix unsigned /tbench_top/dut/i_intf/data_out_4
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {185 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 194
configure wave -valuecolwidth 63
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {79 ns} {358 ns}
