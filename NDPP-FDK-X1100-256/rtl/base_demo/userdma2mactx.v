/***********************************************Copyright@2024*****************************************************

          YUSUR CO. LTD. All rights reserved
                            http://www.yusur.tech, http://www.carch.ac.cn/~adapt

=========================================FILE INFO.===================================================
File Name       : userdma2mactx.v
Last Update     : 2024/11/19
Latest version  : v1.00
Descriptions    : userdma --> Cross Domain --> Width Convert --> mactx
========================================UPDATE HISTORY================================================
Modified by     : 
Modified date   : 
Version         : 
Descriptions    : 
------------------------------------------------------------------------------------------------------

(Add more modification logs, separated with '----')*
*****************************************Confidential. Do NOT disclose*********************************************/
`default_nettype none
module userdma2mactx #(
    parameter   USERDMA_AXI_DATA_WIDTH  =   64,
    parameter   USERDMA_AXI_STRB_WIDTH  =   8,
    parameter   USERDMA_TX_BUFFER       =   4'b0
) (
    input   wire                                            mactx_clk,
    input   wire                                            mactx_rstn,
    input   wire                                            sys_clk,
    input   wire                                            sys_rstn,

    input   wire                                            udma_axi_st_tx_tvalid,
    input   wire    [3:0]                                   udma_axi_st_tx_tuser,
    input   wire                                            udma_axi_st_tx_tlast,
    input   wire    [USERDMA_AXI_DATA_WIDTH-1 :0]           udma_axi_st_tx_tdata,
    input   wire    [USERDMA_AXI_STRB_WIDTH-1 :0]           udma_axi_st_tx_tstrb,
    output  wire                                            udma_axi_st_tx_tready,

    output  wire                                            mactx_axi_st_tx_tvalid,
    output  wire                                            mactx_axi_st_tx_tlast,
    output  wire                                            mactx_axi_st_tx_tuser,
    output  wire     [31:0]                                 mactx_axi_st_tx_tdata,
    output  wire     [3:0]                                  mactx_axi_st_tx_tstrb,
    input   wire                                            mactx_axi_st_tx_tready
);
//**********************************************
//** userdma --> Cross Domain
//**********************************************
    wire                                                udma_axi_st_tx_tvalid_true;
    wire                                                cross_domain_axi_tready;
    wire                                                cross_domain_axi_tvalid;
    wire                                                cross_domain_axi_tlast;
    wire                                                cross_domain_axi_tuser;
    wire    [USERDMA_AXI_DATA_WIDTH-1 :0]               cross_domain_axi_tdata;
    wire    [USERDMA_AXI_STRB_WIDTH-1 :0]               cross_domain_axi_tstrb;

    assign  udma_axi_st_tx_tvalid_true  =   udma_axi_st_tx_tvalid && (udma_axi_st_tx_tuser == USERDMA_TX_BUFFER);

    cross_domain#(
        .DATA_WIDTH    ( USERDMA_AXI_DATA_WIDTH ),
        .STRB_WIDTH    ( USERDMA_AXI_STRB_WIDTH ),
        .USER_WIDTH    ( 1 )
    )u_cross_domain(
        .m_axis_clk    ( sys_clk       ),
        .s_axis_clk    ( mactx_clk     ),
        .sys_rstn      ( sys_rstn      ),

        .m_axis_tvalid ( udma_axi_st_tx_tvalid_true ),
        .m_axis_tlast  ( udma_axi_st_tx_tlast       ),
        .m_axis_tdata  ( udma_axi_st_tx_tdata       ),
        .m_axis_tstrb  ( udma_axi_st_tx_tstrb       ),
        .m_axis_tuser  ( 1'b0                       ),
        .m_axis_tready ( udma_axi_st_tx_tready      ),

        .s_axis_tvalid ( cross_domain_axi_tvalid    ),
        .s_axis_tlast  ( cross_domain_axi_tlast     ),
        .s_axis_tdata  ( cross_domain_axi_tdata     ),
        .s_axis_tstrb  ( cross_domain_axi_tstrb     ),
        .s_axis_tuser  ( cross_domain_axi_tuser     ),
        .s_axis_tready ( cross_domain_axi_tready    )
    );

//**********************************************
//** Cross Domain --> Width Convert
//**********************************************
    localparam      DOWNSIZE_RATIO    =   USERDMA_AXI_DATA_WIDTH/32;
    wire                            width_convert_axi_tvalid;
    wire                            width_convert_axi_tlast;
    wire                            width_convert_axi_tuser;
    wire     [31:0]                 width_convert_axi_tdata;
    wire     [3:0]                  width_convert_axi_tstrb;
    wire                            width_convert_axi_tready;

    // axi_stream_downsize#(
    //     .DW            ( USERDMA_AXI_DATA_WIDTH ),
    //     .RATIO         ( DOWNSIZE_RATIO         ),
    //     .USR_W         ( 1 )
    // )u_axi_stream_downsize(
    //     .aclk          ( mactx_clk     ),
    //     .aresetn       ( mactx_rstn    ),

    //     .s_axis_tvalid ( cross_domain_axi_tvalid ),
    //     .s_axis_tready ( cross_domain_axi_tready ),
    //     .s_axis_tdata  ( cross_domain_axi_tdata  ),
    //     .s_axis_tkeep  ( cross_domain_axi_tstrb  ),
    //     .s_axis_tuser  ( cross_domain_axi_tuser  ),
    //     .s_axis_tlast  ( cross_domain_axi_tlast  ),

    //     .m_axis_tvalid ( width_convert_axi_tvalid ),
    //     .m_axis_tready ( width_convert_axi_tready ),
    //     .m_axis_tdata  ( width_convert_axi_tdata  ),
    //     .m_axis_tkeep  ( width_convert_axi_tstrb  ),
    //     .m_axis_tuser  ( width_convert_axi_tuser  ),
    //     .m_axis_tlast  ( width_convert_axi_tlast  )
    // );

    axi_stream_adapter #(
        .S_DATA_WIDTH   ( USERDMA_AXI_DATA_WIDTH  ),
        .M_DATA_WIDTH   ( 'd32  ),
        .ID_ENABLE      ( 'b0   ),
        .DEST_ENABLE    ( 'b0   ),
        .USER_ENABLE    ( 'b1   ),
        .USER_WIDTH     ( 'd1   )
    )u_axi_stream_adapter_downsize(
        .clk            ( mactx_clk   ),
        .rst            ( !mactx_rstn ),

        .s_axis_tdata   ( cross_domain_axi_tdata ),
        .s_axis_tkeep   ( cross_domain_axi_tstrb ),
        .s_axis_tvalid  ( cross_domain_axi_tvalid),
        .s_axis_tlast   ( cross_domain_axi_tlast ),
        .s_axis_tuser   ( cross_domain_axi_tuser ),
        .s_axis_tready  ( cross_domain_axi_tready),
        .s_axis_tid     (   ),
        .s_axis_tdest   (   ),

        .m_axis_tdata   ( width_convert_axi_tdata ),
        .m_axis_tkeep   ( width_convert_axi_tstrb ),
        .m_axis_tvalid  ( width_convert_axi_tvalid),
        .m_axis_tlast   ( width_convert_axi_tlast ),
        .m_axis_tuser   ( width_convert_axi_tuser ),
        .m_axis_tready  ( width_convert_axi_tready)
    );

//*******************************************************
//** Width Convert ---> axi-s register ---> mac rx
//--- The MAC and PCIe serdes are far apart, and the base
//--- demo is only a small logic. In order to meet the
//--- timing requirements,the MAC signal is Register
//*******************************************************
    axi_stream_register#(
        .DATA_WIDTH    ( 32 ),
        .STRB_WIDTH    ( 4 ),
        .USER_WIDTH    ( 1 )
    )u_mac0_tx_register(
        .sys_clk       ( mactx_clk    ),
        .sys_rstn      ( mactx_rstn ),

        .m_axis_tvalid ( width_convert_axi_tvalid ),
        .m_axis_tlast  ( width_convert_axi_tlast  ),
        .m_axis_tdata  ( width_convert_axi_tdata  ),
        .m_axis_tstrb  ( width_convert_axi_tstrb  ),
        .m_axis_tuser  ( width_convert_axi_tuser  ),
        .m_axis_tready ( width_convert_axi_tready ),

        .s_axis_tvalid ( mactx_axi_st_tx_tvalid ),
        .s_axis_tlast  ( mactx_axi_st_tx_tlast  ),
        .s_axis_tdata  ( mactx_axi_st_tx_tdata  ),
        .s_axis_tstrb  ( mactx_axi_st_tx_tstrb  ),
        .s_axis_tuser  ( mactx_axi_st_tx_tuser  ),
        .s_axis_tready ( mactx_axi_st_tx_tready )
    );

endmodule
`default_nettype wire