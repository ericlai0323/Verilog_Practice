transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -sv -work work +incdir+. {top.svo}

vlog -vlog01compat -work work +incdir+C:/Users/Ericlai/Documents/Verilog_Practice/FPGA_Quartus_II_Project/ALU_7Segment_Display {C:/Users/Ericlai/Documents/Verilog_Practice/FPGA_Quartus_II_Project/ALU_7Segment_Display/top_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L cycloneii_ver -L gate_work -L work -voptargs="+acc"  top_tb

add wave *
view structure
view signals
run -all
