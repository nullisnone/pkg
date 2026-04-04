// ************************************************Copyright@2018*****************************************************
//             YUSUR CO. LTD. All rights reserved
//                             http://www.yusur.tech, http://www.carch.ac.cn/
// ===========================================FILE INFO.===================================================
// File Name       : general_asfifo_fwft.v      // Last Update     : 2022/05/31
// Latest version  : v0.1                       // Descriptions    : Async FIFO 
// =========================================UPDATE HISTORY=================================================
// Modified by     : zhanghao                   // Modified date   : 2022/05/31
// Version         : v0.1                       // Descriptions    : XILINX_RTL or ASIC
// ------------------------------------------------------------------------------------------------------
// (Add more modification logs, separated with '----')*
// *****************************************Confidential. Do NOT disclose*********************************************

//    `timescale 1ns / 1ps
// `include "../ram_param.vh"
`default_nettype wire

module general_asfifo_fwft_user
# (
    parameter FIFO_DEPTH = 1024     ,
    parameter FIFO_WIDTH = 32       ,
    parameter PROG_FULL_THR  = 768  ,
    parameter PROG_EMPTY_THR = 16   ,
    parameter RAM_STYLE = "block"       // "block"/"distributed"
    // parameter RAM_PERFORMANCE = "LOW_LATENCY"
) 
(
    wr_clk      , // (i)
    rd_clk      , // (i)
    rstn        , // (i)
    din         , // (iv)
    wr_en       , // (i)
    rd_en       , // (i)
    dout        , // (ov)
    full        , // (o)
    empty       , // (o)
    prog_full   , // (o)
    prog_empty  , // (o)
    wr_cnt      , // (ov)
    rd_cnt        // (ov)
);

    // localparam RAM_STYLE       = "block"; // only make sense when RAM_TYPE==1, Set "block" or "distributed"
    localparam RAM_PERFORMANCE = "LOW_LATENCY";
    localparam FIFO_ADDR_WIDTH = (FIFO_DEPTH<=32'h00000010) ?  4 :
                                 (FIFO_DEPTH<=32'h00000020) ?  5 :
                                 (FIFO_DEPTH<=32'h00000040) ?  6 :
                                 (FIFO_DEPTH<=32'h00000080) ?  7 :
                                 (FIFO_DEPTH<=32'h00000100) ?  8 :
                                 (FIFO_DEPTH<=32'h00000200) ?  9 :
                                 (FIFO_DEPTH<=32'h00000400) ? 10 :
                                 (FIFO_DEPTH<=32'h00000800) ? 11 :
                                 (FIFO_DEPTH<=32'h00001000) ? 12 :
                                 (FIFO_DEPTH<=32'h00002000) ? 13 :
                                 (FIFO_DEPTH<=32'h00004000) ? 14 :
                                 (FIFO_DEPTH<=32'h00008000) ? 15 :
                                 (FIFO_DEPTH<=32'h00010000) ? 16 :
                                 (FIFO_DEPTH<=32'h00020000) ? 17 :
                                 (FIFO_DEPTH<=32'h00040000) ? 18 :
                                 (FIFO_DEPTH<=32'h00080000) ? 19 :
                                 (FIFO_DEPTH<=32'h00100000) ? 20 :
                                 (FIFO_DEPTH<=32'h00200000) ? 21 :
                                 (FIFO_DEPTH<=32'h00400000) ? 22 :
                                 (FIFO_DEPTH<=32'h00800000) ? 23 :
                                 (FIFO_DEPTH<=32'h01000000) ? 24 :
                                 (FIFO_DEPTH<=32'h02000000) ? 25 :
                                 (FIFO_DEPTH<=32'h04000000) ? 26 :
                                 (FIFO_DEPTH<=32'h08000000) ? 27 :
                                 (FIFO_DEPTH<=32'h10000000) ? 28 :
                                 (FIFO_DEPTH<=32'h20000000) ? 29 :
                                 (FIFO_DEPTH<=32'h40000000) ? 30 :
                                 (FIFO_DEPTH<=32'h80000000) ? 31 : 32;
    
    input wire                      rstn        ; // (i)
    input                       wr_clk      ; // (i)
    input                       rd_clk      ; // (i)
    input  [FIFO_WIDTH-1:0]     din         ; // (iv)
    input                       wr_en       ; // (i)
    input                       rd_en       ; // (i)
    output [FIFO_WIDTH-1:0]     dout        ; // (ov)
    output                      full        ; // (o)
    output                      empty       ; // (o)
    output                      prog_full   ; // (o)
    output                      prog_empty  ; // (o)
    output [FIFO_ADDR_WIDTH:0]  wr_cnt      ; // (ov)
    output [FIFO_ADDR_WIDTH:0]  rd_cnt      ; // (ov)
    
    wire [FIFO_WIDTH-1:0]       ram_dout    ;
    wire                        fifo_empty  ;
    wire                        fifo_rd_en  ;
    wire                        val_wr      ;
    wire                        val_rd      ;
    wire [FIFO_ADDR_WIDTH-1:0]  rdaddr      ;
    wire [FIFO_ADDR_WIDTH-1:0]  wraddr      ;
    
    asfifo_user #(
        .ADDR_WIDTH         (FIFO_ADDR_WIDTH),
        .PROG_EMPTY_OFST    (PROG_EMPTY_THR ),
        .PROG_FULL_OFST     (PROG_FULL_THR  )
    ) u_asfifo_task (
        .rstn           (rstn),
        
        .wr_clk_i       (wr_clk),
        .wr_en_i        (wr_en),
        .wr_cnt         (wr_cnt),
        .full_o         (full),
        .prog_full_o    (prog_full),
        
        .rd_clk_i       (rd_clk),
        .rd_en_i        (fifo_rd_en),
        .rd_cnt         (rd_cnt),
        .empty_o        (fifo_empty),
        .prog_empty_o   (prog_empty),
        
        // external ram port
        .val_wr         (val_wr     ),
        .val_rd         (val_rd     ),
        .rdaddr         (rdaddr     ),
        .wraddr         (wraddr     )
    );

    fifo_fwft_adapter_user #(
        .DATA_WIDTH (FIFO_WIDTH  )
    ) fwft_adapter (
        .clk            (rd_clk),
        .rstn           (rstn),
        .rd_en_i        (rd_en),
        .fifo_empty_i   (fifo_empty),
        .fifo_rd_en_o   (fifo_rd_en),
        .fifo_dout_i    (ram_dout),
        .dout_o         (dout),
        .empty_o        (empty)
    );
    
    general_sdpram_dc_user # (
        .RAM_DEPTH          (FIFO_DEPTH     ) , // 1024
        .RAM_WIDTH          (FIFO_WIDTH     ) , // 32
        .RAM_TYPE           (RAM_STYLE      ) , // Set "block" or "distributed" or "ultra"
        .RAM_PERFORMANCE    (RAM_PERFORMANCE) , // Set "HIGH_PERFORMANCE"(2 cycle latency) or "LOW_LATENCY"(1 cycle latency)
        .INIT_FILE          (""             ) 
        )
        u_general_sdpram_dc (
        .clka               (wr_clk         ) , // Write Clock
        .clkb               (rd_clk         ) , // Read Clock
        .dina               (din            ) , // Data Input 
        .addra              (wraddr         ) , // Write Address
        .addrb              (rdaddr         ) , // Read Address
        .wea                (val_wr         ) , // Write enable
        .enb                (val_rd         ) , // Read Enable, for additional power savings, disable when not in use
        .doutb              (ram_dout       )   // Data Output
        );

endmodule
