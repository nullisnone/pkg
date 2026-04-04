//--------------------------------------------------------------------------------
//  __   ___   _ ____  _   _ ____       Project     : ndpp_sim
//  \ \ / / | | / ___|| | | |  _ \      File        : axis_rx.v
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
`define LOCAL_PRINT_ENABLE

//--------------------------------------------------------------------------------
`timescale 1ps / 1ps    //`timescale 1ns / 1ps

module eth_rx  #(
	parameter           WORK_MODE 			= 0					                    ,//0:global, 1:local
    parameter           DATA_WIDTH          = 64                                    ,//32 64
    parameter           KEEP_WIDTH          = DATA_WIDTH / 8                        ,// 4  8
    parameter           USER_WIDTH          = 4                                     ,// 4
    parameter           DATA_DUTY           = 128                                   ,//128
    parameter           DATA_LENGTH         = 256                                   ,//256
    parameter           FILE_HANDLE_NAME    = "eth_rx_file.txt"                      //write and save

    )   (
    //---
	input      				                sys_clk								    ,
	input      				                sys_rst_n						        ,
    //---
	output wire				                axis_rx_tready						    ,
	input      			                    axis_rx_tvalid						    ,
	input       [DATA_WIDTH-1 : 0]          axis_rx_tdata						    ,
	input       [USER_WIDTH-1 : 0]          axis_rx_tuser						    ,
	input       [KEEP_WIDTH-1 : 0]          axis_rx_tkeep						    ,
	input       [KEEP_WIDTH-1 : 0]          axis_rx_tstrb						    ,
    input                                   axis_rx_tlast   
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
    //------axis_rx_tready
    reg                 local_axis_rx_tready                                    ;

    initial begin
        local_axis_rx_tready = 0;
        wait(sys_rst_n);
        #10;
        local_axis_rx_tready = 1;
    end

    assign axis_rx_tready = (!sys_rst_n)? 1'b0 : local_axis_rx_tready           ;
    
//--------------------------------------------------------------------------------
    //------axis_rx
    integer axis_rx_file                                                        ;

    initial begin
        //axis_rx_file = $fopen("axis_rx_file_save.txt", "w");
        axis_rx_file = $fopen(FILE_HANDLE_NAME, "w");

        `ifdef LOCAL_PRINT_ENABLE
        $display("%s is created.",FILE_HANDLE_NAME);
        `endif

        if (axis_rx_file == 0) begin
            $display("Failed to open axis_rx_file .");
            $stop(2);
            $finish;
        end
    end

    always @(posedge sys_clk) begin
        if (axis_rx_tvalid && axis_rx_tready) begin
            $fwrite(axis_rx_file, "%h\n", axis_rx_tdata);
        end
    end

//--------------------------------------------------------------------------------

endmodule
