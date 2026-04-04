module hw_time (
    //---
    input                   sys_clk                             ,
    input                   sys_rstn                            ,
    //---
    input                   wd_reset_n                          ,
    output      [31:0]      loc_time_1ms_sw                     ,
    output      [31:0]      loc_time_1s_sw                      ,
    //---
    output      [31:0]      loc_time_1ms_hw                     ,
    output      [31:0]      loc_time_1s_hw
);

    //------------------------------------------------------------------------
    //-------
    parameter       LOC_PERIOD_VERSION   = 32'h2023_0915        ;
    //-------
    localparam      LOC_PERIOD_1US       =  8'd124              ;//1us@250MHz
    localparam      LOC_PERIOD_1MS       = 32'd4_99             ;//1ms@250MHz
    localparam      LOC_PERIOD_1S        = 32'd4_99             ;//1 s@250MHz
    //------------------------------------------------------------------------SW Heart-beat
    //-------
    reg     [07:00]         sw_timestamp                        ;// 250Mhz\4ns
    reg                     sw_1us_clk                          ;
    reg                     sw_1us_clk_r                        ;

    reg     [08:00]         sw_1us_cnt                          ;
    reg                     sw_1ms_clk                          ;
    reg                     sw_1ms_clk_r                        ;

    reg     [08:00]         sw_1ms_cnt                          ;
    reg                     sw_sec_clk                          ;
    reg                     sw_sec_clk_r                        ;

    reg     [31:00]         sw_sec_cnt                          ;
    //---
    reg     [31:00]         sw_ms_cnt                           ;
    reg     [00:00]         sw_ms_carry_flag                    ;
    //-------
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            sw_1us_clk_r    <=  0                               ;
            sw_1ms_clk_r    <=  0                               ;
            sw_sec_clk_r    <=  0                               ;
        end else if (!wd_reset_n) begin
            sw_1us_clk_r    <=  0                               ;
            sw_1ms_clk_r    <=  0                               ;
            sw_sec_clk_r    <=  0                               ;
        end else begin
            sw_1us_clk_r    <=  sw_1us_clk                      ;
            sw_1ms_clk_r    <=  sw_1ms_clk                      ;
            sw_sec_clk_r    <=  sw_sec_clk                      ;
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            sw_timestamp    <=  0                               ;
            sw_1us_clk      <=  0                               ;
        end else if (!wd_reset_n) begin
            sw_timestamp    <=  0                               ;
            sw_1us_clk      <=  0                               ;
        end else begin
            if (sw_timestamp == LOC_PERIOD_1US) begin
                sw_1us_clk      <=  ~sw_1us_clk                 ;
                sw_timestamp    <=  0                           ;
            end else begin
                sw_1us_clk      <=  sw_1us_clk                  ;
                sw_timestamp    <=  sw_timestamp + 1            ;
            end
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            sw_1us_cnt      <=  0                               ;
            sw_1ms_clk      <=  0                               ;
        end else if (!wd_reset_n) begin
            sw_1us_cnt      <=  0                               ;
            sw_1ms_clk      <=  0                               ;
        end else begin
            if (sw_1us_cnt == 9'd500) begin
                sw_1ms_clk      <=  ~sw_1ms_clk                 ;
                sw_1us_cnt      <=  0                           ;
            end else if ((sw_1us_clk_r == 1'b0) && (sw_1us_clk == 1'b1)) begin
                sw_1ms_clk      <=  sw_1ms_clk                  ;
                sw_1us_cnt      <=  sw_1us_cnt + 1              ;
            end else begin
                sw_1ms_clk      <=  sw_1ms_clk                  ;
                sw_1us_cnt      <=  sw_1us_cnt                  ;
            end
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            sw_1ms_cnt      <=  0                               ;
            sw_sec_clk      <=  0                               ;
        end else if (!wd_reset_n) begin
            sw_1ms_cnt      <=  0                               ;
            sw_sec_clk      <=  0                               ;
        end else begin
            if (sw_1ms_cnt == 9'd500) begin
                sw_sec_clk      <=  ~sw_sec_clk                 ;
                sw_1ms_cnt      <=  0                           ;
            end else if ((sw_1ms_clk_r == 1'b0) && (sw_1ms_clk == 1'b1)) begin
                sw_sec_clk      <=  sw_sec_clk                  ;
                sw_1ms_cnt      <=  sw_1ms_cnt + 1              ;
            end else begin
                sw_sec_clk      <=  sw_sec_clk                  ;
                sw_1ms_cnt      <=  sw_1ms_cnt                  ;
            end
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            sw_sec_cnt      <=  0                               ;
        end else if (!wd_reset_n) begin
            sw_sec_cnt      <=  0                               ;
        end else begin
            if ((sw_sec_clk == 1'b1) && (sw_sec_clk_r == 1'b0)) begin
                sw_sec_cnt      <=  sw_sec_cnt + 1              ;
            end else begin
                sw_sec_cnt      <=  sw_sec_cnt                  ;
            end
        end
    end
    //------
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            sw_ms_cnt       <=  0                               ;
        end else if (!wd_reset_n) begin
            sw_ms_cnt       <=  0                               ;
        end else if ((sw_1ms_clk_r == 1'b0) && (sw_1ms_clk == 1'b1)) begin
            sw_ms_cnt       <=  sw_ms_cnt + 1                   ;
        end else begin
            sw_ms_cnt       <=  sw_ms_cnt                       ;
        end
    end
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            sw_ms_carry_flag    <=  0                           ;
        end else if (!wd_reset_n) begin
            sw_ms_carry_flag    <=  0                           ;
        //end else if ((loc_1ms_clk_r == 1'b0) && (loc_1ms_clk == 1'b1) && (hw_1ms_cnt == 32'hffff_ffff)) begin
        end else if(sw_ms_cnt == 32'hffff_ffff) begin
            sw_ms_carry_flag    <=  sw_ms_carry_flag + 1        ;
        end else begin
            sw_ms_carry_flag    <=  sw_ms_carry_flag            ;
        end
    end
    //------
    assign  loc_time_1s_sw   =  sw_sec_cnt                      ;
    //------
    assign  loc_time_1ms_sw  =  sw_ms_cnt                       ;
    //------------------------------------------------------------------------SW Heart-beat end
    //------------------------------------------------------------------------HW Heart-beat start
    //-------
    reg     [07:00]         loc_timestamp                       ;// 250Mhz\4ns
    reg                     loc_1us_clk                         ;
    reg                     loc_1us_clk_r                       ;

    reg     [08:00]         loc_1us_cnt                         ;
    reg                     loc_1ms_clk                         ;
    reg                     loc_1ms_clk_r                       ;

    reg     [08:00]         loc_1ms_cnt                         ;
    reg                     loc_sec_clk                         ;
    reg                     loc_sec_clk_r                       ;

    reg     [31:00]         loc_sec_cnt                         ;
    //---
    reg     [31:00]         hw_ms_cnt                           ;
    reg     [00:00]         hw_ms_carry_flag                    ;
    //-------
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            loc_1us_clk_r   <=  0                               ;
            loc_1ms_clk_r   <=  0                               ;
            loc_sec_clk_r   <=  0                               ;
        end else begin
            loc_1us_clk_r   <=  loc_1us_clk                     ;
            loc_1ms_clk_r   <=  loc_1ms_clk                     ;
            loc_sec_clk_r   <=  loc_sec_clk                     ;
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            loc_timestamp   <=  0                               ;
            loc_1us_clk     <=  0                               ;
        end else begin
            if (loc_timestamp == LOC_PERIOD_1US) begin
                loc_1us_clk     <=  ~loc_1us_clk                ;
                loc_timestamp   <=  0                           ;
            end else begin
                loc_1us_clk     <=  loc_1us_clk                 ;
                loc_timestamp   <=  loc_timestamp + 1           ;
            end
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            loc_1us_cnt     <=  0                               ;
            loc_1ms_clk     <=  0                               ;
        end else begin
            if (loc_1us_cnt == 9'd500) begin
                loc_1ms_clk     <=  ~loc_1ms_clk                ;
                loc_1us_cnt     <=  0                           ;
            end else if ((loc_1us_clk_r == 1'b0) && (loc_1us_clk == 1'b1)) begin
                loc_1ms_clk     <=  loc_1ms_clk                 ;
                loc_1us_cnt     <=  loc_1us_cnt + 1             ;
            end else begin
                loc_1ms_clk     <=  loc_1ms_clk                 ;
                loc_1us_cnt     <=  loc_1us_cnt                 ;
            end
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            loc_1ms_cnt     <=  0                               ;
            loc_sec_clk     <=  0                               ;
        end else begin
            if (loc_1ms_cnt == 9'd500) begin
                loc_sec_clk     <=  ~loc_sec_clk                ;
                loc_1ms_cnt     <=  0                           ;
            end else if ((loc_1ms_clk_r == 1'b0) && (loc_1ms_clk == 1'b1)) begin
                loc_sec_clk     <=  loc_sec_clk                 ;
                loc_1ms_cnt     <=  loc_1ms_cnt + 1             ;
            end else begin
                loc_sec_clk     <=  loc_sec_clk                 ;
                loc_1ms_cnt     <=  loc_1ms_cnt                 ;
            end
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            loc_sec_cnt     <=  0                               ;
        end else begin
            if ((loc_sec_clk == 1'b1) && (loc_sec_clk_r == 1'b0)) begin
                loc_sec_cnt     <=  loc_sec_cnt + 1             ;
            end else begin
                loc_sec_cnt     <=  loc_sec_cnt                 ;
            end
        end
    end
    //------
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            hw_ms_cnt       <=  0                               ;
        end else if ((loc_1ms_clk_r == 1'b0) && (loc_1ms_clk == 1'b1)) begin
            hw_ms_cnt       <=  hw_ms_cnt + 1                   ;
        end else begin
            hw_ms_cnt       <=  hw_ms_cnt                       ;
        end
    end
    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            hw_ms_carry_flag    <=  0                           ;
        //end else if ((loc_1ms_clk_r == 1'b0) && (loc_1ms_clk == 1'b1) && (hw_1ms_cnt == 32'hffff_ffff)) begin
        end else if(hw_ms_cnt == 32'hffff_ffff) begin
            hw_ms_carry_flag    <=  hw_ms_carry_flag + 1        ;
        end else begin
            hw_ms_carry_flag    <=  hw_ms_carry_flag            ;
        end
    end
    //------
    assign  loc_time_1s_hw   =  loc_sec_cnt                     ;
    //------
    assign  loc_time_1ms_hw  =  hw_ms_cnt                       ;
    //------------------------------------------------------------------------HW Heart-beat end

endmodule
