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
//** m_axis --(LOSS PACKET)--> FIFO --> s_axis
//*********************************************
// FULL_THR is PACK LOSS THR (At least one packet of data can be cached)
// Eg: DATA_WIDTH = FIFO_WIDTH = 256; FIFO_DEPTH = 1024; FIFO_FULL_THR = 780;
//  When the progfull signal is High, the remaining space inside the FIFO is 244 * 32 = 7808 Byte
//  Therefore, the maximum length of a packet that can be transmitted is 7808 Byte
module packet_loss #(
    parameter   DATA_WIDTH      =   64,
    parameter   STRB_WIDTH      =   8,
    parameter   USER_WIDTH      =   1,
    parameter   FIFO_DEPTH      =   2048,
    parameter   FULL_THR        =   1108
) (
    input   wire                            sys_clk,
    input   wire                            sys_rstn,

    output  reg     [63:0]                  packet_loss_count,  //** Base on SYS CLOCK
    output  reg                             packet_loss_edge,   //** The signal is reversed whenever a packet is lost (default = 0)

    input   wire                            m_axis_tvalid,
    input   wire                            m_axis_tlast,
    input   wire    [DATA_WIDTH-1 :0]       m_axis_tdata,
    input   wire    [STRB_WIDTH-1 :0]       m_axis_tstrb,
    input   wire    [USER_WIDTH-1 :0]       m_axis_tuser,

    output  wire                            s_axis_tvalid,
    output  wire                            s_axis_tlast,
    output  wire    [DATA_WIDTH-1 :0]       s_axis_tdata,
    output  wire    [STRB_WIDTH-1 :0]       s_axis_tstrb,
    output  wire    [USER_WIDTH-1 :0]       s_axis_tuser,
    input   wire                            s_axis_tready
);
localparam      FIFO_WIDTH  =   DATA_WIDTH + STRB_WIDTH + USER_WIDTH + 1;

//** FSM
    reg                                     state_cur;
    reg                                     state_nxt;
    localparam  IDLE    =   1'b0;
    localparam  TRANS   =   1'b1;

//** FIFO SIGNAL
    wire                                    fifo_wren;
    wire    [FIFO_WIDTH-1 :0]               fifo_din;
    wire                                    fifo_rden;
    wire    [FIFO_WIDTH-1 :0]               fifo_dout;
    wire                                    fifo_empty;
    wire                                    fifo_progfull;

//** PACKET LOSS
    reg                                     packet_loss_flag;

//**************************************
//** FSM
//**************************************
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            state_cur   <=  IDLE;
        end else begin
            state_cur   <=  state_nxt;
        end
    end

    always @ ( * ) begin
        case (state_cur)
            IDLE : begin
                if (m_axis_tvalid && (!m_axis_tlast)) begin
                    state_nxt   =   TRANS;
                end else begin
                    state_nxt   =   IDLE;
                end
            end

            TRANS : begin
                if (m_axis_tvalid && m_axis_tlast) begin
                    state_nxt   =   IDLE;
                end else begin
                    state_nxt   =   TRANS;
                end
            end
        endcase
    end

//**************************************
//** PACKET LOSS FLAG
//**************************************
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            packet_loss_flag    <=  0;
        end else begin
            if (state_nxt == IDLE) begin
                if (fifo_progfull == 0) begin
                    packet_loss_flag    <=  0;
                end else begin
                    packet_loss_flag    <=  1;
                end
            end else begin
                packet_loss_flag    <=  packet_loss_flag;
            end
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            packet_loss_count   <=  0;
            packet_loss_edge    <=  0;
        end else begin
            if (packet_loss_flag && m_axis_tlast && m_axis_tvalid) begin
                packet_loss_count   <=  packet_loss_count + 1;
                packet_loss_edge    <=  !packet_loss_edge;
            end else begin
                packet_loss_count   <=  packet_loss_count;
                packet_loss_edge    <=  packet_loss_edge;
            end
        end
    end

//**************************************
//** m_axis --> FIFO - 1
//**************************************
    assign  fifo_wren     =   (!packet_loss_flag) && m_axis_tvalid;
    assign  fifo_din      =   {m_axis_tdata, m_axis_tstrb, m_axis_tuser, m_axis_tlast};


//**************************************
//** FIFO --> s_axis
//**************************************
    assign  fifo_rden       =   (!fifo_empty) && s_axis_tready;
    assign  s_axis_tvalid   =   (!fifo_empty);
    assign  s_axis_tdata    =   fifo_dout[(STRB_WIDTH + USER_WIDTH + 1) +: DATA_WIDTH];
    assign  s_axis_tstrb    =   fifo_dout[(USER_WIDTH+1) +: STRB_WIDTH];
    assign  s_axis_tuser    =   fifo_dout[1 +: USER_WIDTH];
    assign  s_axis_tlast    =   fifo_dout[0 +: 1];

    general_asfifo_fwft_user#(
        .FIFO_DEPTH         ( FIFO_DEPTH ),
        .FIFO_WIDTH         ( FIFO_WIDTH ),
        .PROG_FULL_THR      ( FULL_THR   )
    )u_fifo_1(
        .wr_clk        ( sys_clk        ),
        .rstn          ( sys_rstn       ),
        .wr_en         ( fifo_wren      ),
        .din           ( fifo_din       ),
        .prog_full     ( fifo_progfull  ),
        .rd_clk        ( sys_clk        ),
        .rd_en         ( fifo_rden      ),
        .dout          ( fifo_dout      ),
        .empty         ( fifo_empty     )
    );

    
endmodule
`default_nettype wire