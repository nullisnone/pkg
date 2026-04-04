// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Thu Mar 13 11:19:53 2025
// Host        : HSD_164 running 64-bit CentOS Linux release 7.9.2009 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /home/zhaomj/work/fae_zmj/wukuangqihuo_20250311/NDPP-FDK-Basic-XSeries-V1.1.0.8/NDPP-FDK/X1100/prj/yusur_ndpp_x1100/yusur_ndpp_x1100.gen/sources_1/ip/axi_traffic_gen_1/axi_traffic_gen_1_stub.v
// Design      : axi_traffic_gen_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku15p_CIV-ffve1517-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "axi_traffic_gen_v3_0_13_top,Vivado 2022.2" *)
module axi_traffic_gen_1(s_axi_aclk, s_axi_aresetn, core_ext_start, 
  core_ext_stop, s_axi_awid, s_axi_awaddr, s_axi_awlen, s_axi_awsize, s_axi_awburst, 
  s_axi_awlock, s_axi_awcache, s_axi_awprot, s_axi_awqos, s_axi_awuser, s_axi_awvalid, 
  s_axi_awready, s_axi_wlast, s_axi_wdata, s_axi_wstrb, s_axi_wvalid, s_axi_wready, s_axi_bid, 
  s_axi_bresp, s_axi_bvalid, s_axi_bready, s_axi_arid, s_axi_araddr, s_axi_arlen, s_axi_arsize, 
  s_axi_arburst, s_axi_arlock, s_axi_arcache, s_axi_arprot, s_axi_arqos, s_axi_aruser, 
  s_axi_arvalid, s_axi_arready, s_axi_rid, s_axi_rlast, s_axi_rdata, s_axi_rresp, s_axi_rvalid, 
  s_axi_rready, m_axis_1_tready, m_axis_1_tvalid, m_axis_1_tlast, m_axis_1_tdata, 
  m_axis_1_tstrb, m_axis_1_tkeep, m_axis_1_tuser, m_axis_1_tid, m_axis_1_tdest, err_out)
/* synthesis syn_black_box black_box_pad_pin="s_axi_aclk,s_axi_aresetn,core_ext_start,core_ext_stop,s_axi_awid[0:0],s_axi_awaddr[31:0],s_axi_awlen[7:0],s_axi_awsize[2:0],s_axi_awburst[1:0],s_axi_awlock[0:0],s_axi_awcache[3:0],s_axi_awprot[2:0],s_axi_awqos[3:0],s_axi_awuser[7:0],s_axi_awvalid,s_axi_awready,s_axi_wlast,s_axi_wdata[31:0],s_axi_wstrb[3:0],s_axi_wvalid,s_axi_wready,s_axi_bid[0:0],s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_arid[0:0],s_axi_araddr[31:0],s_axi_arlen[7:0],s_axi_arsize[2:0],s_axi_arburst[1:0],s_axi_arlock[0:0],s_axi_arcache[3:0],s_axi_arprot[2:0],s_axi_arqos[3:0],s_axi_aruser[7:0],s_axi_arvalid,s_axi_arready,s_axi_rid[0:0],s_axi_rlast,s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rvalid,s_axi_rready,m_axis_1_tready,m_axis_1_tvalid,m_axis_1_tlast,m_axis_1_tdata[31:0],m_axis_1_tstrb[3:0],m_axis_1_tkeep[3:0],m_axis_1_tuser[7:0],m_axis_1_tid[7:0],m_axis_1_tdest[7:0],err_out" */;
  input s_axi_aclk;
  input s_axi_aresetn;
  input core_ext_start;
  input core_ext_stop;
  input [0:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input [0:0]s_axi_awlock;
  input [3:0]s_axi_awcache;
  input [2:0]s_axi_awprot;
  input [3:0]s_axi_awqos;
  input [7:0]s_axi_awuser;
  input s_axi_awvalid;
  output s_axi_awready;
  input s_axi_wlast;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input s_axi_wvalid;
  output s_axi_wready;
  output [0:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [0:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input [0:0]s_axi_arlock;
  input [3:0]s_axi_arcache;
  input [2:0]s_axi_arprot;
  input [3:0]s_axi_arqos;
  input [7:0]s_axi_aruser;
  input s_axi_arvalid;
  output s_axi_arready;
  output [0:0]s_axi_rid;
  output s_axi_rlast;
  output [31:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rvalid;
  input s_axi_rready;
  input m_axis_1_tready;
  output m_axis_1_tvalid;
  output m_axis_1_tlast;
  output [31:0]m_axis_1_tdata;
  output [3:0]m_axis_1_tstrb;
  output [3:0]m_axis_1_tkeep;
  output [7:0]m_axis_1_tuser;
  output [7:0]m_axis_1_tid;
  output [7:0]m_axis_1_tdest;
  output err_out;
endmodule
