# --- Configuration Parameters ---
# Adjust these paths to match your exact file locations
set base_dir       "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100-256/X1100/prj/yusur_ndpp_x1100"

# Output MCS base filename (write_cfgmem will automatically append _primary and _secondary)
set mcs_primary    "$base_dir/yusur_ndpp_x1100_primary.mcs"
set mcs_secondary  "$base_dir/yusur_ndpp_x1100_secondary.mcs"

set hw_target_path "*/xilinx_tcf/Xilinx/15051AA"
set fpga_device    "xcku15p_CIV_0"
set flash_part     "is25wp256d-spi-x1_x2_x4_x8"

# ==============================================================================
# 1. Open Hardware Manager and Connect
# ==============================================================================
puts "INFO: Opening Hardware Manager..."
open_hw_manager
connect_hw_server -allow_non_jtag

# ==============================================================================
# 2. Open Hardware Target
# ==============================================================================
puts "INFO: Opening Hardware Target..."
open_hw_target [get_hw_targets $hw_target_path]

# ==============================================================================
# 3. Select Device and Set Properties
# ==============================================================================
puts "INFO: Selecting Device $fpga_device..."
current_hw_device [get_hw_devices $fpga_device]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices $fpga_device] 0]

# ==============================================================================
# 4. Create Flash Device Object
# ==============================================================================
puts "INFO: Creating Flash Device ($flash_part)..."
# Check if one exists and delete it first to be safe
set existing_mem [get_property PROGRAM.HW_CFGMEM [get_hw_devices $fpga_device]]
if {$existing_mem ne ""} {
    delete_hw_cfgmem $existing_mem
}

create_hw_cfgmem -hw_device [lindex [get_hw_devices $fpga_device] 0] [lindex [get_cfgmem_parts $flash_part] 0]

# ==============================================================================
# 5. Configure Flash Programming Properties
# ==============================================================================
set flash_obj [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $fpga_device] 0]]

set_property PROGRAM.ADDRESS_RANGE  {use_file} $flash_obj
set_property PROGRAM.FILES [list $mcs_primary $mcs_secondary] $flash_obj
set_property PROGRAM.PRM_FILE {} $flash_obj
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} $flash_obj
set_property PROGRAM.BLANK_CHECK  0 $flash_obj
set_property PROGRAM.ERASE  1 $flash_obj
set_property PROGRAM.CFG_PROGRAM  1 $flash_obj
set_property PROGRAM.VERIFY  1 $flash_obj
set_property PROGRAM.CHECKSUM  0 $flash_obj

# ==============================================================================
# 6. Execute Programming
# ==============================================================================
puts "INFO: Starting Flash Programming..."
startgroup
create_hw_bitstream -hw_device [lindex [get_hw_devices $fpga_device] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [lindex [get_hw_devices $fpga_device] 0]]
program_hw_devices [lindex [get_hw_devices $fpga_device] 0]
refresh_hw_device [lindex [get_hw_devices $fpga_device] 0]
program_hw_cfgmem -hw_cfgmem $flash_obj
endgroup

puts "SUCCESS: Flash programming completed successfully."

# ==============================================================================
# 7. Cleanup
# ==============================================================================
close_hw_target
close_hw_manager
