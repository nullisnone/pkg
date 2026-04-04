/***********************************************Copyright@2024*****************************************************

          YUSUR CO. LTD. All rights reserved
                            http://www.yusur.tech, http://www.carch.ac.cn/~adapt

=========================================FILE INFO.===================================================
File Name       : cross_domain.v
Last Update     : 2024/11/19
Latest version  : v1.00
Descriptions    : AXI Stream Cross Domain
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
//** m_axis --> ASYNC FIFO --> s_axis
//*********************************************
module cross_domain #(
    parameter   DATA_WIDTH      =   32,
    parameter   STRB_WIDTH      =   4,
    parameter   USER_WIDTH      =   1
) (
    input   wire                            m_axis_clk,
    input   wire                            s_axis_clk,
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

//** ASYNC FIFO SIGNAL
    wire                                    async_fifo_wren;
    wire    [FIFO_WIDTH-1 :0]               async_fifo_din;
    wire                                    async_fifo_rden;
    wire    [FIFO_WIDTH-1 :0]               async_fifo_dout;
    wire                                    async_fifo_empty;
    wire                                    async_fifo_progfull;


//**************************************
//** m_axis --> ASYNC FIFO
//**************************************
    assign  async_fifo_wren     =   m_axis_tready && m_axis_tvalid;
    assign  async_fifo_din      =   {m_axis_tdata, m_axis_tstrb, m_axis_tuser, m_axis_tlast};
    assign  m_axis_tready       =   !async_fifo_progfull;

//**************************************
//** ASYNC FIFO --> s_axis
//**************************************
    assign  async_fifo_rden     =   (!async_fifo_empty) && s_axis_tready;
    assign  s_axis_tvalid       =   (!async_fifo_empty);
    assign  s_axis_tdata        =   async_fifo_dout[(STRB_WIDTH + USER_WIDTH + 1) +: DATA_WIDTH];
    assign  s_axis_tstrb        =   async_fifo_dout[(USER_WIDTH+1) +: STRB_WIDTH];
    assign  s_axis_tuser        =   async_fifo_dout[1 +: USER_WIDTH];
    assign  s_axis_tlast        =   async_fifo_dout[0 +: 1];

    general_asfifo_fwft_user#(
        .FIFO_DEPTH         ( FIFO_DEPTH ),
        .FIFO_WIDTH         ( FIFO_WIDTH ),
        .PROG_FULL_THR      ( FULL_THR   )
    )u_async_fifo(
        .wr_clk        ( m_axis_clk         ),
        .rstn          ( sys_rstn           ),
        .wr_en         ( async_fifo_wren    ),
        .din           ( async_fifo_din     ),
        .prog_full     ( async_fifo_progfull),
        .rd_clk        ( s_axis_clk         ),
        .rd_en         ( async_fifo_rden    ),
        .dout          ( async_fifo_dout    ),
        .empty         ( async_fifo_empty   )
    );
    
endmodule
`default_nettype wire