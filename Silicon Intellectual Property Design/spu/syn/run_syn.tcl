#set variable
set lib SPU
set top_module spu

#remove all designs
remove_design -designs

#Read Design File
if { [file exists "$lib"] } { sh rm -r $lib }
sh mkdir $lib

define_design_lib $lib -path ./$lib
analyze -library $lib -format verilog "../rtl/spu.v \
                                       ../rtl/spu_ctrl.v \
                                       ../rtl/spu_datapath.v \
                                       ../rtl/reg_file.v"
elaborate $top_module -architecture verilog -library $lib

#remove unconnected ports
remove_unconnected_ports \
    -blast_buses [get_cells -hierarchical *]

#Setting Clock Constraints
create_clock -name clk \
             -period 10 \
             -waveform {0 5} [get_ports clk]
 
set_dont_touch_network            [get_clocks clk]
set_fix_hold                      [get_clocks clk]
set_clock_uncertainty       0.1   [get_clocks clk]
set_clock_latency   -source 0     [get_clocks clk]
set_clock_latency           1     [get_clocks clk] 
set_input_transition        0.5   [get_clocks clk]
set_clock_transition        0.5   [all_clocks]

#Setting Design Environment
set_operating_conditions -min fast  -max slow
#set_wire_load_model -name tsmc13_wl10 -library slow

set_driving_cell -library slow \
       -lib_cell BUFX2 \
       -pin {Y}  {clk rst}

set_driving_cell -library slow \
   -lib_cell DFFX2   \
   -pin {Q}  [remove_from_collection [all_inputs] {clk rst}]

set_load  [load_of "slow/DFFX1/D"]       [all_outputs]

set_input_delay   -max 5    -clock clk   [remove_from_collection [all_inputs] {clk rst}]
set_input_delay   -min 0.2  -clock clk   [remove_from_collection [all_inputs] {clk rst}]

set_input_delay   -max 1    -clock clk   {rst}
set_input_delay   -min 0.2  -clock clk   {rst}

set_output_delay  -max 5    -clock clk   [all_outputs]
set_output_delay  -min 0.2  -clock clk   [all_outputs]

#Setting recovery removal timing check
set enable_recovery_removal_arcs true

#Setting Area Constraint
set_max_area        0

#Setting DRC Constraint
set_max_fanout      4    [all_inputs]
set_max_transition  0.3  [all_inputs]

#Solve Multiple Instance
uniquify

#solve assign Problem
set verilogout_no_tri true
set_fix_multiple_port_nets \
    -all -buffer_constants [get_designs *]

#check timing
uplevel #0 check_timing

#check design
uplevel #0 check_design


#Synthesis all design
#compile -boundary_optimization -map_effort high -area_effort high
compile_ultra

#remove unconnected ports
remove_unconnected_ports \
    -blast_buses [get_cells -hierarchical *]

#change naming rules
set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true

change_names -hierarchy -rule verilog

define_name_rules name_rule \
      -allowed {a-z A-Z 0-9 _} \
      -max_length 255 -type cell

define_name_rules name_rule \
      -allowed {a-z A-Z 0-9 _[]} \
      -max_length 255 -type net

define_name_rules name_rule \
      -map {{"\\*cell\\*" "cell"}}

define_name_rules name_rule \
      -case_insensitive

change_names -hierarchy -rules name_rule

remove_unconnected_ports \
    -blast_buses [get_cells -hierarchical *]

#Write out ddc
set ddc_name ""
append ddc_name $top_module "_syn.ddc"
write -format ddc -hierarchy \
      -output $ddc_name

#Write out gate-level netlist
set syn_v_name ""
append syn_v_name $top_module "_syn.v" 
write -format verilog -hierarchy -output $syn_v_name

#Write out sdf file
set sdf_name ""
append sdf_name "../sim/gate_sim/run/" $top_module "_syn.sdf"
write_sdf -version 1.0 -context verilog \
         -load_delay net $sdf_name
          
          
#Check setup time violation
uplevel #0 { report_timing -path full -delay max -nworst 1 \
             -max_paths 1 -significant_digits 2 -sort_by group }

#Check hold time violation             
uplevel #0 { report_timing -path full -delay min -nworst 1 \
             -max_paths 1 -significant_digits 2 -sort_by group } 

#Check recovery time violation
uplevel #0 { report_timing  -from { rst } -path full -delay max \
             -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group }

#Check removal time violation
uplevel #0 { report_timing  -from { rst } -path full -delay min \
             -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group }

#Check area             
uplevel #0 { report_area -hierarchy -designware } 

exit

          
