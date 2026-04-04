`default_nettype none
module base_demo #(
    parameter   USER_DMA_AXI_WIDTH  =   64,
    parameter   USER_DMA_AXI_STRB   =   8,
    parameter   PACKET_LOSS_FIFO_DEPTH  =   2048,
    parameter   PACKET_LOSS_FULL_THR    =   1108
)(
//** CLOCK DOMAIN
    //**** PCIE CLOCK DOMAIN
        input   wire                pcie_axi_clk,
        input   wire                pcie_axi_resetn,
    //**** MAC CLOCK DOMAIN
        //******** MAC-0 TX CLOCK
        input   wire                mac0tx_user_clk,
        input   wire                mac0tx_user_resetn,
        //******** MAC-0 RX CLOCK
        input   wire                mac0rx_user_clk,
        input   wire                mac0rx_user_resetn,
        //******** MAC-1 TX CLOCK
        input   wire                mac1tx_user_clk,
        input   wire                mac1tx_user_resetn,
        //******** MAC-1 RX CLOCK
        input   wire                mac1rx_user_clk,
        input   wire                mac1rx_user_resetn,
        //******** MAC-2 TX CLOCK
        input   wire                mac2tx_user_clk,
        input   wire                mac2tx_user_resetn,
        //******** MAC-2 RX CLOCK
        input   wire                mac2rx_user_clk,
        input   wire                mac2rx_user_resetn,
        //******** MAC-3 TX CLOCK
        input   wire                mac3tx_user_clk,
        input   wire                mac3tx_user_resetn,
        //******** MAC-3 RX CLOCK
        input   wire                mac3rx_user_clk,
        input   wire                mac3rx_user_resetn,

//** AXI-LITE SIGNAL
    input   wire    [31:0]      user_bar1_axi_lite_awaddr,
    input   wire    [2:0]       user_bar1_axi_lite_awprot,
    input   wire                user_bar1_axi_lite_awvalid,
    input   wire    [31:0]      user_bar1_axi_lite_wdata,
    input   wire    [3:0]       user_bar1_axi_lite_wstrb,
    input   wire                user_bar1_axi_lite_wvalid,
    input   wire                user_bar1_axi_lite_bready,
    input   wire    [31:0]      user_bar1_axi_lite_araddr,
    input   wire    [2:0]       user_bar1_axi_lite_arprot,
    input   wire                user_bar1_axi_lite_arvalid,
    input   wire                user_bar1_axi_lite_rready,

    output  wire                user_bar1_axi_lite_awready,
    output  wire                user_bar1_axi_lite_wready,
    output  wire                user_bar1_axi_lite_bvalid,
    output  wire    [1:0]       user_bar1_axi_lite_bresp,
    output  wire                user_bar1_axi_lite_arready,
    output  wire    [31:0]      user_bar1_axi_lite_rdata,
    output  wire    [1:0]       user_bar1_axi_lite_rresp,
    output  wire                user_bar1_axi_lite_rvalid,

//** MAC CONTROL && STATUS SIGNAL
    //****** MAC-0 CONTROL && STATUS
    output  wire                lightning_mac0_enable,
    output  wire                lightning_mac0_loopback,
    input   wire                lightning_mac0_link_status,
    input   wire                lightning_mac0_active_status,

    //****** MAC-1 CONTROL && STATUS
    output  wire                lightning_mac1_enable,
    output  wire                lightning_mac1_loopback,
    input   wire                lightning_mac1_link_status,
    input   wire                lightning_mac1_active_status,

    //****** MAC-2 CONTROL && STATUS
    output  wire                lightning_mac2_enable,
    output  wire                lightning_mac2_loopback,
    input   wire                lightning_mac2_link_status,
    input   wire                lightning_mac2_active_status,

    //****** MAC-3 CONTROL && STATUS
    output  wire                lightning_mac3_enable,
    output  wire                lightning_mac3_loopback,
    input   wire                lightning_mac3_link_status,
    input   wire                lightning_mac3_active_status,

//** MAC AXI-STREAM INTERFACE
    //****** MAC-0 TX AXI-STREAM
    output  wire                lightning_mac0_axi_st_tx_tvalid,
    output  wire                lightning_mac0_axi_st_tx_tuser,
    output  wire                lightning_mac0_axi_st_tx_tlast,
    output  wire    [3:0]       lightning_mac0_axi_st_tx_tstrb,
    output  wire    [31:0]      lightning_mac0_axi_st_tx_tdata,
    input   wire                lightning_mac0_axi_st_tx_tready,

    //****** MAC-0 RX AXI-STREAM
    input   wire                lightning_mac0_axi_st_rx_tvalid,
    input   wire                lightning_mac0_axi_st_rx_tuser,
    input   wire                lightning_mac0_axi_st_rx_tlast,
    input   wire  [31:0]        lightning_mac0_axi_st_rx_tdata,
    input   wire  [3:0]         lightning_mac0_axi_st_rx_tstrb,

    //****** MAC-1 TX AXI-STREAM
    output  wire                lightning_mac1_axi_st_tx_tvalid,
    output  wire                lightning_mac1_axi_st_tx_tuser,
    output  wire                lightning_mac1_axi_st_tx_tlast,
    output  wire    [3:0]       lightning_mac1_axi_st_tx_tstrb,
    output  wire    [31:0]      lightning_mac1_axi_st_tx_tdata,
    input   wire                lightning_mac1_axi_st_tx_tready,

    //****** MAC-1 RX AXI-STREAM
    input   wire                lightning_mac1_axi_st_rx_tvalid,
    input   wire                lightning_mac1_axi_st_rx_tuser,
    input   wire                lightning_mac1_axi_st_rx_tlast,
    input   wire  [31:0]        lightning_mac1_axi_st_rx_tdata,
    input   wire  [3:0]         lightning_mac1_axi_st_rx_tstrb,

    //****** MAC-2 TX AXI-STREAM
    output  wire                lightning_mac2_axi_st_tx_tvalid,
    output  wire                lightning_mac2_axi_st_tx_tuser,
    output  wire                lightning_mac2_axi_st_tx_tlast,
    output  wire    [3:0]       lightning_mac2_axi_st_tx_tstrb,
    output  wire    [31:0]      lightning_mac2_axi_st_tx_tdata,
    input   wire                lightning_mac2_axi_st_tx_tready,

    //****** MAC-2 RX AXI-STREAM
    input   wire                lightning_mac2_axi_st_rx_tvalid,
    input   wire                lightning_mac2_axi_st_rx_tuser,
    input   wire                lightning_mac2_axi_st_rx_tlast,
    input   wire  [31:0]        lightning_mac2_axi_st_rx_tdata,
    input   wire  [3:0]         lightning_mac2_axi_st_rx_tstrb,

    //****** MAC-3 TX AXI-STREAM
    output  wire                lightning_mac3_axi_st_tx_tvalid,
    output  wire                lightning_mac3_axi_st_tx_tuser,
    output  wire                lightning_mac3_axi_st_tx_tlast,
    output  wire    [3:0]       lightning_mac3_axi_st_tx_tstrb,
    output  wire    [31:0]      lightning_mac3_axi_st_tx_tdata,
    input   wire                lightning_mac3_axi_st_tx_tready,

    //****** MAC-3 RX AXI-STREAM
    input   wire                lightning_mac3_axi_st_rx_tvalid,
    input   wire                lightning_mac3_axi_st_rx_tuser,
    input   wire                lightning_mac3_axi_st_rx_tlast,
    input   wire  [31:0]        lightning_mac3_axi_st_rx_tdata,
    input   wire  [3:0]         lightning_mac3_axi_st_rx_tstrb,

//** BASE DMA
    //**** BASE DMA 0

        //******** DMA TX AXI-STREAM INTERFACE
        input   wire    [31:0]      base_dma0_axi_st_tx_tdata,
        input   wire                base_dma0_axi_st_tx_tvalid,
        input   wire    [3:0]       base_dma0_axi_st_tx_tkeep,
        input   wire                base_dma0_axi_st_tx_tlast,
        output  wire                base_dma0_axi_st_tx_tready,

        //******** DMA RX PORT 0 AXI-STREAM INTERFACE
        output  wire    [31:0]      base_dma0_axi_st_rx_tdata,
        output  wire                base_dma0_axi_st_rx_tvalid,
        output  wire    [2:0]       base_dma0_axi_st_rx_tuser,   // bit[0]: error_flag;  bit[2:1]: BUFFER ID
        output  wire    [3:0]       base_dma0_axi_st_rx_tkeep,
        output  wire                base_dma0_axi_st_rx_tlast,


    //**** BASE DMA 1

        //******** DMA TX AXI-STREAM INTERFACE
        input   wire    [31:0]      base_dma1_axi_st_tx_tdata,
        input   wire                base_dma1_axi_st_tx_tvalid,
        input   wire    [3:0]       base_dma1_axi_st_tx_tkeep,
        input   wire                base_dma1_axi_st_tx_tlast,
        output  wire                base_dma1_axi_st_tx_tready,

        //******** DMA RX PORT 0 AXI-STREAM INTERFACE
        output  wire    [31:0]      base_dma1_axi_st_rx_tdata,
        output  wire                base_dma1_axi_st_rx_tvalid,
        output  wire    [2:0]       base_dma1_axi_st_rx_tuser,   // bit[0]: error_flag;  bit[2:1]: BUFFER ID
        output  wire    [3:0]       base_dma1_axi_st_rx_tkeep,
        output  wire                base_dma1_axi_st_rx_tlast,


//** USER DMA
    //**** USER DMA CTRL SIGNAL
        //******** TX CROSSBAR CTRL SIGNAL
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan0,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan1,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan2,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan3,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan4,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan5,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan6,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan7,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan8,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan9,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan10,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan11,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan12,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan13,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan14,
        output  wire    [1:0]       user_dma_tx_crossbar_ctrl_chan15,
        //******** RX CROSSBAR CTRL SIGNAL
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan0,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan1,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan2,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan3,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan4,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan5,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan6,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan7,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan8,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan9,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan10,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan11,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan12,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan13,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan14,
        output  wire    [1:0]       user_dma_rx_crossbar_ctrl_chan15,
        //******** RX CHANNEL ENABLE
        // input   wire    [15:0]      user_dma_rx_chennel_enable,
    //**** USER DMA PORT 0
        //******** DMA TX AXI-STREAM INTERFACE
        input   wire                                user_dma_axi_st_port0_tx_tvalid,
        input   wire    [3:0]                       user_dma_axi_st_port0_tx_tuser,
        input   wire                                user_dma_axi_st_port0_tx_tlast,
        input   wire    [63:0]                      user_dma_axi_st_port0_tx_tdata,
        input   wire    [7:0]                       user_dma_axi_st_port0_tx_tstrb,
        output  wire                                user_dma_axi_st_port0_tx_tready,

        //******** DMA RX AXI-STRREAM INTERFACE
        output  wire                                user_dma_axi_st_port0_rx_tvalid,
        output  wire    [4:0]                       user_dma_axi_st_port0_rx_tuser,
        output  wire                                user_dma_axi_st_port0_rx_tlast,
        output  wire    [USER_DMA_AXI_WIDTH-1 :0]   user_dma_axi_st_port0_rx_tdata,
        output  wire    [USER_DMA_AXI_STRB-1 :0]    user_dma_axi_st_port0_rx_tstrb,
        input   wire                                user_dma_axi_st_port0_rx_tready,

    //**** USER DMA PORT 1
        //******** DMA TX AXI-STREAM INTERFACE
        input   wire                                user_dma_axi_st_port1_tx_tvalid,
        input   wire    [3:0]                       user_dma_axi_st_port1_tx_tuser,
        input   wire                                user_dma_axi_st_port1_tx_tlast,
        input   wire    [63:0]                      user_dma_axi_st_port1_tx_tdata,
        input   wire    [7:0]                       user_dma_axi_st_port1_tx_tstrb,
        output  wire                                user_dma_axi_st_port1_tx_tready,

        //******** DMA RX AXI-STRREAM INTERFACE
        output  wire                                user_dma_axi_st_port1_rx_tvalid,
        output  wire    [4:0]                       user_dma_axi_st_port1_rx_tuser,
        output  wire                                user_dma_axi_st_port1_rx_tlast,
        output  wire    [USER_DMA_AXI_WIDTH-1 :0]   user_dma_axi_st_port1_rx_tdata,
        output  wire    [USER_DMA_AXI_STRB-1 :0]    user_dma_axi_st_port1_rx_tstrb,
        input   wire                                user_dma_axi_st_port1_rx_tready,

    //**** USER DMA PORT 2
        //******** DMA TX AXI-STREAM INTERFACE
        input   wire                                user_dma_axi_st_port2_tx_tvalid,
        input   wire    [3:0]                       user_dma_axi_st_port2_tx_tuser,
        input   wire                                user_dma_axi_st_port2_tx_tlast,
        input   wire    [63:0]                      user_dma_axi_st_port2_tx_tdata,
        input   wire    [7:0]                       user_dma_axi_st_port2_tx_tstrb,
        output  wire                                user_dma_axi_st_port2_tx_tready,

        //******** DMA RX AXI-STRREAM INTERFACE
        output  wire                                user_dma_axi_st_port2_rx_tvalid,
        output  wire    [4:0]                       user_dma_axi_st_port2_rx_tuser,
        output  wire                                user_dma_axi_st_port2_rx_tlast,
        output  wire    [USER_DMA_AXI_WIDTH-1 :0]   user_dma_axi_st_port2_rx_tdata,
        output  wire    [USER_DMA_AXI_STRB-1 :0]    user_dma_axi_st_port2_rx_tstrb,
        input   wire                                user_dma_axi_st_port2_rx_tready,

    //**** USER DMA PORT 3
        //******** DMA TX AXI-STREAM INTERFACE
        input   wire                                user_dma_axi_st_port3_tx_tvalid,
        input   wire    [3:0]                       user_dma_axi_st_port3_tx_tuser,
        input   wire                                user_dma_axi_st_port3_tx_tlast,
        input   wire    [63:0]                      user_dma_axi_st_port3_tx_tdata,
        input   wire    [7:0]                       user_dma_axi_st_port3_tx_tstrb,
        output  wire                                user_dma_axi_st_port3_tx_tready,

        //******** DMA RX AXI-STRREAM INTERFACE
        output  wire                                user_dma_axi_st_port3_rx_tvalid,
        output  wire    [4:0]                       user_dma_axi_st_port3_rx_tuser,
        output  wire                                user_dma_axi_st_port3_rx_tlast,
        output  wire    [USER_DMA_AXI_WIDTH-1 :0]   user_dma_axi_st_port3_rx_tdata,
        output  wire    [USER_DMA_AXI_STRB-1 :0]    user_dma_axi_st_port3_rx_tstrb,
        input   wire                                user_dma_axi_st_port3_rx_tready
);

//*******************************************************
//** Regfile
//*******************************************************
    wire    [63:0]              udma_port0_rxloss_packet;
    wire    [63:0]              udma_port1_rxloss_packet;
    wire    [63:0]              udma_port2_rxloss_packet;
    wire    [63:0]              udma_port3_rxloss_packet;

    base_demo_regfile u_base_demo_regfile(
        .pcie_axi_clk               ( pcie_axi_clk               ),
        .pcie_axi_resetn            ( pcie_axi_resetn            ),
        .user_bar1_axi_lite_awaddr  ( user_bar1_axi_lite_awaddr  ),
        .user_bar1_axi_lite_awprot  ( user_bar1_axi_lite_awprot  ),
        .user_bar1_axi_lite_awvalid ( user_bar1_axi_lite_awvalid ),
        .user_bar1_axi_lite_wdata   ( user_bar1_axi_lite_wdata   ),
        .user_bar1_axi_lite_wstrb   ( user_bar1_axi_lite_wstrb   ),
        .user_bar1_axi_lite_wvalid  ( user_bar1_axi_lite_wvalid  ),
        .user_bar1_axi_lite_bready  ( user_bar1_axi_lite_bready  ),
        .user_bar1_axi_lite_araddr  ( user_bar1_axi_lite_araddr  ),
        .user_bar1_axi_lite_arprot  ( user_bar1_axi_lite_arprot  ),
        .user_bar1_axi_lite_arvalid ( user_bar1_axi_lite_arvalid ),
        .user_bar1_axi_lite_rready  ( user_bar1_axi_lite_rready  ),
        .user_bar1_axi_lite_awready ( user_bar1_axi_lite_awready ),
        .user_bar1_axi_lite_wready  ( user_bar1_axi_lite_wready  ),
        .user_bar1_axi_lite_bvalid  ( user_bar1_axi_lite_bvalid  ),
        .user_bar1_axi_lite_bresp   ( user_bar1_axi_lite_bresp   ),
        .user_bar1_axi_lite_arready ( user_bar1_axi_lite_arready ),
        .user_bar1_axi_lite_rdata   ( user_bar1_axi_lite_rdata   ),
        .user_bar1_axi_lite_rresp   ( user_bar1_axi_lite_rresp   ),
        .user_bar1_axi_lite_rvalid  ( user_bar1_axi_lite_rvalid  ),

        .udma_port0_rxloss_packet   ( udma_port0_rxloss_packet   ),
        .udma_port1_rxloss_packet   ( udma_port1_rxloss_packet   ),
        .udma_port2_rxloss_packet   ( udma_port2_rxloss_packet   ),
        .udma_port3_rxloss_packet   ( udma_port3_rxloss_packet   ),

        .lightning_mac0_enable      ( lightning_mac0_enable      ),
        .lightning_mac0_loopback    ( lightning_mac0_loopback    ),
        .lightning_mac1_enable      ( lightning_mac1_enable      ),
        .lightning_mac1_loopback    ( lightning_mac1_loopback    ),
        .lightning_mac2_enable      ( lightning_mac2_enable      ),
        .lightning_mac2_loopback    ( lightning_mac2_loopback    ),
        .lightning_mac3_enable      ( lightning_mac3_enable      ),
        .lightning_mac3_loopback    ( lightning_mac3_loopback    )
    );

//*******************************************************
//** USER DMA Config
//*******************************************************
    assign  user_dma_tx_crossbar_ctrl_chan0     =   0;
    assign  user_dma_tx_crossbar_ctrl_chan1     =   0;
    assign  user_dma_tx_crossbar_ctrl_chan2     =   0;
    assign  user_dma_tx_crossbar_ctrl_chan3     =   0;
    assign  user_dma_tx_crossbar_ctrl_chan4     =   1;
    assign  user_dma_tx_crossbar_ctrl_chan5     =   1;
    assign  user_dma_tx_crossbar_ctrl_chan6     =   1;
    assign  user_dma_tx_crossbar_ctrl_chan7     =   1;
    assign  user_dma_tx_crossbar_ctrl_chan8     =   2;
    assign  user_dma_tx_crossbar_ctrl_chan9     =   2;
    assign  user_dma_tx_crossbar_ctrl_chan10    =   2;
    assign  user_dma_tx_crossbar_ctrl_chan11    =   2;
    assign  user_dma_tx_crossbar_ctrl_chan12    =   3;
    assign  user_dma_tx_crossbar_ctrl_chan13    =   3;
    assign  user_dma_tx_crossbar_ctrl_chan14    =   3;
    assign  user_dma_tx_crossbar_ctrl_chan15    =   3;

    assign  user_dma_rx_crossbar_ctrl_chan0     =   0;
    assign  user_dma_rx_crossbar_ctrl_chan1     =   0;
    assign  user_dma_rx_crossbar_ctrl_chan2     =   0;
    assign  user_dma_rx_crossbar_ctrl_chan3     =   0;
    assign  user_dma_rx_crossbar_ctrl_chan4     =   1;
    assign  user_dma_rx_crossbar_ctrl_chan5     =   1;
    assign  user_dma_rx_crossbar_ctrl_chan6     =   1;
    assign  user_dma_rx_crossbar_ctrl_chan7     =   1;
    assign  user_dma_rx_crossbar_ctrl_chan8     =   2;
    assign  user_dma_rx_crossbar_ctrl_chan9     =   2;
    assign  user_dma_rx_crossbar_ctrl_chan10    =   2;
    assign  user_dma_rx_crossbar_ctrl_chan11    =   2;
    assign  user_dma_rx_crossbar_ctrl_chan12    =   3;
    assign  user_dma_rx_crossbar_ctrl_chan13    =   3;
    assign  user_dma_rx_crossbar_ctrl_chan14    =   3;
    assign  user_dma_rx_crossbar_ctrl_chan15    =   3;
//*******************************************************
//** MAC #0 <---> BASE DMA #0
//*******************************************************
  //**** MAC #0 Rx ---> AXI-S Register ---> BASE DMA #0 Rx
    assign  base_dma0_axi_st_rx_tuser[2:1]  = 0;
    axi_stream_noready_register#(
        .DATA_WIDTH    ( 32 ),
        .STRB_WIDTH    ( 4 ),
        .USER_WIDTH    ( 1 )
    )u_mac0_rx_register(
        .sys_clk       ( mac0rx_user_clk    ),
        .sys_rstn      ( mac0rx_user_resetn ),

        .m_axis_tvalid ( lightning_mac0_axi_st_rx_tvalid ),
        .m_axis_tlast  ( lightning_mac0_axi_st_rx_tlast  ),
        .m_axis_tdata  ( lightning_mac0_axi_st_rx_tdata  ),
        .m_axis_tstrb  ( lightning_mac0_axi_st_rx_tstrb  ),
        .m_axis_tuser  ( lightning_mac0_axi_st_rx_tuser  ),

        .s_axis_tvalid ( base_dma0_axi_st_rx_tvalid   ),
        .s_axis_tlast  ( base_dma0_axi_st_rx_tlast    ),
        .s_axis_tdata  ( base_dma0_axi_st_rx_tdata    ),
        .s_axis_tstrb  ( base_dma0_axi_st_rx_tkeep    ),
        .s_axis_tuser  ( base_dma0_axi_st_rx_tuser[0] )
    );
  //**** BASE DMA #0 Tx ---> AXI-S Register ---> MAC #0 Tx
    axi_stream_register#(
        .DATA_WIDTH    ( 32 ),
        .STRB_WIDTH    ( 4 ),
        .USER_WIDTH    ( 1 )
    )u_mac0_tx_register(
        .sys_clk       ( mac0tx_user_clk    ),
        .sys_rstn      ( mac0tx_user_resetn ),

        .m_axis_tvalid ( base_dma0_axi_st_tx_tvalid ),
        .m_axis_tlast  ( base_dma0_axi_st_tx_tlast  ),
        .m_axis_tdata  ( base_dma0_axi_st_tx_tdata  ),
        .m_axis_tstrb  ( base_dma0_axi_st_tx_tkeep  ),
        .m_axis_tuser  ( 1'b0  ),
        .m_axis_tready ( base_dma0_axi_st_tx_tready ),

        .s_axis_tvalid ( lightning_mac0_axi_st_tx_tvalid ),
        .s_axis_tlast  ( lightning_mac0_axi_st_tx_tlast  ),
        .s_axis_tdata  ( lightning_mac0_axi_st_tx_tdata  ),
        .s_axis_tstrb  ( lightning_mac0_axi_st_tx_tstrb  ),
        .s_axis_tuser  ( lightning_mac0_axi_st_tx_tuser  ),
        .s_axis_tready ( lightning_mac0_axi_st_tx_tready )
    );

//*******************************************************
//** MAC #1 <---> BASE DMA #1
//*******************************************************
  //**** MAC #1 Rx ---> AXI-S Register ---> BASE DMA #1 Rx
    assign  base_dma1_axi_st_rx_tuser[2:1]  = 0;
    axi_stream_noready_register#(
        .DATA_WIDTH    ( 32 ),
        .STRB_WIDTH    ( 4 ),
        .USER_WIDTH    ( 1 )
    )u_mac1_rx_register(
        .sys_clk       ( mac1rx_user_clk    ),
        .sys_rstn      ( mac1rx_user_resetn ),

        .m_axis_tvalid ( lightning_mac1_axi_st_rx_tvalid ),
        .m_axis_tlast  ( lightning_mac1_axi_st_rx_tlast  ),
        .m_axis_tdata  ( lightning_mac1_axi_st_rx_tdata  ),
        .m_axis_tstrb  ( lightning_mac1_axi_st_rx_tstrb  ),
        .m_axis_tuser  ( lightning_mac1_axi_st_rx_tuser  ),

        .s_axis_tvalid ( base_dma1_axi_st_rx_tvalid   ),
        .s_axis_tlast  ( base_dma1_axi_st_rx_tlast    ),
        .s_axis_tdata  ( base_dma1_axi_st_rx_tdata    ),
        .s_axis_tstrb  ( base_dma1_axi_st_rx_tkeep    ),
        .s_axis_tuser  ( base_dma1_axi_st_rx_tuser[0] )
    );
  //**** BASE DMA #1 Tx ---> AXI-S Register ---> MAC #1 Tx
    axi_stream_register#(
        .DATA_WIDTH    ( 32 ),
        .STRB_WIDTH    ( 4 ),
        .USER_WIDTH    ( 1 )
    )u_mac1_tx_register(
        .sys_clk       ( mac1tx_user_clk    ),
        .sys_rstn      ( mac1tx_user_resetn ),

        .m_axis_tvalid ( base_dma1_axi_st_tx_tvalid ),
        .m_axis_tlast  ( base_dma1_axi_st_tx_tlast  ),
        .m_axis_tdata  ( base_dma1_axi_st_tx_tdata  ),
        .m_axis_tstrb  ( base_dma1_axi_st_tx_tkeep  ),
        .m_axis_tuser  ( 1'b0  ),
        .m_axis_tready ( base_dma1_axi_st_tx_tready ),

        .s_axis_tvalid ( lightning_mac1_axi_st_tx_tvalid ),
        .s_axis_tlast  ( lightning_mac1_axi_st_tx_tlast  ),
        .s_axis_tdata  ( lightning_mac1_axi_st_tx_tdata  ),
        .s_axis_tstrb  ( lightning_mac1_axi_st_tx_tstrb  ),
        .s_axis_tuser  ( lightning_mac1_axi_st_tx_tuser  ),
        .s_axis_tready ( lightning_mac1_axi_st_tx_tready )
    );

//*******************************************************
//** MAC #0 (Mirror) <---> USER DMA #0
//*******************************************************
  //**** MAC #0 Rx ---> macrx2userdma ---> USER DMA #0 Rx
    macrx2userdma#(
        .USERDMA_AXI_DATA_WIDTH ( USER_DMA_AXI_WIDTH ),
        .USERDMA_AXI_STRB_WIDTH ( USER_DMA_AXI_STRB  ),
        .USERDMA_RX_BUFFER      ( 4'd0 ),
        .PACKET_LOSS_FIFO_DEPTH ( PACKET_LOSS_FIFO_DEPTH ),
        .PACKET_LOSS_FULL_THR   ( PACKET_LOSS_FULL_THR   )
    )u_macrx2userdma_0(
        .macrx_clk              ( mac0rx_user_clk        ),
        .macrx_rstn             ( mac0rx_user_resetn     ),
        .sys_clk                ( pcie_axi_clk           ),
        .sys_rstn               ( pcie_axi_resetn        ),

        .macrx_axi_st_rx_tvalid ( lightning_mac0_axi_st_rx_tvalid ),
        .macrx_axi_st_rx_tuser  ( lightning_mac0_axi_st_rx_tuser  ),
        .macrx_axi_st_rx_tlast  ( lightning_mac0_axi_st_rx_tlast  ),
        .macrx_axi_st_rx_tdata  ( lightning_mac0_axi_st_rx_tdata  ),
        .macrx_axi_st_rx_tstrb  ( lightning_mac0_axi_st_rx_tstrb  ),

        .udma_axi_st_rx_tvalid  ( user_dma_axi_st_port0_rx_tvalid ),
        .udma_axi_st_rx_tlast   ( user_dma_axi_st_port0_rx_tlast  ),
        .udma_axi_st_rx_tuser   ( user_dma_axi_st_port0_rx_tuser  ),
        .udma_axi_st_rx_tdata   ( user_dma_axi_st_port0_rx_tdata  ),
        .udma_axi_st_rx_tstrb   ( user_dma_axi_st_port0_rx_tstrb  ),
        .udma_axi_st_rx_tready  ( user_dma_axi_st_port0_rx_tready ),
        .packet_loss_count      ( udma_port0_rxloss_packet        )
    );
  //**** USER DMA #0 Tx
    assign  user_dma_axi_st_port0_tx_tready     =   1;

//*******************************************************
//** MAC #1 (Mirror) <---> USER DMA #1
//*******************************************************
  //**** MAC #1 Rx ---> macrx2userdma ---> USER DMA #1 Rx
    macrx2userdma#(
        .USERDMA_AXI_DATA_WIDTH ( USER_DMA_AXI_WIDTH ),
        .USERDMA_AXI_STRB_WIDTH ( USER_DMA_AXI_STRB  ),
        .USERDMA_RX_BUFFER      ( 4'd4 ),
        .PACKET_LOSS_FIFO_DEPTH ( PACKET_LOSS_FIFO_DEPTH ),
        .PACKET_LOSS_FULL_THR   ( PACKET_LOSS_FULL_THR   )
    )u_macrx2userdma_1(
        .macrx_clk              ( mac1rx_user_clk        ),
        .macrx_rstn             ( mac1rx_user_resetn     ),
        .sys_clk                ( pcie_axi_clk           ),
        .sys_rstn               ( pcie_axi_resetn        ),

        .macrx_axi_st_rx_tvalid ( lightning_mac1_axi_st_rx_tvalid ),
        .macrx_axi_st_rx_tuser  ( lightning_mac1_axi_st_rx_tuser  ),
        .macrx_axi_st_rx_tlast  ( lightning_mac1_axi_st_rx_tlast  ),
        .macrx_axi_st_rx_tdata  ( lightning_mac1_axi_st_rx_tdata  ),
        .macrx_axi_st_rx_tstrb  ( lightning_mac1_axi_st_rx_tstrb  ),

        .udma_axi_st_rx_tvalid  ( user_dma_axi_st_port1_rx_tvalid ),
        .udma_axi_st_rx_tlast   ( user_dma_axi_st_port1_rx_tlast  ),
        .udma_axi_st_rx_tuser   ( user_dma_axi_st_port1_rx_tuser  ),
        .udma_axi_st_rx_tdata   ( user_dma_axi_st_port1_rx_tdata  ),
        .udma_axi_st_rx_tstrb   ( user_dma_axi_st_port1_rx_tstrb  ),
        .udma_axi_st_rx_tready  ( user_dma_axi_st_port1_rx_tready ),
        .packet_loss_count      ( udma_port1_rxloss_packet        )
    );
  //**** USER DMA #1 Tx
    assign  user_dma_axi_st_port1_tx_tready     =   1;

//*******************************************************
//** MAC #2 (Mirror) <---> USER DMA #2
//*******************************************************
  //**** MAC #2 Rx ---> macrx2userdma ---> USER DMA #2 Rx
    macrx2userdma#(
        .USERDMA_AXI_DATA_WIDTH ( USER_DMA_AXI_WIDTH ),
        .USERDMA_AXI_STRB_WIDTH ( USER_DMA_AXI_STRB  ),
        .USERDMA_RX_BUFFER      ( 4'd8 ),
        .PACKET_LOSS_FIFO_DEPTH ( PACKET_LOSS_FIFO_DEPTH ),
        .PACKET_LOSS_FULL_THR   ( PACKET_LOSS_FULL_THR   )
    )u_macrx2userdma_2(
        .macrx_clk              ( mac2rx_user_clk        ),
        .macrx_rstn             ( mac2rx_user_resetn     ),
        .sys_clk                ( pcie_axi_clk           ),
        .sys_rstn               ( pcie_axi_resetn        ),

        .macrx_axi_st_rx_tvalid ( lightning_mac2_axi_st_rx_tvalid ),
        .macrx_axi_st_rx_tuser  ( lightning_mac2_axi_st_rx_tuser  ),
        .macrx_axi_st_rx_tlast  ( lightning_mac2_axi_st_rx_tlast  ),
        .macrx_axi_st_rx_tdata  ( lightning_mac2_axi_st_rx_tdata  ),
        .macrx_axi_st_rx_tstrb  ( lightning_mac2_axi_st_rx_tstrb  ),

        .udma_axi_st_rx_tvalid  ( user_dma_axi_st_port2_rx_tvalid ),
        .udma_axi_st_rx_tlast   ( user_dma_axi_st_port2_rx_tlast  ),
        .udma_axi_st_rx_tuser   ( user_dma_axi_st_port2_rx_tuser  ),
        .udma_axi_st_rx_tdata   ( user_dma_axi_st_port2_rx_tdata  ),
        .udma_axi_st_rx_tstrb   ( user_dma_axi_st_port2_rx_tstrb  ),
        .udma_axi_st_rx_tready  ( user_dma_axi_st_port2_rx_tready ),
        .packet_loss_count      ( udma_port2_rxloss_packet        )
    );
  //**** USER DMA #2 Tx ---> userdma2mactx ---> MAC #2 Tx
    userdma2mactx#(
        .USERDMA_AXI_DATA_WIDTH ( 64 ),
        .USERDMA_AXI_STRB_WIDTH ( 8  ),
        .USERDMA_TX_BUFFER      ( 4'd8 )
    )u_userdma2mactx_2(
        .mactx_clk              ( mac2tx_user_clk        ),
        .mactx_rstn             ( mac2tx_user_resetn     ),
        .sys_clk                ( pcie_axi_clk           ),
        .sys_rstn               ( pcie_axi_resetn        ),

        .udma_axi_st_tx_tvalid  ( user_dma_axi_st_port2_tx_tvalid  ),
        .udma_axi_st_tx_tuser   ( user_dma_axi_st_port2_tx_tuser   ),
        .udma_axi_st_tx_tlast   ( user_dma_axi_st_port2_tx_tlast   ),
        .udma_axi_st_tx_tdata   ( user_dma_axi_st_port2_tx_tdata   ),
        .udma_axi_st_tx_tstrb   ( user_dma_axi_st_port2_tx_tstrb   ),
        .udma_axi_st_tx_tready  ( user_dma_axi_st_port2_tx_tready  ),

        .mactx_axi_st_tx_tvalid ( lightning_mac2_axi_st_tx_tvalid ),
        .mactx_axi_st_tx_tlast  ( lightning_mac2_axi_st_tx_tlast  ),
        .mactx_axi_st_tx_tuser  ( lightning_mac2_axi_st_tx_tuser  ),
        .mactx_axi_st_tx_tdata  ( lightning_mac2_axi_st_tx_tdata  ),
        .mactx_axi_st_tx_tstrb  ( lightning_mac2_axi_st_tx_tstrb  ),
        .mactx_axi_st_tx_tready ( lightning_mac2_axi_st_tx_tready )
    );

//*******************************************************
//** MAC #3 (Mirror) <---> USER DMA #3
//*******************************************************
  //**** MAC #3 Rx ---> macrx2userdma ---> USER DMA #3 Rx
    macrx2userdma#(
        .USERDMA_AXI_DATA_WIDTH ( USER_DMA_AXI_WIDTH ),
        .USERDMA_AXI_STRB_WIDTH ( USER_DMA_AXI_STRB  ),
        .USERDMA_RX_BUFFER      ( 4'd12 ),
        .PACKET_LOSS_FIFO_DEPTH ( PACKET_LOSS_FIFO_DEPTH ),
        .PACKET_LOSS_FULL_THR   ( PACKET_LOSS_FULL_THR   )
    )u_macrx2userdma_3(
        .macrx_clk              ( mac3rx_user_clk        ),
        .macrx_rstn             ( mac3rx_user_resetn     ),
        .sys_clk                ( pcie_axi_clk           ),
        .sys_rstn               ( pcie_axi_resetn        ),

        .macrx_axi_st_rx_tvalid ( lightning_mac3_axi_st_rx_tvalid ),
        .macrx_axi_st_rx_tuser  ( lightning_mac3_axi_st_rx_tuser  ),
        .macrx_axi_st_rx_tlast  ( lightning_mac3_axi_st_rx_tlast  ),
        .macrx_axi_st_rx_tdata  ( lightning_mac3_axi_st_rx_tdata  ),
        .macrx_axi_st_rx_tstrb  ( lightning_mac3_axi_st_rx_tstrb  ),

        .udma_axi_st_rx_tvalid  ( user_dma_axi_st_port3_rx_tvalid ),
        .udma_axi_st_rx_tlast   ( user_dma_axi_st_port3_rx_tlast  ),
        .udma_axi_st_rx_tuser   ( user_dma_axi_st_port3_rx_tuser  ),
        .udma_axi_st_rx_tdata   ( user_dma_axi_st_port3_rx_tdata  ),
        .udma_axi_st_rx_tstrb   ( user_dma_axi_st_port3_rx_tstrb  ),
        .udma_axi_st_rx_tready  ( user_dma_axi_st_port3_rx_tready ),
        .packet_loss_count      ( udma_port3_rxloss_packet        )
    );
  //**** USER DMA #3 Tx ---> userdma2mactx ---> MAC #3 Tx
    userdma2mactx#(
        .USERDMA_AXI_DATA_WIDTH ( 64 ),
        .USERDMA_AXI_STRB_WIDTH ( 8  ),
        .USERDMA_TX_BUFFER      ( 4'd12 )
    )u_userdma2mactx_3(
        .mactx_clk              ( mac3tx_user_clk        ),
        .mactx_rstn             ( mac3tx_user_resetn     ),
        .sys_clk                ( pcie_axi_clk           ),
        .sys_rstn               ( pcie_axi_resetn        ),

        .udma_axi_st_tx_tvalid  ( user_dma_axi_st_port3_tx_tvalid  ),
        .udma_axi_st_tx_tuser   ( user_dma_axi_st_port3_tx_tuser   ),
        .udma_axi_st_tx_tlast   ( user_dma_axi_st_port3_tx_tlast   ),
        .udma_axi_st_tx_tdata   ( user_dma_axi_st_port3_tx_tdata   ),
        .udma_axi_st_tx_tstrb   ( user_dma_axi_st_port3_tx_tstrb   ),
        .udma_axi_st_tx_tready  ( user_dma_axi_st_port3_tx_tready  ),

        .mactx_axi_st_tx_tvalid ( lightning_mac3_axi_st_tx_tvalid ),
        .mactx_axi_st_tx_tlast  ( lightning_mac3_axi_st_tx_tlast  ),
        .mactx_axi_st_tx_tuser  ( lightning_mac3_axi_st_tx_tuser  ),
        .mactx_axi_st_tx_tdata  ( lightning_mac3_axi_st_tx_tdata  ),
        .mactx_axi_st_tx_tstrb  ( lightning_mac3_axi_st_tx_tstrb  ),
        .mactx_axi_st_tx_tready ( lightning_mac3_axi_st_tx_tready )
    );

endmodule
`default_nettype wire