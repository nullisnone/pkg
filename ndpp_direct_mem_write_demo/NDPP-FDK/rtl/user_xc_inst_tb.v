`timescale 1ns / 1ps

module user_xc_inst_tb();
    //------------------------------------------------------------------------
    //------BAR-2
    //        |---ADDR: 64-bits (0x0000_0000_0000_0000 ~ 0x0000_0000_0030_0000)
    //        |            |---3MBytes: 0x0000_0000_0000_0000 ~ 0x0000_0000_002f_ffff   //RESERVED(USER-DMA)
    //        |            |---1MBytes: 0x0000_0000_0030_0000 ~ 0x0000_0000_0040_0000   //NATIVE MEM IF
    //        |---DATA: 256-bits
    //        |---STRB: 32-bits
    //------------------------------------------------------------------------
    //------DATA[255:0] = {CMD[63:00], XC_GEAR[63:00], XC_STOCKS[127:00]}
    //        |
    //        |---CMD[63:00]        = {16'h5a01, 48'hffff_ffff_ffff}
    //        |           |---16'h5a01: command for user logic;                                                                   //DATA[255:240]  STRB[31:30]
    //        |           |---48'hffff_ffff_ffff: reserved;                                                                       //DATA[239:192]  STRB[29:24]
    //        |
    //        |---XC_GEAR[63:00]    = {1'b0,xc_gear_reg15,    1'b0,xc_gear_reg14,    1'b0,xc_gear_reg13,    1'b0,xc_gear_reg12,
    //        |                        1'b0,xc_gear_reg11,    1'b0,xc_gear_reg10,    1'b0,xc_gear_reg9,     1'b0,xc_gear_reg8,
    //        |                        1'b0,xc_gear_reg7,     1'b0,xc_gear_reg6,     1'b0,xc_gear_reg5,     1'b0,xc_gear_reg4,
    //        |                        1'b0,xc_gear_reg3,     1'b0,xc_gear_reg2,     1'b0,xc_gear_reg1,     1'b0,xc_gear_reg0}    //DATA[191:128]  STRB[23:16]
    //        |
    //        |---XC_STOCKS[127:00] = {1'b0,xc_stocks_reg15,  1'b0,xc_stocks_reg14,  1'b0,xc_stocks_reg13,  1'b0,xc_stocks_reg12,
    //        |                        1'b0,xc_stocks_reg11,  1'b0,xc_stocks_reg10,  1'b0,xc_stocks_reg9,   1'b0,xc_stocks_reg8,
    //        |                        1'b0,xc_stocks_reg7,   1'b0,xc_stocks_reg6,   1'b0,xc_stocks_reg5,   1'b0,xc_stocks_reg4,
    //        |                        1'b0,xc_stocks_reg3,   1'b0,xc_stocks_reg2,   1'b0,xc_stocks_reg1,   1'b0,xc_stocks_reg0}  //DATA[127: 00]  STRB[15:00]
    //------------------------------------------------------------------------
    //[256-bits]:   16-bits      48-bits     64-bits    128-bits
    //------DATA: 255 : 240    239 : 192   191 : 128   127 : 0
    //------STRB:  31 :  30     29 : 24     23 : 16     15 : 0
    //------------------------------------------------------------------------
    //------------------------------------------------------------------------
    //------parameter
    parameter   XC_ARRAY_DEPTH              = 16'd16                            ;
    parameter   XC_GEAR_WIDTH               = 16'd3                             ;
    parameter   XC_STOCKS_WIDTH             = 16'd7                             ;
    //------localparam
    localparam  LOCAL_OFFSET                =   0                               ;//used for keep the sys_clk = 0 at the beginning.
    localparam  LOCAL_PERIOD                =   4                               ;//10.0ns @ 100MHz; 4ns @ 250MHz;
    localparam  LOCAL_DATA_DUTY             = 128                               ;
    localparam  LOCAL_DATA_LENGTH           = 256                               ;

    localparam  LOCAL_DATA_INIT0            = 32'h5a01_0001                     ;
    localparam  LOCAL_DATA_INIT1            = 32'h5b01_0001                     ;
    localparam  LOCAL_DATA_INIT2            = 32'h5c01_0001                     ;
    localparam  LOCAL_DATA_INIT3            = 32'h5d01_0001                     ;

    localparam  MEM_BASE_ADDRESS            = 64'h0000_0000_0030_0000           ;
    localparam  DELAY_TO_STOP               = 32'd1_000                         ;//1us @ 1ns
    localparam  DELAY_TO_FINISH             = 32'd5_000                         ;//5us @ 1ns
    //------ clk and rst_n
    reg                                     pcie_axi_clk                        ;
    reg                                     pcie_axi_resetn                     ;
    //------NATIVE MEM IF
    wire                                    user_logic_native_mem_valid         ;
    reg  [63:0]                             user_logic_native_mem_address       ;//0x0000_0000_0030_0000 ~ 0x0000_0000_003f_ffff
    reg  [255:0]                            user_logic_native_mem_data          ;
    wire [31:0]                             user_logic_native_mem_strb          ;
    //------xc_gear
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_0                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_1                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_2                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_3                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_4                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_5                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_6                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_7                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_8                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_9                           ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_10                          ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_11                          ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_12                          ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_13                          ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_14                          ;
    wire [XC_GEAR_WIDTH - 1:00]             xc_gear_15                          ;
    //------xc_gear
    //wire [XC_GEAR_WIDTH-1:0]                xc_gear_0 , xc_gear_1 , xc_gear_2 , xc_gear_3 ,
    //                                        xc_gear_4 , xc_gear_5 , xc_gear_6 , xc_gear_7 ,
    //                                        xc_gear_8 , xc_gear_9 , xc_gear_10, xc_gear_11,
    //                                        xc_gear_12, xc_gear_13, xc_gear_14, xc_gear_15;
    //------xc_stocks
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_0                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_1                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_2                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_3                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_4                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_5                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_6                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_7                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_8                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_9                         ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_10                        ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_11                        ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_12                        ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_13                        ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_14                        ;
    wire [XC_STOCKS_WIDTH - 1:00]           xc_stocks_15                        ;
    //------xc_stocks
    //wire [XC_STOCKS_WIDTH-1:0]              xc_stocks_0 , xc_stocks_1 , xc_stocks_2 , xc_stocks_3 ,
    //                                        xc_stocks_4 , xc_stocks_5 , xc_stocks_6 , xc_stocks_7 ,
    //                                        xc_stocks_8 , xc_stocks_9 , xc_stocks_10, xc_stocks_11,
    //                                        xc_stocks_12, xc_stocks_13, xc_stocks_14, xc_stocks_15;
    //------data_cnt
    reg                 data_cnt_en                                             ;
    reg     [31:00]     data_cnt                                                ;
    //------------------------------------------------------------------------
    //------pcie_axi_clk
    initial begin
    pcie_axi_clk        = 1'b0;

    data_cnt = 'h0;
    user_logic_native_mem_address = 'h0;
    user_logic_native_mem_data = 'h0;
    end

    always begin
        #(LOCAL_PERIOD/2) pcie_axi_clk = ~pcie_axi_clk  ;
    end
    //------pcie_axi_resetn
    initial begin
    pcie_axi_resetn     = 1'b1  ;
    data_cnt_en         = 1'b0  ;
    #1000;
    pcie_axi_resetn     = 1'b0  ;
    #(500*LOCAL_PERIOD + LOCAL_OFFSET);
    pcie_axi_resetn     = 1'b1  ;
    #100;
    data_cnt_en         = 1'b1  ;
    end

    //------stop_and_finish
    initial begin
        //---10us to stop
        #(10*DELAY_TO_STOP);
        $display ("%t: %m: Stop simulation.", $time);
        $stop();//2us

        //---5us to finish
        #(1*DELAY_TO_FINISH);
        $display ("%t: %m: Finish simulation.", $time);
        $finish();//5us

        //---10us to finish
        #(2*DELAY_TO_FINISH);
        $display ("%t: %m: Finish simulation.", $time);
        $finish();//10us
    end
    //------------------------------------------------------------------------
    //------
    always@(posedge pcie_axi_clk or negedge pcie_axi_resetn)
    begin
        if(!pcie_axi_resetn) begin
            data_cnt          <=  32'h0                                         ;
        end else if(data_cnt_en)begin
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
    assign  user_logic_native_mem_valid = ((data_cnt_en == 1'b1) && (data_cnt == LOCAL_DATA_LENGTH))? 1'b1 : 1'b0;
    assign  user_logic_native_mem_strb  = (user_logic_native_mem_valid)? 32'hffff_ffff : 32'h0;
//  assign  user_logic_native_mem_data  = (!pcie_axi_resetn)? 256'h0 :
//                                        (user_logic_native_mem_valid)? {LOCAL_DATA_INIT0, LOCAL_DATA_INIT1, LOCAL_DATA_INIT2, LOCAL_DATA_INIT3} : 256'h0;
    
    //------
    always@(posedge pcie_axi_clk or negedge pcie_axi_resetn) begin
    if(!pcie_axi_resetn) begin
        user_logic_native_mem_address <= MEM_BASE_ADDRESS                       ;//64'h0000_0000_0030_0000
    end else if(user_logic_native_mem_valid) begin
        user_logic_native_mem_address <= user_logic_native_mem_address + 64'h8  ;
    end else begin
        user_logic_native_mem_address <= user_logic_native_mem_address          ;
    end
    end
    always@(posedge pcie_axi_clk or negedge pcie_axi_resetn) begin
    if(!pcie_axi_resetn) begin
        //user_logic_native_mem_data      <= 256'h0                               ;
        user_logic_native_mem_data      <=  {
                                            16'h5a01, 48'hffff_ffff_ffff,
                                            1'b0,u_user_xc_inst.XC_GEAR_0,   1'b0,u_user_xc_inst.XC_GEAR_1,   1'b0,u_user_xc_inst.XC_GEAR_2,   1'b0,u_user_xc_inst.XC_GEAR_3,
                                            1'b0,u_user_xc_inst.XC_GEAR_4,   1'b0,u_user_xc_inst.XC_GEAR_5,   1'b0,u_user_xc_inst.XC_GEAR_6,   1'b0,u_user_xc_inst.XC_GEAR_7,
                                            1'b0,u_user_xc_inst.XC_GEAR_8,   1'b0,u_user_xc_inst.XC_GEAR_9,   1'b0,u_user_xc_inst.XC_GEAR_A,   1'b0,u_user_xc_inst.XC_GEAR_B,
                                            1'b0,u_user_xc_inst.XC_GEAR_C,   1'b0,u_user_xc_inst.XC_GEAR_D,   1'b0,u_user_xc_inst.XC_GEAR_E,   1'b0,u_user_xc_inst.XC_GEAR_F,
                                            1'b0,u_user_xc_inst.XC_STOCKS_0, 1'b0,u_user_xc_inst.XC_STOCKS_1, 1'b0,u_user_xc_inst.XC_STOCKS_2, 1'b0,u_user_xc_inst.XC_STOCKS_3,
                                            1'b0,u_user_xc_inst.XC_STOCKS_4, 1'b0,u_user_xc_inst.XC_STOCKS_5, 1'b0,u_user_xc_inst.XC_STOCKS_6, 1'b0,u_user_xc_inst.XC_STOCKS_7,
                                            1'b0,u_user_xc_inst.XC_STOCKS_8, 1'b0,u_user_xc_inst.XC_STOCKS_9, 1'b0,u_user_xc_inst.XC_STOCKS_A, 1'b0,u_user_xc_inst.XC_STOCKS_B,
                                            1'b0,u_user_xc_inst.XC_STOCKS_C, 1'b0,u_user_xc_inst.XC_STOCKS_D, 1'b0,u_user_xc_inst.XC_STOCKS_E, 1'b0,u_user_xc_inst.XC_STOCKS_F
                                            } ;
    end else if(user_logic_native_mem_valid) begin
        user_logic_native_mem_data      <=  {
                                            {user_logic_native_mem_data[255:240] + 16'h1}, 48'hffff_ffff_ffff,
                                            {1'b0,{user_logic_native_mem_data[190:188] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[186:184] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[182:180] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[178:176] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[174:172] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[170:168] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[166:164] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[162:160] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[158:156] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[154:152] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[150:148] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[146:144] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[142:140] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[138:136] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[134:132] + 3'h1}},
                                            {1'b0,{user_logic_native_mem_data[130:128] + 3'h1}},

                                            {1'b0,{user_logic_native_mem_data[126:120] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[118:112] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[110:104] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[102:096] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[094:088] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[086:080] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[078:072] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[070:064] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[062:056] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[054:048] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[046:040] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[038:032] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[030:024] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[022:016] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[014:008] + 7'h1}},
                                            {1'b0,{user_logic_native_mem_data[006:000] + 7'h1}}
                                            };
    end else begin
        user_logic_native_mem_data      <= user_logic_native_mem_data           ;
    end
    end

    //------------------------------------------------------------------------

    //------
    user_xc_inst #(
    .XC_ARRAY_DEPTH                         ( XC_ARRAY_DEPTH                    ),
    .XC_GEAR_WIDTH                          ( XC_GEAR_WIDTH                     ),
    .XC_STOCKS_WIDTH                        ( XC_STOCKS_WIDTH                   )
    )                               u_user_xc_inst(
    //---
    .sys_clk                                ( pcie_axi_clk                      ),//I 250MHz
    .sys_rstn                               ( pcie_axi_resetn                   ),//I
    //---Native Mem IF
    .user_logic_native_mem_valid            ( user_logic_native_mem_valid       ),//I
    .user_logic_native_mem_address          ( user_logic_native_mem_address     ),//I
    .user_logic_native_mem_data             ( user_logic_native_mem_data        ),//I
    .user_logic_native_mem_strb             ( user_logic_native_mem_strb        ),//I
    //---xc_gear
    .xc_gear_0                              ( xc_gear_0                         ),//O
    .xc_gear_1                              ( xc_gear_1                         ),//O
    .xc_gear_2                              ( xc_gear_2                         ),//O
    .xc_gear_3                              ( xc_gear_3                         ),//O
    .xc_gear_4                              ( xc_gear_4                         ),//O
    .xc_gear_5                              ( xc_gear_5                         ),//O
    .xc_gear_6                              ( xc_gear_6                         ),//O
    .xc_gear_7                              ( xc_gear_7                         ),//O
    .xc_gear_8                              ( xc_gear_8                         ),//O
    .xc_gear_9                              ( xc_gear_9                         ),//O
    .xc_gear_10                             ( xc_gear_10                        ),//O
    .xc_gear_11                             ( xc_gear_11                        ),//O
    .xc_gear_12                             ( xc_gear_12                        ),//O
    .xc_gear_13                             ( xc_gear_13                        ),//O
    .xc_gear_14                             ( xc_gear_14                        ),//O
    .xc_gear_15                             ( xc_gear_15                        ),//O
    //---xc_stocks
    .xc_stocks_0                            ( xc_stocks_0                       ),//O
    .xc_stocks_1                            ( xc_stocks_1                       ),//O
    .xc_stocks_2                            ( xc_stocks_2                       ),//O
    .xc_stocks_3                            ( xc_stocks_3                       ),//O
    .xc_stocks_4                            ( xc_stocks_4                       ),//O
    .xc_stocks_5                            ( xc_stocks_5                       ),//O
    .xc_stocks_6                            ( xc_stocks_6                       ),//O
    .xc_stocks_7                            ( xc_stocks_7                       ),//O
    .xc_stocks_8                            ( xc_stocks_8                       ),//O
    .xc_stocks_9                            ( xc_stocks_9                       ),//O
    .xc_stocks_10                           ( xc_stocks_10                      ),//O
    .xc_stocks_11                           ( xc_stocks_11                      ),//O
    .xc_stocks_12                           ( xc_stocks_12                      ),//O
    .xc_stocks_13                           ( xc_stocks_13                      ),//O
    .xc_stocks_14                           ( xc_stocks_14                      ),//O
    .xc_stocks_15                           ( xc_stocks_15                      ) //O

    );
    //------------------------------------------------------------------------

endmodule
//`default_nettype wire
