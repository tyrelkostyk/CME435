vlib work

vlog ./dut/*.sv
vlog ./verification/*.sv

vsim -coverage -vopt tbench_top -c +UVM_TESTNAME=mem_wr_rd_test -do "run -all; exit"
