onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbench_top/i_intf/clk
add wave -noupdate /tbench_top/i_intf/reset
add wave -noupdate -divider {Inputs to DUT}
add wave -noupdate /tbench_top/i_intf/addr_in
add wave -noupdate /tbench_top/i_intf/data_in
add wave -noupdate /tbench_top/i_intf/valid_in
add wave -noupdate /tbench_top/i_intf/data_rd
add wave -noupdate -divider {Outputs from DUT}
add wave -noupdate /tbench_top/i_intf/addr_out
add wave -noupdate /tbench_top/i_intf/data_out
add wave -noupdate /tbench_top/i_intf/valid_out
add wave -noupdate /tbench_top/i_intf/rcv_rdy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {109 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 158
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {520 ns}
