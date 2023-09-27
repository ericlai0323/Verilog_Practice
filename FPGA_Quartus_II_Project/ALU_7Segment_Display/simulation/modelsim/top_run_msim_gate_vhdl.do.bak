transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vcom -93 -work work {top.vho}

vlog -vlog01compat -work work +incdir+C:/Users/Ericlai/Documents/Verilog_Practice/FPGA_Quartus_II_Project/ALU_7Segment_Display {C:/Users/Ericlai/Documents/Verilog_Practice/FPGA_Quartus_II_Project/ALU_7Segment_Display/top_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -sdftyp /NA=top_vhd.sdo -L cycloneii -L gate_work -L work -voptargs="+acc"  top_tb

add wave *
view structure
view signals
run -all
