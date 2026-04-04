`include "yusur_ndpp.vh" 

module ndpp_regfile(
    // clk and rst_n
    input                           sys_clk                     , // (i)
    input                           sys_rstn                    , // (i)
    //---sfp_status
    input       [31:00]             sfp_status                  ,
    input       [31:00]             sfp_status_inner            ,
 
    //---soft_reset
    output reg  [31:00]             soft_reset_req              ,// > 32'h0
    input       [31:00]             soft_reset_ack              ,// active with 32'hffff_ffff
    input                           soft_reset_n                ,

    output reg                      udp_param_0_tvalid          ,
    output      [127:0]             udp_param_0_tdata           ,
    
    input       [ 31:00]            mac1rx_cnt                  , 
    input       [ 31:00]            user0_rx_cnt                , 
    input       [ 31:00]            user1_rx_cnt                , 
    input       [ 31:00]            user2_rx_cnt                , 
    input       [ 31:00]            user3_rx_cnt                , 
    input       [ 31:00]            trigger_counter             ,
    input       [ 31:00]            write_counter_out           ,
    input       [ 31:00]            write_counter_out2           ,
    input       [ 31:00]            trigger_counter_out         ,

    input       [ 31:00]            trigger_counter_vld         ,
    input       [ 31:00]            trigger_counter_vld_full    ,
    input       [ 31:00]            trigger_counter_vld_a       ,
    input       [ 31:00]            trigger_counter_vld_b       ,
    input       [ 31:00]            trigger_counter_vld_notab   ,
    //---axilinput       [ 31:00]            trigger_counter    ,

    //---axil
    input  wire [31:00]             axil_awaddr                 ,
    input  wire [02:00]             axil_awprot                 ,
    input  wire                     axil_awvalid                ,
    input  wire [31:00]             axil_wdata                  ,
    input  wire [03:00]             axil_wstrb                  ,
    input  wire                     axil_wvalid                 ,
    input  wire                     axil_bready                 ,
    input  wire [31:00]             axil_araddr                 ,
    input  wire [02:00]             axil_arprot                 ,
    input  wire                     axil_arvalid                ,
    input  wire                     axil_rready                 ,

    output wire                     axil_awready                ,
    output wire                     axil_wready                 ,
    output wire                     axil_bvalid                 ,
    output wire [01:00]             axil_bresp                  ,
    output wire                     axil_arready                ,
    output reg  [31:00]             axil_rdata                  ,
    output wire [01:00]             axil_rresp                  ,
    output reg                      axil_rvalid                  
 
);  
    reg  [31:0]                     SOURCE_IP;
    reg  [31:0]                     DESTINATION_IP;
    reg  [31:0]                     SOURCE_PORT;
    reg  [31:0]                     DESTINATION_PORT;
    //*******************************************************
    // axil_m2s/s2m define,master or slave
    //*******************************************************
    reg [31:0]      awaddr_reg              ;
    wire[31:0]      awaddr_use              ;   
    reg             axil_wvalid_1d          ;
    wire[31:0]      data_fifo_progfull      ;
    //------------------------------------------------------------------------
    //****************************************************
    // axi lite signals pre-proc;---don't change//
    //**************************************************** 
    assign axil_wready  = 1'b1 ;
    assign axil_arready = axil_rvalid; 
    assign axil_bvalid  = axil_wvalid_1d;
    assign axil_bresp   = (axil_wvalid_1d)? 2'b00: 2'b10;
    assign axil_rresp   = (axil_rvalid )? 2'b00: 2'b10;  
    assign axil_awready = 1'b1; 
    assign awaddr_use   = (axil_awvalid) ? axil_awaddr : awaddr_reg;

    always@(posedge sys_clk or negedge sys_rstn)begin//axi lite 
        if(!sys_rstn) begin
            awaddr_reg <= 0;
            axil_rvalid <= 'd0 ;
            axil_wvalid_1d <= 'd0;
        end 
        else begin
            axil_rvalid <= (axil_arvalid && (!axil_rvalid)) ? 1'b1 :(axil_rvalid&&axil_rready) ? 1'b0 : axil_rvalid;
            axil_wvalid_1d <= axil_wvalid  ;
            if(axil_awvalid)begin
                awaddr_reg <= axil_awaddr;
            end
        end
    end 
    //------------------------------------------------------------------------
    //****************************************************
    // axi lite Write
    //****************************************************

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin 
            soft_reset_req <= 0;
            SOURCE_IP <= 0;
            DESTINATION_IP <= 0;
            SOURCE_PORT <= 0;
            DESTINATION_PORT <= 0; 
        end else begin
            if (axil_wvalid && axil_wready) begin
                case (awaddr_use[15:0]) 
                    16'h0000 : soft_reset_req <= axil_wdata; 
                    
                    16'h0100 : SOURCE_IP <= axil_wdata; 
                    16'h0104 : DESTINATION_IP <= axil_wdata; 
                    16'h0108 : SOURCE_PORT <= axil_wdata; 
                    16'h010C : DESTINATION_PORT <= axil_wdata; 
                endcase
            end else begin 
                soft_reset_req <= soft_reset_n == 1'b0 ? 0 : soft_reset_req;
                SOURCE_IP <= SOURCE_IP;
                DESTINATION_IP <= DESTINATION_IP;
                SOURCE_PORT <= SOURCE_PORT;
                DESTINATION_PORT <= DESTINATION_PORT; 
            end
        end
    end

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin
            udp_param_0_tvalid <=  0; 
        end else begin
            udp_param_0_tvalid <= (axil_wvalid && axil_wready && (awaddr_use[15:0] == 16'h010C)) ? 1'b1 : 1'b0; 
        end
    end

    // assign udp_param_0_tdata = {SOURCE_IP, DESTINATION_IP, SOURCE_PORT, DESTINATION_PORT};
    assign udp_param_0_tdata = {DESTINATION_PORT, SOURCE_PORT, DESTINATION_IP, SOURCE_IP};

    //----20260221
    localparam PRJ_VERSION = 32'h5a01_0201;
    localparam LAST_DATE   = 32'h2026_0324;
    `define    USER_DATE     32'h0324_0001

    always @ (posedge sys_clk or negedge sys_rstn) begin
        if (!sys_rstn) begin 
            axil_rdata  <=  32'b0;
        end else begin
            if (axil_arvalid) begin
                case (axil_araddr[15:0]) 
                    16'h0000 : axil_rdata <= soft_reset_req;
                    16'h0004 : axil_rdata <= soft_reset_ack;//32'hffff_ffff
                    16'h0008 : axil_rdata <= soft_reset_n;//32'hffff_ffff

                    16'h0100 : axil_rdata <= SOURCE_IP;
                    16'h0104 : axil_rdata <= DESTINATION_IP;
                    16'h0108 : axil_rdata <= SOURCE_PORT;
                    16'h010C : axil_rdata <= DESTINATION_PORT;

                    16'h0200 : axil_rdata <= user0_rx_cnt;
                    16'h0204 : axil_rdata <= user1_rx_cnt;
                    16'h0208 : axil_rdata <= user2_rx_cnt;
                    16'h020C : axil_rdata <= user3_rx_cnt;

                    16'h0300 : axil_rdata <= trigger_counter;
                    16'h0304 : axil_rdata <= write_counter_out;
                    16'h0308 : axil_rdata <= write_counter_out2;
                    16'h030c : axil_rdata <= trigger_counter_out;
                    
                    16'h0400 : axil_rdata <= trigger_counter_vld;
                    16'h0404 : axil_rdata <= trigger_counter_vld_full;
                    16'h0408 : axil_rdata <= trigger_counter_vld_a;
                    16'h040c : axil_rdata <= trigger_counter_vld_b;
                    
                    16'h0500 : axil_rdata <= trigger_counter_vld_notab;
                                        
                    16'h1000 : axil_rdata <= PRJ_VERSION;
                    16'h1004 : axil_rdata <= LAST_DATE;
                    16'h1008 : axil_rdata <= `USER_DATE;

                    default : axil_rdata <= 32'b0;
                endcase
            end else begin
                axil_rdata <= 32'b0;
            end
        end
    end
    

endmodule 
