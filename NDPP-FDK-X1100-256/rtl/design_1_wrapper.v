//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
//Date        : Mon Nov 18 11:32:25 2024
//Host        : localhost.localdomain running 64-bit CentOS Stream release 8
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (ETH_RX_AXIS_tdata,
    ETH_RX_AXIS_tkeep,
    ETH_RX_AXIS_tlast,
    ETH_RX_AXIS_tready,
    ETH_RX_AXIS_tvalid,
    mac_rx_clk,
    mac_rx_rstn,
    pcie_aclk,
    pcie_arstn,
    udp_param_0_tdata,
    udp_param_0_tready,
    udp_param_0_tvalid,
    user_dma_rx_0_tdata,
    user_dma_rx_0_tkeep,
    user_dma_rx_0_tlast,
    user_dma_rx_0_tready,
    user_dma_rx_0_tstrb,
    user_dma_rx_0_tvalid,
    user_dma_rx_1_tdata,
    user_dma_rx_1_tkeep,
    user_dma_rx_1_tlast,
    user_dma_rx_1_tready,
    user_dma_rx_1_tstrb,
    user_dma_rx_1_tvalid,
    user_dma_rx_2_tdata,
    user_dma_rx_2_tkeep,
    user_dma_rx_2_tlast,
    user_dma_rx_2_tready,
    user_dma_rx_2_tstrb,
    user_dma_rx_2_tvalid,
    user_dma_rx_3_tdata,
    user_dma_rx_3_tkeep,
    user_dma_rx_3_tlast,
    user_dma_rx_3_tready,
    user_dma_rx_3_tstrb,
    user_dma_rx_3_tvalid,
    user_dma_tx_0_tdata,
    user_dma_tx_0_tkeep,
    user_dma_tx_0_tlast,
    user_dma_tx_0_tready,
    user_dma_tx_0_tstrb,
    user_dma_tx_0_tvalid,
    user_dma_tx_0_tuser,
    user_logic_native_mem_valid,
    user_logic_native_mem_address,
    user_logic_native_mem_data,
    user_logic_native_mem_strb,
    write_counter_out,
    write_counter_out2,
    trigger_counter_out);
  input [31:0]ETH_RX_AXIS_tdata;
  input [3:0]ETH_RX_AXIS_tkeep;
  input ETH_RX_AXIS_tlast;
  output ETH_RX_AXIS_tready;
  input ETH_RX_AXIS_tvalid;
  input mac_rx_clk;
  input mac_rx_rstn;
  input pcie_aclk;
  input pcie_arstn;
  input [127:0]udp_param_0_tdata;
  output udp_param_0_tready;
  input udp_param_0_tvalid;
  output [255:0]user_dma_rx_0_tdata;
  output [31:0]user_dma_rx_0_tkeep;
  output user_dma_rx_0_tlast;
  input user_dma_rx_0_tready;
  output [31:0]user_dma_rx_0_tstrb;
  output user_dma_rx_0_tvalid;
  output [63:0]user_dma_rx_1_tdata;
  output [7:0]user_dma_rx_1_tkeep;
  output user_dma_rx_1_tlast;
  input user_dma_rx_1_tready;
  output [7:0]user_dma_rx_1_tstrb;
  output user_dma_rx_1_tvalid;
  output [63:0]user_dma_rx_2_tdata;
  output [7:0]user_dma_rx_2_tkeep;
  output user_dma_rx_2_tlast;
  input user_dma_rx_2_tready;
  output [7:0]user_dma_rx_2_tstrb;
  output user_dma_rx_2_tvalid;
  output [63:0]user_dma_rx_3_tdata;
  output [7:0]user_dma_rx_3_tkeep;
  output user_dma_rx_3_tlast;
  input user_dma_rx_3_tready;
  output [7:0]user_dma_rx_3_tstrb;
  output user_dma_rx_3_tvalid;
  input [63:0]user_dma_tx_0_tdata;
  input [7:0]user_dma_tx_0_tkeep;
  input user_dma_tx_0_tlast;
  output user_dma_tx_0_tready;
  input [7:0]user_dma_tx_0_tstrb;
  input user_dma_tx_0_tvalid;
  input [3:0]user_dma_tx_0_tuser;
  input [0:0]user_logic_native_mem_valid;
  input [63:0]user_logic_native_mem_address;
  input [255:0]user_logic_native_mem_data;
  input [31:0]user_logic_native_mem_strb;
  output [31:0]write_counter_out;
  output [31:0]write_counter_out2;
  output [31:0]trigger_counter_out;

  wire [31:0]ETH_RX_AXIS_tdata;
  wire [3:0]ETH_RX_AXIS_tkeep;
  wire ETH_RX_AXIS_tlast;
  wire ETH_RX_AXIS_tready;
  wire ETH_RX_AXIS_tvalid;
  wire mac_rx_clk;
  wire mac_rx_rstn;
  wire pcie_aclk;
  wire pcie_arstn;
  wire [127:0]udp_param_0_tdata;
  wire udp_param_0_tready;
  wire udp_param_0_tvalid;
  wire [255:0]user_dma_rx_0_tdata;
  wire [31:0]user_dma_rx_0_tkeep;
  wire user_dma_rx_0_tlast;
  wire user_dma_rx_0_tready;
  wire [31:0]user_dma_rx_0_tstrb;
  wire user_dma_rx_0_tvalid;
  wire [63:0]user_dma_rx_1_tdata;
  wire [7:0]user_dma_rx_1_tkeep;
  wire user_dma_rx_1_tlast;
  wire user_dma_rx_1_tready;
  wire [7:0]user_dma_rx_1_tstrb;
  wire user_dma_rx_1_tvalid;
  wire [63:0]user_dma_rx_2_tdata;
  wire [7:0]user_dma_rx_2_tkeep;
  wire user_dma_rx_2_tlast;
  wire user_dma_rx_2_tready;
  wire [7:0]user_dma_rx_2_tstrb;
  wire user_dma_rx_2_tvalid;
  wire [63:0]user_dma_rx_3_tdata;
  wire [7:0]user_dma_rx_3_tkeep;
  wire user_dma_rx_3_tlast;
  wire user_dma_rx_3_tready;
  wire [7:0]user_dma_rx_3_tstrb;
  wire user_dma_rx_3_tvalid;
  wire [63:0]user_dma_tx_0_tdata;
  wire [7:0]user_dma_tx_0_tkeep;
  wire user_dma_tx_0_tlast;
  wire user_dma_tx_0_tready;
  wire [7:0]user_dma_tx_0_tstrb;
  wire user_dma_tx_0_tvalid;
  wire [3:0]user_dma_tx_0_tuser;
  wire [0:0]user_logic_native_mem_valid;
  wire [63:0]user_logic_native_mem_address;
  wire [255:0]user_logic_native_mem_data;
  wire [31:0]user_logic_native_mem_strb;
  wire [31:0]write_counter_out;
  wire [31:0]write_counter_out2;
  wire [31:0]trigger_counter_out;

  design_1 design_1_i
       (.ETH_RX_AXIS_tdata(ETH_RX_AXIS_tdata),
        .ETH_RX_AXIS_tkeep(ETH_RX_AXIS_tkeep),
        .ETH_RX_AXIS_tlast(ETH_RX_AXIS_tlast),
        .ETH_RX_AXIS_tready(ETH_RX_AXIS_tready),
        .ETH_RX_AXIS_tvalid(ETH_RX_AXIS_tvalid),
        .mac_rx_clk(mac_rx_clk),
        .mac_rx_rstn(mac_rx_rstn),
        .pcie_aclk(pcie_aclk),
        .pcie_arstn(pcie_arstn),
        .udp_param_0_tdata(udp_param_0_tdata),
        .udp_param_0_tready(udp_param_0_tready),
        .udp_param_0_tvalid(udp_param_0_tvalid),
        .user_dma_rx_0_tdata(user_dma_rx_0_tdata),
        .user_dma_rx_0_tkeep(user_dma_rx_0_tkeep),
        .user_dma_rx_0_tlast(user_dma_rx_0_tlast),
        .user_dma_rx_0_tready(user_dma_rx_0_tready),
        .user_dma_rx_0_tstrb(user_dma_rx_0_tstrb),
        .user_dma_rx_0_tvalid(user_dma_rx_0_tvalid),
        .user_dma_rx_1_tdata(user_dma_rx_1_tdata),
        .user_dma_rx_1_tkeep(user_dma_rx_1_tkeep),
        .user_dma_rx_1_tlast(user_dma_rx_1_tlast),
        .user_dma_rx_1_tready(user_dma_rx_1_tready),
        .user_dma_rx_1_tstrb(user_dma_rx_1_tstrb),
        .user_dma_rx_1_tvalid(user_dma_rx_1_tvalid),
        .user_dma_rx_2_tdata(user_dma_rx_2_tdata),
        .user_dma_rx_2_tkeep(user_dma_rx_2_tkeep),
        .user_dma_rx_2_tlast(user_dma_rx_2_tlast),
        .user_dma_rx_2_tready(user_dma_rx_2_tready),
        .user_dma_rx_2_tstrb(user_dma_rx_2_tstrb),
        .user_dma_rx_2_tvalid(user_dma_rx_2_tvalid),
        .user_dma_rx_3_tdata(user_dma_rx_3_tdata),
        .user_dma_rx_3_tkeep(user_dma_rx_3_tkeep),
        .user_dma_rx_3_tlast(user_dma_rx_3_tlast),
        .user_dma_rx_3_tready(user_dma_rx_3_tready),
        .user_dma_rx_3_tstrb(user_dma_rx_3_tstrb),
        .user_dma_rx_3_tvalid(user_dma_rx_3_tvalid),
        .user_dma_tx_0_tdata(user_dma_tx_0_tdata),
        .user_dma_tx_0_tkeep(user_dma_tx_0_tkeep),
        .user_dma_tx_0_tlast(user_dma_tx_0_tlast),
        .user_dma_tx_0_tready(user_dma_tx_0_tready),
        .user_dma_tx_0_tstrb(user_dma_tx_0_tstrb),
        .user_dma_tx_0_tvalid(user_dma_tx_0_tvalid),
        .user_dma_tx_0_tuser(user_dma_tx_0_tuser),
        .user_logic_native_mem_valid(user_logic_native_mem_valid),
        .user_logic_native_mem_address(user_logic_native_mem_address),
        .user_logic_native_mem_data(user_logic_native_mem_data),
        .user_logic_native_mem_strb(user_logic_native_mem_strb),
        .write_counter_out(write_counter_out),
        .write_counter_out2(write_counter_out2),
        .trigger_counter_out(trigger_counter_out));
endmodule
