onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbench_top/clock
add wave -noupdate /tbench_top/reset
add wave -noupdate /tbench_top/packet_valid
add wave -noupdate /tbench_top/data
add wave -noupdate /tbench_top/data_0
add wave -noupdate /tbench_top/ready_0
add wave -noupdate /tbench_top/read_0
add wave -noupdate /tbench_top/data_1
add wave -noupdate /tbench_top/ready_1
add wave -noupdate /tbench_top/read_1
add wave -noupdate /tbench_top/data_2
add wave -noupdate /tbench_top/ready_2
add wave -noupdate /tbench_top/read_2
add wave -noupdate /tbench_top/data_3
add wave -noupdate /tbench_top/ready_3
add wave -noupdate /tbench_top/read_3
add wave -noupdate /tbench_top/mem_en
add wave -noupdate /tbench_top/mem_rd_wr
add wave -noupdate /tbench_top/mem_data
add wave -noupdate /tbench_top/mem_add
add wave -noupdate /tbench_top/mem
add wave -noupdate /tbench_top/reset_trigger
add wave -noupdate /tbench_top/reset_finished
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 128
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
WaveRestoreZoom {0 ns} {1072 ns}
