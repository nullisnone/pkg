/***********************************************Copyright@2024*****************************************************

          YUSUR CO. LTD. All rights reserved
                            http://www.yusur.tech, http://www.carch.ac.cn/~adapt

=========================================FILE INFO.===================================================
File Name       : axis_register.v
Last Update     : 2024/11/19
Latest version  : v1.00
Descriptions    : AXI Stream Register
========================================UPDATE HISTORY================================================
Modified by     : 
Modified date   : 
Version         : 
Descriptions    : 
------------------------------------------------------------------------------------------------------

(Add more modification logs, separated with '----')*
*****************************************Confidential. Do NOT disclose*********************************************/
`default_nettype none
//*********************************************
//** m_axis --> FIFO-1 --> FIFO-2 --> s_axis
//*********************************************
module axi_stream_register #(
    parameter   DATA_WIDTH      =   32,
    parameter   STRB_WIDTH      =   4,
    parameter   USER_WIDTH      =   1
) (
    input   wire                            sys_clk,
    input   wire                            sys_rstn,

    input   wire                            m_axis_tvalid,
    input   wire                            m_axis_tlast,
    input   wire    [DATA_WIDTH-1 :0]       m_axis_tdata,
    input   wire    [STRB_WIDTH-1 :0]       m_axis_tstrb,
    input   wire    [USER_WIDTH-1 :0]       m_axis_tuser,
    output  wire                            m_axis_tready,

    output  wire                            s_axis_tvalid,
    output  wire                            s_axis_tlast,
    output  wire    [DATA_WIDTH-1 :0]       s_axis_tdata,
    output  wire    [STRB_WIDTH-1 :0]       s_axis_tstrb,
    output  wire    [USER_WIDTH-1 :0]       s_axis_tuser,
    input   wire                            s_axis_tready
);
localparam      FIFO_WIDTH  =   DATA_WIDTH + STRB_WIDTH + USER_WIDTH + 1;
localparam      FIFO_DEPTH  =   128;
localparam      FULL_THR    =   120;

//** FIFO - 1 SIGNAL
    wire                                    fifo_1_wren;
    wire    [FIFO_WIDTH-1 :0]               fifo_1_din;
    wire                                    fifo_1_rden;
    wire    [FIFO_WIDTH-1 :0]               fifo_1_dout;
    wire                                    fifo_1_empty;
    wire                                    fifo_1_progfull;

//** FIFO - 2 SIGNAL
    wire                                    fifo_2_wren;
    wire    [FIFO_WIDTH-1 :0]               fifo_2_din;
    wire                                    fifo_2_rden;
    wire    [FIFO_WIDTH-1 :0]               fifo_2_dout;
    wire                                    fifo_2_empty;
    wire                                    fifo_2_progfull;

//**************************************
//** m_axis --> FIFO - 1
//**************************************
    assign  fifo_1_wren     =   m_axis_tready && m_axis_tvalid;
    assign  fifo_1_din      =   {m_axis_tdata, m_axis_tstrb, m_axis_tuser, m_axis_tlast};
    assign  m_axis_tready   =   !fifo_1_progfull;

//**************************************
//** FIFO - 1 --> FIFO - 2
//**************************************
    assign  fifo_1_rden     =   (!fifo_1_empty) && (!fifo_2_progfull);
    assign  fifo_2_wren     =   fifo_1_rden;
    assign  fifo_2_din      =   fifo_1_dout;

//**************************************
//** FIFO - 2 --> s_axis
//**************************************
    assign  fifo_2_rden     =   (!fifo_2_empty) && s_axis_tready;
    assign  s_axis_tvalid   =   (!fifo_2_empty);
    assign  s_axis_tdata    =   fifo_2_dout[(STRB_WIDTH + USER_WIDTH + 1) +: DATA_WIDTH];
    assign  s_axis_tstrb    =   fifo_2_dout[(USER_WIDTH+1) +: STRB_WIDTH];
    assign  s_axis_tuser    =   fifo_2_dout[1 +: USER_WIDTH];
    assign  s_axis_tlast    =   fifo_2_dout[0 +: 1];

    general_asfifo_fwft_user#(
        .FIFO_DEPTH         ( FIFO_DEPTH ),
        .FIFO_WIDTH         ( FIFO_WIDTH ),
        .PROG_FULL_THR      ( FULL_THR   ),
        .RAM_STYLE          ( "distributed" )
    )u_fifo_1(
        .wr_clk        ( sys_clk        ),
        .rstn          ( sys_rstn       ),
        .wr_en         ( fifo_1_wren    ),
        .din           ( fifo_1_din     ),
        .prog_full     ( fifo_1_progfull),
        .rd_clk        ( sys_clk        ),
        .rd_en         ( fifo_1_rden    ),
        .dout          ( fifo_1_dout    ),
        .empty         ( fifo_1_empty   )
    );

    general_asfifo_fwft_user#(
        .FIFO_DEPTH         ( FIFO_DEPTH ),
        .FIFO_WIDTH         ( FIFO_WIDTH ),
        .PROG_FULL_THR      ( FULL_THR   ),
        .RAM_STYLE          ( "distributed" )
    )u_fifo_2(
        .wr_clk        ( sys_clk        ),
        .rstn          ( sys_rstn       ),
        .wr_en         ( fifo_2_wren    ),
        .din           ( fifo_2_din     ),
        .prog_full     ( fifo_2_progfull),
        .rd_clk        ( sys_clk        ),
        .rd_en         ( fifo_2_rden    ),
        .dout          ( fifo_2_dout    ),
        .empty         ( fifo_2_empty   )
    );
    
endmodule
`default_nettype wire