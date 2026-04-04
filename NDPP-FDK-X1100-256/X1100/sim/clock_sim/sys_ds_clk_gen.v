//--------------------------------------------------------------------------------
//  __   ___   _ ____  _   _ ____       Project     : ndpp_sim
//  \ \ / / | | / ___|| | | |  _ \      File        : sys_ds_clk_gen.sv
//   \ V /| | | \___ \| | | | |_) |     Version     : 0.0.1
//    | | | |_| |___) | |_| |  _ <      Author      : 
//    |_|  \___/|____/ \___/|_| \_\     Date        : 2024-01-01
//                                      Description : system differential clock generator
//--------------------------------------------------------------------------------
//------Verilog_Header(`define)
//`include "<path_to_vh>/NDPP_SIM.vh"
//`include "<path_to_vh>/NDPP.vh"
//`include "<path_to_vh>/USER.vh"
//------Define
`define GLOBAL_PARAM
//`define LOCAL_PARAM

//------clock mode : Differential-Clock, Independent-Clock
//    Abbreviation : DIFF-CLK, INDIES-CLK/IND-CLK
//    Differential-Clock : sys_clk_p and sys_clk_n are differential clock pair (default)
//    Independent-Clock  : sys_clk_p and sys_clk_n are independent clock

`define DIFF_CLK_MODE

`ifndef DIFF_CLK_MODE
    `define IND_CLK_MODE
`endif
//--------------------------------------------------------------------------------

`timescale 1ps/1ps

module sys_ds_clk_gen (
    output wire             sys_clk_p                           ,

`ifdef DIFF_CLK_MODE
    output wire             sys_clk_n                           ,
`elsif IND_CLK_MODE
    output reg              sys_clk_n                           ,
`else
    output wire             sys_clk_n                           ,
`endif

    output wire             sys_clk_locked                      ,
    output wire             sys_rst_n                       
    );
//--------------------------------------------------------------------------------
    //------parameters
    parameter           TCQ                 = 0                 ;//0ns = 0_000ps
    parameter           OFFSET              = 0                 ;//used for keep the sys_clk_reg = 0 at the beginning.
    parameter           PERIOD              = 10000             ;//10.0ns = 10_000ps @ 100MHz
    parameter           HALFCYCLE           = PERIOD/2          ;//05.0ns = 05_000ps @ 100MHz

    //------instantiation
    sys_clk_gen #(
    .OFFSET                 ( OFFSET                            ),
    .PERIOD                 ( PERIOD                            )
    )   u_ds_clk_gen (
    .sys_clk                (sys_clk_p                          ),
    .sys_clk_locked         (sys_clk_locked                     ),
    .sys_rst_n              (sys_rst_n                          )
    );
    //------
`ifdef DIFF_CLK_MODE
    assign sys_clk_n =  ~sys_clk_p                               ;//wire
`elsif IND_CLK_MODE
    initial begin
        sys_clk_n = 1'b1                                         ;//reg
    end
    always #TCQ sys_clk_n = ~sys_clk_p                           ;//reg
    //always sys_clk_n = #TCQ ~sys_clk_p                         ;//reg    There is something wrong with this always block.
`else
    assign sys_clk_n =  ~sys_clk_p                               ;//wire
`endif

endmodule // sys_ds_clk_gen
