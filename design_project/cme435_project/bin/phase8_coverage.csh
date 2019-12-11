#!/bin/csh

rm -r work transcript *.vcd *.wlf report/phase8*

if (! -e work) then
	vlib work
endif

vlog dut/*.svp dut/*.sv
vlog +cover +acc +incdir+verification/phase8_coverage verification/phase8_coverage/*.sv

vsim -coverage +acc tbench_top -c -do "coverage exclude -srcfile TransBase.sv; coverage exclude -du work.intf -togglenode {addr_in[7:2]} {addr_in[15:10]} {addr_in[23:18]} {addr_in[31:26]} {addr_out[7:2]} {addr_out[15:10]} {addr_out[23:18]} {addr_out[31:26]} {rcv_rdy[3:0]}; coverage exclude -du work.testbench {pkt_count[31:0]} {verbose[31:0]}; coverage exclude -du work.xswitch -togglenode {addr_in[7:2]} {addr_in[15:10]} {addr_in[23:18]} {addr_in[31:26]} {addr_out[7:2]} {addr_out[15:10]} {addr_out[23:18]} {addr_out[31:26]} {rcv_rdy[3:0]}; coverage exclude -srcfile generator.sv -linerange 50; coverage exclude -srcfile generator.sv -linerange 53-56; coverage exclude -srcfile driver.sv -linerange 66-69; coverage exclude -srcfile monitor.sv -linerange 66-69; coverage exclude -srcfile scoreboard.sv -linerange 57 74-76; coverage save -onexit -directive -codeAll -cvg report/phase8_coverage.ucdb; run -all; exit"

vcover report -details report/phase8_coverage.ucdb -file report/phase8_coverage.rpt
vcover report -html report/phase8_coverage.ucdb -htmldir report/phase8_coverage
