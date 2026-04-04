//--------------------------------------------------------------------------------
//  __   ___   _ ____  _   _ ____       Project     : ndpp_sim
//  \ \ / / | | / ___|| | | |  _ \      File        : mac_top.v
//   \ V /| | | \___ \| | | | |_) |     Version     : 0.0.1
//    | | | |_| |___) | |_| |  _ <      Author      : 
//    |_|  \___/|____/ \___/|_| \_\     Date        : 2024-01-01
//                                      Description : NDPP Simulation Model
//--------------------------------------------------------------------------------
//------Verilog_Header(`define)
//`include "<path_to_vh>/NDPP_SIM.vh"
//`include "<path_to_vh>/USER.vh"
//`include "./verilog_header/NDPP_SIM.vh"
//------Define
`define GLOBAL_MODE
//`define LOCAL_MODE
//`define PRINT_ENABLE

//--------------------------------------------------------------------------------
`timescale 1ps / 1ps    //`timescale 1ns / 1ps

module mac_top #(
    parameter           TCQ                 = 0                                     ,//0ns = 0_000ps
    parameter           OFFSET              = 0                                     ,//used for keep the sys_clk_reg = 0 at the beginning.
    parameter           PERIOD              = 10000                                 ,//10.0ns = 10_000ps @ 100MHz
    parameter           HALFCYCLE           = PERIOD/2                              ,//05.0ns = 05_000ps @ 100MHz

    parameter           WORK_MODE           = 0                                     ,//0:global, 1:local
    parameter           CLOCK_MODE          = 0                                     ,//0:master, 1:slave
    parameter           DATA_WIDTH          = 64                                    ,//32 64
    parameter           KEEP_WIDTH          = DATA_WIDTH / 8                        ,// 4  8
    parameter           USER_WIDTH          = 4                                     ,// 4
    parameter           DATA_DUTY           = 128                                   ,//128
    parameter           DATA_LENGTH         = 256                                   ,//256
    
    parameter           DST_MAC_ADDR        = 48'h00_23_cd_76_63_1a                 ,
    parameter           SRC_MAC_ADDR        = 48'h00_23_cd_76_63_1b                 ,
    parameter           ETH_TYPE_LENGTH     = 16'h08_00                             ,
    parameter           IP_VERSION          =  4'h4                                 ,
    parameter           IP_HEADER_LENGTH    =  4'h5                                 ,
    parameter           IP_SERVICE_TYPE     =  8'h00                                ,
    parameter           IP_TOTAL_LENGTH     = 16'h003a                              ,
    parameter           IP_IDENTIFIER       = 16'h0001                              ,
    parameter           IP_FLAG             =  8'h00                                ,
    parameter           IP_OFFSET           =  8'h00                                ,
    parameter           IP_TTL              =  8'h40                                ,
    parameter           IP_PROTOCOL         =  8'h11                                ,//UDP
    parameter           IP_HEADER_CHECK_SUM = 16'hf635                              ,
    parameter           IP_SRC_IP           = 32'hc0_a8_01_64                       ,//192.168.1.200
    parameter           IP_DST_IP           = 32'hc0_a8_01_c8                       ,//192.168.1.100
    parameter           UDP_SRC_PORT        = 16'h03_e8                             ,//1000
    parameter           UDP_DST_PORT        = 16'h07_d0                             ,//2000
    parameter           UDP_LENGTH          = 16'h00_26                             ,
    parameter           UDP_CHECKSUM        = 16'h15_04                             ,

    parameter           FILE_HANDLE_TX      = "mac_tx_file.txt"                     ,
    parameter           FILE_HANDLE_RX      = "mac_rx_file.txt"                    
    )   (
    //---
    input                                   sys_clk                                 ,
    input                                   sys_rst_n                               ,
    //---
    input                                   axis_enable                             ,
    input                                   axis_loopback                           ,
    //---
    output wire                             axis_clk                                ,
    output wire                             axis_rst_n                              ,
    //---
    output wire                             axis_tx_clk                             ,
    output wire                             axis_tx_rst_n                           ,
    //---
    output reg                              axis_rx_clk                             ,
    output reg                              axis_rx_rst_n                           ,
    //---
    input                                   axis_tx_tready                          ,
    output wire                             axis_tx_tvalid                          ,
    output wire [DATA_WIDTH-1 : 0]          axis_tx_tdata                           ,
    output wire [USER_WIDTH-1 : 0]          axis_tx_tuser                           ,
    output wire [KEEP_WIDTH-1 : 0]          axis_tx_tkeep                           ,
    output wire [KEEP_WIDTH-1 : 0]          axis_tx_tstrb                           ,
    output wire                             axis_tx_tlast                           ,
    //---
    output wire                             axis_rx_tready                          ,
    input                                   axis_rx_tvalid                          ,
    input       [DATA_WIDTH-1 : 0]          axis_rx_tdata                           ,
    input       [USER_WIDTH-1 : 0]          axis_rx_tuser                           ,
    input       [KEEP_WIDTH-1 : 0]          axis_rx_tkeep                           ,
    input       [KEEP_WIDTH-1 : 0]          axis_rx_tstrb                           ,
    input                                   axis_rx_tlast                           ,
    //---
    output wire                             sys_clk_locked                          

    );

//--------------------------------------------------------------------------------
    //------parameters
    /*
    parameter           TCQ                 = 0                                     ;//0ns = 0_000ps
    parameter           OFFSET              = 0                                     ;//used for keep the sys_clk_reg = 0 at the beginning.
    parameter           PERIOD              = 10000                                 ;//10.0ns = 10_000ps @ 100MHz
    parameter           HALFCYCLE           = PERIOD/2                              ;//05.0ns = 05_000ps @ 100MHz

    parameter           WORK_MODE           = 0                                     ;//0:global, 1:local
    parameter           DATA_WIDTH          = 64                                    ;//32 64
    parameter           KEEP_WIDTH          = BAR1_DATA_WIDTH / 8                   ;//4
    parameter           USER_WIDTH          = 4                                     ;//4
    parameter           DATA_DUTY           = 128                                   ;//128
    parameter           DATA_LENGTH         = 256                                   ;//256
    parameter           DATA_INIT0          = 32'h5a01_0001                         ;//32'h5a01_0001
    parameter           DATA_INIT1          = 32'h5b01_0001                         ;//32'h5b01_0001
    parameter           DATA_INIT2          = 32'h5c01_0001                         ;//32'h5c01_0001
    parameter           DATA_INIT3          = 32'h5d01_0001                         ;//32'h5d01_0001
    */
    //-------
    wire                                    local_sys_clk                           ;
    wire                                    local_sys_rst_n                         ;

//  assign axis_clk     =    sys_clk                                                ;
//  assign axis_rst_n   =   (sys_clk_locked)? sys_rst_n : 1'b0                      ;
    assign axis_clk     = (CLOCK_MODE)? sys_clk : local_sys_clk                     ;
    assign axis_rst_n   = (CLOCK_MODE)? sys_rst_n :
                                        (sys_clk_locked)? local_sys_rst_n : 1'b0    ;

    assign axis_tx_clk          =   axis_clk                                        ;
    assign axis_tx_rst_n        =   axis_rst_n && axis_enable                       ;

    always #TCQ axis_rx_clk     = ~ axis_clk                                        ;//reg
    always #TCQ axis_rx_rst_n   =   axis_rst_n && axis_enable                       ;//reg
//  assign axis_rx_clk      =   axis_clk                                            ;
//  assign axis_rx_rst_n    =   axis_rst_n                                          ;
//--------------------------------------------------------------------------------
    //------sys_clk_locked
    initial begin
        //$timeformat(DISPLAY_UNIT,DISPLAY_FRACTION,DISPLAY_MESSAGE,DISPLAY_DEPTH);
        #1_100;
        
        `ifdef PRINT_ENABLE
            $display("INFO: ......................................");
            @(posedge sys_clk_locked)
            $display ("%t: %m: System-Clock is locked", $time);
            $display("INFO: ......................................");
        `endif
    end
//--------------------------------------------------------------------------------
    //------DATA Duty Cycle: DATA_DUTY / DATA_LENGTH = xx%
    real                                    data_duty                               ;

    initial begin

        `ifdef GLOBAL_MODE
            data_duty = (real(DATA_DUTY) / real(DATA_LENGTH)) * 100;
        `else
            data_duty = (real(u_axis_tx.LOCAL_DATA_DUTY) / real(u_axis_tx.LOCAL_DATA_LENGTH)) * 100;
        `endif

        #100;

        `ifdef PRINT_ENABLE
            $display("DATA-DUTY-CYCLE(DATA_DUTY/DATA_LENGTH) is: %0f %%.", data_duty);
        `endif
    end
//--------------------------------------------------------------------------------
    //------u_sys_clk_gen
    sys_clk_gen #(
    .OFFSET                                 (OFFSET                                 ),
    .PERIOD                                 (PERIOD                                 )
    )   u_sys_clk_gen (
    .sys_clk                                (local_sys_clk                          ),//O
    .sys_clk_locked                         (sys_clk_locked                         ),//O
    .sys_rst_n                              (local_sys_rst_n                        ) //O
    );

    //------u_axis_tx
    mac_tx #(
    .WORK_MODE                              (WORK_MODE                              ),//0:global, 1:local
    .DATA_WIDTH                             (DATA_WIDTH                             ),//32
    .KEEP_WIDTH                             (KEEP_WIDTH                             ),//4
    .USER_WIDTH                             (USER_WIDTH                             ),//4
    .DATA_DUTY                              (DATA_DUTY                              ),//128
    .DATA_LENGTH                            (DATA_LENGTH                            ),//256
    
    .DST_MAC_ADDR                           (DST_MAC_ADDR                           ),
    .SRC_MAC_ADDR                           (SRC_MAC_ADDR                           ),
    .ETH_TYPE_LENGTH                        (ETH_TYPE_LENGTH                        ),
    .IP_VERSION                             (IP_VERSION                             ),
    .IP_HEADER_LENGTH                       (IP_HEADER_LENGTH                       ),
    .IP_SERVICE_TYPE                        (IP_SERVICE_TYPE                        ),
    .IP_TOTAL_LENGTH                        (IP_TOTAL_LENGTH                        ),
    .IP_IDENTIFIER                          (IP_IDENTIFIER                          ),
    .IP_FLAG                                (IP_FLAG                                ),
    .IP_OFFSET                              (IP_OFFSET                              ),
    .IP_TTL                                 (IP_TTL                                 ),
    .IP_PROTOCOL                            (IP_PROTOCOL                            ),
    .IP_HEADER_CHECK_SUM                    (IP_HEADER_CHECK_SUM                    ),
    .IP_SRC_IP                              (IP_SRC_IP                              ),
    .IP_DST_IP                              (IP_DST_IP                              ),
    .UDP_SRC_PORT                           (UDP_SRC_PORT                           ),
    .UDP_DST_PORT                           (UDP_DST_PORT                           ),
    .UDP_LENGTH                             (UDP_LENGTH                             ),
    .UDP_CHECKSUM                           (UDP_CHECKSUM                           ),

    .FILE_HANDLE_NAME                       (FILE_HANDLE_TX                         ) //("mac_tx_file.txt"                     )
    )   u_mac_tx(
    //---
    .sys_clk                                (axis_clk                               ),//I
    .sys_rst_n                              (axis_rst_n && axis_enable              ),//I
    //---
    .axis_tx_tready                         (axis_tx_tready                         ),//I
    .axis_tx_tvalid                         (axis_tx_tvalid                         ),//O
    .axis_tx_tdata                          (axis_tx_tdata                          ),//O
    .axis_tx_tuser                          (axis_tx_tuser                          ),//O
    .axis_tx_tkeep                          (axis_tx_tkeep                          ),//O
    .axis_tx_tstrb                          (axis_tx_tstrb                          ),//O
    .axis_tx_tlast                          (axis_tx_tlast                          ) //O
    );
    
    //------u_axis_rx
    mac_rx #(
    .WORK_MODE                              (WORK_MODE                              ),//0:global, 1:local
    .DATA_WIDTH                             (DATA_WIDTH                             ),//32
    .KEEP_WIDTH                             (KEEP_WIDTH                             ),//4
    .USER_WIDTH                             (USER_WIDTH                             ),//4
    .FILE_HANDLE_NAME                       (FILE_HANDLE_RX                         ) //("mac_rx_file.txt"                     )
    )   u_mac_rx(
    //---
    .sys_clk                                (axis_clk                               ),//I
    .sys_rst_n                              (axis_rst_n && axis_enable              ),//I
    //---
    .axis_rx_tready                         (axis_rx_tready                         ),//O
    .axis_rx_tvalid                         (axis_rx_tvalid                         ),//I
    .axis_rx_tdata                          (axis_rx_tdata                          ),//I
    .axis_rx_tuser                          (axis_rx_tuser                          ),//I
    .axis_rx_tkeep                          (axis_rx_tkeep                          ),//I
    .axis_rx_tstrb                          (axis_rx_tstrb                          ),//I
    .axis_rx_tlast                          (axis_rx_tlast                          ) //I
    );
    
//--------------------------------------------------------------------------------

endmodule
