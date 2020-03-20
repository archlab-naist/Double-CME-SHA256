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


read_file -format verilog ../rtl/Block_Memory_128.v
read_file -format verilog ../rtl/Block_Memory_160.v
read_file -format verilog ../rtl/Block_Memory_192.v
read_file -format verilog ../rtl/Block_Memory_224.v
read_file -format verilog ../rtl/Block_Memory_256.v
read_file -format verilog ../rtl/Block_Memory_288.v
read_file -format verilog ../rtl/Block_Memory_320.v
read_file -format verilog ../rtl/Block_Memory_352.v
read_file -format verilog ../rtl/Block_Memory_384.v
read_file -format verilog ../rtl/Block_Memory_416.v
read_file -format verilog ../rtl/Block_Memory_448.v
read_file -format verilog ../rtl/Block_Memory_480.v
read_file -format verilog ../rtl/Block_Memory_512.v
read_file -format verilog ../rtl/Digest_Memory_2.v
read_file -format verilog ../rtl/Main_Loop_Pipeline-0to63_2.v
read_file -format verilog ../rtl/SHA256.v
read_file -format verilog ../rtl/SHA256_Core_2_Pipeline.v
read_file -format verilog ../rtl/SHA256_Core_3_Pipeline.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-16_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-16_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-17_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-17_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-18_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-18to21_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-19_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-20_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-21_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-22_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-22_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-23_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-23_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-24_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-24_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-25_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-25_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-26_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-26_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-27_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-27_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-28_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-28_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-29_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-29_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-30_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-30_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-31_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-31_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-32to63_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-32to63_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-57_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-58_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-59_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-60_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-61_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-62_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-63_2.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-54_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-55_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-56_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-57_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-58_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-59_3.v
read_file -format verilog ../rtl/SHA256_Memory_Pipeline-60_3.v
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
redirect pcpu.timing.log { report_timing -max_paths 20 }
redirect pcpu.area.log { report_area }
redirect power.log { report_power }

 quit
