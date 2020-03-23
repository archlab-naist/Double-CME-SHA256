#Name: Phan Tri Dung
#
#			Synthesizing Design
#
#
#Define library and design file
set verilogout_no_tri "true"
lappend search_path "/home/hoailuan/proj-emin/rohm18/rohm018lib//synthesis/lib/"

set library_path "/home/hoailuan/proj-emin/rohm18/rohm018lib//synthesis/lib/"
set target_library {ROHM18_FF.db ROHM18_WO_FF.db}
set synthetic_library "dw_foundation.sldb"
set link_library [list ROHM18_FF.db ROHM18_WO_FF.db $synthetic_library]

#set_clock_gating_style -sequential_cell latch -positive_edge_logic {and} -negative_edge_logic {or}

set hdlin_unsigned_integers "false"
# Analyze Command
# analyze -format verilog ../rtl/pcpu.v

 
# Adding design file. 
#set_dont_use {ROHM18/ROHM18*005*}


read_file -format verilog ../rtl/Block_Memory.v
read_file -format verilog ../rtl/Digest_Memory.v
read_file -format verilog ../rtl/Main_Loop_Pipeline-0to63.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-0to63.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-63.v
read_file -format verilog ../rtl/SHA256.v
read_file -format verilog ../rtl/SHA256_Core_Pipeline.v
read_file -format verilog ../rtl/pcpu.v
check_design

#Adding CLK and Input valu 
source ../rtl/pcpu.sdc
link
# compiler switches...                  
# set useUltra 1                      ;# 1 for compile_ultra, 0 for compile

# mapEffort, useUngroup are for    
# non-ultra compile...         
# set mapEffort      high            ;# First pass - low, medium, or high
# set useUngroup 1                    ;# 0 if no flatten, 1 if flatten

# check_design

# Add area optimize
set_max_area -ignore_tns 0


#set_cost_priority -delay
#insert_clock_gating 
#propagate_constraints -gate_clock


# Fixing Heavily Loaded Nets
# set_max_capacitance 3.0
# compile_ultra -only_design_rule
# compile_ultra -no_autoungroup

# Optimizing Across Hierarchical Boundaries
# compile -boundary_optimization
uniquify
# Removing Levels of Hierarchy
# compile -ungroup_all
compile
# ************************************************************
# * now write out the results                                *
# ************************************************************


# •Õ•√•»§ŒÃæ¡∞§À±—¬Á ∏ª˙§»øÙª˙∞ ≥∞§¨∆˛§È§ §§§Ë§¶§À§π§ÅE 
define_name_rules verilog -allowed "A-Z0-9_"
change_names -rules verilog -hierarchy
# •Õ•√•»•ÅEπ•»§ÚΩÒ§≠Ω–§π
write -f verilog -hier -o pcpu_net.v
# •«°º•ø•Ÿ°º•π§À ›¬∏
write -f ddc -hier -o pcpu.ddc
# SDC§ÚΩÒ§≠Ω–§π
write_sdc -version 1.8 -nosplit pcpu.sdc
# SDF§ÚΩÒ§≠Ω–§π
write_sdf -version 2.1 pcpu.sdf
# •ø•§•ﬂ•Û•∞, ÃÃ¿—≈˘§ÚΩ–Œœ. 

#report_clock_gating
redirect pcpu.area.log { report_area }
redirect power.log { report_power }

 quit
