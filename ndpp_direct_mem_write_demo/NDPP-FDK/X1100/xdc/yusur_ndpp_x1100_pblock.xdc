## MAC Pblock
create_pblock pblock_mac
add_cells_to_pblock [get_pblocks pblock_mac] [get_cells -quiet [list u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper]]
resize_pblock [get_pblocks pblock_mac] -add {CLOCKREGION_X0Y7:CLOCKREGION_X0Y8}
set_property CONTAIN_ROUTING 1 [get_pblocks pblock_mac]
set_property EXCLUDE_PLACEMENT 1 [get_pblocks pblock_mac]
# resize_pblock [get_pblocks pblock_mac] -add {CLOCKREGION_X0Y6:CLOCKREGION_X0Y7}

## PCIE
create_pblock pblock_pcie
add_cells_to_pblock [get_pblocks pblock_pcie] [get_cells -quiet u_yusur_ndpp_fdk/u_system/yusur_dma_i]
# add_cells_to_pblock [get_pblocks pblock_pcie] [get_cells -quiet u_yusur_ndpp_fdk/s_hardware]
add_cells_to_pblock [get_pblocks pblock_pcie] [get_cells -quiet u_yusur_ndpp_fdk/u_base_dma_0]
add_cells_to_pblock [get_pblocks pblock_pcie] [get_cells -quiet u_yusur_ndpp_fdk/u_base_dma_1]
add_cells_to_pblock [get_pblocks pblock_pcie] [get_cells -quiet u_yusur_ndpp_fdk/u_global]
add_cells_to_pblock [get_pblocks pblock_pcie] [get_cells -quiet u_yusur_ndpp_fdk/u_user_dma/u_axis_register]
add_cells_to_pblock [get_pblocks pblock_pcie] [get_cells -quiet u_yusur_ndpp_fdk/u_user_dma_tcpdump_wrapper/u_axis_register]
add_cells_to_pblock [get_pblocks pblock_pcie] [get_cells -quiet u_yusur_ndpp_fdk/u_xcvr_eth10g/u_mac_statistic_regfile]
# resize_pblock [get_pblocks pblock_pcie] -add {CLOCKREGION_X0Y3:CLOCKREGION_X0Y4}
resize_pblock [get_pblocks pblock_pcie] -add {CLOCKREGION_X2Y0:CLOCKREGION_X3Y3}
set_property CONTAIN_ROUTING 1 [get_pblocks pblock_pcie]

## PCIE AXIL REGISTER
create_pblock pblock_axil_register
add_cells_to_pblock [get_pblocks pblock_axil_register] [get_cells -quiet u_yusur_ndpp_fdk/u_system/axi_lite_dec_i]
add_cells_to_pblock [get_pblocks pblock_axil_register] [get_cells -quiet u_yusur_ndpp_fdk/u_system/u_*_axil_register]
resize_pblock [get_pblocks pblock_axil_register] -add {CLOCKREGION_X2Y0:CLOCKREGION_X3Y2}
set_property CONTAIN_ROUTING 1 [get_pblocks pblock_axil_register]


create_pblock pblock_udma
add_cells_to_pblock [get_pblocks pblock_udma] [get_cells -quiet u_yusur_ndpp_fdk/u_user_dma/u_user_dma_h2c_wrapper]
add_cells_to_pblock [get_pblocks pblock_udma] [get_cells -quiet u_yusur_ndpp_fdk/u_user_dma/u_user_dma_c2h_wrapper]
add_cells_to_pblock [get_pblocks pblock_udma] [get_cells -quiet u_yusur_ndpp_fdk/u_user_dma_tcpdump_wrapper/u_tcpdump_buffer_0_dma]
add_cells_to_pblock [get_pblocks pblock_udma] [get_cells -quiet u_yusur_ndpp_fdk/u_user_dma_tcpdump_wrapper/u_tcpdump_buffer_1_dma]
add_cells_to_pblock [get_pblocks pblock_udma] [get_cells -quiet u_yusur_ndpp_fdk/u_user_dma_tcpdump_wrapper/u_tcpdump_buffer_0_crossbar]
add_cells_to_pblock [get_pblocks pblock_udma] [get_cells -quiet u_yusur_ndpp_fdk/u_user_dma_tcpdump_wrapper/u_tcpdump_buffer_1_crossbar]
resize_pblock [get_pblocks pblock_udma] -add {CLOCKREGION_X0Y3:CLOCKREGION_X1Y4}
set_property CONTAIN_ROUTING 1 [get_pblocks pblock_udma]