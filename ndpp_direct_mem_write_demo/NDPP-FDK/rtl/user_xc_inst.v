//`include "yusur_ndpp.vh"
//`default_nettype none

module user_xc_inst #(
    parameter   XC_ARRAY_DEPTH          =   16'd16                              ,
    parameter   XC_GEAR_WIDTH           =   16'd3                               ,
    parameter   XC_STOCKS_WIDTH         =   16'd7                
    )           (
    //--- clk and rst_n
    input                                   sys_clk                             ,
    input                                   sys_rstn                            ,
    //---NATIVE MEM IF
    input  wire                             user_logic_native_mem_valid         ,
    input  wire [63:0]                      user_logic_native_mem_address       ,//0x0000_0000_0030_0000 ~ 0x0000_0000_003f_ffff
    input  wire [255:0]                     user_logic_native_mem_data          ,
    input  wire [31:0]                      user_logic_native_mem_strb          ,
    //---xc_gear
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_0                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_1                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_2                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_3                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_4                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_5                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_6                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_7                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_8                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_9                           ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_10                          ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_11                          ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_12                          ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_13                          ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_14                          ,
    output wire [XC_GEAR_WIDTH - 1:00]      xc_gear_15                          ,
    //---xc_stocks
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_0                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_1                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_2                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_3                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_4                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_5                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_6                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_7                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_8                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_9                         ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_10                        ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_11                        ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_12                        ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_13                        ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_14                        ,
    output wire [XC_STOCKS_WIDTH - 1:00]    xc_stocks_15                      
    
    );
    
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
    parameter   XC_GEAR_0       =   3'd5        ,
                XC_GEAR_1       =   3'd5        ,
                XC_GEAR_2       =   3'd5        ,
                XC_GEAR_3       =   3'd5        ,
                XC_GEAR_4       =   3'd5        ,
                XC_GEAR_5       =   3'd5        ,
                XC_GEAR_6       =   3'd5        ,
                XC_GEAR_7       =   3'd5        ,
                XC_GEAR_8       =   3'd1        ,
                XC_GEAR_9       =   3'd1        ,
                XC_GEAR_A       =   3'd1        ,
                XC_GEAR_B       =   3'd1        ,
                XC_GEAR_C       =   3'd1        ,
                XC_GEAR_D       =   3'd1        ,
                XC_GEAR_E       =   3'd1        ,
                XC_GEAR_F       =   3'd1        ;
    
    parameter   XC_STOCKS_0     =   7'd10       ;
    parameter   XC_STOCKS_1     =   7'd10       ;
    parameter   XC_STOCKS_2     =   7'd10       ;
    parameter   XC_STOCKS_3     =   7'd10       ;
    parameter   XC_STOCKS_4     =   7'd10       ;
    parameter   XC_STOCKS_5     =   7'd10       ;
    parameter   XC_STOCKS_6     =   7'd10       ;
    parameter   XC_STOCKS_7     =   7'd10       ;
    parameter   XC_STOCKS_8     =   7'd10       ;
    parameter   XC_STOCKS_9     =   7'd10       ;
    parameter   XC_STOCKS_A     =   7'd10       ;
    parameter   XC_STOCKS_B     =   7'd10       ;
    parameter   XC_STOCKS_C     =   7'd10       ;
    parameter   XC_STOCKS_D     =   7'd10       ;
    parameter   XC_STOCKS_E     =   7'd10       ;
    parameter   XC_STOCKS_F     =   7'd10       ;
    //------------------------------------------------------------------------
    reg  [15:00]                            user_cmd                                ;
    reg  [47:00]                            user_cmd_reserved                       ;
    reg  [XC_GEAR_WIDTH - 1:00]             xc_gear_reg    [XC_ARRAY_DEPTH - 1:00]  ;
    reg  [XC_STOCKS_WIDTH - 1:00]           xc_stocks_reg  [XC_ARRAY_DEPTH - 1:00]  ;
    //------------------------------------------------------------------------
    //------`define
    `define         LOCAL_SIM_EN
    //------------------------------------------------------------------------
    
`ifdef LOCAL_SIM_EN

    //------user_cmd
    initial begin
    user_cmd    =   16'h5a0f;
        $display("user_cmd = %h", user_cmd);

    user_cmd_reserved = 48'hffff_ffff_ffff;
        $display("user_cmd_reserved = %h", user_cmd_reserved);
    end

    //------xc_gear_reg
    integer i,j;
    initial begin
    //xc_gear_reg =   {   XC_GEAR_0, XC_GEAR_1, XC_GEAR_2, XC_GEAR_3, 
    //                    XC_GEAR_4, XC_GEAR_5, XC_GEAR_6, XC_GEAR_7, 
    //                    XC_GEAR_8, XC_GEAR_9, XC_GEAR_A, XC_GEAR_B, 
    //                    XC_GEAR_C, XC_GEAR_D, XC_GEAR_E, XC_GEAR_F 
    //                };
    
    xc_gear_reg[0]      =   XC_GEAR_0    ;
    xc_gear_reg[1]      =   XC_GEAR_1    ;
    xc_gear_reg[2]      =   XC_GEAR_2    ;
    xc_gear_reg[3]      =   XC_GEAR_3    ;
    xc_gear_reg[4]      =   XC_GEAR_4    ;
    xc_gear_reg[5]      =   XC_GEAR_5    ;
    xc_gear_reg[6]      =   XC_GEAR_6    ;
    xc_gear_reg[7]      =   XC_GEAR_7    ;
    xc_gear_reg[8]      =   XC_GEAR_8    ;
    xc_gear_reg[9]      =   XC_GEAR_9    ;
    xc_gear_reg[10]     =   XC_GEAR_A    ;
    xc_gear_reg[11]     =   XC_GEAR_B    ;
    xc_gear_reg[12]     =   XC_GEAR_C    ;
    xc_gear_reg[13]     =   XC_GEAR_D    ;
    xc_gear_reg[14]     =   XC_GEAR_E    ;
    xc_gear_reg[15]     =   XC_GEAR_F    ;
        //---read
        for(i=0;i<XC_ARRAY_DEPTH;i=i+1)begin
            $display("xc_gear_reg[%d] = %d", i, xc_gear_reg[i]);
        end
    #100;
    xc_gear_reg[0]      =   3'd0    ;
    xc_gear_reg[1]      =   3'd1    ;
    xc_gear_reg[2]      =   3'd2    ;
    xc_gear_reg[3]      =   3'd3    ;
    xc_gear_reg[4]      =   3'd4    ;
    xc_gear_reg[5]      =   3'd5    ;
    xc_gear_reg[6]      =   3'd6    ;
    xc_gear_reg[7]      =   3'd7    ;
    xc_gear_reg[8]      =   3'd0    ;
    xc_gear_reg[9]      =   3'd1    ;
    xc_gear_reg[10]     =   3'd2    ;
    xc_gear_reg[11]     =   3'd3    ;
    xc_gear_reg[12]     =   3'd4    ;
    xc_gear_reg[13]     =   3'd5    ;
    xc_gear_reg[14]     =   3'd6    ;
    xc_gear_reg[15]     =   3'd7    ;
    #100;
        //---read
        for(i=0;i<XC_ARRAY_DEPTH;i=i+1)begin
            $display("xc_gear_reg[%d] = %d", i, xc_gear_reg[i]);
        end
    
    #100;
    end

    //------xc_stocks_reg
    initial begin
    //xc_stocks_reg   =   {
    //                        XC_STOCKS_0,    XC_STOCKS_1,    XC_STOCKS_2,    XC_STOCKS_3,
    //                        XC_STOCKS_4,    XC_STOCKS_5,    XC_STOCKS_6,    XC_STOCKS_7,
    //                        XC_STOCKS_8,    XC_STOCKS_9,    XC_STOCKS_A,    XC_STOCKS_B,
    //                        XC_STOCKS_C,    XC_STOCKS_D,    XC_STOCKS_E,    XC_STOCKS_F
    //                    };
    xc_stocks_reg[0]      =   XC_STOCKS_0    ;
    xc_stocks_reg[1]      =   XC_STOCKS_1    ;
    xc_stocks_reg[2]      =   XC_STOCKS_2    ;
    xc_stocks_reg[3]      =   XC_STOCKS_3    ;
    xc_stocks_reg[4]      =   XC_STOCKS_4    ;
    xc_stocks_reg[5]      =   XC_STOCKS_5    ;
    xc_stocks_reg[6]      =   XC_STOCKS_6    ;
    xc_stocks_reg[7]      =   XC_STOCKS_7    ;
    xc_stocks_reg[8]      =   XC_STOCKS_8    ;
    xc_stocks_reg[9]      =   XC_STOCKS_9    ;
    xc_stocks_reg[10]     =   XC_STOCKS_A    ;
    xc_stocks_reg[11]     =   XC_STOCKS_B    ;
    xc_stocks_reg[12]     =   XC_STOCKS_C    ;
    xc_stocks_reg[13]     =   XC_STOCKS_D    ;
    xc_stocks_reg[14]     =   XC_STOCKS_E    ;
    xc_stocks_reg[15]     =   XC_STOCKS_F    ;
        //---read
        for(i = 0 ; i<XC_ARRAY_DEPTH ; i=i+1)begin
            $display("xc_stocks_reg[%d] = %d", i, xc_stocks_reg[i]);
        end

    #100;
        //---write
        for(i = 0 ; i<XC_ARRAY_DEPTH ; i=i+1)begin
            xc_stocks_reg[i]    =   i + 1   ;
        end
        //---read
        for(i = 0 ; i<XC_ARRAY_DEPTH ; i=i+1)begin
            $display("xc_stocks_reg[%d] = %d", i, xc_stocks_reg[i]);
        end
        
    #100;
    xc_stocks_reg[10]   =   7'd99   ;
    $display("xc_stocks_reg[10] = %d", xc_stocks_reg[10]);
    #100;
    end

`endif
    
    //------------------------------------------------------------------------host write BAR-2 / fpga read BAR-2
    always @ (posedge sys_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
	    //---
        user_cmd                <= 16'h0000                     ;
        user_cmd_reserved       <= 48'h0000_0000_0000           ;
        //---
        xc_gear_reg[0]          <= 3'd0                         ;
        xc_gear_reg[1]          <= 3'd1                         ;
        xc_gear_reg[2]          <= 3'd2                         ;
        xc_gear_reg[3]          <= 3'd3                         ;
        xc_gear_reg[4]          <= 3'd4                         ;
        xc_gear_reg[5]          <= 3'd5                         ;
        xc_gear_reg[6]          <= 3'd6                         ;
        xc_gear_reg[7]          <= 3'd7                         ;
        xc_gear_reg[8]          <= 3'd0                         ;
        xc_gear_reg[9]          <= 3'd1                         ;
        xc_gear_reg[10]         <= 3'd2                         ;
        xc_gear_reg[11]         <= 3'd3                         ;
        xc_gear_reg[12]         <= 3'd4                         ;
        xc_gear_reg[13]         <= 3'd5                         ;
        xc_gear_reg[14]         <= 3'd6                         ;
        xc_gear_reg[15]         <= 3'd7                         ;
        //---
        xc_stocks_reg[0]        <= 7'd0                         ;
        xc_stocks_reg[1]        <= 7'd1                         ;
        xc_stocks_reg[2]        <= 7'd2                         ;
        xc_stocks_reg[3]        <= 7'd3                         ;
        xc_stocks_reg[4]        <= 7'd4                         ;
        xc_stocks_reg[5]        <= 7'd5                         ;
        xc_stocks_reg[6]        <= 7'd6                         ;
        xc_stocks_reg[7]        <= 7'd7                         ;
        xc_stocks_reg[8]        <= 7'd0                         ;
        xc_stocks_reg[9]        <= 7'd1                         ;
        xc_stocks_reg[10]       <= 7'd2                         ;
        xc_stocks_reg[11]       <= 7'd3                         ;
        xc_stocks_reg[12]       <= 7'd4                         ;
        xc_stocks_reg[13]       <= 7'd5                         ;
        xc_stocks_reg[14]       <= 7'd6                         ;
        xc_stocks_reg[15]       <= 7'd7                         ;
    end else begin
        if ((user_logic_native_mem_valid == 1'b1) && (user_logic_native_mem_strb == 32'hffff_ffff)) begin
            case (user_logic_native_mem_address[23:0])
            24'h30_0000 : begin
                //---
                user_cmd                <= user_logic_native_mem_data[255:240]  ;
                user_cmd_reserved       <= user_logic_native_mem_data[239:192]  ;
                //---xc_gear_reg
                xc_gear_reg[0]          <= user_logic_native_mem_data[130:128]  ;//[131-1 : 128]
                xc_gear_reg[1]          <= user_logic_native_mem_data[134:132]  ;//[135-1 : 132]
                xc_gear_reg[2]          <= user_logic_native_mem_data[138:136]  ;//[139-1 : 136]
                xc_gear_reg[3]          <= user_logic_native_mem_data[142:140]  ;//[143-1 : 140]
                xc_gear_reg[4]          <= user_logic_native_mem_data[146:144]  ;//[147-1 : 144]
                xc_gear_reg[5]          <= user_logic_native_mem_data[150:148]  ;//[151-1 : 148]
                xc_gear_reg[6]          <= user_logic_native_mem_data[154:152]  ;//[155-1 : 152]
                xc_gear_reg[7]          <= user_logic_native_mem_data[158:156]  ;//[159-1 : 156]
                xc_gear_reg[8]          <= user_logic_native_mem_data[162:160]  ;//[163-1 : 160]
                xc_gear_reg[9]          <= user_logic_native_mem_data[166:164]  ;//[167-1 : 164]
                xc_gear_reg[10]         <= user_logic_native_mem_data[170:168]  ;//[171-1 : 168]
                xc_gear_reg[11]         <= user_logic_native_mem_data[174:172]  ;//[175-1 : 172]
                xc_gear_reg[12]         <= user_logic_native_mem_data[178:176]  ;//[179-1 : 176]
                xc_gear_reg[13]         <= user_logic_native_mem_data[182:180]  ;//[183-1 : 180]
                xc_gear_reg[14]         <= user_logic_native_mem_data[186:184]  ;//[187-1 : 184]
                xc_gear_reg[15]         <= user_logic_native_mem_data[190:188]  ;//[191-1 : 188]
                //---xc_stocks_reg
                xc_stocks_reg[0]        <= user_logic_native_mem_data[06 : 00]  ;//[07 -1 :  00]
                xc_stocks_reg[1]        <= user_logic_native_mem_data[14 : 08]  ;//[15 -1 :  08]
                xc_stocks_reg[2]        <= user_logic_native_mem_data[22 : 16]  ;//[23 -1 :  16]
                xc_stocks_reg[3]        <= user_logic_native_mem_data[30 : 24]  ;//[31 -1 :  24]
                xc_stocks_reg[4]        <= user_logic_native_mem_data[38 : 32]  ;//[39 -1 :  32]
                xc_stocks_reg[5]        <= user_logic_native_mem_data[46 : 40]  ;//[47 -1 :  40]
                xc_stocks_reg[6]        <= user_logic_native_mem_data[54 : 48]  ;//[55 -1 :  48]
                xc_stocks_reg[7]        <= user_logic_native_mem_data[62 : 56]  ;//[63 -1 :  56]
                xc_stocks_reg[8]        <= user_logic_native_mem_data[70 : 64]  ;//[71 -1 :  64]
                xc_stocks_reg[9]        <= user_logic_native_mem_data[78 : 72]  ;//[79 -1 :  72]
                xc_stocks_reg[10]       <= user_logic_native_mem_data[86 : 80]  ;//[87 -1 :  80]
                xc_stocks_reg[11]       <= user_logic_native_mem_data[94 : 88]  ;//[95 -1 :  88]
                xc_stocks_reg[12]       <= user_logic_native_mem_data[102: 96]  ;//[103-1 :  96]
                xc_stocks_reg[13]       <= user_logic_native_mem_data[110:104]  ;//[111-1 : 104]
                xc_stocks_reg[14]       <= user_logic_native_mem_data[118:112]  ;//[119-1 : 112]
                xc_stocks_reg[15]       <= user_logic_native_mem_data[126:120]  ;//[127-1 : 120]
            end
            24'h30_0008 : begin
                //---
                user_cmd                <= user_logic_native_mem_data[255:240]  ;
                user_cmd_reserved       <= user_logic_native_mem_data[239:192]  ;
                //---xc_gear_reg
                //---xc_stocks_reg

            end
            default: begin
                //---
                user_cmd                <= user_cmd                             ;
                user_cmd_reserved       <= user_cmd_reserved                    ;
                //---xc_gear_reg
                //---xc_stocks_reg
                
            end
            endcase
        end else begin
            //---
            user_cmd                <= user_cmd                             ;
            user_cmd_reserved       <= user_cmd_reserved                    ;
            //---xc_gear_reg
            xc_gear_reg[0]          <= xc_gear_reg[0]                       ;
            xc_gear_reg[1]          <= xc_gear_reg[1]                       ;
            xc_gear_reg[2]          <= xc_gear_reg[2]                       ;
            xc_gear_reg[3]          <= xc_gear_reg[3]                       ;
            xc_gear_reg[4]          <= xc_gear_reg[4]                       ;
            xc_gear_reg[5]          <= xc_gear_reg[5]                       ;
            xc_gear_reg[6]          <= xc_gear_reg[6]                       ;
            xc_gear_reg[7]          <= xc_gear_reg[7]                       ;
            xc_gear_reg[8]          <= xc_gear_reg[8]                       ;
            xc_gear_reg[9]          <= xc_gear_reg[9]                       ;
            xc_gear_reg[10]         <= xc_gear_reg[10]                      ;
            xc_gear_reg[11]         <= xc_gear_reg[11]                      ;
            xc_gear_reg[12]         <= xc_gear_reg[12]                      ;
            xc_gear_reg[13]         <= xc_gear_reg[13]                      ;
            xc_gear_reg[14]         <= xc_gear_reg[14]                      ;
            xc_gear_reg[15]         <= xc_gear_reg[15]                      ;
            //---xc_stocks_reg
            xc_stocks_reg[0]        <= xc_stocks_reg[0]                     ;
            xc_stocks_reg[1]        <= xc_stocks_reg[1]                     ;
            xc_stocks_reg[2]        <= xc_stocks_reg[2]                     ;
            xc_stocks_reg[3]        <= xc_stocks_reg[3]                     ;
            xc_stocks_reg[4]        <= xc_stocks_reg[4]                     ;
            xc_stocks_reg[5]        <= xc_stocks_reg[5]                     ;
            xc_stocks_reg[6]        <= xc_stocks_reg[6]                     ;
            xc_stocks_reg[7]        <= xc_stocks_reg[7]                     ;
            xc_stocks_reg[8]        <= xc_stocks_reg[8]                     ;
            xc_stocks_reg[9]        <= xc_stocks_reg[9]                     ;
            xc_stocks_reg[10]       <= xc_stocks_reg[10]                    ;
            xc_stocks_reg[11]       <= xc_stocks_reg[11]                    ;
            xc_stocks_reg[12]       <= xc_stocks_reg[12]                    ;
            xc_stocks_reg[13]       <= xc_stocks_reg[13]                    ;
            xc_stocks_reg[14]       <= xc_stocks_reg[14]                    ;
            xc_stocks_reg[15]       <= xc_stocks_reg[15]                    ;
        end
    end
    end

    //------------------------------------------------------------------------
    //------xc_gear
    assign  xc_gear_0       = xc_gear_reg[0]                                ;
    assign  xc_gear_1       = xc_gear_reg[1]                                ;
    assign  xc_gear_2       = xc_gear_reg[2]                                ;
    assign  xc_gear_3       = xc_gear_reg[3]                                ;
    assign  xc_gear_4       = xc_gear_reg[4]                                ;
    assign  xc_gear_5       = xc_gear_reg[5]                                ;
    assign  xc_gear_6       = xc_gear_reg[6]                                ;
    assign  xc_gear_7       = xc_gear_reg[7]                                ;
    assign  xc_gear_8       = xc_gear_reg[8]                                ;
    assign  xc_gear_9       = xc_gear_reg[9]                                ;
    assign  xc_gear_10      = xc_gear_reg[10]                               ;
    assign  xc_gear_11      = xc_gear_reg[11]                               ;
    assign  xc_gear_12      = xc_gear_reg[12]                               ;
    assign  xc_gear_13      = xc_gear_reg[13]                               ;
    assign  xc_gear_14      = xc_gear_reg[14]                               ;
    assign  xc_gear_15      = xc_gear_reg[15]                               ;
    //------xc_stocks
    assign  xc_stocks_0     = xc_stocks_reg[0]                              ;
    assign  xc_stocks_1     = xc_stocks_reg[1]                              ;
    assign  xc_stocks_2     = xc_stocks_reg[2]                              ;
    assign  xc_stocks_3     = xc_stocks_reg[3]                              ;
    assign  xc_stocks_4     = xc_stocks_reg[4]                              ;
    assign  xc_stocks_5     = xc_stocks_reg[5]                              ;
    assign  xc_stocks_6     = xc_stocks_reg[6]                              ;
    assign  xc_stocks_7     = xc_stocks_reg[7]                              ;
    assign  xc_stocks_8     = xc_stocks_reg[8]                              ;
    assign  xc_stocks_9     = xc_stocks_reg[9]                              ;
    assign  xc_stocks_10    = xc_stocks_reg[10]                             ;
    assign  xc_stocks_11    = xc_stocks_reg[11]                             ;
    assign  xc_stocks_12    = xc_stocks_reg[12]                             ;
    assign  xc_stocks_13    = xc_stocks_reg[13]                             ;
    assign  xc_stocks_14    = xc_stocks_reg[14]                             ;
    assign  xc_stocks_15    = xc_stocks_reg[15]                             ;
    //---------------------------------------------------------

endmodule
//`default_nettype wire
