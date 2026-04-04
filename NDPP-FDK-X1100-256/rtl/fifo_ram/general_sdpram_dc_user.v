// ************************************************Copyright@2022*****************************************************
//             YUSUR CO. LTD. All rights reserved
//                             http://www.yusur.tech, http://www.carch.ac.cn/
// ============================================FILE INFO.==================================================
// File Name       : wrapper_sdpram_sc.v        // Last Update     : 2022/05/31
// Latest version  : v0.1                       // Descriptions    : General Simple Dual Port RAM with Single Clock
// ==========================================UPDATE HISTORY================================================
// Modified by     : Zhang Hao                  // Modified date   : 2022/05/31
// Version         : v0.1                       // Descriptions    : XILINX_RTL or ASIC
// ------------------------------------------------------------------------------------------------------
// (Add more modification logs, separated with '----')*
// *****************************************Confidential. Do NOT disclose*********************************************
//    `timescale 1ns / 1ps

//# Module 

module general_sdpram_dc_user
#(  
    parameter   RAM_DEPTH       = 1024              ,
    parameter   RAM_WIDTH       = 32                ,
    parameter   RAM_TYPE        = "block"           , // Set "block" or "distributed" or "ultra"
    parameter   RAM_PERFORMANCE = "HIGH_PERFORMANCE", // Set "HIGH_PERFORMANCE"(2 cycle latency) or "LOW_LATENCY"(1 cycle latency)
    parameter   INIT_FILE       = ""                  // Specify name/location of RAM initialization file if using one (leave blank if not)
) // 0 ASIC RAM Library;  1 RTL Inferenced RAM for AMD/Xilinx FPGA;
(
    clka        , // (i)
    clkb        , // (i)
    wea         , // (iv)
    addra       , // (iv)
    dina        , // (iv)
    enb         , // (i)
    addrb       , // (iv)
    doutb         // (ov)
);
    
    localparam ADDR_WIDTH = (RAM_DEPTH<=32'h00000002) ?  1 :
                            (RAM_DEPTH<=32'h00000004) ?  2 :
                            (RAM_DEPTH<=32'h00000008) ?  3 :
                            (RAM_DEPTH<=32'h00000010) ?  4 :
                            (RAM_DEPTH<=32'h00000020) ?  5 :
                            (RAM_DEPTH<=32'h00000040) ?  6 :
                            (RAM_DEPTH<=32'h00000080) ?  7 :
                            (RAM_DEPTH<=32'h00000100) ?  8 :
                            (RAM_DEPTH<=32'h00000200) ?  9 :
                            (RAM_DEPTH<=32'h00000400) ? 10 :
                            (RAM_DEPTH<=32'h00000800) ? 11 :
                            (RAM_DEPTH<=32'h00001000) ? 12 :
                            (RAM_DEPTH<=32'h00002000) ? 13 :
                            (RAM_DEPTH<=32'h00004000) ? 14 :
                            (RAM_DEPTH<=32'h00008000) ? 15 :
                            (RAM_DEPTH<=32'h00010000) ? 16 :
                            (RAM_DEPTH<=32'h00020000) ? 17 :
                            (RAM_DEPTH<=32'h00040000) ? 18 :
                            (RAM_DEPTH<=32'h00080000) ? 19 :
                            (RAM_DEPTH<=32'h00100000) ? 20 :
                            (RAM_DEPTH<=32'h00200000) ? 21 :
                            (RAM_DEPTH<=32'h00400000) ? 22 :
                            (RAM_DEPTH<=32'h00800000) ? 23 :
                            (RAM_DEPTH<=32'h01000000) ? 24 :
                            (RAM_DEPTH<=32'h02000000) ? 25 :
                            (RAM_DEPTH<=32'h04000000) ? 26 :
                            (RAM_DEPTH<=32'h08000000) ? 27 :
                            (RAM_DEPTH<=32'h10000000) ? 28 :
                            (RAM_DEPTH<=32'h20000000) ? 29 :
                            (RAM_DEPTH<=32'h40000000) ? 30 :
                            (RAM_DEPTH<=32'h80000000) ? 31 : 32;
    localparam RAM_BYTES = RAM_WIDTH/8;
    
    input                   clka    ; // (i)
    input                   clkb    ; // (i)
    input                   wea     ; // (i)
    input  [ADDR_WIDTH-1:0] addra   ; // (iv)
    input  [RAM_WIDTH-1:0]  dina    ; // (iv)
    input                   enb     ; // (i)
    input  [ADDR_WIDTH-1:0] addrb   ; // (iv)
    output [RAM_WIDTH-1:0]  doutb   ; // (ov)
    
    //generate
    //if (RAM_TYPE==1) begin : u_xilinx
    /* The following is an instantiation template for xilinx_simple_dual_port_ram */
    xilinx_sdpram_dc_user #(
        .RAM_DEPTH(RAM_DEPTH),              // Specify RAM depth (number of entries)
        .RAM_WIDTH(RAM_WIDTH),              // Specify RAM data width
        .RAM_STYLE(RAM_TYPE),               // Set "block" or "distributed"
        .RAM_PERFORMANCE(RAM_PERFORMANCE),    // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("")                      // Specify name/location of RAM initialization file if using one (leave blank if not)
    ) u_xilinx_sdpram_dc (
        .addra  (addra),   // Write address bus, width determined from RAM_DEPTH
        .addrb  (addrb),   // Read address bus, width determined from RAM_DEPTH
        .dina   (dina),    // RAM input data, width determined from RAM_WIDTH
        .clka   (clka),    // Clocka
        .clkb   (clkb),    // Clocka
        .wea    (wea),     // Write enable
        .enb    (enb),	   // Read Enable, for additional power savings, disable when not in use
        //.rstn   (1'b1),    // reset (does not affect memory contents)
        //.regceb (1'b1),    // register enable
        .doutb  (doutb)    // RAM output data, width determined from RAM_WIDTH
    );



endmodule
