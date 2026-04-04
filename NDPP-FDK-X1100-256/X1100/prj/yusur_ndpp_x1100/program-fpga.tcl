write_cfgmem -format mcs -size 64 -interface SPIx8 -loadbit {up 0x00000000 "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100-256/X1100/prj/yusur_ndpp_x1100/yusur_ndpp_x1100.runs/impl_1/yusur_ndpp_x1100.bit" } -force -file "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100-256/X1100/prj/yusur_ndpp_x1100/yusur_ndpp_x1100-256.mcs"
open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
set_property PROGRAM.FILE {/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100-256/X1100/prj/yusur_ndpp_x1100/yusur_ndpp_x1100.runs/impl_1/yusur_ndpp_x1100.bit} [get_hw_devices xcku15p_CIV_0]
current_hw_device [get_hw_devices xcku15p_CIV_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcku15p_CIV_0] 0]
create_hw_cfgmem -hw_device [lindex [get_hw_devices xcku15p_CIV_0] 0] [lindex [get_cfgmem_parts {is25wp256d-spi-x1_x2_x4_x8}] 0]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
refresh_hw_device [lindex [get_hw_devices xcku15p_CIV_0] 0]
set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.FILES [list "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100-256/X1100/prj/yusur_ndpp_x1100/yusur_ndpp_x1100-256_primary.mcs" "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100-256/X1100/prj/yusur_ndpp_x1100/yusur_ndpp_x1100-256_secondary.mcs" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.PRM_FILE {} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
startgroup 
create_hw_bitstream -hw_device [lindex [get_hw_devices xcku15p_CIV_0] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices xcku15p_CIV_0] 0]]; program_hw_devices [lindex [get_hw_devices xcku15p_CIV_0] 0]; refresh_hw_device [lindex [get_hw_devices xcku15p_CIV_0] 0];
program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xcku15p_CIV_0] 0]]
endgroup
