//--------------------------------------------------------------------------------
//  __   ___   _ ____  _   _ ____       Project     : ndpp_sim
//  \ \ / / | | / ___|| | | |  _ \      File        : axis_tx.sv
//   \ V /| | | \___ \| | | | |_) |     Version     : 0.0.1
//    | | | |_| |___) | |_| |  _ <      Author      : 
//    |_|  \___/|____/ \___/|_| \_\     Date        : 2024-01-01
//                                      Description : NDPP Simulation Model
//--------------------------------------------------------------------------------
//------Verilog_Header(`define)
//`include "<path_to_vh>/NDPP_SIM.vh"
//`include "<path_to_vh>/NDPP.vh"
//`include "<path_to_vh>/USER.vh"
//------Define
`define GLOBAL_MODE
//`define LOCAL_MODE
//`define PRINT_ENABLE

//--------------------------------------------------------------------------------
`timescale 1ps / 1ps    //`timescale 1ns / 1ps

module axis_tx  #(
	parameter           WORK_MODE 			= 0					                    ,//0:global, 1:local
    parameter           DATA_WIDTH          = 64                                    ,//32 64
    parameter           KEEP_WIDTH          = DATA_WIDTH / 8                        ,// 4  8
    parameter           USER_WIDTH          = 4                                     ,// 4
    parameter           DATA_DUTY           = 128                                   ,//128
    parameter           DATA_LENGTH         = 256                                   ,//256
    parameter           DATA_HEADER_INIT    = 32'h5a01_0001                         ,//32'h5a01_0001 32'h5b01_0001 32'h5c01_0001 32'h5d01_0001
    parameter           FILE_HANDLE_NAME    = "axis_tx_file.txt"                     //read

    )   (
    //---
	input      				                sys_clk								    ,
	input      				                sys_rst_n						        ,
    //---
	input      				                axis_tx_tready						    ,
	output wire			                    axis_tx_tvalid						    ,
	output wire [DATA_WIDTH-1 : 0]          axis_tx_tdata						    ,
	output wire [USER_WIDTH-1 : 0]          axis_tx_tuser						    ,
	output wire [KEEP_WIDTH-1 : 0]          axis_tx_tkeep						    ,
	output wire [KEEP_WIDTH-1 : 0]          axis_tx_tstrb						    ,
    output wire                             axis_tx_tlast   
    );

//--------------------------------------------------------------------------------
    //------parameter
    localparam      LOCAL_DATA_DUTY         = 128                               ;
    localparam      LOCAL_DATA_LENGTH       = 256                               ;

    localparam      LOCAL_DATA_INIT0        = 32'h5a01_0001                     ;
    localparam      LOCAL_DATA_INIT1        = 32'h5b01_0001                     ;
    localparam      LOCAL_DATA_INIT2        = 32'h5c01_0001                     ;
    localparam      LOCAL_DATA_INIT3        = 32'h5d01_0001                     ;

    localparam      LOCAL_PERIOD_1US        = 32'd249                           ;//1us@250MHz
    localparam      LOCAL_PERIOD_100US      = 32'd249_99                        ;//1us@250MHz
    localparam      LOCAL_PERIOD_1MS        = 32'd249_999                       ;//1ms@250MHz
//--------------------------------------------------------------------------------
    reg                 local_axis_tx_tready                                    ;
    wire    [03:00]     local_axis_tx_tkeep                                     ;
    wire    [03:00]     local_axis_tx_tstrb                                     ;
    reg     [31:00]     data_cnt                                                ;
    //------DATA Duty Cycle: DATA_DUTY / DATA_LENGTH = xx%
    real                                    data_duty                           ;

    initial begin

        `ifdef GLOBAL_MODE
            data_duty = (real(DATA_DUTY) / real(DATA_LENGTH)) * 100;
        `else
            data_duty = (real(LOCAL_DATA_DUTY) / real(LOCAL_DATA_LENGTH)) * 100;
        `endif
        
        #100;

        `ifdef PRINT_ENABLE
            $display("DATA-DUTY-CYCLE(DATA_DUTY/DATA_LENGTH) is: %0f %%.", data_duty);
        `endif
    end
    //------
    initial begin
        local_axis_tx_tready = 0;
        data_cnt = 0;
        wait(sys_rst_n);
        #5_000;
    
        `ifdef GLOBAL_MODE
            local_axis_tx_tready = axis_tx_tready;
        `else
            local_axis_tx_tready = 1;
        `endif
    end
    
    always@(posedge sys_clk or negedge sys_rst_n)
    begin
        if(!sys_rst_n) begin
            data_cnt          <=  32'h0                                         ;
        end else if(local_axis_tx_tready)begin
            if(data_cnt == LOCAL_DATA_LENGTH) begin
                data_cnt      <=  32'h0                                         ;
            end else begin
                data_cnt      <=  data_cnt + 32'h1                              ;
            end
        end else begin
            data_cnt          <=  data_cnt                                      ;
        end
    end
    
    //------
    assign local_axis_tx_tkeep =  'hf                                           ;
    assign local_axis_tx_tstrb =  'h0                                           ;
    assign axis_tx_tvalid      = ((data_cnt >= 32'd1) && (data_cnt <= LOCAL_DATA_DUTY) && local_axis_tx_tready)? 1'b1 : 1'b0 ;
    assign axis_tx_tdata       = (!sys_rst_n)? 32'h0     :
                                 (axis_tx_tvalid)? {DATA_HEADER_INIT, data_cnt} : axis_tx_tdata ;
    assign axis_tx_tkeep       =  'hf                                           ;
    assign axis_tx_tstrb       =  'h0                                           ;
    assign axis_tx_tlast       = (data_cnt == LOCAL_DATA_DUTY)?  1'b1  : 1'b0   ;
    assign axis_tx_tuser       =  'h0                                           ;
/*  assign axis_tx_tuser       = {(USER_WIDTH-1){1'b0}, 1'b0}                   ;   */
    
//--------------------------------------------------------------------------------

endmodule
