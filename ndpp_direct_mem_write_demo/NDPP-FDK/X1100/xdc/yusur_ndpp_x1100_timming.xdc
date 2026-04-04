############################################################################
#
#   X1100 XDC File
#
#  Revision 1.00.00 - Intial Release
#
#################################################################################

## Performance Test Version Constraints

#set_max_delay -from [get_pins u_ndpp_performance_wrapper/u_performance_timepiece/timepiece_en_reg/C] -to [get_pins u_ndpp_performance_wrapper/u_performance_timepiece/macrx_performance_flag_reg/D] 2.000
#set_max_delay -from [get_pins u_ndpp_performance_wrapper/u_performance_timepiece/timepiece_en_reg/C] -to [get_pins u_ndpp_performance_wrapper/u_performance_timepiece/mactx_performance_flag_reg/D] 2.000

#
# Create Clock Constraints
#
create_clock -period 10.000 -name pcie_ref_clk [get_ports pcie_refclk_p]
create_clock -period 6.400 -name gtrefclk0 [get_ports sfp_refclk_p]

### PLL-OUT-CLOCK
create_generated_clock -name clk_conv_100m [get_pins u_yusur_ndpp_fdk/clk_conv_inst/inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name clk_conv_250m [get_pins u_yusur_ndpp_fdk/clk_conv_inst/inst/mmcme4_adv_inst/CLKOUT1]

### PCIE AXI CLOCK
create_generated_clock -name pcie_axi_clock [get_pins u_yusur_ndpp_fdk/u_system/yusur_dma_i/u_pcie4_uscale_plus_x1100/inst/pcie4_uscale_plus_x1100_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]

### MAC AXI CLOCK
create_generated_clock -name mac0_axis_tx_clock [get_pins {u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper/u_mac0_sfp10g/sfp_phy_inst/xcvr.eth_xcvr_gty_full_inst/inst/gen_gtwizard_gtye4_top.eth_xcvr_gty_full_x1100_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name mac0_axis_rx_clock [get_pins {u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper/u_mac0_sfp10g/sfp_phy_inst/xcvr.eth_xcvr_gty_full_inst/inst/gen_gtwizard_gtye4_top.eth_xcvr_gty_full_x1100_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_generated_clock -name mac1_axis_tx_clock [get_pins {u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper/u_mac1_sfp10g/sfp_phy_inst/xcvr.eth_xcvr_gty_channel_inst/inst/gen_gtwizard_gtye4_top.eth_xcvr_gty_channel_x1100_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name mac1_axis_rx_clock [get_pins {u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper/u_mac1_sfp10g/sfp_phy_inst/xcvr.eth_xcvr_gty_channel_inst/inst/gen_gtwizard_gtye4_top.eth_xcvr_gty_channel_x1100_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_generated_clock -name mac2_axis_tx_clock [get_pins {u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper/u_mac2_sfp10g/sfp_phy_inst/xcvr.eth_xcvr_gty_channel_inst/inst/gen_gtwizard_gtye4_top.eth_xcvr_gty_channel_x1100_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name mac2_axis_rx_clock [get_pins {u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper/u_mac2_sfp10g/sfp_phy_inst/xcvr.eth_xcvr_gty_channel_inst/inst/gen_gtwizard_gtye4_top.eth_xcvr_gty_channel_x1100_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

create_generated_clock -name mac3_axis_tx_clock [get_pins {u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper/u_mac3_sfp10g/sfp_phy_inst/xcvr.eth_xcvr_gty_channel_inst/inst/gen_gtwizard_gtye4_top.eth_xcvr_gty_channel_x1100_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name mac3_axis_rx_clock [get_pins {u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper/u_mac3_sfp10g/sfp_phy_inst/xcvr.eth_xcvr_gty_channel_inst/inst/gen_gtwizard_gtye4_top.eth_xcvr_gty_channel_x1100_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[5].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]

# create_generated_clock -name microblaze_clock  [get_pins u_yusur_ndpp_fdk/u_chip_encrypt_wrapper/chip_encrypt_i/clk_wiz_1/inst/mmcme4_adv_inst/CLKOUT0]

# set_false_path -from [get_pins {u_yusur_ndpp_fdk/u_chip_encrypt_wrapper/chip_encrypt_i/axi_gpio_0/U0/gpio_core_1/Not_Dual.gpio_Data_Out_reg[0]*/C}]

## MAC Reset Signal
set_false_path -from [get_pins {u_yusur_ndpp_fdk/u_xcvr_eth10g/u_mac_sync_reset/u_mac*_sync_reset/sync_reg_reg[1]*/C}]
## PCIE Reset Signal
set_false_path -from [get_pins {u_yusur_ndpp_fdk/u_system/u_pcie_sync_reset/sync_reg_reg[1]*/C}]
## PLL Reset Signal
set_false_path -from [get_pins u_yusur_ndpp_fdk/hw_reset_n_reg/C]
## MAC Constraints
# set_false_path -from [get_pins u_yusur_ndpp_fdk/u_xcvr_eth10g/u_sfp10g_wrapper/u_mac*_sfp10g/sfp_mac10g_inst/axis_xgmii_tx_inst/*fault_en*/C]

# pcie_ref_clk vs TXOUTCLK
set_clock_groups -name async18 -asynchronous -group [get_clocks pcie_ref_clk] -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]]
set_clock_groups -name async19 -asynchronous -group [get_clocks -of_objects [get_pins -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gthe4_channel_inst[3].GTHE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks pcie_ref_clk]
# ASYNC CLOCK GROUPINGS

# pcie_ref_clk vs user_clk
set_clock_groups -name async5 -asynchronous -group [get_clocks pcie_ref_clk] -group [get_clocks pcie_axi_clock]
set_clock_groups -name async6 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks pcie_ref_clk]

# pcie_ref_clk vs pclk
set_clock_groups -name async1 -asynchronous -group [get_clocks pcie_ref_clk] -group [get_clocks -of_objects [get_pins u_yusur_ndpp_fdk/u_system/yusur_dma_i/u_pcie4_uscale_plus_x1100/inst/pcie4_uscale_plus_x1100_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/O]]
set_clock_groups -name async2 -asynchronous -group [get_clocks -of_objects [get_pins u_yusur_ndpp_fdk/u_system/yusur_dma_i/u_pcie4_uscale_plus_x1100/inst/pcie4_uscale_plus_x1100_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_pclk/O]] -group [get_clocks pcie_ref_clk]

set_clock_groups -name async24 -asynchronous -group [get_clocks -of_objects [get_pins u_yusur_ndpp_fdk/u_system/yusur_dma_i/u_pcie4_uscale_plus_x1100/inst/pcie4_uscale_plus_x1100_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_intclk/O]] -group [get_clocks pcie_ref_clk]


set_clock_groups -name clk250mgroup_1 -asynchronous -group [get_clocks clk_conv_250m] -group [get_clocks mac0_axis_tx_clock]
set_clock_groups -name clk250mgroup_2 -asynchronous -group [get_clocks clk_conv_250m] -group [get_clocks mac0_axis_rx_clock]
set_clock_groups -name clk250mgroup_3 -asynchronous -group [get_clocks clk_conv_250m] -group [get_clocks mac1_axis_tx_clock]
set_clock_groups -name clk250mgroup_4 -asynchronous -group [get_clocks clk_conv_250m] -group [get_clocks mac1_axis_rx_clock]
set_clock_groups -name clk250mgroup_5 -asynchronous -group [get_clocks clk_conv_250m] -group [get_clocks mac2_axis_tx_clock]
set_clock_groups -name clk250mgroup_6 -asynchronous -group [get_clocks clk_conv_250m] -group [get_clocks mac2_axis_rx_clock]

set_clock_groups -name clk250mgroup_7 -asynchronous -group [get_clocks clk_conv_250m] -group [get_clocks mac3_axis_tx_clock]
set_clock_groups -name clk250mgroup_8 -asynchronous -group [get_clocks clk_conv_250m] -group [get_clocks mac3_axis_rx_clock]

# set_clock_groups -name clk100mgroup_1 -asynchronous -group [get_clocks clk_conv_100m] -group [get_clocks mac0_axis_tx_clock]
# set_clock_groups -name clk100mgroup_2 -asynchronous -group [get_clocks clk_conv_100m] -group [get_clocks mac0_axis_rx_clock]
# set_clock_groups -name clk100mgroup_3 -asynchronous -group [get_clocks clk_conv_100m] -group [get_clocks mac1_axis_tx_clock]
# set_clock_groups -name clk100mgroup_4 -asynchronous -group [get_clocks clk_conv_100m] -group [get_clocks mac1_axis_rx_clock]
# set_clock_groups -name clk100mgroup_5 -asynchronous -group [get_clocks clk_conv_100m] -group [get_clocks mac2_axis_tx_clock]
# set_clock_groups -name clk100mgroup_6 -asynchronous -group [get_clocks clk_conv_100m] -group [get_clocks mac2_axis_rx_clock]
# set_clock_groups -name clk100mgroup_7 -asynchronous -group [get_clocks clk_conv_100m] -group [get_clocks mac3_axis_tx_clock]
# set_clock_groups -name clk100mgroup_8 -asynchronous -group [get_clocks clk_conv_100m] -group [get_clocks mac3_axis_rx_clock]
set_clock_groups -name clk100mgroup_9 -asynchronous -group [get_clocks clk_conv_100m] -group [get_clocks clk_conv_250m]

set_clock_groups -name pcieaxiclkgroup_1 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks mac0_axis_tx_clock]
set_clock_groups -name pcieaxiclkgroup_2 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks mac0_axis_rx_clock]
set_clock_groups -name pcieaxiclkgroup_3 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks mac1_axis_tx_clock]
set_clock_groups -name pcieaxiclkgroup_4 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks mac1_axis_rx_clock]
set_clock_groups -name pcieaxiclkgroup_5 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks mac2_axis_tx_clock]
set_clock_groups -name pcieaxiclkgroup_6 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks mac2_axis_rx_clock]
set_clock_groups -name pcieaxiclkgroup_7 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks mac3_axis_tx_clock]
set_clock_groups -name pcieaxiclkgroup_8 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks mac3_axis_rx_clock]

set_clock_groups -name pcieaxiclkgroup_9 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks clk_conv_250m]
set_clock_groups -name pcieaxiclkgroup_10 -asynchronous -group [get_clocks pcie_axi_clock] -group [get_clocks clk_conv_100m]


set_clock_groups -name macclk_group_0 -asynchronous -group [get_clocks mac0_axis_tx_clock] -group [get_clocks mac0_axis_rx_clock]
set_clock_groups -name macclk_group_1 -asynchronous -group [get_clocks mac0_axis_tx_clock] -group [get_clocks mac1_axis_rx_clock]
set_clock_groups -name macclk_group_2 -asynchronous -group [get_clocks mac0_axis_tx_clock] -group [get_clocks mac2_axis_rx_clock]
set_clock_groups -name macclk_group_3 -asynchronous -group [get_clocks mac0_axis_tx_clock] -group [get_clocks mac3_axis_rx_clock]

set_clock_groups -name macclk_group_4 -asynchronous -group [get_clocks mac1_axis_tx_clock] -group [get_clocks mac0_axis_rx_clock]
set_clock_groups -name macclk_group_5 -asynchronous -group [get_clocks mac1_axis_tx_clock] -group [get_clocks mac1_axis_rx_clock]
set_clock_groups -name macclk_group_6 -asynchronous -group [get_clocks mac1_axis_tx_clock] -group [get_clocks mac2_axis_rx_clock]
set_clock_groups -name macclk_group_7 -asynchronous -group [get_clocks mac1_axis_tx_clock] -group [get_clocks mac3_axis_rx_clock]

set_clock_groups -name macclk_group_8 -asynchronous -group [get_clocks mac2_axis_tx_clock] -group [get_clocks mac0_axis_rx_clock]
set_clock_groups -name macclk_group_9 -asynchronous -group [get_clocks mac2_axis_tx_clock] -group [get_clocks mac1_axis_rx_clock]
set_clock_groups -name macclk_group_10 -asynchronous -group [get_clocks mac2_axis_tx_clock] -group [get_clocks mac2_axis_rx_clock]
set_clock_groups -name macclk_group_11 -asynchronous -group [get_clocks mac2_axis_tx_clock] -group [get_clocks mac3_axis_rx_clock]

set_clock_groups -name macclk_group_12 -asynchronous -group [get_clocks mac3_axis_tx_clock] -group [get_clocks mac0_axis_rx_clock]
set_clock_groups -name macclk_group_13 -asynchronous -group [get_clocks mac3_axis_tx_clock] -group [get_clocks mac1_axis_rx_clock]
set_clock_groups -name macclk_group_14 -asynchronous -group [get_clocks mac3_axis_tx_clock] -group [get_clocks mac2_axis_rx_clock]
set_clock_groups -name macclk_group_15 -asynchronous -group [get_clocks mac3_axis_tx_clock] -group [get_clocks mac3_axis_rx_clock]

# set_clock_groups -name microclkgroup_1  -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks mac0_axis_tx_clock]
# set_clock_groups -name microclkgroup_2  -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks mac0_axis_rx_clock]
# set_clock_groups -name microclkgroup_3  -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks mac1_axis_tx_clock]
# set_clock_groups -name microclkgroup_4  -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks mac1_axis_rx_clock]
# set_clock_groups -name microclkgroup_5  -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks mac2_axis_tx_clock]
# set_clock_groups -name microclkgroup_6  -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks mac2_axis_rx_clock]
# set_clock_groups -name microclkgroup_7  -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks mac3_axis_tx_clock]
# set_clock_groups -name microclkgroup_8  -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks mac3_axis_rx_clock]
# set_clock_groups -name microclkgroup_9  -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks pcie_axi_clock]
# set_clock_groups -name microclkgroup_10 -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks clk_conv_100m]
# set_clock_groups -name microclkgroup_11 -asynchronous -group [get_clocks microblaze_clock] -group [get_clocks clk_conv_250m]


