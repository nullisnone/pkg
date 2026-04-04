`timescale 1ns / 1ps

module design_1 (
    // Clock and Reset Ports
    input wire mac_rx_clk,
    input wire mac_rx_rstn,
    input wire pcie_aclk,
    input wire pcie_arstn,

    // Interface: ETH_RX_AXIS (Slave)
    // Width: 32-bit (4 bytes)
    input  wire [31:0] ETH_RX_AXIS_tdata,
    input  wire [3:0]  ETH_RX_AXIS_tkeep,
    input  wire        ETH_RX_AXIS_tlast,
    input  wire        ETH_RX_AXIS_tvalid,
    output wire        ETH_RX_AXIS_tready,

    // Interface: udp_param_0 (Slave)
    // Width: 128-bit (16 bytes)
    input  wire [127:0] udp_param_0_tdata,
    input  wire         udp_param_0_tvalid,
    output wire         udp_param_0_tready,

    // Interface: user_dma_rx_0 (Master)
    // Width: 64-bit (8 bytes)
    output wire [63:0] user_dma_rx_0_tdata,
    output wire [7:0]  user_dma_rx_0_tkeep,
    output wire        user_dma_rx_0_tlast,
    output wire [7:0]  user_dma_rx_0_tstrb,
    output wire        user_dma_rx_0_tvalid,
    input  wire        user_dma_rx_0_tready,

    // Interface: user_dma_rx_1 (Master)
    // Width: 64-bit (8 bytes)
    output wire [63:0] user_dma_rx_1_tdata,
    output wire [7:0]  user_dma_rx_1_tkeep,
    output wire        user_dma_rx_1_tlast,
    output wire [7:0]  user_dma_rx_1_tstrb,
    output wire        user_dma_rx_1_tvalid,
    input  wire        user_dma_rx_1_tready,

    // Interface: user_dma_rx_2 (Master)
    // Width: 64-bit (8 bytes)
    output wire [63:0] user_dma_rx_2_tdata,
    output wire [7:0]  user_dma_rx_2_tkeep,
    output wire        user_dma_rx_2_tlast,
    output wire [7:0]  user_dma_rx_2_tstrb,
    output wire        user_dma_rx_2_tvalid,
    input  wire        user_dma_rx_2_tready,

    // Interface: user_dma_rx_3 (Master)
    // Width: 64-bit (8 bytes)
    output wire [63:0] user_dma_rx_3_tdata,
    output wire [7:0]  user_dma_rx_3_tkeep,
    output wire        user_dma_rx_3_tlast,
    output wire [7:0]  user_dma_rx_3_tstrb,
    output wire        user_dma_rx_3_tvalid,
    input  wire        user_dma_rx_3_tready,

    // Interface: user_dma_tx_0 (Slave)
    // Width: 64-bit (8 bytes)
    input  wire [63:0] user_dma_tx_0_tdata,
    input  wire [7:0]  user_dma_tx_0_tkeep,
    input  wire        user_dma_tx_0_tlast,
    input  wire [7:0]  user_dma_tx_0_tstrb,
    input  wire        user_dma_tx_0_tvalid,
    input  wire [3:0]  user_dma_tx_0_tuser,
    output wire        user_dma_tx_0_tready,

    // Interface: user_logic_native_mem (Slave)
    input  wire [0:0]   user_logic_native_mem_valid,
    input  wire [63:0]  user_logic_native_mem_address,
    input  wire [255:0] user_logic_native_mem_data,
    input  wire [31:0]  user_logic_native_mem_strb,
    
    output wire [31:0]  write_counter_out,
    output wire [31:0]  trigger_counter_out
);

  //indicate host side FPGA is ready to receive
  assign dma_p0_tx_axis_tready = 1'b0;

  //===========================================================================
  // Internal Wire Declarations
  //===========================================================================

  // Removed: upstream paths for i_axiu_key/i_axiu_stream_data/i_axiu_user0_data
  // (axis_dwidth_converter_0, rx_eth_fifo, yusur_udp_filter_0, axis_data_fifo_0, axis_data_fifo_1)

  // 5. Yusur Hash Allocation Outputs
  // User 0
  wire [63:0] yusur_hash_allocation_0_o_axiu_user0_data_TDATA;
  wire [7:0]  yusur_hash_allocation_0_o_axiu_user0_data_TKEEP;
  //wire [7:0]  yusur_hash_allocation_0_o_axiu_user0_data_TSTRB;
  wire        yusur_hash_allocation_0_o_axiu_user0_data_TLAST;
  wire        yusur_hash_allocation_0_o_axiu_user0_data_TVALID;
  wire        yusur_hash_allocation_0_o_axiu_user0_data_TREADY;

  //===========================================================================
  // Module Instantiations
  //===========================================================================

  // -------------------------------------------------------------------------
  // 6. Yusur Hash Allocation (HLS IP)
  // XCI: design_1_yusur_hash_allocation_0_0
  // -------------------------------------------------------------------------
  //design_1_yusur_hash_allocation_0_0 yusur_hash_allocation_0 (
  yusur_hash_allocation yusur_hash_allocation_0 (
      .ap_clk  (pcie_aclk),
      .ap_rst_n(pcie_arstn),

      // New Interfaces
      .user_logic_native_mem_valid(user_logic_native_mem_valid),
      .user_logic_native_mem_address(user_logic_native_mem_address),
      .user_logic_native_mem_data(user_logic_native_mem_data),
      .user_logic_native_mem_strb(user_logic_native_mem_strb),
      .write_counter_out(write_counter_out),
      .trigger_counter_out(trigger_counter_out),

      // Output: User 0
      .o_axiu_user0_data_TVALID(yusur_hash_allocation_0_o_axiu_user0_data_TVALID),
      .o_axiu_user0_data_TREADY(yusur_hash_allocation_0_o_axiu_user0_data_TREADY),
      .o_axiu_user0_data_TDATA (yusur_hash_allocation_0_o_axiu_user0_data_TDATA),
      .o_axiu_user0_data_TKEEP (yusur_hash_allocation_0_o_axiu_user0_data_TKEEP),
      //.o_axiu_user0_data_TSTRB (yusur_hash_allocation_0_o_axiu_user0_data_TSTRB),
      .o_axiu_user0_data_TLAST (yusur_hash_allocation_0_o_axiu_user0_data_TLAST)

/*
      // Output: User 1
      .o_axiu_user1_data_TVALID(yusur_hash_allocation_0_o_axiu_user1_data_TVALID),
      .o_axiu_user1_data_TREADY(yusur_hash_allocation_0_o_axiu_user1_data_TREADY),
      .o_axiu_user1_data_TDATA (yusur_hash_allocation_0_o_axiu_user1_data_TDATA),
      .o_axiu_user1_data_TKEEP (yusur_hash_allocation_0_o_axiu_user1_data_TKEEP),
      //.o_axiu_user1_data_TSTRB (yusur_hash_allocation_0_o_axiu_user1_data_TSTRB),
      .o_axiu_user1_data_TLAST (yusur_hash_allocation_0_o_axiu_user1_data_TLAST),

      // Output: User 2
      .o_axiu_user2_data_TVALID(yusur_hash_allocation_0_o_axiu_user2_data_TVALID),
      .o_axiu_user2_data_TREADY(yusur_hash_allocation_0_o_axiu_user2_data_TREADY),
      .o_axiu_user2_data_TDATA (yusur_hash_allocation_0_o_axiu_user2_data_TDATA),
      .o_axiu_user2_data_TKEEP (yusur_hash_allocation_0_o_axiu_user2_data_TKEEP),
      //.o_axiu_user2_data_TSTRB (yusur_hash_allocation_0_o_axiu_user2_data_TSTRB),
      .o_axiu_user2_data_TLAST (yusur_hash_allocation_0_o_axiu_user2_data_TLAST),

      // Output: User 3
      .o_axiu_user3_data_TVALID(yusur_hash_allocation_0_o_axiu_user3_data_TVALID),
      .o_axiu_user3_data_TREADY(yusur_hash_allocation_0_o_axiu_user3_data_TREADY),
      .o_axiu_user3_data_TDATA (yusur_hash_allocation_0_o_axiu_user3_data_TDATA),
      .o_axiu_user3_data_TKEEP (yusur_hash_allocation_0_o_axiu_user3_data_TKEEP),
      //.o_axiu_user3_data_TSTRB (yusur_hash_allocation_0_o_axiu_user3_data_TSTRB),
      .o_axiu_user3_data_TLAST (yusur_hash_allocation_0_o_axiu_user3_data_TLAST)
*/
  );

  // -------------------------------------------------------------------------
  // 7. Output FIFOs (Buffers for User DMA)
  // -------------------------------------------------------------------------
  
  // FIFO 2 (User 0)
  // XCI: design_1_axis_data_fifo_2_0
  design_1_axis_data_fifo_2_0 axis_data_fifo_2 (
      .s_axis_aclk   (pcie_aclk),
      .s_axis_aresetn(pcie_arstn),
      .s_axis_tvalid (yusur_hash_allocation_0_o_axiu_user0_data_TVALID),
      .s_axis_tready (yusur_hash_allocation_0_o_axiu_user0_data_TREADY),
      .s_axis_tdata  (yusur_hash_allocation_0_o_axiu_user0_data_TDATA),
      .s_axis_tkeep  (yusur_hash_allocation_0_o_axiu_user0_data_TKEEP),
      //.s_axis_tstrb  (yusur_hash_allocation_0_o_axiu_user0_data_TSTRB),
      .s_axis_tlast  (yusur_hash_allocation_0_o_axiu_user0_data_TLAST),

      .m_axis_tvalid (user_dma_rx_0_tvalid),
      .m_axis_tready (user_dma_rx_0_tready),
      .m_axis_tdata  (user_dma_rx_0_tdata),
      .m_axis_tkeep  (user_dma_rx_0_tkeep),
      .m_axis_tlast  (user_dma_rx_0_tlast)
      //.m_axis_tstrb  (user_dma_rx_0_tstrb)
  );

  // FIFO 3 (User 1)
  // XCI: design_1_axis_data_fifo_2_1
/*
  design_1_axis_data_fifo_2_1 axis_data_fifo_3 (
      .s_axis_aclk   (pcie_aclk),
      .s_axis_aresetn(pcie_arstn),
      .s_axis_tvalid (yusur_hash_allocation_0_o_axiu_user1_data_TVALID),
      .s_axis_tready (yusur_hash_allocation_0_o_axiu_user1_data_TREADY),
      .s_axis_tdata  (yusur_hash_allocation_0_o_axiu_user1_data_TDATA),
      .s_axis_tkeep  (yusur_hash_allocation_0_o_axiu_user1_data_TKEEP),
      //.s_axis_tstrb  (yusur_hash_allocation_0_o_axiu_user1_data_TSTRB),
      .s_axis_tlast  (yusur_hash_allocation_0_o_axiu_user1_data_TLAST),

      .m_axis_tvalid (user_dma_rx_1_tvalid),
      .m_axis_tready (user_dma_rx_1_tready),
      .m_axis_tdata  (user_dma_rx_1_tdata),
      .m_axis_tkeep  (user_dma_rx_1_tkeep),
      .m_axis_tlast  (user_dma_rx_1_tlast)
      //.m_axis_tstrb  (user_dma_rx_1_tstrb)
  );
*/

  // FIFO 4 (User 2)
  // XCI: design_1_axis_data_fifo_2_2
/*
  design_1_axis_data_fifo_2_2 axis_data_fifo_4 (
      .s_axis_aclk   (pcie_aclk),
      .s_axis_aresetn(pcie_arstn),
      .s_axis_tvalid (yusur_hash_allocation_0_o_axiu_user2_data_TVALID),
      .s_axis_tready (yusur_hash_allocation_0_o_axiu_user2_data_TREADY),
      .s_axis_tdata  (yusur_hash_allocation_0_o_axiu_user2_data_TDATA),
      .s_axis_tkeep  (yusur_hash_allocation_0_o_axiu_user2_data_TKEEP),
      //.s_axis_tstrb  (yusur_hash_allocation_0_o_axiu_user2_data_TSTRB),
      .s_axis_tlast  (yusur_hash_allocation_0_o_axiu_user2_data_TLAST),

      .m_axis_tvalid (user_dma_rx_2_tvalid),
      .m_axis_tready (user_dma_rx_2_tready),
      .m_axis_tdata  (user_dma_rx_2_tdata),
      .m_axis_tkeep  (user_dma_rx_2_tkeep),
      .m_axis_tlast  (user_dma_rx_2_tlast)
      //m_axis_tstrb  (user_dma_rx_2_tstrb)
  );
*/

  // FIFO 5 (User 3)
  // XCI: design_1_axis_data_fifo_2_3
/*
  design_1_axis_data_fifo_2_3 axis_data_fifo_5 (
      .s_axis_aclk   (pcie_aclk),
      .s_axis_aresetn(pcie_arstn),
      .s_axis_tvalid (yusur_hash_allocation_0_o_axiu_user3_data_TVALID),
      .s_axis_tready (yusur_hash_allocation_0_o_axiu_user3_data_TREADY),
      .s_axis_tdata  (yusur_hash_allocation_0_o_axiu_user3_data_TDATA),
      .s_axis_tkeep  (yusur_hash_allocation_0_o_axiu_user3_data_TKEEP),
      //.s_axis_tstrb  (yusur_hash_allocation_0_o_axiu_user3_data_TSTRB),
      .s_axis_tlast  (yusur_hash_allocation_0_o_axiu_user3_data_TLAST),

      .m_axis_tvalid (user_dma_rx_3_tvalid),
      .m_axis_tready (user_dma_rx_3_tready),
      .m_axis_tdata  (user_dma_rx_3_tdata),
      .m_axis_tkeep  (user_dma_rx_3_tkeep),
      .m_axis_tlast  (user_dma_rx_3_tlast)
      //.m_axis_tstrb  (user_dma_rx_3_tstrb)
  );
*/

  // -------------------------------------------------------------------------  
  // 9. System ILA (Debug Monitor)
  // XCI: design_1_system_ila_0_0
  // -------------------------------------------------------------------------
  /*
  design_1_system_ila_0_0 system_ila_0 (
      .clk   (pcie_aclk),
      .resetn(pcie_arstn),

      // Slot 0: FIFO 0 Master (Key)
      .SLOT_0_AXIS_tdata (axis_data_fifo_0_M_AXIS_TDATA),
      .SLOT_0_AXIS_tvalid(axis_data_fifo_0_M_AXIS_TVALID),
      .SLOT_0_AXIS_tlast(1'b0),
      .SLOT_0_AXIS_tready(axis_data_fifo_0_M_AXIS_TREADY),

      // Slot 1: FIFO 1 Master (Stream Data)
      .SLOT_1_AXIS_tdata (axis_data_fifo_1_M_AXIS_TDATA),
      .SLOT_1_AXIS_tkeep (axis_data_fifo_1_M_AXIS_TKEEP),
      .SLOT_1_AXIS_tstrb (axis_data_fifo_1_M_AXIS_TSTRB),
      .SLOT_1_AXIS_tlast (axis_data_fifo_1_M_AXIS_TLAST),
      .SLOT_1_AXIS_tvalid(axis_data_fifo_1_M_AXIS_TVALID),
      .SLOT_1_AXIS_tready(axis_data_fifo_1_M_AXIS_TREADY),

      // Slot 2: RX ETH FIFO Master
      .SLOT_2_AXIS_tdata (rx_eth_fifo_M_AXIS_TDATA),
      .SLOT_2_AXIS_tkeep (rx_eth_fifo_M_AXIS_TKEEP),
      .SLOT_2_AXIS_tlast (rx_eth_fifo_M_AXIS_TLAST),
      .SLOT_2_AXIS_tvalid(rx_eth_fifo_M_AXIS_TVALID),
      .SLOT_2_AXIS_tready(rx_eth_fifo_M_AXIS_TREADY),

      // Slot 3: Hash Alloc User 0
      .SLOT_3_AXIS_tdata (yusur_hash_allocation_0_o_axiu_user0_data_TDATA),
      .SLOT_3_AXIS_tkeep (yusur_hash_allocation_0_o_axiu_user0_data_TKEEP),
      .SLOT_3_AXIS_tstrb (yusur_hash_allocation_0_o_axiu_user0_data_TSTRB),
      .SLOT_3_AXIS_tlast (yusur_hash_allocation_0_o_axiu_user0_data_TLAST),
      .SLOT_3_AXIS_tvalid(yusur_hash_allocation_0_o_axiu_user0_data_TVALID),
      .SLOT_3_AXIS_tready(yusur_hash_allocation_0_o_axiu_user0_data_TREADY),

      // Slot 4: Hash Alloc User 1
      .SLOT_4_AXIS_tdata (yusur_hash_allocation_0_o_axiu_user1_data_TDATA),
      .SLOT_4_AXIS_tkeep (yusur_hash_allocation_0_o_axiu_user1_data_TKEEP),
      .SLOT_4_AXIS_tstrb (yusur_hash_allocation_0_o_axiu_user1_data_TSTRB),
      .SLOT_4_AXIS_tlast (yusur_hash_allocation_0_o_axiu_user1_data_TLAST),
      .SLOT_4_AXIS_tvalid(yusur_hash_allocation_0_o_axiu_user1_data_TVALID),
      .SLOT_4_AXIS_tready(yusur_hash_allocation_0_o_axiu_user1_data_TREADY),

      // Slot 5: Hash Alloc User 2
      .SLOT_5_AXIS_tdata (yusur_hash_allocation_0_o_axiu_user2_data_TDATA),
      .SLOT_5_AXIS_tkeep (yusur_hash_allocation_0_o_axiu_user2_data_TKEEP),
      .SLOT_5_AXIS_tstrb (yusur_hash_allocation_0_o_axiu_user2_data_TSTRB),
      .SLOT_5_AXIS_tlast (yusur_hash_allocation_0_o_axiu_user2_data_TLAST),
      .SLOT_5_AXIS_tvalid(yusur_hash_allocation_0_o_axiu_user2_data_TVALID),
      .SLOT_5_AXIS_tready(yusur_hash_allocation_0_o_axiu_user2_data_TREADY),

      // Slot 6: Hash Alloc User 3
      .SLOT_6_AXIS_tdata (yusur_hash_allocation_0_o_axiu_user3_data_TDATA),
      .SLOT_6_AXIS_tkeep (yusur_hash_allocation_0_o_axiu_user3_data_TKEEP),
      .SLOT_6_AXIS_tstrb (yusur_hash_allocation_0_o_axiu_user3_data_TSTRB),
      .SLOT_6_AXIS_tlast (yusur_hash_allocation_0_o_axiu_user3_data_TLAST),
      .SLOT_6_AXIS_tvalid(yusur_hash_allocation_0_o_axiu_user3_data_TVALID),
      .SLOT_6_AXIS_tready(yusur_hash_allocation_0_o_axiu_user3_data_TREADY),

      // Slot 7: UDP Filter Key Output
      .SLOT_7_AXIS_tdata (yusur_udp_filter_0_o_axiu_key_TDATA),
      .SLOT_7_AXIS_tvalid(yusur_udp_filter_0_o_axiu_key_TVALID),
      .SLOT_7_AXIS_tlast(1'b0),
      .SLOT_7_AXIS_tready(yusur_udp_filter_0_o_axiu_key_TREADY),

      // Slot 8: UDP Filter Stream Output
      .SLOT_8_AXIS_tdata (yusur_udp_filter_0_o_axiu_stream_data_TDATA),
      .SLOT_8_AXIS_tkeep (yusur_udp_filter_0_o_axiu_stream_data_TKEEP),
      .SLOT_8_AXIS_tstrb (yusur_udp_filter_0_o_axiu_stream_data_TSTRB),
      .SLOT_8_AXIS_tlast (yusur_udp_filter_0_o_axiu_stream_data_TLAST),
      .SLOT_8_AXIS_tvalid(yusur_udp_filter_0_o_axiu_stream_data_TVALID),
      .SLOT_8_AXIS_tready(yusur_udp_filter_0_o_axiu_stream_data_TREADY),

      // Slot 9: FIFO 2 Master (User 0 DMA)
      .SLOT_9_AXIS_tdata (user_dma_rx_0_tdata),
      .SLOT_9_AXIS_tkeep (user_dma_rx_0_tkeep),
      .SLOT_9_AXIS_tstrb (user_dma_rx_0_tstrb),
      .SLOT_9_AXIS_tlast (user_dma_rx_0_tlast),
      .SLOT_9_AXIS_tvalid(user_dma_rx_0_tvalid),
      .SLOT_9_AXIS_tready(user_dma_rx_0_tready),

      // Slot 10: FIFO 3 Master (User 1 DMA)
      .SLOT_10_AXIS_tdata (user_dma_rx_1_tdata),
      .SLOT_10_AXIS_tkeep (user_dma_rx_1_tkeep),
      .SLOT_10_AXIS_tstrb (user_dma_rx_1_tstrb),
      .SLOT_10_AXIS_tlast (user_dma_rx_1_tlast),
      .SLOT_10_AXIS_tvalid(user_dma_rx_1_tvalid),
      .SLOT_10_AXIS_tready(user_dma_rx_1_tready),

      // Slot 11: FIFO 4 Master (User 2 DMA)
      .SLOT_11_AXIS_tdata (user_dma_rx_2_tdata),
      .SLOT_11_AXIS_tkeep (user_dma_rx_2_tkeep),
      .SLOT_11_AXIS_tstrb (user_dma_rx_2_tstrb),
      .SLOT_11_AXIS_tlast (user_dma_rx_2_tlast),
      .SLOT_11_AXIS_tvalid(user_dma_rx_2_tvalid),
      .SLOT_11_AXIS_tready(user_dma_rx_2_tready),

      // Slot 12: FIFO 5 Master (User 3 DMA)
      .SLOT_12_AXIS_tdata (user_dma_rx_3_tdata),
      .SLOT_12_AXIS_tkeep (user_dma_rx_3_tkeep),
      .SLOT_12_AXIS_tstrb (user_dma_rx_3_tstrb),
      .SLOT_12_AXIS_tlast (user_dma_rx_3_tlast),
      .SLOT_12_AXIS_tvalid(user_dma_rx_3_tvalid),
      .SLOT_12_AXIS_tready(user_dma_rx_3_tready),

      // Slot 13: UDP Param Input
      .SLOT_13_AXIS_tdata (udp_param_0_tdata),
      .SLOT_13_AXIS_tlast (1'b0),
      .SLOT_13_AXIS_tstrb (16'hFF),
      .SLOT_13_AXIS_tkeep (16'hFF),
      .SLOT_13_AXIS_tvalid(udp_param_0_tvalid),
      .SLOT_13_AXIS_tready(udp_param_0_tready)
  );
  */

endmodule
