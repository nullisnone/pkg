//--------------------------------------------------------------------------------
//  __   ___   _ ____  _   _ ____       Project     : ndpp_sim
//  \ \ / / | | / ___|| | | |  _ \      File        : axi4_lite_top.v
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

module axi4_lite_top #(
    parameter       WORK_MODE               = 0                                     ,//0:global, 1:local
    parameter       BAR1_DATA_WIDTH         = 32                                    ,//32
    parameter       BAR1_KEEP_WIDTH         = BAR1_DATA_WIDTH / 8                    //4

    )(
    //---
    input                                   sys_clk                                 ,
    input                                   sys_rst_n                               ,
    //---awaddr
    output wire [31:00]                     o_m_axi_awaddr                          ,
    output wire                             o_m_axi_awvalid                         ,
    output wire [02:00]                     o_m_axi_awprot                          ,
    input                                   i_m_axi_awready                         ,
    //---wdata
    output wire [31:00]                     o_m_axi_wdata                           ,
    output wire [03:00]                     o_m_axi_wstrb                           ,
    output wire                             o_m_axi_wvalid                          ,
    input                                   i_m_axi_wready                          ,
    //---bresp
    input       [01:00]                     i_m_axi_bresp                           ,
    input                                   i_m_axi_bvalid                          ,
    output wire                             o_m_axi_bready                          ,
    //---araddr
    output wire [31:00]                     o_m_axi_araddr                          ,
    output wire                             o_m_axi_arvalid                         ,
    output wire [02:00]                     o_m_axi_arprot                          ,
    input                                   i_m_axi_arready                         ,
    //---rdata
    input       [31:00]                     i_m_axi_rdata                           ,
    input       [01:00]                     i_m_axi_rresp                           ,
    input                                   i_m_axi_rvalid                          ,
    output wire                             o_m_axi_rready
    );

//--------------------------------------------------------------------------------
    //------PARAMETER
    parameter           DATA_WIDTH          = 32                                    ;
    parameter           DATA_WR_WIDTH       = DATA_WIDTH                            ;
    parameter           DATA_RD_WIDTH       = DATA_WIDTH                            ;
    parameter           USER_DMA_DATA_WIDTH = 32                                    ;
    parameter           USER_DMA_KEEP_WIDTH = DATA_WIDTH / 8                        ;
    localparam          BEGIN_ADDRESS       = 32'h00000000                          ;
    localparam          END_ADDRESS         = 32'h0000FFFF                          ;
    localparam          RD_INSTR            = 3'b001                                ; // Read command
    localparam          WR_INSTR            = 3'b000                                ; // Write command

    localparam          DELAY_UNIT          = 32'd4_000                             ;//004ns @ 1ps 250MHz
    localparam          DELAY_TO_WAIT       = 32'd100_000                           ;//100ns @ 1ps 250MHz
    //------Perform the steps of IP core in sequence
    reg     [31:00]                         pcie_bar_rd_data_reg                    ;
    //------
    initial
    begin
        pcie_bar_rd_data_reg = 0;

        `ifdef PRINT_ENABLE
            $display("//--------------------------------------------------------------");
            $display("INFO : Simulation for PCIE_BAR_1 registers.")                     ;
            $display("INFO : Users can get 32 registers in regfile.v, with offset-address is 0x0000_0004.");
            $display("//--------------------------------------------------------------");
        `endif

        wait(sys_rst_n);
        #2000;
        
        `ifdef PRINT_ENABLE
            $display("Start to write and read PCIE_BAR_1 registers.");
        `endif

        while(1) begin
        //---0x0000_0000
        //   It's a read-only register in regfile.v, which defines "ram[0] = NDPP_VERSION = 32'h2311_0002".
        //   Even if User write a value to this register, the value will be ignored.
        //   For more information, please refer to the NDPP_VERSION register description in regfile.v .
        u_m_axi4_lite_if.m_axi_write_data(32'h00000000,32'h5a010001,4'hf)           ;//The value will be ignored.
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000000,pcie_bar_rd_data_reg)         ;//DEMO_VERSION 32'h24110400

        //---0x0000_0004 ~ end
        //   Starting at 0x0000_0004, they are writable and readable registers.
        //   Users can write and read the registers in sequence.
        //   Users can get 31 registers here, with offset-address is 0x0000_0004.
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_write_data(32'h00000004,32'h5a01ffff,4'hf)           ;//lightning_mac0_enable_reg
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000004,pcie_bar_rd_data_reg)         ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000008,pcie_bar_rd_data_reg)         ;//lightning_mac0_loopback_reg
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_write_data(32'h0000000c,32'h5a01ffff,4'hf)           ;//lightning_mac1_enable_reg
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h0000000c,pcie_bar_rd_data_reg)         ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000010,pcie_bar_rd_data_reg)         ;//lightning_mac1_loopback_reg
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_write_data(32'h00000014,32'h5a01ffff,4'hf)           ;//lightning_mac2_enable_reg
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000014,pcie_bar_rd_data_reg)         ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000018,pcie_bar_rd_data_reg)         ;//lightning_mac2_loopback_reg
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_write_data(32'h0000001c,32'h5a01ffff,4'hf)           ;//lightning_mac3_enable_reg
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h0000001c,pcie_bar_rd_data_reg)         ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000020,pcie_bar_rd_data_reg)         ;//lightning_mac3_loopback_reg
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000024,pcie_bar_rd_data_reg)         ;//udma_port0_rxloss_packet[63:32]
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000028,pcie_bar_rd_data_reg)         ;//udma_port0_rxloss_packet[31:0]
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h0000002c,pcie_bar_rd_data_reg)         ;//udma_port1_rxloss_packet[63:32]
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000030,pcie_bar_rd_data_reg)         ;//udma_port1_rxloss_packet[31:0]
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000034,pcie_bar_rd_data_reg)         ;//udma_port2_rxloss_packet[63:32]
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000038,pcie_bar_rd_data_reg)         ;//udma_port2_rxloss_packet[31:0]
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h0000003c,pcie_bar_rd_data_reg)         ;//udma_port3_rxloss_packet[63:32]
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000040,pcie_bar_rd_data_reg)         ;//udma_port3_rxloss_packet[31:0]

        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_write_data(32'h00000100,32'h5a010100,4'hf)           ;//user_reg0
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000100,pcie_bar_rd_data_reg)         ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_write_data(32'h00000104,32'h5a010104,4'hf)           ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000104,pcie_bar_rd_data_reg)         ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_write_data(32'h00000108,32'h5a010108,4'hf)           ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h00000108,pcie_bar_rd_data_reg)         ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_write_data(32'h0000010c,32'h5a01010c,4'hf)           ;
        #(1*DELAY_UNIT);
        u_m_axi4_lite_if.m_axi_read_data(32'h0000010c,pcie_bar_rd_data_reg)         ;

        #(2*DELAY_TO_WAIT);
        end
    end
    //------
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            pcie_bar_rd_data_reg <= 0                                               ;
        end else if(i_m_axi_rvalid && o_m_axi_rready) begin
            pcie_bar_rd_data_reg <= i_m_axi_rdata                                   ;
        end else begin
            pcie_bar_rd_data_reg <= pcie_bar_rd_data_reg                            ;
        end
    end
    
//--------------------------------------------------------------------------------
    //------Instantiate AXI4-lite master module
    
    m_axi4_lite_if          u_m_axi4_lite_if (
    //---
    .sys_clk                                (sys_clk                                ),//I
    .sys_rst_n                              (sys_rst_n                              ),//I
    //---awaddr
    .o_m_axi_awaddr                         (o_m_axi_awaddr                         ),//O    [31:00]
    .o_m_axi_awvalid                        (o_m_axi_awvalid                        ),//O
    .o_m_axi_awprot                         (o_m_axi_awprot                         ),//O    [02:00]  default 3'b000
    .i_m_axi_awready                        (i_m_axi_awready                        ),//I
    //---wdata
    .o_m_axi_wdata                          (o_m_axi_wdata                          ),//O    [31:00]
    .o_m_axi_wstrb                          (o_m_axi_wstrb                          ),//O    [03:00]
    .o_m_axi_wvalid                         (o_m_axi_wvalid                         ),//O
    .i_m_axi_wready                         (i_m_axi_wready                         ),//I
    //---bresp
    .i_m_axi_bresp                          (i_m_axi_bresp                          ),//I    [01:00]
    .i_m_axi_bvalid                         (i_m_axi_bvalid                         ),//I
    .o_m_axi_bready                         (o_m_axi_bready                         ),//O
    //---araddr
    .o_m_axi_araddr                         (o_m_axi_araddr                         ),//O    [31:00]
    .o_m_axi_arvalid                        (o_m_axi_arvalid                        ),//O
    .o_m_axi_arprot                         (o_m_axi_arprot                         ),//O    [02:00]  default 3'b000
    .i_m_axi_arready                        (i_m_axi_arready                        ),//I
    //---rdata
    .i_m_axi_rdata                          (i_m_axi_rdata                          ),//I    [31:00]
    .i_m_axi_rresp                          (i_m_axi_rresp                          ),//I    [01:00]
    .i_m_axi_rvalid                         (i_m_axi_rvalid                         ),//O
    .o_m_axi_rready                         (o_m_axi_rready                         ) //O
    );

//--------------------------------------------------------------------------------

endmodule


//--------------------------------------------------------------------------------
    /*
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
    
    //-------
    wire                                    local_sys_clk                           ;
    wire                                    local_sys_rst_n                         ;
    wire                                    local_sys_clk_locked                    ;
    assign sys_clk_locked = sys_clk_locked                                          ;
//  assign axis_clk     =    sys_clk                                                ;
//  assign axis_rst_n   =   (sys_clk_locked)? sys_rst_n : 1'b0                      ;
    assign axis_clk     = (CLOCK_MODE)? sys_clk : local_sys_clk                     ;
    assign axis_rst_n   = (CLOCK_MODE)? sys_rst_n :
                                        (sys_clk_locked)? local_sys_rst_n : 1'b0    ;
//--------------------------------------------------------------------------------
    //------Define AXI4-lite interface port
    wire                                    w_axi_aclk                              ;
    wire                                    w_axi_aresetn                           ;

    wire    [31:00]                         w_axi_awaddr                            ;
    wire                                    w_axi_awvalid                           ;
    wire                                    w_axi_awready                           ;
    
    wire    [31:00]                         w_axi_wdata                             ;
    wire    [03:00]                         w_axi_wstrb                             ;
    wire                                    w_axi_wvalid                            ;
    wire                                    w_axi_wready                            ;
    
    wire    [01:00]                         w_axi_bresp                             ;
    wire                                    w_axi_bvalid                            ;
    wire                                    w_axi_bready                            ;
    
    wire    [31:00]                         w_axi_araddr                            ;
    wire                                    w_axi_arvalid                           ;
    wire                                    w_axi_arready                           ;
    
    wire    [31:00]                         w_axi_rdata                             ;
    wire    [01:00]                         w_axi_rresp                             ;
    wire                                    w_axi_rvalid                            ;
    wire                                    w_axi_rready                            ;

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
    */
    //------Instantiate AXI4-lite master module
    /*
    m_axi4_lite_if u_m_axi4_lite_if (
    .sys_clk                                (sys_clk                                ),
    .sys_rst_n                              (sys_rst_n                              ),
    .o_m_axi_awaddr                         (w_axi_awaddr                           ),
    .o_m_axi_awvalid                        (w_axi_awvalid                          ),
    .i_m_axi_awready                        (w_axi_awready                          ),
    .o_m_axi_wdata                          (w_axi_wdata                            ),
    .o_m_axi_wstrb                          (w_axi_wstrb                            ),
    .o_m_axi_wvalid                         (w_axi_wvalid                           ),
    .i_m_axi_wready                         (w_axi_wready                           ),
    .i_m_axi_bresp                          (w_axi_bresp                            ),
    .i_m_axi_bvalid                         (w_axi_bvalid                           ),
    .o_m_axi_bready                         (w_axi_bready                           ),
    .o_m_axi_araddr                         (w_axi_araddr                           ),
    .o_m_axi_arvalid                        (w_axi_arvalid                          ),
    .i_m_axi_arready                        (w_axi_arready                          ),
    .i_m_axi_rdata                          (w_axi_rdata                            ),
    .i_m_axi_rresp                          (w_axi_rresp                            ),
    .i_m_axi_rvalid                         (w_axi_rvalid                           ),
    .o_m_axi_rready                         (w_axi_rready                           )
    );
    */
    /*
    //------Instantiate AXI4-lite slave IP core
    s_axi4_lite_if      u_s_axi4_lite_if(
    .i_s_axi_aclk                           (sys_clk                                ),
    .i_s_axi_aresetn                        (sys_rst_n                              ),
//  .i_s_axi_aclk                           (w_axi_aclk                             ),//(i_s_axi_aclk              ),
//  .i_s_axi_aresetn                        (w_axi_aresetn                          ),//(i_s_axi_aresetn           ),
    .i_s_axi_awaddr                         (w_axi_awaddr                           ),//(i_s_axi_awaddr            ),
    .i_s_axi_awprot                         ('d0                                    ),//(i_s_axi_awprot            ),
    .i_s_axi_awvalid                        (w_axi_awvalid                          ),//(i_s_axi_awvalid           ),
    .o_s_axi_awready                        (w_axi_awready                          ),//(o_s_axi_awready           ),
    .i_s_axi_wdata                          (w_axi_wdata                            ),//(i_s_axi_wdata             ),
    .i_s_axi_wstrb                          (w_axi_wstrb                            ),//(i_s_axi_wstrb             ),
    .i_s_axi_wvalid                         (w_axi_wvalid                           ),//(i_s_axi_wvalid            ),
    .o_s_axi_wready                         (w_axi_wready                           ),//(o_s_axi_wready            ),
    .o_s_axi_bresp                          (w_axi_bresp                            ),//(o_s_axi_bresp             ),
    .o_s_axi_bvalid                         (w_axi_bvalid                           ),//(o_s_axi_bvalid            ),
    .i_s_axi_bready                         (w_axi_bready                           ),//(i_s_axi_bready            ),
    .i_s_axi_araddr                         (w_axi_araddr                           ),//(i_s_axi_araddr            ),
    .i_s_axi_arprot                         ('d0                                    ),//(i_s_axi_arprot            ),
    .i_s_axi_arvalid                        (w_axi_arvalid                          ),//(i_s_axi_arvalid           ),
    .o_s_axi_arready                        (w_axi_arready                          ),//(o_s_axi_arready           ),
    .o_s_axi_rdata                          (w_axi_rdata                            ),//(o_s_axi_rdata             ),
    .o_s_axi_rresp                          (w_axi_rresp                            ),//(o_s_axi_rresp             ),
    .o_s_axi_rvalid                         (w_axi_rvalid                           ),//(o_s_axi_rvalid            ),
    .i_s_axi_rready                         (w_axi_rready                           ),//(i_s_axi_rready            ),

    .o_ctrl_wr_addr                         (w_ctrl_wr_addr                         ),
    .o_ctrl_wr_en                           (w_ctrl_wr_en                           ),
    .o_ctrl_wr_data                         (w_ctrl_wr_data                         ),
    .o_ctrl_wr_mask                         (w_ctrl_wr_mask                         ),
    .o_ctrl_rd_addr                         (w_ctrl_rd_addr                         ),
    .i_ctrl_rd_data                         (w_ctrl_rd_data                         )
    );
    */
//--------------------------------------------------------------------------------