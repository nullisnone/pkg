############################################################################
#  DISCLAIMER:
#  XILINX IS DISCLOSING THIS USER GUIDE, MANUAL, RELEASE NOTE,
#  SCHEMATIC, AND/OR SPECIFICATION (THE "DOCUMENTATION")TO YOU SOLELY
#  FOR USE IN THE DEVELOPMENT OF DESIGNS TO OPERATE WITH XILINX
#  HARDWARE DEVICES. YOU MAY NOT REPRODUCE, DISTRIBUTE, REPUBLISH,
#  DOWNLOAD, DISPLAY, POST, OR TRANSMIT THE DOCUMENTATION IN ANY FORM
#  OR BY ANY MEANS INCLUDING, BUT NOT LIMITED TO, ELECTRONIC,
#  MECHANICAL, PHOTOCOPYING, RECORDING, OR OTHERWISE, WITHOUT THE
#  PRIOR WRITTEN CONSENT OF XILINX. XILINX EXPRESSLY DISCLAIMS ANY
#  LIABILITY ARISING OUT OF YOUR USE OF THE DOCUMENTATION.
#  XILINX RESERVES THE RIGHT, AT ITS SOLE DISCRETION, TO CHANGE THE
#  DOCUMENTATION WITHOUT NOTICE AT ANY TIME. XILINX ASSUMES NO
#  OBLIGATION TO CORRECT ANY ERRORS CONTAINED IN THE DOCUMENTATION,
#  OR TO ADVISE YOU OF ANY CORRECTIONS OR UPDATES. XILINX EXPRESSLY
#  DISCLAIMS ANY LIABILITY IN CONNECTION WITH TECHNICAL SUPPORT OR
#  ASSISTANCETHAT MAY BE PROVIDED TO YOU IN CONNECTION WITH THE
#  DOCUMENTATION.
#  THE DOCUMENTATION IS DISCLOSED TO YOU "AS-IS" WITH NO WARRANTY OF
#  ANY OF THIRD-PARTY RIGHTS. IN NO EVENT WILL XILINXBE LIABLE FOR ANY
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
#  NONINFRINGEMENT STATUTORY, REGARDING THEDOCUMENTATION, INCLUDING
#  ANY WARRANTIES OF KIND.
#  XILINX MAKES NO OTHER WARRANTIES, WHETHER EXPRESS, IMPLIED, OR THE
#  DOCUMENTATION. INCLUDING ANY LOSS OF DATA OR LOST PROFITS, ARISING
#  FROM YOUR USE OF CONSEQUENTIAL, INDIRECT, EXEMPLARY, SPECIAL, OR
#  INCIDENTAL DAMAGES, INCLUDING ANY LOSS OF DATA OR LOST PROFITS,
#  ARISING FROM YOUR USE OF THE DOCUMENTATION.
#
#
#
#   X1100 XDC File
#
#  Revision 1.00.00 - Intial Release
#
#################################################################################
#
# Power Constraint to warn User if design will possibly be over cards power limit
#
#
# Bitstream generation
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx8 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 63.8 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]

set_property BITSTREAM.CONFIG.CONFIGFALLBACK enable [current_design]
set_property BITSTREAM.CONFIG.TIMER_CFG 0x4A000000 [current_design]

##### Only Golden Image
## 0x1C00000 --> 28MB
#  set_property BITSTREAM.CONFIG.TIMER_CFG 0x40040000 [current_design]
#  set_property BITSTREAM.CONFIG.NEXT_CONFIG_REBOOT enable [current_design]
#  set_property BITSTREAM.CONFIG.NEXT_CONFIG_ADDR 0xE00000 [current_design]

#
# Input SYSTEM CLOCKS (1.8V banks 64 and 68)
#

##set_property IOSTANDARD LVDS [get_ports clk_conv_n]
##set_property PACKAGE_PIN G16 [get_ports clk_conv_n]
##set_property PACKAGE_PIN G17 [get_ports clk_conv_p]
##set_property IOSTANDARD LVDS [get_ports clk_conv_p]

##set_property DQS_BIAS TRUE [get_ports clk_conv_p]

set_property PACKAGE_PIN AL15 [get_ports clk_conv_in]
set_property IOSTANDARD LVCMOS18 [get_ports clk_conv_in]
#
# MGT Clocks
#
# PCIe Clocks
#
# Input Clocks for Dual x8 Bifurcation on Lane 0-7
# PCIE_REFCLK1 -> PCIe Host clock
# PCIE_SYSCLK1 -> PCIe Asynchronous clock
set_property PACKAGE_PIN AE11 [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AE12 [get_ports pcie_refclk_p]

# #
# Input QSFP28 Clocks
#
# SYNCE_CLK   -> Ethernet Clock
set_property PACKAGE_PIN P28 [get_ports sfp_refclk_n]
set_property PACKAGE_PIN P27 [get_ports sfp_refclk_p]

#
# EEPROM
#
set_property -dict {LOC D1 IOSTANDARD LVCMOS33} [get_ports iic_eeprom_scl]
set_property -dict {LOC D2 IOSTANDARD LVCMOS33} [get_ports iic_eeprom_sda]

#
# BOARD PCB PIN
#

set_property -dict {LOC AW18 IOSTANDARD LVCMOS18} [get_ports {board_pcb_version[0]}]
set_property -dict {LOC AW19 IOSTANDARD LVCMOS18} [get_ports {board_pcb_version[1]}]
set_property -dict {LOC AW20 IOSTANDARD LVCMOS18} [get_ports {board_pcb_version[2]}]
set_property -dict {LOC AW21 IOSTANDARD LVCMOS18} [get_ports {board_pcb_version[3]}]

set_property PULLDOWN true [get_ports {board_pcb_version[0]}]
set_property PULLDOWN true [get_ports {board_pcb_version[1]}]
set_property PULLDOWN true [get_ports {board_pcb_version[2]}]
set_property PULLDOWN true [get_ports {board_pcb_version[3]}]

#
# IIC
#
set_property PULLUP true [get_ports iic_rtl_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_rtl_scl_io]
set_property PACKAGE_PIN A6 [get_ports iic_rtl_scl_io]

set_property PULLUP true [get_ports iic_rtl_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_rtl_sda_io]
set_property PACKAGE_PIN B6 [get_ports iic_rtl_sda_io]

#
# FLASH
#
set_property PULLUP true [get_ports flash_1_qspi_cs_b]
set_property PULLUP true [get_ports flash_1_qspi_dq6]
set_property PULLUP true [get_ports flash_1_qspi_dq7]

set_property -dict {LOC AM12 IOSTANDARD LVCMOS18} [get_ports flash_1_qspi_dq4]
set_property -dict {LOC AN12 IOSTANDARD LVCMOS18} [get_ports flash_1_qspi_dq5]
set_property -dict {LOC AR13 IOSTANDARD LVCMOS18} [get_ports flash_1_qspi_dq6]
set_property -dict {LOC AR12 IOSTANDARD LVCMOS18} [get_ports flash_1_qspi_dq7]
set_property -dict {LOC AV11 IOSTANDARD LVCMOS18} [get_ports flash_1_qspi_cs_b]

#
# BOARD LED PIN
#
set_property -dict {LOC M11 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 8} [get_ports x1100_sfp0_link_led]
set_property -dict {LOC M12 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 8} [get_ports x1100_sfp0_active_led]

set_property -dict {LOC P15 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 8} [get_ports x1100_sfp1_link_led]
set_property -dict {LOC R15 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 8} [get_ports x1100_sfp1_active_led]

set_property -dict {LOC D13 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 8} [get_ports x1100_sfp2_link_led]
set_property -dict {LOC E13 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 8} [get_ports x1100_sfp2_active_led]

set_property -dict {LOC J12 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 8} [get_ports x1100_sfp3_link_led]
set_property -dict {LOC J13 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 8} [get_ports x1100_sfp3_active_led]

set_property -dict {LOC AL16 IOSTANDARD LVCMOS18} [get_ports pcie_active_led]

#
# SFP28 CONTROL & STATUS PIN
#
## SFP 0
set_property -dict {LOC K10 IOSTANDARD LVCMOS33} [get_ports sfp0_tx_fault]
set_property -dict {LOC K11 IOSTANDARD LVCMOS33} [get_ports sfp0_tx_dis]
set_property -dict {LOC L11 IOSTANDARD LVCMOS33} [get_ports sfp0_mod_abs]
set_property -dict {LOC L12 IOSTANDARD LVCMOS33} [get_ports sfp0_rx_los]
set_property -dict {LOC K13 IOSTANDARD LVCMOS33} [get_ports sfp0_rs0]
set_property -dict {LOC L13 IOSTANDARD LVCMOS33} [get_ports sfp0_rs1]
set_property -dict {LOC M10 IOSTANDARD LVCMOS33} [get_ports x1100_sfp0_i2c_scl]
set_property -dict {LOC N10 IOSTANDARD LVCMOS33} [get_ports x1100_sfp0_i2c_sda]

## SFP 1
set_property -dict {LOC N14 IOSTANDARD LVCMOS33} [get_ports sfp1_tx_fault]
set_property -dict {LOC N15 IOSTANDARD LVCMOS33} [get_ports sfp1_tx_dis]
set_property -dict {LOC P10 IOSTANDARD LVCMOS33} [get_ports sfp1_mod_abs]
set_property -dict {LOC P11 IOSTANDARD LVCMOS33} [get_ports sfp1_rx_los]
set_property -dict {LOC P12 IOSTANDARD LVCMOS33} [get_ports sfp1_rs0]
set_property -dict {LOC P13 IOSTANDARD LVCMOS33} [get_ports sfp1_rs1]
set_property -dict {LOC R13 IOSTANDARD LVCMOS33} [get_ports x1100_sfp1_i2c_scl]
set_property -dict {LOC R14 IOSTANDARD LVCMOS33} [get_ports x1100_sfp1_i2c_sda]

## SFP 2
set_property -dict {LOC A14 IOSTANDARD LVCMOS33} [get_ports sfp2_tx_fault]
set_property -dict {LOC B14 IOSTANDARD LVCMOS33} [get_ports sfp2_tx_dis]
set_property -dict {LOC A12 IOSTANDARD LVCMOS33} [get_ports sfp2_mod_abs]
set_property -dict {LOC A13 IOSTANDARD LVCMOS33} [get_ports sfp2_rx_los]
set_property -dict {LOC B12 IOSTANDARD LVCMOS33} [get_ports sfp2_rs0]
set_property -dict {LOC C13 IOSTANDARD LVCMOS33} [get_ports sfp2_rs1]
set_property -dict {LOC C12 IOSTANDARD LVCMOS33} [get_ports x1100_sfp2_i2c_scl]
set_property -dict {LOC D12 IOSTANDARD LVCMOS33} [get_ports x1100_sfp2_i2c_sda]

## SFP 3
set_property -dict {LOC G11 IOSTANDARD LVCMOS33} [get_ports sfp3_tx_fault]
set_property -dict {LOC G12 IOSTANDARD LVCMOS33} [get_ports sfp3_tx_dis]
set_property -dict {LOC G10 IOSTANDARD LVCMOS33} [get_ports sfp3_mod_abs]
set_property -dict {LOC H10 IOSTANDARD LVCMOS33} [get_ports sfp3_rx_los]
set_property -dict {LOC H12 IOSTANDARD LVCMOS33} [get_ports sfp3_rs0]
set_property -dict {LOC H13 IOSTANDARD LVCMOS33} [get_ports sfp3_rs1]
set_property -dict {LOC J10 IOSTANDARD LVCMOS33} [get_ports x1100_sfp3_i2c_scl]
set_property -dict {LOC J11 IOSTANDARD LVCMOS33} [get_ports x1100_sfp3_i2c_sda]

#
# SFP28 MGTY Interface
#

set_property PACKAGE_PIN H36 [get_ports sfp0_rxp]
set_property PACKAGE_PIN H37 [get_ports sfp0_rxn]
set_property PACKAGE_PIN D35 [get_ports sfp0_txp]
set_property PACKAGE_PIN D36 [get_ports sfp0_txn]

set_property PACKAGE_PIN G38 [get_ports sfp1_rxp]
set_property PACKAGE_PIN G39 [get_ports sfp1_rxn]
set_property PACKAGE_PIN C33 [get_ports sfp1_txp]
set_property PACKAGE_PIN C34 [get_ports sfp1_txn]

set_property PACKAGE_PIN E38 [get_ports sfp2_rxp]
set_property PACKAGE_PIN E39 [get_ports sfp2_rxn]
set_property PACKAGE_PIN B35 [get_ports sfp2_txp]
set_property PACKAGE_PIN B36 [get_ports sfp2_txn]

set_property PACKAGE_PIN C38 [get_ports sfp3_rxp]
set_property PACKAGE_PIN C39 [get_ports sfp3_rxn]
set_property PACKAGE_PIN A33 [get_ports sfp3_txp]
set_property PACKAGE_PIN A34 [get_ports sfp3_txn]

#
# PCIe MGTY Interface
#
set_property PACKAGE_PIN AL4 [get_ports {pci_exp_rxp[7]}]
set_property PACKAGE_PIN AL3 [get_ports {pci_exp_rxn[7]}]
set_property PACKAGE_PIN AL8 [get_ports {pci_exp_txp[7]}]
set_property PACKAGE_PIN AL7 [get_ports {pci_exp_txn[7]}]
set_property PACKAGE_PIN AK2 [get_ports {pci_exp_rxp[6]}]
set_property PACKAGE_PIN AK1 [get_ports {pci_exp_rxn[6]}]
set_property PACKAGE_PIN AK6 [get_ports {pci_exp_txp[6]}]
set_property PACKAGE_PIN AK5 [get_ports {pci_exp_txn[6]}]
set_property PACKAGE_PIN AJ4 [get_ports {pci_exp_rxp[5]}]
set_property PACKAGE_PIN AJ3 [get_ports {pci_exp_rxn[5]}]
set_property PACKAGE_PIN AJ8 [get_ports {pci_exp_txp[5]}]
set_property PACKAGE_PIN AJ7 [get_ports {pci_exp_txn[5]}]
set_property PACKAGE_PIN AH2 [get_ports {pci_exp_rxp[4]}]
set_property PACKAGE_PIN AH1 [get_ports {pci_exp_rxn[4]}]
set_property PACKAGE_PIN AH6 [get_ports {pci_exp_txp[4]}]
set_property PACKAGE_PIN AH5 [get_ports {pci_exp_txn[4]}]

set_property PACKAGE_PIN AG4 [get_ports {pci_exp_rxp[3]}]
set_property PACKAGE_PIN AG3 [get_ports {pci_exp_rxn[3]}]
set_property PACKAGE_PIN AG8 [get_ports {pci_exp_txp[3]}]
set_property PACKAGE_PIN AG7 [get_ports {pci_exp_txn[3]}]
set_property PACKAGE_PIN AF2 [get_ports {pci_exp_rxp[2]}]
set_property PACKAGE_PIN AF1 [get_ports {pci_exp_rxn[2]}]
set_property PACKAGE_PIN AF6 [get_ports {pci_exp_txp[2]}]
set_property PACKAGE_PIN AF5 [get_ports {pci_exp_txn[2]}]
set_property PACKAGE_PIN AE4 [get_ports {pci_exp_rxp[1]}]
set_property PACKAGE_PIN AE3 [get_ports {pci_exp_rxn[1]}]
set_property PACKAGE_PIN AE8 [get_ports {pci_exp_txp[1]}]
set_property PACKAGE_PIN AE7 [get_ports {pci_exp_txn[1]}]
set_property PACKAGE_PIN AD2 [get_ports {pci_exp_rxp[0]}]
set_property PACKAGE_PIN AD1 [get_ports {pci_exp_rxn[0]}]
set_property PACKAGE_PIN AD6 [get_ports {pci_exp_txp[0]}]
set_property PACKAGE_PIN AD5 [get_ports {pci_exp_txn[0]}]

set_property PACKAGE_PIN AP10 [get_ports pcie_perst_n]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_perst_n]
set_property PULLUP true [get_ports pcie_perst_n]
set_false_path -from [get_ports pcie_perst_n]
set_input_delay 0.000 [get_ports pcie_perst_n]

