vlib work
#vlib viterbilib

vcom -work work ../src/QRSdetection_top.vhd
vcom -work work ../src/lpf.vhd
vcom -work work ../src/hpf.vhd
vcom -work work ../src/derivative.vhd
vcom -work work ../src/square.vhd
vcom -work work ../src/integration.vhd
vcom -work work ../src/decision.vhd
vcom -work work ../src/divider.vhd


vcom -work work ../tb/tb_qrsdetection_top_file.vhd

vsim -novopt tb_qrsdetection_top_file

add wave -hex sim:/tb_qrsdetection_top_file/DUT/reset
add wave -hex sim:/tb_qrsdetection_top_file/DUT/clk
add wave -dec sim:/tb_qrsdetection_top_file/DUT/beat
add wave -dec sim:/tb_qrsdetection_top_file/DUT/bpm
add wave -dec -analog-interpolated -height 100 -min 0 -max 100 sim:/tb_qrsdetection_top_file/DUT/inecg
add wave -dec -analog-interpolated -height 100 -min 0 -max 900 sim:/tb_qrsdetection_top_file/DUT/outlpf1
add wave -dec -analog-interpolated -height 100 -min -100 -max 100 sim:/tb_qrsdetection_top_file/DUT/outhpf1
add wave -dec -analog-interpolated -height 100 -min -100 -max 100 sim:/tb_qrsdetection_top_file/DUT/outdef1
add wave -unsigned -analog-interpolated -height 100 -min 0 -max 500 sim:/tb_qrsdetection_top_file/DUT/outsq1
add wave -unsigned -analog-interpolated -height 100 -min 0 -max 500 sim:/tb_qrsdetection_top_file/DUT/outint2
add wave -hex sim:/tb_qrsdetection_top_file/DUT/outecg
#add wave -hex -r *

run 10000 ms