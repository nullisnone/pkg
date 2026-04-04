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

module eth_tx  #(
    parameter           WORK_MODE           = 0                                     ,//0:global, 1:local
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

    parameter           FILE_HANDLE_NAME    = "eth_tx_file.txt"                      //read

    )   (
    //---
    input                                   sys_clk                                 ,
    input                                   sys_rst_n                               ,
    //---
    input                                   axis_tx_tready                          ,
    output wire                             axis_tx_tvalid                          ,
    output wire [DATA_WIDTH-1 : 0]          axis_tx_tdata                           ,
    output wire [USER_WIDTH-1 : 0]          axis_tx_tuser                           ,
    output wire [KEEP_WIDTH-1 : 0]          axis_tx_tkeep                           ,
    output wire [KEEP_WIDTH-1 : 0]          axis_tx_tstrb                           ,
    output wire                             axis_tx_tlast   
    );

//--------------------------------------------------------------------------------
    //------parameter
    localparam      LOCAL_DATA_DUTY         = 128                               ;
    localparam      LOCAL_DATA_LENGTH       = 256                               ;
    
    localparam      LOCAL_UDP_DATA_DUTY     = 128                               ;
    localparam      LOCAL_UDP_DATA_LENGTH   = 256                               ;
    //------FRAME PREAMBLE(PREAMBLE + SFD)
    parameter       PREAMBLE_SFD_PART0      = 32'h5555_5555                     ;//7 Byte
    parameter       PREAMBLE_SFD_PART1      = 32'h5555_555d                     ;//7 Byte   SFD(start of frame delimiter)
    //------IP_HEADER   42Bytes
    /*
    //---udp-pheader
    //  00-23-cd-76-63-1a               //dst_mac
    //  00-23-cd-76-63-1b               //src_mac
    //  08 00                           //协议字节
    //  45                              //版本和首部长度
    //  00                              //服务类型
    //  00 3a                           //总长度   16bit-total_length
    //  00 01                           //标识符
    //  00 00                           //标记和偏移
    //  40                              //存活时间
    //  11                              //协议              0x11 = UDP
    //  f6 35                           //首部校验和/CRC校验和
    //  c0 a8 01 64                     //src_ip            192.168.1.100
    //  c0 a8 01 c8                     //dst_ip            192.168.1.200
    //  03 e8                           //udp_src_port      1000
    //  07 d0                           //udp_dst_port      2000
    //  00 26                   //udp_length:     0x0026 = 38 = udp_header(8byte) + udp_payload(30)
    //  15 04                   //udp_checksum:  0x1504
    //  ASCII-DATA              //udp_data/udp_payload
    */
    /*
    parameter       DST_MAC_ADDR			= 48'h00_23_cd_76_63_1a				;
    parameter       SRC_MAC_ADDR			= 48'h00_23_cd_76_63_1b				;
    parameter       ETH_TYPE_LENGTH			= 16'h08_00							;
    parameter       IP_VERSION				=  4'h4								;//parameter    IP_VERSION_HEADER_LENGTH = 16'h45 ;
    parameter       IP_HEADER_LENGTH		=  4'h5								;
    parameter       IP_SERVICE_TYPE			=  8'h00							;
    parameter       IP_TOTAL_LENGTH			= 16'h003a							;
    parameter       IP_IDENTIFIER			= 16'h0001							;
    parameter       IP_FLAG					=  8'h00							;
    parameter       IP_OFFSET				=  8'h00							;
    parameter       IP_TTL					=  8'h40							;
    parameter       IP_PROTOCOL				=  8'h11							;
    parameter       IP_HEADER_CHECK_SUM		= 16'hf635							;
    parameter       IP_SRC_IP				= 32'hc0_a8_01_64					;
    parameter       IP_DST_IP				= 32'hc0_a8_01_c8					;
    parameter       UDP_SRC_PORT			= 16'h03_e8							;
    parameter       UDP_DST_PORT			= 16'h07_d0							;
    parameter       UDP_LENGTH				= 16'h00_26							;
    parameter       UDP_CHECKSUM			= 16'h15_04							;
    */
    //------UDP_PAYLOAD 30-Bytes
    parameter       UDP_PAYLOAD_01          = 32'h30_31_32_33                   ;//0123
    parameter       UDP_PAYLOAD_02          = 32'h34_35_36_37                   ;//4567
    parameter       UDP_PAYLOAD_03          = 32'h38_39_41_42                   ;//89AB
    parameter       UDP_PAYLOAD_04          = 32'h43_44_45_46                   ;//CDEF
    parameter       UDP_PAYLOAD_05          = 32'h47_48_49_4A                   ;//GHIJ
    parameter       UDP_PAYLOAD_06          = 32'h61_62_63_64                   ;//abcd
    parameter       UDP_PAYLOAD_07          = 32'h65_66_67_68                   ;//efgh
    parameter       UDP_PAYLOAD_08          = 16'h69_6a                         ;//ij

    //------
    reg     [31:00]     local_data_cnt                                          ;
    reg                 local_axis_tx_tready                                    ;
    reg     [00:00]     local_axis_tx_tvalid                                    ;
    reg     [31:00]     local_axis_tx_tdata                                     ;
    wire    [03:00]     local_axis_tx_tstrb                                     ;
    wire    [03:00]     local_axis_tx_tkeep                                     ;
    reg     [00:00]     local_axis_tx_tlast  = 0                                ;

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
        local_data_cnt = 0;
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
            local_data_cnt          <=  32'h0                                   ;
        end else if(local_axis_tx_tready)begin
            if(local_data_cnt == LOCAL_DATA_LENGTH) begin
                local_data_cnt      <=  32'h0                                   ;
            end else begin
                local_data_cnt      <=  local_data_cnt + 32'h1                  ;
            end
        end else begin
            local_data_cnt          <=  local_data_cnt                          ;
        end
    end
    
    
    always@(posedge sys_clk or negedge sys_rst_n)
    if(!sys_rst_n)
        local_axis_tx_tdata <=   32'd0;
    else begin
        case(local_data_cnt)
            //------FRAME PREAMBLE(PREAMBLE + SFD)
             1: local_axis_tx_tdata      <=   PREAMBLE_SFD_PART0                                    ;//32'h5555_5555;   //前导码
             2: local_axis_tx_tdata      <=   PREAMBLE_SFD_PART1                                    ;//32'h5555_555d;   //前导码 + 分隔符0xd
            //------IP_HEADER   42Bytes
             3: local_axis_tx_tdata      <=   DST_MAC_ADDR[47:16]                                   ;
             4: local_axis_tx_tdata      <=   {DST_MAC_ADDR[15:00], SRC_MAC_ADDR[47:32]}            ;
             5: local_axis_tx_tdata      <=   SRC_MAC_ADDR[31:00]                                   ;
             6: local_axis_tx_tdata      <=   {ETH_TYPE_LENGTH, IP_VERSION, IP_HEADER_LENGTH, IP_SERVICE_TYPE};
             7: local_axis_tx_tdata      <=   {IP_TOTAL_LENGTH, IP_IDENTIFIER}                      ;
             8: local_axis_tx_tdata      <=   {IP_FLAG, IP_OFFSET, IP_TTL, IP_PROTOCOL}             ;
             9: local_axis_tx_tdata      <=   {IP_HEADER_CHECK_SUM, IP_SRC_IP[31:16]}               ;
            10: local_axis_tx_tdata      <=   {IP_SRC_IP[15:00], IP_DST_IP[31:16]}                  ;
            11: local_axis_tx_tdata      <=   {IP_DST_IP[15:00], UDP_SRC_PORT}                      ;
            12: local_axis_tx_tdata      <=   {UDP_DST_PORT, UDP_LENGTH}                            ;
            //------UDP_PAYLOAD 30-Bytes
            13: local_axis_tx_tdata      <=   {UDP_CHECKSUM, UDP_PAYLOAD_01[31:16]}                 ;//xx01
            14: local_axis_tx_tdata      <=   {UDP_PAYLOAD_01[15:00], UDP_PAYLOAD_02[31:16]}        ;//2345
            15: local_axis_tx_tdata      <=   {UDP_PAYLOAD_02[15:00], UDP_PAYLOAD_03[31:16]}        ;//6789
            16: local_axis_tx_tdata      <=   {UDP_PAYLOAD_03[15:00], UDP_PAYLOAD_04[31:16]}        ;//ABCD
            17: local_axis_tx_tdata      <=   {UDP_PAYLOAD_04[15:00], UDP_PAYLOAD_05[31:16]}        ;//EFGH
            18: local_axis_tx_tdata      <=   {UDP_PAYLOAD_05[15:00], UDP_PAYLOAD_06[31:16]}        ;//IJab
            19: local_axis_tx_tdata      <=   {UDP_PAYLOAD_06[15:00], UDP_PAYLOAD_07[31:16]}        ;//cdef
            20: local_axis_tx_tdata      <=   {UDP_PAYLOAD_07[15:00], UDP_PAYLOAD_08       }        ;//ghij

            default: 
            local_axis_tx_tdata          <=   32'd0;
        endcase
    end

    always@(posedge sys_clk or negedge sys_rst_n)
    if(!sys_rst_n)
        local_axis_tx_tvalid <=   1'b0;
    else if(local_axis_tx_tready) begin
        case(local_data_cnt)
            1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20:
            local_axis_tx_tvalid         <=   1'b1;

            default: 
            local_axis_tx_tvalid         <=   1'b0;
        endcase
    end

    always@(posedge sys_clk or negedge sys_rst_n)
    if(!sys_rst_n)
        local_axis_tx_tlast <=   1'b0;
    else begin
        case(local_data_cnt)
            20:
            local_axis_tx_tlast          <=   1'b1;

            default: 
            local_axis_tx_tlast          <=   1'b0;
        endcase
    end

    //------
    assign local_axis_tx_tkeep =  'hf                                           ;
    assign local_axis_tx_tstrb =  'h0                                           ;
    assign axis_tx_tvalid      = (local_axis_tx_tvalid && local_axis_tx_tready)? 1'b1 : 1'b0 ;
    assign axis_tx_tdata       = (!sys_rst_n)? 32'h0     :
                                             (axis_tx_tvalid)? local_axis_tx_tdata  : axis_tx_tdata ;
    assign axis_tx_tkeep       = 4'hf                                           ;
    assign axis_tx_tstrb       =  'h0                                           ;
    assign axis_tx_tlast       = local_axis_tx_tlast             ;
    assign axis_tx_tuser       =  'h0                                           ;
/*  assign axis_tx_tuser       = {(USER_WIDTH-1){1'b0}, 1'b0}                   ;   */
//--------------------------------------------------------------------------------

endmodule
