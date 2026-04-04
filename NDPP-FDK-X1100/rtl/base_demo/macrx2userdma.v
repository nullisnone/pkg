/***********************************************Copyright@2024*****************************************************

          YUSUR CO. LTD. All rights reserved
                            http://www.yusur.tech, http://www.carch.ac.cn/~adapt

=========================================FILE INFO.===================================================
File Name       : macrx2userdma.v
Last Update     : 2024/11/19
Latest version  : v1.00
Descriptions    : macrx --> Width Convert --> Packet loss --> Cross Domain --> Userdma
========================================UPDATE HISTORY================================================
Modified by     : 
Modified date   : 
Version         : 
Descriptions    : 
------------------------------------------------------------------------------------------------------

(Add more modification logs, separated with '----')*
*****************************************Confidential. Do NOT disclose*********************************************/
`default_nettype none
module macrx2userdma #(
    parameter   USERDMA_AXI_DATA_WIDTH  =   64,
    parameter   USERDMA_AXI_STRB_WIDTH  =   8,
    parameter   USERDMA_RX_BUFFER       =   4'b0,
    parameter   PACKET_LOSS_FIFO_DEPTH  =   2048,
    parameter   PACKET_LOSS_FULL_THR    =   1108
) (
    input   wire                                            macrx_clk,
    input   wire                                            macrx_rstn,
    input   wire                                            sys_clk,
    input   wire                                            sys_rstn,

    input   wire                                            macrx_axi_st_rx_tvalid,
    input   wire                                            macrx_axi_st_rx_tuser,
    input   wire                                            macrx_axi_st_rx_tlast,
    input   wire    [31:0]                                  macrx_axi_st_rx_tdata,
    input   wire    [3:0]                                   macrx_axi_st_rx_tstrb,

    output  wire                                            udma_axi_st_rx_tvalid,
    output  wire                                            udma_axi_st_rx_tlast,
    output  wire    [4:0]                                   udma_axi_st_rx_tuser,
    output  wire    [USERDMA_AXI_DATA_WIDTH-1 :0]           udma_axi_st_rx_tdata,
    output  wire    [USERDMA_AXI_STRB_WIDTH-1 :0]           udma_axi_st_rx_tstrb,
    input   wire                                            udma_axi_st_rx_tready,

    output  reg     [63:0]                                  packet_loss_count
);
//*******************************************************
//** macrx ---> axi-s register ---> mac rx register
//--- The MAC and PCIe serdes are far apart, and the base
//--- demo is only a small logic. In order to meet the
//--- timing requirements,the MAC signal is Register
//*******************************************************
    wire                macrx_axi_st_rx_tvalid_register;
    wire                macrx_axi_st_rx_tuser_register;
    wire                macrx_axi_st_rx_tlast_register;
    wire    [31:0]      macrx_axi_st_rx_tdata_register;
    wire    [3:0]       macrx_axi_st_rx_tstrb_register;

    axi_stream_noready_register#(
        .DATA_WIDTH    ( 32 ),
        .STRB_WIDTH    ( 4 ),
        .USER_WIDTH    ( 1 )
    )u_mac0_rx_register(
        .sys_clk       ( macrx_clk    ),
        .sys_rstn      ( macrx_rstn ),

        .m_axis_tvalid ( macrx_axi_st_rx_tvalid ),
        .m_axis_tlast  ( macrx_axi_st_rx_tlast  ),
        .m_axis_tdata  ( macrx_axi_st_rx_tdata  ),
        .m_axis_tstrb  ( macrx_axi_st_rx_tstrb  ),
        .m_axis_tuser  ( macrx_axi_st_rx_tuser  ),

        .s_axis_tvalid ( macrx_axi_st_rx_tvalid_register ),
        .s_axis_tlast  ( macrx_axi_st_rx_tlast_register  ),
        .s_axis_tdata  ( macrx_axi_st_rx_tdata_register  ),
        .s_axis_tstrb  ( macrx_axi_st_rx_tstrb_register  ),
        .s_axis_tuser  ( macrx_axi_st_rx_tuser_register  )
    );


//**********************************************
//** macrx register --> width convert
//**********************************************
    localparam      UPSIZE_RATIO    =   USERDMA_AXI_DATA_WIDTH/32;
    wire                                                width_convert_axi_tvalid;
    wire                                                width_convert_axi_tlast;
    wire                                                width_convert_axi_tuser;
    wire    [USERDMA_AXI_DATA_WIDTH-1 :0]               width_convert_axi_tdata;
    wire    [USERDMA_AXI_STRB_WIDTH-1 :0]               width_convert_axi_tstrb;

    // axi_stream_upsize#(
    //     .DW            ( 32             ),
    //     .RATIO         ( UPSIZE_RATIO   ),
    //     .USER_WIDTH    ( 1              )
    // )u_axi_stream_upsize(
    //     .sys_clk       ( macrx_clk                ),
    //     .sys_rstn      ( macrx_rstn               ),

    //     .s_axis_tvalid ( macrx_axi_st_rx_tvalid_register),
    //     .s_axis_tdata  ( macrx_axi_st_rx_tdata_register ),
    //     .s_axis_tkeep  ( macrx_axi_st_rx_tstrb_register ),
    //     .s_axis_tlast  ( macrx_axi_st_rx_tlast_register ),
    //     .s_axis_tuser  ( macrx_axi_st_rx_tuser_register ),
    //     .s_axis_tready (                                ),

    //     .m_axis_tvalid ( width_convert_axi_tvalid ),
    //     .m_axis_tdata  ( width_convert_axi_tdata  ),
    //     .m_axis_tkeep  ( width_convert_axi_tstrb  ),
    //     .m_axis_tlast  ( width_convert_axi_tlast  ),
    //     .m_axis_tuser  ( width_convert_axi_tuser  ),
    //     .m_axis_tready ( 1'b1                     )
    // );

    axi_stream_adapter #(
        .S_DATA_WIDTH   ( 'd32  ),
        .M_DATA_WIDTH   ( USERDMA_AXI_DATA_WIDTH ),
        .ID_ENABLE      ( 'b0   ),
        .DEST_ENABLE    ( 'b0   ),
        .USER_ENABLE    ( 'b1   ),
        .USER_WIDTH     ( 'd1   )
    )u_axi_stream_adapter_upsize(
        .clk            ( macrx_clk   ),
        .rst            ( !macrx_rstn ),

        .s_axis_tdata   ( macrx_axi_st_rx_tdata_register ),
        .s_axis_tkeep   ( macrx_axi_st_rx_tstrb_register ),
        .s_axis_tvalid  ( macrx_axi_st_rx_tvalid_register),
        .s_axis_tlast   ( macrx_axi_st_rx_tlast_register ),
        .s_axis_tuser   ( macrx_axi_st_rx_tuser_register ),
        .s_axis_tready  (   ),
        .s_axis_tid     (   ),
        .s_axis_tdest   (   ),

        .m_axis_tdata   ( width_convert_axi_tdata ),
        .m_axis_tkeep   ( width_convert_axi_tstrb ),
        .m_axis_tvalid  ( width_convert_axi_tvalid),
        .m_axis_tlast   ( width_convert_axi_tlast ),
        .m_axis_tuser   ( width_convert_axi_tuser ),
        .m_axis_tready  ( 'b1                     )
    );


//**********************************************
//** Width Convert --> Packet Loss
//**********************************************
    wire                                                packet_loss_axi_tready;
    wire                                                packet_loss_axi_tvalid;
    wire                                                packet_loss_axi_tlast;
    wire                                                packet_loss_axi_tuser;
    wire    [USERDMA_AXI_DATA_WIDTH-1 :0]               packet_loss_axi_tdata;
    wire    [USERDMA_AXI_STRB_WIDTH-1 :0]               packet_loss_axi_tstrb;
    wire                                                packet_loss_edge;
    reg                                                 packet_loss_edge_r;
    reg                                                 packet_loss_edge_r2;

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            packet_loss_edge_r  <=  0;
            packet_loss_edge_r2 <=  0;
        end else begin
            packet_loss_edge_r  <=  packet_loss_edge;
            packet_loss_edge_r2 <=  packet_loss_edge_r;
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            packet_loss_count   <=  0;
        end else begin
            if (packet_loss_edge_r != packet_loss_edge_r2) begin
                packet_loss_count   <=  packet_loss_count + 1;
            end else begin
                packet_loss_count   <=  packet_loss_count;
            end
        end
    end

    packet_loss#(
        .DATA_WIDTH        ( USERDMA_AXI_DATA_WIDTH ),
        .STRB_WIDTH        ( USERDMA_AXI_STRB_WIDTH ),
        .USER_WIDTH        ( 1 ),
        .FIFO_DEPTH        ( PACKET_LOSS_FIFO_DEPTH ),
        .FULL_THR          ( PACKET_LOSS_FULL_THR   )
    )u_packet_loss(
        .sys_clk           ( macrx_clk         ),
        .sys_rstn          ( sys_rstn          ),
        .packet_loss_edge  ( packet_loss_edge ),

        .m_axis_tvalid     ( width_convert_axi_tvalid ),
        .m_axis_tlast      ( width_convert_axi_tlast  ),
        .m_axis_tdata      ( width_convert_axi_tdata  ),
        .m_axis_tstrb      ( width_convert_axi_tstrb  ),
        .m_axis_tuser      ( width_convert_axi_tuser  ),

        .s_axis_tvalid     ( packet_loss_axi_tvalid   ),
        .s_axis_tlast      ( packet_loss_axi_tlast    ),
        .s_axis_tdata      ( packet_loss_axi_tdata    ),
        .s_axis_tstrb      ( packet_loss_axi_tstrb    ),
        .s_axis_tuser      ( packet_loss_axi_tuser    ),
        .s_axis_tready     ( packet_loss_axi_tready   )
    );

//**********************************************
//** Packet Loss --> Cross Domain
//**********************************************
    wire                                                cross_domain_axi_tready;
    wire                                                cross_domain_axi_tvalid;
    wire                                                cross_domain_axi_tlast;
    wire                                                cross_domain_axi_tuser;
    wire    [USERDMA_AXI_DATA_WIDTH-1 :0]               cross_domain_axi_tdata;
    wire    [USERDMA_AXI_STRB_WIDTH-1 :0]               cross_domain_axi_tstrb;
    
    cross_domain#(
        .DATA_WIDTH    ( USERDMA_AXI_DATA_WIDTH ),
        .STRB_WIDTH    ( USERDMA_AXI_STRB_WIDTH ),
        .USER_WIDTH    ( 1 )
    )u_cross_domain(
        .m_axis_clk    ( macrx_clk              ),
        .s_axis_clk    ( sys_clk                ),
        .sys_rstn      ( sys_rstn               ),

        .m_axis_tvalid ( packet_loss_axi_tvalid ),
        .m_axis_tlast  ( packet_loss_axi_tlast  ),
        .m_axis_tdata  ( packet_loss_axi_tdata  ),
        .m_axis_tstrb  ( packet_loss_axi_tstrb  ),
        .m_axis_tuser  ( packet_loss_axi_tuser  ),
        .m_axis_tready ( packet_loss_axi_tready ),

        .s_axis_tvalid ( cross_domain_axi_tvalid),
        .s_axis_tlast  ( cross_domain_axi_tlast ),
        .s_axis_tdata  ( cross_domain_axi_tdata ),
        .s_axis_tstrb  ( cross_domain_axi_tstrb ),
        .s_axis_tuser  ( cross_domain_axi_tuser ),
        .s_axis_tready ( cross_domain_axi_tready)
    );

    assign  udma_axi_st_rx_tvalid   =   cross_domain_axi_tvalid;
    assign  udma_axi_st_rx_tlast    =   cross_domain_axi_tlast;
    assign  udma_axi_st_rx_tuser    =   {USERDMA_RX_BUFFER, cross_domain_axi_tuser};
    assign  udma_axi_st_rx_tdata    =   cross_domain_axi_tdata;
    assign  udma_axi_st_rx_tstrb    =   cross_domain_axi_tstrb;
    assign  cross_domain_axi_tready =   udma_axi_st_rx_tready;


endmodule
`default_nettype wire