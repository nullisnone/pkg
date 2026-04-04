/***********************************************Copyright@2024*****************************************************

          YUSUR CO. LTD. All rights reserved
                            http://www.yusur.tech, http://www.carch.ac.cn/~adapt

=========================================FILE INFO.===================================================
File Name       : axis_register.v
Last Update     : 2024/11/19
Latest version  : v1.00
Descriptions    : AXI Stream Register no ready signal
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
module axi_stream_noready_register #(
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

    output  wire                            s_axis_tvalid,
    output  wire                            s_axis_tlast,
    output  wire    [DATA_WIDTH-1 :0]       s_axis_tdata,
    output  wire    [STRB_WIDTH-1 :0]       s_axis_tstrb,
    output  wire    [USER_WIDTH-1 :0]       s_axis_tuser
);

//** Register
    reg                                     axis_tvalid_r;
    reg                                     axis_tlast_r;
    reg     [DATA_WIDTH-1 :0]               axis_tdata_r;
    reg     [STRB_WIDTH-1 :0]               axis_tstrb_r;
    reg     [USER_WIDTH-1 :0]               axis_tuser_r;

    reg                                     axis_tvalid_r2;
    reg                                     axis_tlast_r2;
    reg     [DATA_WIDTH-1 :0]               axis_tdata_r2;
    reg     [STRB_WIDTH-1 :0]               axis_tstrb_r2;
    reg     [USER_WIDTH-1 :0]               axis_tuser_r2;

//**************************************
//** m_axis --> axis_register_1
//**************************************
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            axis_tvalid_r   <=  0;
            axis_tlast_r    <=  0;
            axis_tdata_r    <=  0;
            axis_tstrb_r    <=  0;
            axis_tuser_r    <=  0;
        end else begin
            axis_tvalid_r   <=  m_axis_tvalid;
            axis_tlast_r    <=  m_axis_tlast;
            axis_tdata_r    <=  m_axis_tdata;
            axis_tstrb_r    <=  m_axis_tstrb;
            axis_tuser_r    <=  m_axis_tuser;
        end
    end

//**************************************
//** axis_register_1 --> axis_register_2
//**************************************
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            axis_tvalid_r2  <=  0;
            axis_tlast_r2   <=  0;
            axis_tdata_r2   <=  0;
            axis_tstrb_r2   <=  0;
            axis_tuser_r2   <=  0;
        end else begin
            axis_tvalid_r2  <=  axis_tvalid_r;
            axis_tlast_r2   <=  axis_tlast_r;
            axis_tdata_r2   <=  axis_tdata_r;
            axis_tstrb_r2   <=  axis_tstrb_r;
            axis_tuser_r2   <=  axis_tuser_r;
        end
    end

//**************************************
//** axis_register_2 --> s_axis
//**************************************
    assign  s_axis_tvalid   =   axis_tvalid_r2;
    assign  s_axis_tlast    =   axis_tlast_r2;
    assign  s_axis_tdata    =   axis_tdata_r2;
    assign  s_axis_tstrb    =   axis_tstrb_r2;
    assign  s_axis_tuser    =   axis_tuser_r2;
    
endmodule
`default_nettype wire