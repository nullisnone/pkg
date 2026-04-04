//--------------------------------------------------------------------------------
//  __   ___   _ ____  _   _ ____       Project     : ndpp_sim
//  \ \ / / | | / ___|| | | |  _ \      File        : yusur_ndpp_fdk_sim.sv
//   \ V /| | | \___ \| | | | |_) |     Version     : 0.0.1
//    | | | |_| |___) | |_| |  _ <      Author      : 
//    |_|  \___/|____/ \___/|_| \_\     Date        : 2024-01-01
//                                      Description : yusur_ndpp_fdk_sim has the basic functions of yusur_ndpp_fdk, it is the NDPP Simulation Model
//--------------------------------------------------------------------------------
//------Verilog_Header(`define)
//`include "<path_to_vh>/NDPP_SIM.vh"
//`include "<path_to_vh>/USER.vh"
//`include "./verilog_header/NDPP_SIM.vh"
//------Define
//`define GLOBAL_MODE
//`define LOCAL_MODE

`ifndef GLOBAL_MODE
    `define SIM_EN
    `define LOCAL_MODE
`else
    `define SIM_EN
    `define NORMAL_MODE
`endif

`define PRINT_ENABLE
//--------------------------------------------------------------------------------
`timescale 1ps / 1ps    //`timescale 1ns / 1ps

module yusur_ndpp_fdk_sim #(
    //---USER_DMA_RX_CH: USER_DMA_WIDTH_64(default) or USER_DMA_WIDTH_256
    parameter       USER_DMA_AXI_WIDTH      =   64                                  ,//64       256
    parameter       USER_DMA_AXI_STRB       =   8                                   ,//8        32
    parameter       PACKET_LOSS_FIFO_DEPTH  =   2048                                ,//2048     1024
    parameter       PACKET_LOSS_FULL_THR    =   1108                                ,//1108     780
    //---
    parameter       WORK_MODE               = 0                                     ,//0:global, 1:local
    parameter       BAR1_DATA_WIDTH         = 32                                    ,//32
    parameter       BAR1_KEEP_WIDTH         = BAR1_DATA_WIDTH / 8                   ,//4
    parameter       MAC_DATA_WIDTH          = 32                                    ,//32
    parameter       MAC_KEEP_WIDTH          = MAC_DATA_WIDTH  / 8                   ,//4
    parameter       MAC_USER_WIDTH          = 1                                     ,//Default 1'b1
    parameter       BASE_DATA_WIDTH         = 32                                    ,//32
    parameter       BASE_KEEP_WIDTH         = BASE_DATA_WIDTH / 8                   ,//4
    parameter       USER_DATA_WIDTH         = 64                                    ,//64
    parameter       USER_KEEP_WIDTH         = USER_DATA_WIDTH / 8                    //8
)
    (
    output  wire                            pcie_axi_clk                            ,
    output  wire [00:00]                    pcie_axi_resetn                         ,
    
    output wire                             mac0tx_user_clk                         ,
    output wire                             mac0tx_user_resetn                      ,
    output wire                             mac0rx_user_clk                         ,
    output wire                             mac0rx_user_resetn                      ,
    output wire                             mac1tx_user_clk                         ,
    output wire                             mac1tx_user_resetn                      ,
    output wire                             mac1rx_user_clk                         ,
    output wire                             mac1rx_user_resetn                      ,
    output wire                             mac2tx_user_clk                         ,
    output wire                             mac2tx_user_resetn                      ,
    output wire                             mac2rx_user_clk                         ,
    output wire                             mac2rx_user_resetn                      ,
    output wire                             mac3tx_user_clk                         ,
    output wire                             mac3tx_user_resetn                      ,
    output wire                             mac3rx_user_clk                         ,
    output wire                             mac3rx_user_resetn                      ,
    //------PTP 1588 CLOCK DOMAIN
    output wire                             ptp_1588_clk                            ,
    output wire                             ptp_1588_rstn                           ,
    //** AXI-LITE IF
    output wire [BAR1_DATA_WIDTH-1 : 0]     user_bar1_axi_lite_awaddr               ,
    output wire [2:0]                       user_bar1_axi_lite_awprot               ,//default 3'b000
    output wire                             user_bar1_axi_lite_awvalid              ,
    output wire [BAR1_DATA_WIDTH-1 : 0]     user_bar1_axi_lite_wdata                ,
    output wire [BAR1_KEEP_WIDTH-1 : 0]     user_bar1_axi_lite_wstrb                ,
    output wire                             user_bar1_axi_lite_wvalid               ,
    output wire                             user_bar1_axi_lite_bready               ,
    output wire [BAR1_DATA_WIDTH-1 : 0]     user_bar1_axi_lite_araddr               ,
    output wire [2:0]                       user_bar1_axi_lite_arprot               ,//default 3'b000
    output wire                             user_bar1_axi_lite_arvalid              ,
    output wire                             user_bar1_axi_lite_rready               ,

    input  wire                             user_bar1_axi_lite_awready              ,
    input  wire                             user_bar1_axi_lite_wready               ,
    input  wire                             user_bar1_axi_lite_bvalid               ,
    input  wire [1:0]                       user_bar1_axi_lite_bresp                ,
    input  wire                             user_bar1_axi_lite_arready              ,
    input  wire [BAR1_DATA_WIDTH-1 : 0]     user_bar1_axi_lite_rdata                ,
    input  wire [1:0]                       user_bar1_axi_lite_rresp                ,
    input  wire                             user_bar1_axi_lite_rvalid               ,
    //------MAC CONTROL && STATUS IF
    input                                   lightning_mac0_enable                   ,//default set 1'b1
    input                                   lightning_mac0_loopback                 ,//default set 1'b0
    output wire                             lightning_mac0_link_status              ,
    output wire                             lightning_mac0_active_status            ,

    input                                   lightning_mac1_enable                   ,//default set 1'b1
    input                                   lightning_mac1_loopback                 ,//default set 1'b0
    output wire                             lightning_mac1_link_status              ,
    output wire                             lightning_mac1_active_status            ,

    input                                   lightning_mac2_enable                   ,
    input                                   lightning_mac2_loopback                 ,
    output wire                             lightning_mac2_link_status              ,
    output wire                             lightning_mac2_active_status            ,

    input                                   lightning_mac3_enable                   ,
    input                                   lightning_mac3_loopback                 ,
    output wire                             lightning_mac3_link_status              ,
    output wire                             lightning_mac3_active_status            ,

    //------MAC AXI-STREAM IF
    //---MAC-0 TX AXI-STREAM
    input                                   lightning_mac0_axi_st_tx_tvalid         ,
    input                                   lightning_mac0_axi_st_tx_tuser          ,
    input                                   lightning_mac0_axi_st_tx_tlast          ,
    input       [MAC_KEEP_WIDTH-1  : 0]     lightning_mac0_axi_st_tx_tstrb          ,
    input       [MAC_DATA_WIDTH-1  : 0]     lightning_mac0_axi_st_tx_tdata          ,
    output wire                             lightning_mac0_axi_st_tx_tready         ,
    //---MAC-0 RX AXI-STREAM
    output wire                             lightning_mac0_axi_st_rx_tvalid         ,
    output wire                             lightning_mac0_axi_st_rx_tuser          ,
    output wire                             lightning_mac0_axi_st_rx_tlast          ,
    output wire [MAC_DATA_WIDTH-1  : 0]     lightning_mac0_axi_st_rx_tdata          ,
    output wire [MAC_KEEP_WIDTH-1  : 0]     lightning_mac0_axi_st_rx_tstrb          ,
    //---MAC-1 TX AXI-STREAM
    input                                   lightning_mac1_axi_st_tx_tvalid         ,//I
    input                                   lightning_mac1_axi_st_tx_tuser          ,//I
    input                                   lightning_mac1_axi_st_tx_tlast          ,//I
    input       [MAC_KEEP_WIDTH-1  : 0]     lightning_mac1_axi_st_tx_tstrb          ,//I
    input       [MAC_DATA_WIDTH-1  : 0]     lightning_mac1_axi_st_tx_tdata          ,//I
    output wire                             lightning_mac1_axi_st_tx_tready         ,//O
    //---MAC-1 RX AXI-STREAM
    output wire                             lightning_mac1_axi_st_rx_tvalid         ,//O
    output wire                             lightning_mac1_axi_st_rx_tuser          ,//O
    output wire                             lightning_mac1_axi_st_rx_tlast          ,//O
    output wire [MAC_DATA_WIDTH-1  : 0]     lightning_mac1_axi_st_rx_tdata          ,//O
    output wire [MAC_KEEP_WIDTH-1  : 0]     lightning_mac1_axi_st_rx_tstrb          ,//O
    //---MAC-2 TX AXI-STREAM
    input                                   lightning_mac2_axi_st_tx_tvalid         ,//I
    input                                   lightning_mac2_axi_st_tx_tuser          ,//I
    input                                   lightning_mac2_axi_st_tx_tlast          ,//I
    input       [MAC_KEEP_WIDTH-1  : 0]     lightning_mac2_axi_st_tx_tstrb          ,//I
    input       [MAC_DATA_WIDTH-1  : 0]     lightning_mac2_axi_st_tx_tdata          ,//I
    output wire                             lightning_mac2_axi_st_tx_tready         ,//O
    //---MAC-1 RX AXI-STREAM
    output wire                             lightning_mac2_axi_st_rx_tvalid         ,//O
    output wire                             lightning_mac2_axi_st_rx_tuser          ,//O
    output wire                             lightning_mac2_axi_st_rx_tlast          ,//O
    output wire [MAC_DATA_WIDTH-1  : 0]     lightning_mac2_axi_st_rx_tdata          ,//O
    output wire [MAC_KEEP_WIDTH-1  : 0]     lightning_mac2_axi_st_rx_tstrb          ,//O
    //---MAC-3 TX AXI-STREAM
    input                                   lightning_mac3_axi_st_tx_tvalid         ,//I
    input                                   lightning_mac3_axi_st_tx_tuser          ,//I
    input                                   lightning_mac3_axi_st_tx_tlast          ,//I
    input       [MAC_KEEP_WIDTH-1  : 0]     lightning_mac3_axi_st_tx_tstrb          ,//I
    input       [MAC_DATA_WIDTH-1  : 0]     lightning_mac3_axi_st_tx_tdata          ,//I
    output wire                             lightning_mac3_axi_st_tx_tready         ,//O
    //---MAC-3 RX AXI-STREAM
    output wire                             lightning_mac3_axi_st_rx_tvalid         ,//O
    output wire                             lightning_mac3_axi_st_rx_tuser          ,//O
    output wire                             lightning_mac3_axi_st_rx_tlast          ,//O
    output wire [MAC_DATA_WIDTH-1  : 0]     lightning_mac3_axi_st_rx_tdata          ,//O
    output wire [MAC_KEEP_WIDTH-1  : 0]     lightning_mac3_axi_st_rx_tstrb          ,//O
    //------BASE_DMA_PORT0
    //---H2C
    output wire [BASE_DATA_WIDTH-1 : 0]     base_dma0_axi_st_tx_tdata               ,
    output wire                             base_dma0_axi_st_tx_tvalid              ,
    output wire                             base_dma0_axi_st_tx_bypass              ,
    //output  wire[2:0]                     base_dma0_axi_st_tx_tuser               ,NC
    output wire [BASE_KEEP_WIDTH-1 : 0]     base_dma0_axi_st_tx_tkeep               ,
    output wire                             base_dma0_axi_st_tx_tlast               ,
    input  wire                             base_dma0_axi_st_tx_tready              ,
    //---C2H
    input  wire [BASE_DATA_WIDTH-1 : 0]     base_dma0_axi_st_rx_tdata               ,
    input  wire                             base_dma0_axi_st_rx_tvalid              ,
    input  wire [2:0]                       base_dma0_axi_st_rx_tuser               ,
    input  wire [BASE_KEEP_WIDTH-1 : 0]     base_dma0_axi_st_rx_tkeep               ,
    input  wire                             base_dma0_axi_st_rx_tlast               ,
    output wire                             base_dma0_axi_st_rx_tready              ,
    input                                   base_dma0_rx_ready_enable               ,//set 0 if NC
    output      [3:0]                       base_dma0_rx_channel_enable             ,//set 0 if NC
    //------BASE_DMA_PORT1
    //---H2C
    output wire [BASE_DATA_WIDTH-1 : 0]     base_dma1_axi_st_tx_tdata               ,
    output wire                             base_dma1_axi_st_tx_tvalid              ,
    output wire                             base_dma1_axi_st_tx_bypass              ,
    //output wire [2:0]                     base_dma1_axi_st_tx_tuser               ,NC
    output wire [BASE_KEEP_WIDTH-1 : 0]     base_dma1_axi_st_tx_tkeep               ,
    output wire                             base_dma1_axi_st_tx_tlast               ,
    input  wire                             base_dma1_axi_st_tx_tready              ,
    //---C2H
    input  wire [BASE_DATA_WIDTH-1 : 0]     base_dma1_axi_st_rx_tdata               ,
    input  wire                             base_dma1_axi_st_rx_tvalid              ,
    input  wire [2:0]                       base_dma1_axi_st_rx_tuser               ,
    input  wire [BASE_KEEP_WIDTH-1 : 0]     base_dma1_axi_st_rx_tkeep               ,
    input  wire                             base_dma1_axi_st_rx_tlast               ,
    output wire                             base_dma1_axi_st_rx_tready              ,
    input                                   base_dma1_rx_ready_enable               ,//set 0 if NC
    output      [3:0]                       base_dma1_rx_channel_enable             ,//set 0 if NC
    //------USER_DMA_CTRL_SIGNAL
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan0         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan1         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan2         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan3         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan4         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan5         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan6         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan7         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan8         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan9         ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan10        ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan11        ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan12        ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan13        ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan14        ,
    input       [1:0]                       user_dma_tx_crossbar_ctrl_chan15        ,

    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan0         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan1         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan2         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan3         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan4         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan5         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan6         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan7         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan8         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan9         ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan10        ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan11        ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan12        ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan13        ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan14        ,
    input       [1:0]                       user_dma_rx_crossbar_ctrl_chan15        ,

    output wire [15:00]                     user_dma_rx_chennel_enable              ,
    //------USER_DMA_PORT0
    //---H2C
    output wire                             user_dma_axi_st_port0_tx_tvalid         ,
    output wire [3:0]                       user_dma_axi_st_port0_tx_tuser          ,
    output wire                             user_dma_axi_st_port0_tx_tlast          ,
    output wire [USER_DATA_WIDTH-1 : 0]     user_dma_axi_st_port0_tx_tdata          ,
    output wire [USER_KEEP_WIDTH-1 : 0]     user_dma_axi_st_port0_tx_tstrb          ,//user_dma_axi_st_port3_tx_tkeep
    input  wire                             user_dma_axi_st_port0_tx_tready         ,
    //---C2H
    input  wire                             user_dma_axi_st_port0_rx_tvalid         ,
    input  wire [4:0]                       user_dma_axi_st_port0_rx_tuser          ,
    input  wire                             user_dma_axi_st_port0_rx_tlast          ,
    input  wire [USER_DMA_AXI_WIDTH-1 : 0]  user_dma_axi_st_port0_rx_tdata          ,//USER_DATA_WIDTH -> USER_DMA_AXI_WIDTH
    input  wire [USER_DMA_AXI_STRB-1 : 0]   user_dma_axi_st_port0_rx_tstrb          ,//USER_KEEP_WIDTH -> USER_DMA_AXI_STRB   //user_dma_axi_st_port3_rx_tkeep
    output wire                             user_dma_axi_st_port0_rx_tready         ,
    //------USER_DMA_PORT1
    //---H2C
    output wire                             user_dma_axi_st_port1_tx_tvalid         ,
    output wire [3:0]                       user_dma_axi_st_port1_tx_tuser          ,
    output wire                             user_dma_axi_st_port1_tx_tlast          ,
    output wire [USER_DATA_WIDTH-1 : 0]     user_dma_axi_st_port1_tx_tdata          ,
    output wire [USER_KEEP_WIDTH-1 : 0]     user_dma_axi_st_port1_tx_tstrb          ,//user_dma_axi_st_port3_tx_tkeep
    input  wire                             user_dma_axi_st_port1_tx_tready         ,
    //---C2H
    input  wire                             user_dma_axi_st_port1_rx_tvalid         ,
    input  wire [4:0]                       user_dma_axi_st_port1_rx_tuser          ,
    input  wire                             user_dma_axi_st_port1_rx_tlast          ,
    input  wire [USER_DMA_AXI_WIDTH-1 : 0]  user_dma_axi_st_port1_rx_tdata          ,
    input  wire [USER_DMA_AXI_STRB-1 : 0]   user_dma_axi_st_port1_rx_tstrb          ,//user_dma_axi_st_port3_rx_tkeep
    output wire                             user_dma_axi_st_port1_rx_tready         ,
    //------USER_DMA_PORT2
    //---H2C
    output wire                             user_dma_axi_st_port2_tx_tvalid         ,
    output wire [3:0]                       user_dma_axi_st_port2_tx_tuser          ,
    output wire                             user_dma_axi_st_port2_tx_tlast          ,
    output wire [USER_DATA_WIDTH-1 : 0]     user_dma_axi_st_port2_tx_tdata          ,
    output wire [USER_KEEP_WIDTH-1 : 0]     user_dma_axi_st_port2_tx_tstrb          ,//user_dma_axi_st_port3_tx_tkeep
    input  wire                             user_dma_axi_st_port2_tx_tready         ,
    //---C2H
    input  wire                             user_dma_axi_st_port2_rx_tvalid         ,
    input  wire [4:0]                       user_dma_axi_st_port2_rx_tuser          ,
    input  wire                             user_dma_axi_st_port2_rx_tlast          ,
    input  wire [USER_DMA_AXI_WIDTH-1 : 0]  user_dma_axi_st_port2_rx_tdata          ,
    input  wire [USER_DMA_AXI_STRB-1 : 0]   user_dma_axi_st_port2_rx_tstrb          ,//user_dma_axi_st_port3_rx_tkeep
    output wire                             user_dma_axi_st_port2_rx_tready         ,
    //------USER_DMA_PORT3
    //---H2C
    output wire                             user_dma_axi_st_port3_tx_tvalid         ,
    output wire [3:0]                       user_dma_axi_st_port3_tx_tuser          ,
    output wire                             user_dma_axi_st_port3_tx_tlast          ,
    output wire [USER_DATA_WIDTH-1 : 0]     user_dma_axi_st_port3_tx_tdata          ,
    output wire [USER_KEEP_WIDTH-1 : 0]     user_dma_axi_st_port3_tx_tstrb          ,//user_dma_axi_st_port3_tx_tkeep
    input  wire                             user_dma_axi_st_port3_tx_tready         ,
    //---C2H
    input  wire                             user_dma_axi_st_port3_rx_tvalid         ,
    input  wire [4:0]                       user_dma_axi_st_port3_rx_tuser          ,
    input  wire                             user_dma_axi_st_port3_rx_tlast          ,
    input  wire [USER_DMA_AXI_WIDTH-1 : 0]  user_dma_axi_st_port3_rx_tdata          ,
    input  wire [USER_DMA_AXI_STRB-1 : 0]   user_dma_axi_st_port3_rx_tstrb          ,//user_dma_axi_st_port3_rx_tkeep
    output wire                             user_dma_axi_st_port3_rx_tready         ,

    //------NATIVE MEM IF      //NC
    output reg                              user_logic_native_mem_valid             ,
    output reg  [63:00]                     user_logic_native_mem_address           ,
    output reg  [255:0]                     user_logic_native_mem_data              ,
    output reg  [31:00]                     user_logic_native_mem_strb              ,

    //------HARDWARE DNA IF    //NC
    output wire [95:00]                     hardware_local_dna                      ,
    //------                   //NC
    output wire                             sys_clk_locked

);

//--------------------------------------------------------------------------------
    //------parameter
    parameter       DATA_HEADER_INIT0       = 32'h5a01_0001                         ;//32'h5a01_0001
    parameter       DATA_HEADER_INIT1       = 32'h5b01_0001                         ;//32'h5b01_0001
    parameter       DATA_HEADER_INIT2       = 32'h5c01_0001                         ;//32'h5c01_0001
    parameter       DATA_HEADER_INIT3       = 32'h5d01_0001                         ;//32'h5d01_0001

    //------DATA Duty Cycle: DATA_DUTY / DATA_LENGTH = xx%
    localparam      LOCAL_DATA_DUTY         = 128                                   ;
    localparam      LOCAL_DATA_LENGTH       = 256                                   ;

    localparam      LOCAL_PORT0_DATA_INIT   = 32'h5a01_0001                         ;
    localparam      LOCAL_PORT1_DATA_INIT   = 32'h5b01_0001                         ;
    localparam      LOCAL_PORT2_DATA_INIT   = 32'h5c01_0001                         ;
    localparam      LOCAL_PORT3_DATA_INIT   = 32'h5d01_0001                         ;

    localparam      PERIOD_1US              = 32'd249                               ;//1us@250MHz
    localparam      PERIOD_100US            = 32'd249_99                            ;//1us@250MHz
    localparam      PERIOD_1MS              = 32'd249_999                           ;//1ms@250MHz

    localparam      PERIOD_100MHZ           = 32'd10_000                            ;//10.000ns = 10_000ps @ 100MHz
    localparam      PERIOD_250MHZ           = 32'd04_000                            ;//04.000ns = 04_000ps @ 250MHz
    localparam      PEIROD_322P6MHZ         = 32'd03_103                            ;//03.103ns = 03_103ps @ 322.26MHz
    localparam      PERIOD_PCIE             = PERIOD_250MHZ                         ;
    localparam      PERIOD_MAC              = PEIROD_322P6MHZ                       ;
//--------------------------------------------------------------------------------
    //------DATA Duty Cycle: DATA_DUTY / DATA_LENGTH = xx%
    real                                    data_duty                               ;
    //------
    initial begin
        data_duty = (real(LOCAL_DATA_DUTY) / real(LOCAL_DATA_LENGTH)) * 100;//real -> 'real

        `ifdef PRINT_ENABLE
            $display("//--------------------------------------------------------------");
            $display("DATA-DUTY-CYCLE(DATA_DUTY/DATA_LENGTH) is: %0f %%.", data_duty);
        `endif

    end
//--------------------------------------------------------------------------------
    //------
    wire                                    sys_clk                                 ;//250MHz
    wire                                    sys_rst_n                               ;
//  wire                                    sys_clk_locked                          ;
    wire                                    axis_clk                                ;//250MHz
    wire                                    axis_rst_n                              ;

    //------
    assign sys_clk          =   axis_clk                                            ;//250MHz
    assign sys_rst_n        =   axis_rst_n                                          ;
    //------
    assign ptp_1588_clk     =   axis_clk                                            ;//250MHz
    assign ptp_1588_rstn    =   axis_rst_n                                          ;
    //------
    assign pcie_axi_clk     =   axis_clk                                            ;//250MHz
    assign pcie_axi_resetn  =   axis_rst_n                                          ;
    assign user_dma_rx_chennel_enable = 16'h1111                                    ;//16'b0001_0001_0001_0001

    assign lightning_mac0_link_status   = (sys_clk_locked)? 1'b1 : 1'b0             ;//1'b1:link up, 1'b0:link down
    assign lightning_mac1_link_status   = (sys_clk_locked)? 1'b1 : 1'b0             ;//1'b1:link up, 1'b0:link down
    assign lightning_mac2_link_status   = (sys_clk_locked)? 1'b1 : 1'b0             ;//1'b1:link up, 1'b0:link down
    assign lightning_mac3_link_status   = (sys_clk_locked)? 1'b1 : 1'b0             ;//1'b1:link up, 1'b0:link down

    assign lightning_mac0_active_status = (lightning_mac0_axi_st_tx_tvalid || lightning_mac0_axi_st_rx_tvalid)? 1'b1 : 1'b0 ;
    assign lightning_mac1_active_status = (lightning_mac1_axi_st_tx_tvalid || lightning_mac1_axi_st_rx_tvalid)? 1'b1 : 1'b0 ;
    assign lightning_mac2_active_status = (lightning_mac2_axi_st_tx_tvalid || lightning_mac2_axi_st_rx_tvalid)? 1'b1 : 1'b0 ;
    assign lightning_mac3_active_status = (lightning_mac3_axi_st_tx_tvalid || lightning_mac3_axi_st_rx_tvalid)? 1'b1 : 1'b0 ;

    assign base_dma0_axi_st_tx_bypass   = 1'b0                                      ;
    assign base_dma1_axi_st_tx_bypass   = 1'b0                                      ;
    //------NC
    assign hardware_local_dna           = 96'h12345678123456781234567A              ;//for more info, please refer to DNA_PORTE2
    //------NC
    always@(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        user_logic_native_mem_valid    <= 1'b0                                      ;
        user_logic_native_mem_address  <= 64'h0                                     ;
        user_logic_native_mem_data     <= 256'h0                                    ;
        user_logic_native_mem_strb     <= 32'h0                                     ;
    end else begin
        user_logic_native_mem_valid    <= user_logic_native_mem_valid               ;
        user_logic_native_mem_address  <= user_logic_native_mem_address             ;
        user_logic_native_mem_data     <= user_logic_native_mem_data                ;
        user_logic_native_mem_strb     <= user_logic_native_mem_strb                ;
    end
    end
//--------------------------------------------------------------------------------
    //------u_axis_top_port0
    axis_top    #(
    //---
    .USER_DMA_AXI_WIDTH                     ( USER_DMA_AXI_WIDTH                    ),
    .USER_DMA_AXI_STRB                      ( USER_DMA_AXI_STRB                     ),
    .PACKET_LOSS_FIFO_DEPTH                 ( PACKET_LOSS_FIFO_DEPTH                ),
    .PACKET_LOSS_FULL_THR                   ( PACKET_LOSS_FULL_THR                  ),
    //---
    .TCQ                                    (0                                      ),//0ns = 0_000ps
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_PCIE                            ),//04.0ns = 04_000ps @ 250MHz
    .HALFCYCLE                              (PERIOD_PCIE /2                         ),//02.0ns = 02_000ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (0                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (64                                     ),//32 64
    .KEEP_WIDTH                             (64 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256
    .DATA_HEADER_INIT                       (DATA_HEADER_INIT0                      ),//32'h5a01_0001 32'h5b01_0001 32'h5c01_0001 32'h5d01_0001
    .FILE_HANDLE_TX                         ("axis_tx_file_port0.txt"               ),
    .FILE_HANDLE_RX                         ("axis_rx_file_port0.txt"               )

    )    u_axis_top_port0 (
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_clk                               (axis_clk                               ),//O
    .axis_rst_n                             (axis_rst_n                             ),//O
    //---H2C
    .axis_tx_tready                         (1'b1),//(user_dma_axi_st_port0_tx_tready        ),//I
    .axis_tx_tvalid                         (user_dma_axi_st_port0_tx_tvalid        ),//O
    .axis_tx_tdata                          (user_dma_axi_st_port0_tx_tdata         ),//O    [DATA_WIDTH-1 : 0]
    .axis_tx_tuser                          (user_dma_axi_st_port0_tx_tuser         ),//O    [USER_WIDTH-1 : 0]
    .axis_tx_tkeep                          (user_dma_axi_st_port0_tx_tstrb         ),//O    [KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [KEEP_WIDTH-1 : 0]
    .axis_tx_tlast                          (user_dma_axi_st_port0_tx_tlast         ),//O
    //---C2H
    .axis_rx_tready                         (user_dma_axi_st_port0_rx_tready        ),//O
    .axis_rx_tvalid                         (user_dma_axi_st_port0_rx_tvalid        ),//I
    .axis_rx_tdata                          (user_dma_axi_st_port0_rx_tdata         ),//I    [DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (user_dma_axi_st_port0_rx_tuser         ),//I    [USER_WIDTH-1 : 0]
    .axis_rx_tkeep                          (user_dma_axi_st_port0_rx_tstrb         ),//I    [KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [KEEP_WIDTH-1 : 0]
    .axis_rx_tlast                          (user_dma_axi_st_port0_rx_tlast         ),//I
    //---
    .sys_clk_locked                         (sys_clk_locked                         ) //O

    );
    //------u_axis_top_port1
    axis_top    #(
    //---
    .USER_DMA_AXI_WIDTH                     ( USER_DMA_AXI_WIDTH                    ),
    .USER_DMA_AXI_STRB                      ( USER_DMA_AXI_STRB                     ),
    .PACKET_LOSS_FIFO_DEPTH                 ( PACKET_LOSS_FIFO_DEPTH                ),
    .PACKET_LOSS_FULL_THR                   ( PACKET_LOSS_FULL_THR                  ),
    //---
    .TCQ                                    (0                                      ),//0ns = 0_000ps
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_PCIE                            ),//04.0ns = 04_000ps @ 250MHz
    .HALFCYCLE                              (PERIOD_PCIE /2                         ),//02.0ns = 02_000ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (1                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (64                                     ),//32 64
    .KEEP_WIDTH                             (64 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256
    .DATA_HEADER_INIT                       (DATA_HEADER_INIT1                      ),//32'h5a01_0001 32'h5b01_0001 32'h5c01_0001 32'h5d01_0001
    .FILE_HANDLE_TX                         ("axis_tx_file_port1.txt"               ),
    .FILE_HANDLE_RX                         ("axis_rx_file_port1.txt"               )

    )    u_axis_top_port1 (
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_clk                               (),//(axis_clk                          ),//O
    .axis_rst_n                             (),//(axis_rst_n                        ),//O
    //---H2C
    .axis_tx_tready                         (1'b1),//(user_dma_axi_st_port1_tx_tready        ),//I
    .axis_tx_tvalid                         (user_dma_axi_st_port1_tx_tvalid        ),//O
    .axis_tx_tdata                          (user_dma_axi_st_port1_tx_tdata         ),//O    [DATA_WIDTH-1 : 0]
    .axis_tx_tuser                          (user_dma_axi_st_port1_tx_tuser         ),//O    [USER_WIDTH-1 : 0]
    .axis_tx_tkeep                          (user_dma_axi_st_port1_tx_tstrb         ),//O    [KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [KEEP_WIDTH-1 : 0]
    .axis_tx_tlast                          (user_dma_axi_st_port1_tx_tlast         ),//O
    //---C2H
    .axis_rx_tready                         (user_dma_axi_st_port1_rx_tready        ),//O
    .axis_rx_tvalid                         (user_dma_axi_st_port1_rx_tvalid        ),//I
    .axis_rx_tdata                          (user_dma_axi_st_port1_rx_tdata         ),//I    [DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (user_dma_axi_st_port1_rx_tuser         ),//I    [USER_WIDTH-1 : 0]
    .axis_rx_tkeep                          (user_dma_axi_st_port1_rx_tstrb         ),//I    [KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [KEEP_WIDTH-1 : 0]
    .axis_rx_tlast                          (user_dma_axi_st_port1_rx_tlast         ),//I
    //---
    .sys_clk_locked                         (                                       ) //O

    );
    //------u_axis_top_port2
    axis_top    #(
    //---
    .USER_DMA_AXI_WIDTH                     ( USER_DMA_AXI_WIDTH                    ),
    .USER_DMA_AXI_STRB                      ( USER_DMA_AXI_STRB                     ),
    .PACKET_LOSS_FIFO_DEPTH                 ( PACKET_LOSS_FIFO_DEPTH                ),
    .PACKET_LOSS_FULL_THR                   ( PACKET_LOSS_FULL_THR                  ),
    //---
    .TCQ                                    (0                                      ),//0ns = 0_000ps
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_PCIE                            ),//04.0ns = 04_000ps @ 250MHz
    .HALFCYCLE                              (PERIOD_PCIE /2                         ),//02.0ns = 02_000ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (1                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (64                                     ),//32 64
    .KEEP_WIDTH                             (64 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256
    .DATA_HEADER_INIT                       (DATA_HEADER_INIT2                      ),//32'h5a01_0001 32'h5b01_0001 32'h5c01_0001 32'h5d01_0001
    .FILE_HANDLE_TX                         ("axis_tx_file_port2.txt"               ),
    .FILE_HANDLE_RX                         ("axis_rx_file_port2.txt"               )

    )    u_axis_top_port2 (
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_clk                               (),//(axis_clk                          ),//O
    .axis_rst_n                             (),//(axis_rst_n                        ),//O
    //---H2C
    .axis_tx_tready                         (1'b1),//(user_dma_axi_st_port2_tx_tready        ),//I
    .axis_tx_tvalid                         (user_dma_axi_st_port2_tx_tvalid        ),//O
    .axis_tx_tdata                          (user_dma_axi_st_port2_tx_tdata         ),//O    [DATA_WIDTH-1 : 0]
    .axis_tx_tuser                          (user_dma_axi_st_port2_tx_tuser         ),//O    [USER_WIDTH-1 : 0]
    .axis_tx_tkeep                          (user_dma_axi_st_port2_tx_tstrb         ),//O    [KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [KEEP_WIDTH-1 : 0]
    .axis_tx_tlast                          (user_dma_axi_st_port2_tx_tlast         ),//O
    //---C2H
    .axis_rx_tready                         (user_dma_axi_st_port2_rx_tready        ),//O
    .axis_rx_tvalid                         (user_dma_axi_st_port2_rx_tvalid        ),//I
    .axis_rx_tdata                          (user_dma_axi_st_port2_rx_tdata         ),//I    [DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (user_dma_axi_st_port2_rx_tuser         ),//I    [USER_WIDTH-1 : 0]
    .axis_rx_tkeep                          (user_dma_axi_st_port2_rx_tstrb         ),//I    [KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [KEEP_WIDTH-1 : 0]
    .axis_rx_tlast                          (user_dma_axi_st_port2_rx_tlast         ),//I
    //---
    .sys_clk_locked                         (                                       ) //O

    );
    //------u_axis_top_port3
    axis_top    #(
    //---
    .USER_DMA_AXI_WIDTH                     ( USER_DMA_AXI_WIDTH                    ),
    .USER_DMA_AXI_STRB                      ( USER_DMA_AXI_STRB                     ),
    .PACKET_LOSS_FIFO_DEPTH                 ( PACKET_LOSS_FIFO_DEPTH                ),
    .PACKET_LOSS_FULL_THR                   ( PACKET_LOSS_FULL_THR                  ),
    //---
    .TCQ                                    (0                                      ),//0ns = 0_000ps
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_PCIE                            ),//04.0ns = 04_000ps @ 250MHz
    .HALFCYCLE                              (PERIOD_PCIE /2                         ),//02.0ns = 02_000ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (1                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (64                                     ),//32 64
    .KEEP_WIDTH                             (64 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256
    .DATA_HEADER_INIT                       (DATA_HEADER_INIT3                      ),//32'h5a01_0001 32'h5b01_0001 32'h5c01_0001 32'h5d01_0001
    .FILE_HANDLE_TX                         ("axis_tx_file_port3.txt"               ),
    .FILE_HANDLE_RX                         ("axis_rx_file_port3.txt"               )

    )    u_axis_top_port3 (
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_clk                               (),//(axis_clk                          ),//O
    .axis_rst_n                             (),//(axis_rst_n                        ),//O
    //---H2C
    .axis_tx_tready                         (1'b1),//(user_dma_axi_st_port3_tx_tready        ),//I
    .axis_tx_tvalid                         (user_dma_axi_st_port3_tx_tvalid        ),//O
    .axis_tx_tdata                          (user_dma_axi_st_port3_tx_tdata         ),//O    [DATA_WIDTH-1 : 0]
    .axis_tx_tuser                          (user_dma_axi_st_port3_tx_tuser         ),//O    [USER_WIDTH-1 : 0]
    .axis_tx_tkeep                          (user_dma_axi_st_port3_tx_tstrb         ),//O    [KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [KEEP_WIDTH-1 : 0]
    .axis_tx_tlast                          (user_dma_axi_st_port3_tx_tlast         ),//O
    //---C2H
    .axis_rx_tready                         (user_dma_axi_st_port3_rx_tready        ),//O
    .axis_rx_tvalid                         (user_dma_axi_st_port3_rx_tvalid        ),//I
    .axis_rx_tdata                          (user_dma_axi_st_port3_rx_tdata         ),//I    [DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (user_dma_axi_st_port3_rx_tuser         ),//I    [USER_WIDTH-1 : 0]
    .axis_rx_tkeep                          (user_dma_axi_st_port3_rx_tstrb         ),//I    [KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [KEEP_WIDTH-1 : 0]
    .axis_rx_tlast                          (user_dma_axi_st_port3_rx_tlast         ),//I
    //---
    .sys_clk_locked                         (                                       ) //O

    );
//--------------------------------------------------------------------------------Hardware_Timestamp
    //------loc_time_1s_hw: reset with pcie_axi_aresetn.
    wire                    wd_reset_n                          ;
    wire [31:00]            loc_time_1ms_sw                     ;
    wire [31:00]            loc_time_1s_sw                      ;
    wire [31:00]            loc_time_1ms_hw                     ;
    wire [31:00]            loc_time_1s_hw                      ;
    
    assign wd_reset_n = 1'b1;
    
    hw_time u_loc_hw_time(
    //---
    .sys_clk                                ( sys_clk                               ),//I 250MHz
    .sys_rstn                               ( sys_rst_n                             ),//I
    //---SW heart-beat
    .wd_reset_n                             ( wd_reset_n                            ),//I
    .loc_time_1ms_sw                        ( loc_time_1ms_sw                       ),//O
    .loc_time_1s_sw                         ( loc_time_1s_sw                        ),//O
    //---HW heart-beat
    .loc_time_1ms_hw                        ( loc_time_1ms_hw                       ),//O
    .loc_time_1s_hw                         ( loc_time_1s_hw                        ) //O
    );

//--------------------------------------------------------------------------------
    parameter       BASE0_DST_MAC_ADDR          = 48'h00_23_cd_76_63_1a             ;
    parameter       BASE0_SRC_MAC_ADDR          = 48'h00_23_cd_76_63_1b             ;
    parameter       BASE0_ETH_TYPE_LENGTH       = 16'h08_00                         ;
    parameter       BASE0_IP_VERSION            =  4'h4                             ;
    parameter       BASE0_IP_HEADER_LENGTH      =  4'h5                             ;
    parameter       BASE0_IP_SERVICE_TYPE       =  8'h00                            ;
    parameter       BASE0_IP_TOTAL_LENGTH       = 16'h003a                          ;
    parameter       BASE0_IP_IDENTIFIER         = 16'h0001                          ;
    parameter       BASE0_IP_FLAG               =  8'h00                            ;
    parameter       BASE0_IP_OFFSET             =  8'h00                            ;
    parameter       BASE0_IP_TTL                =  8'h40                            ;
    parameter       BASE0_IP_PROTOCOL           =  8'h11                            ;//UDP
    parameter       BASE0_IP_HEADER_CHECK_SUM   = 16'hf635                          ;
    parameter       BASE0_IP_SRC_IP             = 32'hc0_a8_01_64                   ;//192.168.1.100
    parameter       BASE0_IP_DST_IP             = 32'hc0_a8_01_c8                   ;//192.168.1.200
    parameter       BASE0_UDP_SRC_PORT          = 16'h03_e8                         ;//1000
    parameter       BASE0_UDP_DST_PORT          = 16'h07_d0                         ;//2000
    parameter       BASE0_UDP_LENGTH            = 16'h00_26                         ;
    parameter       BASE0_UDP_CHECKSUM          = 16'h15_04                         ;

    parameter       BASE1_DST_MAC_ADDR          = 48'h00_23_cd_76_63_1b             ;
    parameter       BASE1_SRC_MAC_ADDR          = 48'h00_23_cd_76_63_1a             ;
    parameter       BASE1_ETH_TYPE_LENGTH       = 16'h08_00                         ;
    parameter       BASE1_IP_VERSION            =  4'h4                             ;
    parameter       BASE1_IP_HEADER_LENGTH      =  4'h5                             ;
    parameter       BASE1_IP_SERVICE_TYPE       =  8'h00                            ;
    parameter       BASE1_IP_TOTAL_LENGTH       = 16'h003a                          ;
    parameter       BASE1_IP_IDENTIFIER         = 16'h0001                          ;
    parameter       BASE1_IP_FLAG               =  8'h00                            ;
    parameter       BASE1_IP_OFFSET             =  8'h00                            ;
    parameter       BASE1_IP_TTL                =  8'h40                            ;
    parameter       BASE1_IP_PROTOCOL           =  8'h11                            ;//UDP
    parameter       BASE1_IP_HEADER_CHECK_SUM   = 16'hf635                          ;
    parameter       BASE1_IP_SRC_IP             = 32'hc0_a8_01_c8                   ;//192.168.1.200
    parameter       BASE1_IP_DST_IP             = 32'hc0_a8_01_64                   ;//192.168.1.100
    parameter       BASE1_UDP_SRC_PORT          = 16'h03_e8                         ;//1000
    parameter       BASE1_UDP_DST_PORT          = 16'h07_d0                         ;//2000
    parameter       BASE1_UDP_LENGTH            = 16'h00_26                         ;
    parameter       BASE1_UDP_CHECKSUM          = 16'h2d_33                         ;

    assign base_dma0_rx_channel_enable          =  4'h0                             ;//set 0 if NC
    assign base_dma1_rx_channel_enable          =  4'h0                             ;//set 0 if NC
    
    parameter       MAC_TCQ                     = 10                                ;//0.010ns = 0_010ps    MAC_TCQ should large than 0.000ns/0_000ps.
    parameter       MAC0_TCQ                    = MAC_TCQ                           ;//0.010ns = 0_010ps
    parameter       MAC1_TCQ                    = MAC_TCQ                           ;//0.010ns = 0_010ps    
    parameter       MAC2_TCQ                    = MAC_TCQ                           ;//0.010ns = 0_010ps
    parameter       MAC3_TCQ                    = MAC_TCQ                           ;//0.010ns = 0_010ps
    //------BASE_DMA_PORT0
    eth_top    #(
    .TCQ                                    (0                                      ),//0ns = 0_000ps
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_PCIE                            ),//04.0ns = 04_000ps @ 250MHz
    .HALFCYCLE                              (PERIOD_PCIE /2                         ),//02.0ns = 02_000ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (1                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (32                                     ),//32 64
    .KEEP_WIDTH                             (32 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256

    .DST_MAC_ADDR                           (BASE0_DST_MAC_ADDR                     ),
    .SRC_MAC_ADDR                           (BASE0_SRC_MAC_ADDR                     ),
    .ETH_TYPE_LENGTH                        (BASE0_ETH_TYPE_LENGTH                  ),
    .IP_VERSION                             (BASE0_IP_VERSION                       ),
    .IP_HEADER_LENGTH                       (BASE0_IP_HEADER_LENGTH                 ),
    .IP_SERVICE_TYPE                        (BASE0_IP_SERVICE_TYPE                  ),
    .IP_TOTAL_LENGTH                        (BASE0_IP_TOTAL_LENGTH                  ),
    .IP_IDENTIFIER                          (BASE0_IP_IDENTIFIER                    ),
    .IP_FLAG                                (BASE0_IP_FLAG                          ),
    .IP_OFFSET                              (BASE0_IP_OFFSET                        ),
    .IP_TTL                                 (BASE0_IP_TTL                           ),
    .IP_PROTOCOL                            (BASE0_IP_PROTOCOL                      ),
    .IP_HEADER_CHECK_SUM                    (BASE0_IP_HEADER_CHECK_SUM              ),
    .IP_SRC_IP                              (BASE0_IP_SRC_IP                        ),
    .IP_DST_IP                              (BASE0_IP_DST_IP                        ),
    .UDP_SRC_PORT                           (BASE0_UDP_SRC_PORT                     ),
    .UDP_DST_PORT                           (BASE0_UDP_DST_PORT                     ),
    .UDP_LENGTH                             (BASE0_UDP_LENGTH                       ),
    .UDP_CHECKSUM                           (BASE0_UDP_CHECKSUM                     ),

    .FILE_HANDLE_TX                         ("eth_tx_file_base0.txt"                ),
    .FILE_HANDLE_RX                         ("eth_rx_file_base0.txt"                )
    
    )    u_base_dma0 (
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_clk                               (),//(axis_clk                          ),//O
    .axis_rst_n                             (),//(axis_rst_n                        ),//O
    //---H2C
    .axis_tx_tready                         (base_dma0_axi_st_tx_tready             ),//I  Only 1'b1    //(1'b1),//
    .axis_tx_tvalid                         (base_dma0_axi_st_tx_tvalid             ),//O
    .axis_tx_tdata                          (base_dma0_axi_st_tx_tdata              ),//O    [DATA_WIDTH-1 : 0]
//  .axis_tx_tuser                          (base_dma0_axi_st_tx_tuser              ),//O    [USER_WIDTH-1 : 0] NC
    .axis_tx_tkeep                          (base_dma0_axi_st_tx_tkeep              ),//O    [KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [KEEP_WIDTH-1 : 0]
    .axis_tx_tlast                          (base_dma0_axi_st_tx_tlast              ),//O
    //---C2H
    .axis_rx_tready                         (base_dma0_axi_st_rx_tready             ),//O
    .axis_rx_tvalid                         (base_dma0_axi_st_rx_tvalid             ),//I
    .axis_rx_tdata                          (base_dma0_axi_st_rx_tdata              ),//I    [DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (base_dma0_axi_st_rx_tuser              ),//I    [USER_WIDTH-1 : 0]
    .axis_rx_tkeep                          (base_dma0_axi_st_rx_tkeep              ),//I    [KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [KEEP_WIDTH-1 : 0]
    .axis_rx_tlast                          (base_dma0_axi_st_rx_tlast              ),//I
    //---
    .sys_clk_locked                         (                                       ) //O
    
    );
    
    //------BASE_DMA_PORT1
    eth_top    #(
    .TCQ                                    (0                                      ),//0ns = 0_000ps
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_PCIE                            ),//04.0ns = 04_000ps @ 250MHz
    .HALFCYCLE                              (PERIOD_PCIE /2                         ),//02.0ns = 02_000ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (1                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (32                                     ),//32 64
    .KEEP_WIDTH                             (32 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256

    .DST_MAC_ADDR                           (BASE1_DST_MAC_ADDR                     ),
    .SRC_MAC_ADDR                           (BASE1_SRC_MAC_ADDR                     ),
    .ETH_TYPE_LENGTH                        (BASE1_ETH_TYPE_LENGTH                  ),
    .IP_VERSION                             (BASE1_IP_VERSION                       ),
    .IP_HEADER_LENGTH                       (BASE1_IP_HEADER_LENGTH                 ),
    .IP_SERVICE_TYPE                        (BASE1_IP_SERVICE_TYPE                  ),
    .IP_TOTAL_LENGTH                        (BASE1_IP_TOTAL_LENGTH                  ),
    .IP_IDENTIFIER                          (BASE1_IP_IDENTIFIER                    ),
    .IP_FLAG                                (BASE1_IP_FLAG                          ),
    .IP_OFFSET                              (BASE1_IP_OFFSET                        ),
    .IP_TTL                                 (BASE1_IP_TTL                           ),
    .IP_PROTOCOL                            (BASE1_IP_PROTOCOL                      ),
    .IP_HEADER_CHECK_SUM                    (BASE1_IP_HEADER_CHECK_SUM              ),
    .IP_SRC_IP                              (BASE1_IP_SRC_IP                        ),
    .IP_DST_IP                              (BASE1_IP_DST_IP                        ),
    .UDP_SRC_PORT                           (BASE1_UDP_SRC_PORT                     ),
    .UDP_DST_PORT                           (BASE1_UDP_DST_PORT                     ),
    .UDP_LENGTH                             (BASE1_UDP_LENGTH                       ),
    .UDP_CHECKSUM                           (BASE1_UDP_CHECKSUM                     ),

    .FILE_HANDLE_TX                         ("eth_tx_file_base1.txt"                ),
    .FILE_HANDLE_RX                         ("eth_rx_file_base1.txt"                )
    
    )    u_base_dma1 (
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_clk                               (),//(axis_clk                          ),//O
    .axis_rst_n                             (),//(axis_rst_n                        ),//O
    //---H2C
    .axis_tx_tready                         (base_dma1_axi_st_tx_tready             ),//I  Only 1'b1    //(1'b1),//
    .axis_tx_tvalid                         (base_dma1_axi_st_tx_tvalid             ),//O
    .axis_tx_tdata                          (base_dma1_axi_st_tx_tdata              ),//O    [DATA_WIDTH-1 : 0]
//  .axis_tx_tuser                          (base_dma1_axi_st_tx_tuser              ),//O    [USER_WIDTH-1 : 0] NC
    .axis_tx_tkeep                          (base_dma1_axi_st_tx_tkeep              ),//O    [KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [KEEP_WIDTH-1 : 0]
    .axis_tx_tlast                          (base_dma1_axi_st_tx_tlast              ),//O
    //---C2H
    .axis_rx_tready                         (base_dma1_axi_st_rx_tready             ),//O
    .axis_rx_tvalid                         (base_dma1_axi_st_rx_tvalid             ),//I
    .axis_rx_tdata                          (base_dma1_axi_st_rx_tdata              ),//I    [DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (base_dma1_axi_st_rx_tuser              ),//I    [USER_WIDTH-1 : 0]
    .axis_rx_tkeep                          (base_dma1_axi_st_rx_tkeep              ),//I    [KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [KEEP_WIDTH-1 : 0]
    .axis_rx_tlast                          (base_dma1_axi_st_rx_tlast              ),//I
    //---
    .sys_clk_locked                         (                                       ) //O
    
    );

//--------------------------------------------------------------------------------MAC_AXI-STREAM_IF
    //------MAC0
    mac_top    #(
    .TCQ                                    (MAC0_TCQ                               ),//0.010ns = 0_010ps    MAC_TCQ should large than 0.000ns/0_000ps.
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_MAC                             ),//03.103ns = 03_103ps @ 322.26MHz
    .HALFCYCLE                              (PERIOD_MAC /2                          ),//01.551ns = 01_551ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (0                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (32                                     ),//32 64
    .KEEP_WIDTH                             (32 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256

    .DST_MAC_ADDR                           (BASE1_DST_MAC_ADDR                     ),
    .SRC_MAC_ADDR                           (BASE1_SRC_MAC_ADDR                     ),
    .ETH_TYPE_LENGTH                        (BASE1_ETH_TYPE_LENGTH                  ),
    .IP_VERSION                             (BASE1_IP_VERSION                       ),
    .IP_HEADER_LENGTH                       (BASE1_IP_HEADER_LENGTH                 ),
    .IP_SERVICE_TYPE                        (BASE1_IP_SERVICE_TYPE                  ),
    .IP_TOTAL_LENGTH                        (BASE1_IP_TOTAL_LENGTH                  ),
    .IP_IDENTIFIER                          (BASE1_IP_IDENTIFIER                    ),
    .IP_FLAG                                (BASE1_IP_FLAG                          ),
    .IP_OFFSET                              (BASE1_IP_OFFSET                        ),
    .IP_TTL                                 (BASE1_IP_TTL                           ),
    .IP_PROTOCOL                            (BASE1_IP_PROTOCOL                      ),
    .IP_HEADER_CHECK_SUM                    (BASE1_IP_HEADER_CHECK_SUM              ),
    .IP_SRC_IP                              (BASE1_IP_SRC_IP                        ),
    .IP_DST_IP                              (BASE1_IP_DST_IP                        ),
    .UDP_SRC_PORT                           (BASE1_UDP_SRC_PORT                     ),
    .UDP_DST_PORT                           (BASE1_UDP_DST_PORT                     ),
    .UDP_LENGTH                             (BASE1_UDP_LENGTH                       ),
    .UDP_CHECKSUM                           (BASE1_UDP_CHECKSUM                     ),

    .FILE_HANDLE_TX                         ("mac0_tx_file.txt"                     ),
    .FILE_HANDLE_RX                         ("mac0_rx_file.txt"                     )
    
    )    u_mac0_top (
    
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_enable                            (lightning_mac0_enable                  ),//I
    .axis_loopback                          (lightning_mac0_loopback                ),//I
    //---
    .axis_clk                               (),//(axis_clk                          ),//O
    .axis_rst_n                             (),//(axis_rst_n                        ),//O
    //---
    .axis_tx_clk                            (mac0rx_user_clk                        ),//O
    .axis_tx_rst_n                          (mac0rx_user_resetn                     ),//O
    .axis_rx_clk                            (mac0tx_user_clk                        ),//O
    .axis_rx_rst_n                          (mac0tx_user_resetn                     ),//O
    //---MAC-0 TX AXI-STREAM    （C2P: Card to Peripheral）
    .axis_tx_tready                         (1'b1),//(lightning_mac0_axi_st_rx_tready        ),//I  Only 1'b1 @MAC    //(1'b1),//
    .axis_tx_tvalid                         (lightning_mac0_axi_st_rx_tvalid        ),//O
    .axis_tx_tdata                          (lightning_mac0_axi_st_rx_tdata         ),//O    [MAC_DATA_WIDTH-1 : 0]
    .axis_tx_tuser                          (lightning_mac0_axi_st_rx_tuser         ),//O    [MAC_USER_WIDTH-1 : 0]
    .axis_tx_tkeep                          (lightning_mac0_axi_st_rx_tstrb         ),//O    [MAC_KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [MAC_KEEP_WIDTH-1 : 0] NC
    .axis_tx_tlast                          (lightning_mac0_axi_st_rx_tlast         ),//O
    //---MAC-0 RX AXI-STREAM    （P2C: Peripheral to Card)
    .axis_rx_tready                         (lightning_mac0_axi_st_tx_tready        ),//O
    .axis_rx_tvalid                         (lightning_mac0_axi_st_tx_tvalid        ),//I
    .axis_rx_tdata                          (lightning_mac0_axi_st_tx_tdata         ),//I    [MAC_DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (lightning_mac0_axi_st_tx_tuser         ),//I    [MAC_USER_WIDTH-1 : 0] 1bit
    .axis_rx_tkeep                          (lightning_mac0_axi_st_tx_tstrb         ),//I    [MAC_KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [MAC_KEEP_WIDTH-1 : 0] NC
    .axis_rx_tlast                          (lightning_mac0_axi_st_tx_tlast         ),//I
    //---
    .sys_clk_locked                         (                                       ) //O
    
    );
    
    //------MAC1
    mac_top    #(
    .TCQ                                    (MAC1_TCQ                               ),//0.010ns = 0_010ps    MAC_TCQ should large than 0.000ns/0_000ps.
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_MAC                             ),//03.103ns = 03_103ps @ 322.26MHz
    .HALFCYCLE                              (PERIOD_MAC /2                          ),//01.551ns = 01_551ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (0                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (32                                     ),//32 64
    .KEEP_WIDTH                             (32 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256

    .DST_MAC_ADDR                           (BASE0_DST_MAC_ADDR                     ),
    .SRC_MAC_ADDR                           (BASE0_SRC_MAC_ADDR                     ),
    .ETH_TYPE_LENGTH                        (BASE0_ETH_TYPE_LENGTH                  ),
    .IP_VERSION                             (BASE0_IP_VERSION                       ),
    .IP_HEADER_LENGTH                       (BASE0_IP_HEADER_LENGTH                 ),
    .IP_SERVICE_TYPE                        (BASE0_IP_SERVICE_TYPE                  ),
    .IP_TOTAL_LENGTH                        (BASE0_IP_TOTAL_LENGTH                  ),
    .IP_IDENTIFIER                          (BASE0_IP_IDENTIFIER                    ),
    .IP_FLAG                                (BASE0_IP_FLAG                          ),
    .IP_OFFSET                              (BASE0_IP_OFFSET                        ),
    .IP_TTL                                 (BASE0_IP_TTL                           ),
    .IP_PROTOCOL                            (BASE0_IP_PROTOCOL                      ),
    .IP_HEADER_CHECK_SUM                    (BASE0_IP_HEADER_CHECK_SUM              ),
    .IP_SRC_IP                              (BASE0_IP_SRC_IP                        ),
    .IP_DST_IP                              (BASE0_IP_DST_IP                        ),
    .UDP_SRC_PORT                           (BASE0_UDP_SRC_PORT                     ),
    .UDP_DST_PORT                           (BASE0_UDP_DST_PORT                     ),
    .UDP_LENGTH                             (BASE0_UDP_LENGTH                       ),
    .UDP_CHECKSUM                           (BASE0_UDP_CHECKSUM                     ),

    .FILE_HANDLE_TX                         ("mac1_tx_file.txt"                     ),
    .FILE_HANDLE_RX                         ("mac1_rx_file.txt"                     )
    
    )    u_mac1_top (
    
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_enable                            (lightning_mac1_enable                  ),//I
    .axis_loopback                          (lightning_mac1_loopback                ),//I
    //---
    .axis_clk                               (),//(axis_clk                          ),//O
    .axis_rst_n                             (),//(axis_rst_n                        ),//O
    //---
    .axis_tx_clk                            (mac1rx_user_clk                        ),//O
    .axis_tx_rst_n                          (mac1rx_user_resetn                     ),//O
    .axis_rx_clk                            (mac1tx_user_clk                        ),//O
    .axis_rx_rst_n                          (mac1tx_user_resetn                     ),//O
    //---MAC-1 TX AXI-STREAM    （C2P: Card to Peripheral）
    .axis_tx_tready                         (1'b1),//(lightning_mac1_axi_st_rx_tready        ),//I  Only 1'b1 @MAC   //(1'b1),//
    .axis_tx_tvalid                         (lightning_mac1_axi_st_rx_tvalid        ),//O
    .axis_tx_tdata                          (lightning_mac1_axi_st_rx_tdata         ),//O    [MAC_DATA_WIDTH-1 : 0]
    .axis_tx_tuser                          (lightning_mac1_axi_st_rx_tuser         ),//O    [MAC_USER_WIDTH-1 : 0]
    .axis_tx_tkeep                          (lightning_mac1_axi_st_rx_tstrb         ),//O    [MAC_KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [MAC_KEEP_WIDTH-1 : 0] NC
    .axis_tx_tlast                          (lightning_mac1_axi_st_rx_tlast         ),//O
    //---MAC-1 RX AXI-STREAM    （P2C: Peripheral to Card)
    .axis_rx_tready                         (lightning_mac1_axi_st_tx_tready        ),//O
    .axis_rx_tvalid                         (lightning_mac1_axi_st_tx_tvalid        ),//I
    .axis_rx_tdata                          (lightning_mac1_axi_st_tx_tdata         ),//I    [MAC_DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (lightning_mac1_axi_st_tx_tuser         ),//I    [MAC_USER_WIDTH-1 : 0] 1bit
    .axis_rx_tkeep                          (lightning_mac1_axi_st_tx_tstrb         ),//I    [MAC_KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [MAC_KEEP_WIDTH-1 : 0] NC
    .axis_rx_tlast                          (lightning_mac1_axi_st_tx_tlast         ),//I
    //---
    .sys_clk_locked                         (                                       ) //O
    
    );
    
    //------MAC2
    mac_top    #(
    .TCQ                                    (MAC2_TCQ                               ),//0.010ns = 0_010ps    MAC_TCQ should large than 0.000ns/0_000ps.
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_MAC                             ),//03.103ns = 03_103ps @ 322.26MHz
    .HALFCYCLE                              (PERIOD_MAC /2                          ),//01.551ns = 01_551ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (0                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (32                                     ),//32 64
    .KEEP_WIDTH                             (32 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256

    .DST_MAC_ADDR                           (BASE1_DST_MAC_ADDR                     ),
    .SRC_MAC_ADDR                           (BASE1_SRC_MAC_ADDR                     ),
    .ETH_TYPE_LENGTH                        (BASE1_ETH_TYPE_LENGTH                  ),
    .IP_VERSION                             (BASE1_IP_VERSION                       ),
    .IP_HEADER_LENGTH                       (BASE1_IP_HEADER_LENGTH                 ),
    .IP_SERVICE_TYPE                        (BASE1_IP_SERVICE_TYPE                  ),
    .IP_TOTAL_LENGTH                        (BASE1_IP_TOTAL_LENGTH                  ),
    .IP_IDENTIFIER                          (BASE1_IP_IDENTIFIER                    ),
    .IP_FLAG                                (BASE1_IP_FLAG                          ),
    .IP_OFFSET                              (BASE1_IP_OFFSET                        ),
    .IP_TTL                                 (BASE1_IP_TTL                           ),
    .IP_PROTOCOL                            (BASE1_IP_PROTOCOL                      ),
    .IP_HEADER_CHECK_SUM                    (BASE1_IP_HEADER_CHECK_SUM              ),
    .IP_SRC_IP                              (BASE1_IP_SRC_IP                        ),
    .IP_DST_IP                              (BASE1_IP_DST_IP                        ),
    .UDP_SRC_PORT                           (BASE1_UDP_SRC_PORT                     ),
    .UDP_DST_PORT                           (BASE1_UDP_DST_PORT                     ),
    .UDP_LENGTH                             (BASE1_UDP_LENGTH                       ),
    .UDP_CHECKSUM                           (BASE1_UDP_CHECKSUM                     ),

    .FILE_HANDLE_TX                         ("mac2_tx_file.txt"                     ),
    .FILE_HANDLE_RX                         ("mac2_rx_file.txt"                     )
    
    )    u_mac2_top (
    
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_enable                            (lightning_mac2_enable                  ),//I
    .axis_loopback                          (lightning_mac2_loopback                ),//I
    //---
    .axis_clk                               (),//(axis_clk                          ),//O
    .axis_rst_n                             (),//(axis_rst_n                        ),//O
    //---
    .axis_tx_clk                            (mac2rx_user_clk                        ),//O
    .axis_tx_rst_n                          (mac2rx_user_resetn                     ),//O
    .axis_rx_clk                            (mac2tx_user_clk                        ),//O
    .axis_rx_rst_n                          (mac2tx_user_resetn                     ),//O
    //---MAC-2 TX AXI-STREAM    （C2P: Card to Peripheral）
    .axis_tx_tready                         (1'b1),//(lightning_mac2_axi_st_rx_tready        ),//I  Only 1'b1 @MAC    //(1'b1),//
    .axis_tx_tvalid                         (lightning_mac2_axi_st_rx_tvalid        ),//O
    .axis_tx_tdata                          (lightning_mac2_axi_st_rx_tdata         ),//O    [MAC_DATA_WIDTH-1 : 0]
    .axis_tx_tuser                          (lightning_mac2_axi_st_rx_tuser         ),//O    [MAC_USER_WIDTH-1 : 0]
    .axis_tx_tkeep                          (lightning_mac2_axi_st_rx_tstrb         ),//O    [MAC_KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [MAC_KEEP_WIDTH-1 : 0] NC
    .axis_tx_tlast                          (lightning_mac2_axi_st_rx_tlast         ),//O
    //---MAC-2 RX AXI-STREAM    （P2C: Peripheral to Card)
    .axis_rx_tready                         (lightning_mac2_axi_st_tx_tready        ),//O
    .axis_rx_tvalid                         (lightning_mac2_axi_st_tx_tvalid        ),//I
    .axis_rx_tdata                          (lightning_mac2_axi_st_tx_tdata         ),//I    [MAC_DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (lightning_mac2_axi_st_tx_tuser         ),//I    [MAC_USER_WIDTH-1 : 0] 1bit
    .axis_rx_tkeep                          (lightning_mac2_axi_st_tx_tstrb         ),//I    [MAC_KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [MAC_KEEP_WIDTH-1 : 0] NC
    .axis_rx_tlast                          (lightning_mac2_axi_st_tx_tlast         ),//I
    //---
    .sys_clk_locked                         (                                       ) //O
    
    );
    
    //------MAC3
    mac_top    #(
    .TCQ                                    (MAC3_TCQ                               ),//0.010ns = 0_010ps    MAC_TCQ should large than 0.000ns/0_000ps.
    .OFFSET                                 (0                                      ),//used for keep the sys_clk_reg = 0 at the beginning.
    .PERIOD                                 (PERIOD_MAC                             ),//03.103ns = 03_103ps @ 322.26MHz
    .HALFCYCLE                              (PERIOD_MAC /2                          ),//01.551ns = 01_551ps

    .WORK_MODE                              (0                                      ),//0:global, 1:local   //NC
    .CLOCK_MODE                             (0                                      ),//0:master, 1:slave
    .DATA_WIDTH                             (32                                     ),//32 64
    .KEEP_WIDTH                             (32 / 8                                 ),// 4  8
    .USER_WIDTH                             (4                                      ),// 4
    .DATA_DUTY                              (128                                    ),//128
    .DATA_LENGTH                            (256                                    ),//256

    .DST_MAC_ADDR                           (BASE0_DST_MAC_ADDR                     ),
    .SRC_MAC_ADDR                           (BASE0_SRC_MAC_ADDR                     ),
    .ETH_TYPE_LENGTH                        (BASE0_ETH_TYPE_LENGTH                  ),
    .IP_VERSION                             (BASE0_IP_VERSION                       ),
    .IP_HEADER_LENGTH                       (BASE0_IP_HEADER_LENGTH                 ),
    .IP_SERVICE_TYPE                        (BASE0_IP_SERVICE_TYPE                  ),
    .IP_TOTAL_LENGTH                        (BASE0_IP_TOTAL_LENGTH                  ),
    .IP_IDENTIFIER                          (BASE0_IP_IDENTIFIER                    ),
    .IP_FLAG                                (BASE0_IP_FLAG                          ),
    .IP_OFFSET                              (BASE0_IP_OFFSET                        ),
    .IP_TTL                                 (BASE0_IP_TTL                           ),
    .IP_PROTOCOL                            (BASE0_IP_PROTOCOL                      ),
    .IP_HEADER_CHECK_SUM                    (BASE0_IP_HEADER_CHECK_SUM              ),
    .IP_SRC_IP                              (BASE0_IP_SRC_IP                        ),
    .IP_DST_IP                              (BASE0_IP_DST_IP                        ),
    .UDP_SRC_PORT                           (BASE0_UDP_SRC_PORT                     ),
    .UDP_DST_PORT                           (BASE0_UDP_DST_PORT                     ),
    .UDP_LENGTH                             (BASE0_UDP_LENGTH                       ),
    .UDP_CHECKSUM                           (BASE0_UDP_CHECKSUM                     ),

    .FILE_HANDLE_TX                         ("mac3_tx_file.txt"                     ),
    .FILE_HANDLE_RX                         ("mac3_rx_file.txt"                     )
    
    )    u_mac3_top (
    
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---
    .axis_enable                            (lightning_mac3_enable                  ),//I
    .axis_loopback                          (lightning_mac3_loopback                ),//I
    //---
    .axis_clk                               (),//(axis_clk                          ),//O
    .axis_rst_n                             (),//(axis_rst_n                        ),//O
    //---
    .axis_tx_clk                            (mac3rx_user_clk                        ),//O
    .axis_tx_rst_n                          (mac3rx_user_resetn                     ),//O
    .axis_rx_clk                            (mac3tx_user_clk                        ),//O
    .axis_rx_rst_n                          (mac3tx_user_resetn                     ),//O
    //---MAC-3 TX AXI-STREAM    （C2P: Card to Peripheral）
    .axis_tx_tready                         (1'b1),//(lightning_mac3_axi_st_rx_tready        ),//I  Only 1'b1 @MAC    //(1'b1),//
    .axis_tx_tvalid                         (lightning_mac3_axi_st_rx_tvalid        ),//O
    .axis_tx_tdata                          (lightning_mac3_axi_st_rx_tdata         ),//O    [MAC_DATA_WIDTH-1 : 0]
    .axis_tx_tuser                          (lightning_mac3_axi_st_rx_tuser         ),//O    [MAC_USER_WIDTH-1 : 0]
    .axis_tx_tkeep                          (lightning_mac3_axi_st_rx_tstrb         ),//O    [MAC_KEEP_WIDTH-1 : 0]
//  .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O    [MAC_KEEP_WIDTH-1 : 0] NC
    .axis_tx_tlast                          (lightning_mac3_axi_st_rx_tlast         ),//O
    //---MAC-3 RX AXI-STREAM    （P2C: Peripheral to Card)
    .axis_rx_tready                         (lightning_mac3_axi_st_tx_tready        ),//O
    .axis_rx_tvalid                         (lightning_mac3_axi_st_tx_tvalid        ),//I
    .axis_rx_tdata                          (lightning_mac3_axi_st_tx_tdata         ),//I    [MAC_DATA_WIDTH-1 : 0]
    .axis_rx_tuser                          (lightning_mac3_axi_st_tx_tuser         ),//I    [MAC_USER_WIDTH-1 : 0] 1bit
    .axis_rx_tkeep                          (lightning_mac3_axi_st_tx_tstrb         ),//I    [MAC_KEEP_WIDTH-1 : 0]
//  .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I    [MAC_KEEP_WIDTH-1 : 0] NC
    .axis_rx_tlast                          (lightning_mac3_axi_st_tx_tlast         ),//I
    //---
    .sys_clk_locked                         (                                       ) //O
    
    );
    
//--------------------------------------------------------------------------------PCIE_BAR1-AXI4_Lite
    //------u_axi4_lite_top
    axi4_lite_top #(
    .WORK_MODE                              (WORK_MODE                              ),//0:global, 1:local
    .BAR1_DATA_WIDTH                        (BAR1_DATA_WIDTH                        ),//32
    .BAR1_KEEP_WIDTH                        (BAR1_KEEP_WIDTH / 8                    ) //4
    )    u_axi4_lite_top(
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---awaddr
    .o_m_axi_awaddr                         (user_bar1_axi_lite_awaddr              ),//O    [31:00]
    .o_m_axi_awvalid                        (user_bar1_axi_lite_awvalid             ),//O
    .o_m_axi_awprot                         (user_bar1_axi_lite_awprot              ),//O    [02:00]  default 3'b000
    .i_m_axi_awready                        (user_bar1_axi_lite_awready             ),//I
    //---wdata
    .o_m_axi_wdata                          (user_bar1_axi_lite_wdata               ),//O    [31:00]
    .o_m_axi_wstrb                          (user_bar1_axi_lite_wstrb               ),//O    [03:00]
    .o_m_axi_wvalid                         (user_bar1_axi_lite_wvalid              ),//O
    .i_m_axi_wready                         (user_bar1_axi_lite_wready              ),//I
    //---bresp
    .i_m_axi_bresp                          (user_bar1_axi_lite_bresp               ),//I    [01:00]
    .i_m_axi_bvalid                         (user_bar1_axi_lite_bvalid              ),//I
    .o_m_axi_bready                         (user_bar1_axi_lite_bready              ),//O
    //---araddr
    .o_m_axi_araddr                         (user_bar1_axi_lite_araddr              ),//O    [31:00]
    .o_m_axi_arvalid                        (user_bar1_axi_lite_arvalid             ),//O
    .o_m_axi_arprot                         (user_bar1_axi_lite_arprot              ),//O    [02:00]  default 3'b000
    .i_m_axi_arready                        (user_bar1_axi_lite_arready             ),//I
    //---rdata
    .i_m_axi_rdata                          (user_bar1_axi_lite_rdata               ),//I    [31:00]
    .i_m_axi_rresp                          (user_bar1_axi_lite_rresp               ),//I    [01:00]
    .i_m_axi_rvalid                         (user_bar1_axi_lite_rvalid              ),//O
    .o_m_axi_rready                         (user_bar1_axi_lite_rready              ) //O
    );

//--------------------------------------------------------------------------------

endmodule
