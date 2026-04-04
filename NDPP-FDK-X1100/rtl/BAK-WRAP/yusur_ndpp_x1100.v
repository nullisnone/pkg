 

module yusur_ndpp_x1100 ( 
    // System Clock
    input   wire            clk_conv_in,        // 50 MHz in fact

    // PCI Express Interface
    input   wire            pcie_refclk_p,      // PCIe reference clock
    input   wire            pcie_refclk_n,      // PCIe reference clock
    input   wire            pcie_perst_n,       // Reset from the PCIe edge connector reset signal
    output  wire[7:0]       pci_exp_txp,        // PCIe TX serial interface
    output  wire[7:0]       pci_exp_txn,        // PCIe TX serial interface
    input   wire[7:0]       pci_exp_rxp,        // PCIe RX serial interface
    input   wire[7:0]       pci_exp_rxn,        // PCIe RX serial interface
    
     // SFP Clock
    input   wire            sfp_refclk_p,       // GT reference clock
    input   wire            sfp_refclk_n,       // GT reference clock
    // SFP#0
    output  wire            sfp0_txp,           // GT serial output
    output  wire            sfp0_txn,           // GT serial output
    input   wire            sfp0_rxp,           // GT serial input
    input   wire            sfp0_rxn,           // GT serial input

    // SFP#1
    output  wire            sfp1_txp,           // GT serial output
    output  wire            sfp1_txn,           // GT serial output
    input   wire            sfp1_rxp,           // GT serial input
    input   wire            sfp1_rxn,           // GT serial input

    // SFP#2
    output  wire            sfp2_txp,           // GT serial output
    output  wire            sfp2_txn,           // GT serial output
    input   wire            sfp2_rxp,           // GT serial input
    input   wire            sfp2_rxn,           // GT serial input

    // SFP#3
    output  wire            sfp3_txp,           // GT serial output
    output  wire            sfp3_txn,           // GT serial output
    input   wire            sfp3_rxp,           // GT serial input
    input   wire            sfp3_rxn,           // GT serial input

    //** SFP STATUS SIGNAL
    //****** SFP#0 STATUS
    output  wire            sfp0_rs0,
    output  wire            sfp0_rs1,
    output  wire            sfp0_tx_dis,
    input   wire            sfp0_tx_fault,
    input   wire            sfp0_mod_abs,
    input   wire            sfp0_rx_los,

    //****** SFP#1 STATUS
    output  wire            sfp1_rs0,
    output  wire            sfp1_rs1,
    output  wire            sfp1_tx_dis,
    input   wire            sfp1_tx_fault,
    input   wire            sfp1_mod_abs,
    input   wire            sfp1_rx_los,

    //****** SFP#2 STATUS
    output  wire            sfp2_rs0,
    output  wire            sfp2_rs1,
    output  wire            sfp2_tx_dis,
    input   wire            sfp2_tx_fault,
    input   wire            sfp2_mod_abs,
    input   wire            sfp2_rx_los,

    //****** SFP#3 STATUS
    output  wire            sfp3_rs0,
    output  wire            sfp3_rs1,
    output  wire            sfp3_tx_dis,
    input   wire            sfp3_tx_fault,
    input   wire            sfp3_mod_abs,
    input   wire            sfp3_rx_los,
    
    //** IIC
    inout   wire            iic_rtl_scl_io,
    inout   wire            iic_rtl_sda_io,

    //** EEPROM SIGNAL
    inout   wire            iic_eeprom_scl,
    inout   wire            iic_eeprom_sda,
    
    //** SFP IIC
    inout   wire            x1100_sfp0_i2c_scl,
    inout   wire            x1100_sfp0_i2c_sda,

    inout   wire            x1100_sfp1_i2c_scl,
    inout   wire            x1100_sfp1_i2c_sda,

    inout   wire            x1100_sfp2_i2c_scl,
    inout   wire            x1100_sfp2_i2c_sda,

    inout   wire            x1100_sfp3_i2c_scl,
    inout   wire            x1100_sfp3_i2c_sda,

    //** LED SIGNAL
    output  wire            x1100_sfp0_link_led,
    output  wire            x1100_sfp0_active_led,
    output  wire            x1100_sfp1_link_led,
    output  wire            x1100_sfp1_active_led,
    output  wire            x1100_sfp2_link_led,
    output  wire            x1100_sfp2_active_led,
    output  wire            x1100_sfp3_link_led,
    output  wire            x1100_sfp3_active_led

);

//*****************************************************************
//*  SIGNAL DEFINITION
//*****************************************************************   
    
    //** DMA AXI-STREAM INTERFACE
        //**** BASE DMA #0
            //******** DMA 0 RX CHANNEL ENABLE
            wire    [3:0]       base_dma0_rx_channel_enable = 'd0;
            //******** DMA 0 TX AXI-STREAM INTERFACE
            wire    [31:0]      base_dma0_axi_st_tx_tdata;
            wire                base_dma0_axi_st_tx_tvalid;
            wire    [3:0]       base_dma0_axi_st_tx_tkeep;
            wire                base_dma0_axi_st_tx_tlast;
            wire                base_dma0_axi_st_tx_tready = 'd0;

            //******** DMA 0 RX AXI-STREAM INTERFACE
            wire    [31:0]      base_dma0_axi_st_rx_tdata = 'd0;
            wire                base_dma0_axi_st_rx_tvalid = 'd0;
            wire    [2:0]       base_dma0_axi_st_rx_tuser = 'd0;
            wire    [3:0]       base_dma0_axi_st_rx_tkeep = 'd0;
            wire                base_dma0_axi_st_rx_tlast = 'd0;
            wire                base_dma0_axi_st_rx_tready;
            wire                base_dma0_rx_ready_enable = 'd0;

        //**** BASE DMA #1
            //******** DMA 1 RX CHANNEL ENABLE
            wire    [3:0]       base_dma1_rx_channel_enable = 'd0;
            //******** DMA 1 TX AXI-STREAM INTERFACE
            wire    [31:0]      base_dma1_axi_st_tx_tdata;
            wire                base_dma1_axi_st_tx_tvalid;
            wire    [3:0]       base_dma1_axi_st_tx_tkeep;
            wire                base_dma1_axi_st_tx_tlast;
            wire                base_dma1_axi_st_tx_tready = 'd0;

            //******** DMA 1 RX AXI-STREAM INTERFACE
            wire    [31:0]      base_dma1_axi_st_rx_tdata = 'd0;
            wire                base_dma1_axi_st_rx_tvalid = 'd0;
            wire    [2:0]       base_dma1_axi_st_rx_tuser = 'd0;
            wire    [3:0]       base_dma1_axi_st_rx_tkeep = 'd0;
            wire                base_dma1_axi_st_rx_tlast = 'd0;
            wire                base_dma1_axi_st_rx_tready;
            wire                base_dma1_rx_ready_enable = 'd0;

        //**** USER DMA
            //******** USER DMA CTRL SIGNAL
                //******** CROSSBAR SIGNAL
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan0;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan1;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan2;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan3;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan4;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan5;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan6;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan7;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan8;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan9;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan10;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan11;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan12;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan13;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan14;
                wire    [1:0]       user_dma_tx_crossbar_ctrl_chan15;
                
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan0;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan1;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan2;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan3;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan4;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan5;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan6;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan7;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan8;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan9;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan10;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan11;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan12;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan13;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan14;
                wire    [1:0]       user_dma_rx_crossbar_ctrl_chan15;
                //******** RX CHANNEL SIGNAL
//                wire    [15:0]      user_dma_rx_chennel_enable;
            //******** PORT - 0
                //******** PORT 0 TX AXI-STREAM INTERFACE
                wire                user_dma_axi_st_port0_tx_tvalid;
                wire    [3:0]       user_dma_axi_st_port0_tx_tuser;
                wire                user_dma_axi_st_port0_tx_tlast;
                wire    [63:0]      user_dma_axi_st_port0_tx_tdata;
                wire    [7:0]       user_dma_axi_st_port0_tx_tstrb;
                wire                user_dma_axi_st_port0_tx_tready;
                //******** PORT 0 RX AXI-STREAM INTERFACE
                wire                user_dma_axi_st_port0_rx_tvalid;
                wire    [4:0]       user_dma_axi_st_port0_rx_tuser;
                wire                user_dma_axi_st_port0_rx_tlast;
                wire    [63:0]      user_dma_axi_st_port0_rx_tdata;
                wire    [7:0]       user_dma_axi_st_port0_rx_tstrb;
                wire                user_dma_axi_st_port0_rx_tready;
            //******** PORT - 1
                //******** PORT 1 TX AXI-STREAM INTERFACE
                wire                user_dma_axi_st_port1_tx_tvalid;
                wire    [3:0]       user_dma_axi_st_port1_tx_tuser;
                wire                user_dma_axi_st_port1_tx_tlast;
                wire    [63:0]      user_dma_axi_st_port1_tx_tdata;
                wire    [7:0]       user_dma_axi_st_port1_tx_tstrb;
                wire                user_dma_axi_st_port1_tx_tready;
                //******** PORT 1 RX AXI-STREAM INTERFACE
                wire                user_dma_axi_st_port1_rx_tvalid;
                wire    [4:0]       user_dma_axi_st_port1_rx_tuser;
                wire                user_dma_axi_st_port1_rx_tlast;
                wire    [63:0]      user_dma_axi_st_port1_rx_tdata;
                wire    [7:0]       user_dma_axi_st_port1_rx_tstrb;
                wire                user_dma_axi_st_port1_rx_tready;
            
            //******** PORT - 2
                //******** PORT 2 TX AXI-STREAM INTERFACE
                wire                user_dma_axi_st_port2_tx_tvalid;
                wire    [3:0]       user_dma_axi_st_port2_tx_tuser;
                wire                user_dma_axi_st_port2_tx_tlast;
                wire    [63:0]      user_dma_axi_st_port2_tx_tdata;
                wire    [7:0]       user_dma_axi_st_port2_tx_tstrb;
                wire                user_dma_axi_st_port2_tx_tready;
                //******** PORT 2 RX AXI-STREAM INTERFACE
                wire                user_dma_axi_st_port2_rx_tvalid;
                wire    [4:0]       user_dma_axi_st_port2_rx_tuser;
                wire                user_dma_axi_st_port2_rx_tlast;
                wire    [63:0]      user_dma_axi_st_port2_rx_tdata;
                wire    [7:0]       user_dma_axi_st_port2_rx_tstrb;
                wire                user_dma_axi_st_port2_rx_tready;
            //******** PORT - 3
                //******** PORT 3 TX AXI-STREAM INTERFACE
                wire                user_dma_axi_st_port3_tx_tvalid;
                wire    [3:0]       user_dma_axi_st_port3_tx_tuser;
                wire                user_dma_axi_st_port3_tx_tlast;
                wire    [63:0]      user_dma_axi_st_port3_tx_tdata;
                wire    [7:0]       user_dma_axi_st_port3_tx_tstrb;
                wire                user_dma_axi_st_port3_tx_tready;
                //******** PORT 3 RX AXI-STREAM INTERFACE
                wire                user_dma_axi_st_port3_rx_tvalid;
                wire    [4:0]       user_dma_axi_st_port3_rx_tuser;
                wire                user_dma_axi_st_port3_rx_tlast;
                wire    [63:0]      user_dma_axi_st_port3_rx_tdata;
                wire    [7:0]       user_dma_axi_st_port3_rx_tstrb;
                wire                user_dma_axi_st_port3_rx_tready;

//*********************** END *************************************
    //------------------------------------------------------------------------
    //------
    wire                    pcie_axi_aclk                       ;//250MHz
    wire                    pcie_axi_aresetn                    ;
    //------ndpp_bar1_axil 
    wire    [31:00]         ndpp_bar1_axil_awaddr               ;
    wire    [02:00]         ndpp_bar1_axil_awprot               ;
    wire                    ndpp_bar1_axil_awvalid              ;
    wire    [31:00]         ndpp_bar1_axil_wdata                ;
    wire    [03:00]         ndpp_bar1_axil_wstrb                ;
    wire                    ndpp_bar1_axil_wvalid               ;
    wire                    ndpp_bar1_axil_bready               ;
    wire    [31:00]         ndpp_bar1_axil_araddr               ;
    wire    [02:00]         ndpp_bar1_axil_arprot               ;
    wire                    ndpp_bar1_axil_arvalid              ;
    wire                    ndpp_bar1_axil_rready               ;
    wire                    ndpp_bar1_axil_awready              ;
    wire                    ndpp_bar1_axil_wready               ;
    wire                    ndpp_bar1_axil_bvalid               ;
    wire    [01:00]         ndpp_bar1_axil_bresp                ;
    wire                    ndpp_bar1_axil_arready              ;
    wire    [31:00]         ndpp_bar1_axil_rdata                ;
    wire    [01:00]         ndpp_bar1_axil_rresp                ;
    wire                    ndpp_bar1_axil_rvalid               ;

    //------MAC - 0
    wire                    sfp0_link                           ;
    wire                    sfp0_act                            ; 
    wire                    mac0tx_clk                          ;
    wire                    mac0rx_clk                          ;
    wire                    mac0tx_user_resetn                  ;
    wire                    mac0rx_user_resetn                  ;

    wire                    mac0tx_axis_tvalid = 'd0            ;
    wire                    mac0tx_axis_tuser  = 'd0            ;
    wire                    mac0tx_axis_tlast  = 'd0            ;
    wire    [03:00]         mac0tx_axis_tkeep  = 'd0            ;
    wire    [31:00]         mac0tx_axis_tdata  = 'd0            ;
    wire                    mac0tx_axis_tready                  ; 

    wire                    mac0rx_axis_tvalid                  ;
    wire                    mac0rx_axis_tuser                   ;
    wire                    mac0rx_axis_tlast                   ;
    wire    [31:00]         mac0rx_axis_tdata                   ;
    wire    [03:00]         mac0rx_axis_tstrb                   ;
    wire                    mac0rx_axis_tready                  ;//NC

    //------MAC - 1
    wire                    sfp1_link                           ;
    wire                    sfp1_act                            ;
    wire                    mac1tx_clk                          ;
    wire                    mac1rx_clk                          ;
    wire                    mac1tx_user_resetn                  ;
    wire                    mac1rx_user_resetn                  ;

    wire                    mac1tx_axis_tvalid = 'd0            ;
    wire                    mac1tx_axis_tuser  = 'd0            ;
    wire                    mac1tx_axis_tlast  = 'd0            ;
    wire    [03:00]         mac1tx_axis_tkeep  = 'd0            ;
    wire    [31:00]         mac1tx_axis_tdata  = 'd0            ;
    wire                    mac1tx_axis_tready                  ;   

    wire                    mac1rx_axis_tvalid                  ;
    wire                    mac1rx_axis_tuser                   ;
    wire                    mac1rx_axis_tlast                   ;
    wire    [31:00]         mac1rx_axis_tdata                   ;
    wire    [03:00]         mac1rx_axis_tstrb                   ;
    wire                    mac1rx_axis_tready                  ;//NC

    //------MAC - 2
    wire                    sfp2_link                           ;
    wire                    sfp2_act                            ;
    wire                    mac2tx_clk                          ;
    wire                    mac2rx_clk                          ;
    wire                    mac2tx_user_resetn                  ;
    wire                    mac2rx_user_resetn                  ;

    wire                    mac2tx_axis_tvalid= 0               ;
    wire                    mac2tx_axis_tuser = 0               ;
    wire                    mac2tx_axis_tlast = 0               ;
    wire    [03:00]         mac2tx_axis_tkeep = 0               ;
    wire    [31:00]         mac2tx_axis_tdata = 0               ;
    wire                    mac2tx_axis_tready                  ;
    
    wire                    mac2rx_axis_tvalid                  ;
    wire                    mac2rx_axis_tuser                   ;
    wire                    mac2rx_axis_tlast                   ;
    wire    [31:00]         mac2rx_axis_tdata                   ;
    wire    [03:00]         mac2rx_axis_tstrb                   ;

    //------MAC - 3
    wire                    sfp3_link                           ;
    wire                    sfp3_act                            ;
    wire                    mac3tx_clk                          ;
    wire                    mac3rx_clk                          ;
    wire                    mac3tx_user_resetn                  ;
    wire                    mac3rx_user_resetn                  ;

    wire                    mac3tx_axis_tvalid = 'd0            ;
    wire                    mac3tx_axis_tuser  = 'd0            ;
    wire                    mac3tx_axis_tlast  = 'd0            ;
    wire    [03:00]         mac3tx_axis_tkeep  = 'd0            ;
    wire    [31:00]         mac3tx_axis_tdata  = 'd0            ;
    wire                    mac3tx_axis_tready                  ;
 

    wire                    mac3rx_axis_tvalid                  ;
    wire                    mac3rx_axis_tuser                   ;
    wire                    mac3rx_axis_tlast                   ;
    wire    [31:00]         mac3rx_axis_tdata                   ;
    wire    [03:00]         mac3rx_axis_tstrb                   ;
 
    //------BAR-1
    wire [31:00]            sfp_status                          ;
    wire [31:00]            sfp_status_inner                    ;//Reserved for 4-QSFP/16-MAC

    wire [31:00]            soft_reset_req                      ;
    reg  [31:00]            soft_reset_cnt                      ;
    wire [00:00]            soft_reset_n                        ;
    reg  [31:00]            soft_reset_ack                      ;
    
    wire [31:00]            market_reset_req                    ;
    reg  [31:00]            market_reset_cnt                    ;
    wire [00:00]            market_reset_n                      ;
    reg  [31:00]            market_reset_ack                    ;
    
    wire [31:00]            order_reset_req                     ;
    reg  [31:00]            order_reset_cnt                     ;
    wire [00:00]            order_reset_n                       ;
    reg  [31:00]            order_reset_ack                     ;
    
    wire [31:00]            strategy_reset_req                  ;
    reg  [31:00]            strategy_reset_cnt                  ;
    wire [00:00]            strategy_reset_n                    ;       
    reg  [31:00]            strategy_reset_ack                  ;

    wire [31:00]            wd_reset_req                        ;
    reg  [31:00]            wd_reset_cnt                        ;
    wire [00:00]            wd_reset_n                          ;
    reg  [31:00]            wd_reset_ack                        ;
    //------vio: only for test.
    wire                    vio_rstn_req = 1'b1                 ;
    wire                    vio_market_rstn_req                 ;
    wire                    vio_order_rstn_req                  ;
    wire                    vio_strategy_rstn_req               ;
    wire                    vio_wd_rstn_req                     ;
    wire [31:00]            vio_version                         ;
    wire                    vio_rx_rstn                         ;
    wire [31:00]            result_version                      ; 
    
    // USER DMA TX CROSSBAR SIGNAL
    assign  user_dma_tx_crossbar_ctrl_chan0    =   2'd0;
    assign  user_dma_tx_crossbar_ctrl_chan1    =   2'd0;
    assign  user_dma_tx_crossbar_ctrl_chan2    =   2'd0;
    assign  user_dma_tx_crossbar_ctrl_chan3    =   2'd0;

    assign  user_dma_tx_crossbar_ctrl_chan4    =   2'd1;
    assign  user_dma_tx_crossbar_ctrl_chan5    =   2'd1;
    assign  user_dma_tx_crossbar_ctrl_chan6    =   2'd1;
    assign  user_dma_tx_crossbar_ctrl_chan7    =   2'd1;

    assign  user_dma_tx_crossbar_ctrl_chan8    =   2'd2;
    assign  user_dma_tx_crossbar_ctrl_chan9    =   2'd2;
    assign  user_dma_tx_crossbar_ctrl_chan10   =   2'd2;
    assign  user_dma_tx_crossbar_ctrl_chan11   =   2'd2;

    assign  user_dma_tx_crossbar_ctrl_chan12   =   2'd3;
    assign  user_dma_tx_crossbar_ctrl_chan13   =   2'd3;
    assign  user_dma_tx_crossbar_ctrl_chan14   =   2'd3;
    assign  user_dma_tx_crossbar_ctrl_chan15   =   2'd3;
    
    // USER DMA RX CROSSBAR SIGNAL
    assign  user_dma_rx_crossbar_ctrl_chan0    =   2'd0;
    assign  user_dma_rx_crossbar_ctrl_chan1    =   2'd0;
    assign  user_dma_rx_crossbar_ctrl_chan2    =   2'd0;
    assign  user_dma_rx_crossbar_ctrl_chan3    =   2'd0;

    assign  user_dma_rx_crossbar_ctrl_chan4    =   2'd1;
    assign  user_dma_rx_crossbar_ctrl_chan5    =   2'd1;
    assign  user_dma_rx_crossbar_ctrl_chan6    =   2'd1;
    assign  user_dma_rx_crossbar_ctrl_chan7    =   2'd1;

    assign  user_dma_rx_crossbar_ctrl_chan8    =   2'd2;
    assign  user_dma_rx_crossbar_ctrl_chan9    =   2'd2;
    assign  user_dma_rx_crossbar_ctrl_chan10   =   2'd2;
    assign  user_dma_rx_crossbar_ctrl_chan11   =   2'd2;

    assign  user_dma_rx_crossbar_ctrl_chan12   =   2'd3;
    assign  user_dma_rx_crossbar_ctrl_chan13   =   2'd3;
    assign  user_dma_rx_crossbar_ctrl_chan14   =   2'd3;
    assign  user_dma_rx_crossbar_ctrl_chan15   =   2'd3;


    //------------------------------------------------------------------------
    assign sfp_status       = { 4'b0000, sfp3_link,  sfp2_link,  sfp1_link,  sfp0_link, 12'b0000_0000_0000,
                                sfp3_act,   sfp2_act,   sfp1_act,   sfp0_act,  8'b0000_0000
                                };//
    assign sfp_status_inner = { 12'b0000_0000_0000,  sfp3_act,   sfp2_act,   sfp1_act,   sfp0_act,
                                12'b0000_0000_0000,  sfp3_link,  sfp2_link,  sfp1_link,  sfp0_link
                                };    
    assign result_version   = (soft_reset_n)? vio_version : 0   ;
    //------------------------------------------------------------------------
    //------soft_reset_req
    localparam      PERIOD_1US           = 32'd249              ;//1us@250MHz
    localparam      PERIOD_100US         = 32'd24_999           ;//1us@250MHz
    localparam      PERIOD_1MS           = 32'd249_999          ;//1ms@250MHz

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn)
    begin
        //---
        if(!pcie_axi_aresetn) begin
            soft_reset_cnt  <=  32'h0                           ;
        end else if(!vio_rstn_req) begin
            soft_reset_cnt  <=  32'h1                           ;
        end else if(soft_reset_req > 32'h0) begin
            soft_reset_cnt  <=  32'h1                           ;
        end else if(soft_reset_cnt > 32'h0) begin
            if(soft_reset_cnt >= PERIOD_100US)begin
                soft_reset_cnt  <=  32'h0                       ;
            end else begin
                soft_reset_cnt  <=  soft_reset_cnt + 32'h1      ;
            end
        end
        else begin
                soft_reset_cnt  <=  soft_reset_cnt              ;
        end 
    end

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn)
    begin
        //---
        if(!pcie_axi_aresetn) begin
            soft_reset_ack <= 32'h1111_1111;
        end else if(!vio_rstn_req) begin
            soft_reset_ack <= 32'h0;
        end else if(soft_reset_cnt == 32'h1) begin
            soft_reset_ack <= 32'h0;
        end else if(soft_reset_cnt == PERIOD_100US) begin
            soft_reset_ack <= 32'hffff_ffff;
        end else begin
            soft_reset_ack <= soft_reset_ack;
        end 
    end

    assign soft_reset_n = (soft_reset_cnt == 32'h0)? 1'b1 : 1'b0; 
    
    //------------------------------------------------------------------------yusur_ndpp_fdk
 
yusur_ndpp_fdk u_yusur_ndpp_fdk(
//! FPGA BOARD PIN
  //** CLOCK
    .clk_conv_in                     ( clk_conv_in                     ),
    .pcie_refclk_p                   ( pcie_refclk_p                   ),
    .pcie_refclk_n                   ( pcie_refclk_n                   ),
    .pcie_perst_n                    ( pcie_perst_n                    ),
    .sfp_refclk_p                    ( sfp_refclk_p                    ),
    .sfp_refclk_n                    ( sfp_refclk_n                    ),
  //** PCIE PIN
    .pci_exp_txp                     ( pci_exp_txp                     ),
    .pci_exp_txn                     ( pci_exp_txn                     ),
    .pci_exp_rxp                     ( pci_exp_rxp                     ),
    .pci_exp_rxn                     ( pci_exp_rxn                     ),
  //** SFP PIN
    .sfp0_txp                        ( sfp0_txp                        ),
    .sfp0_txn                        ( sfp0_txn                        ),
    .sfp0_rxp                        ( sfp0_rxp                        ),
    .sfp0_rxn                        ( sfp0_rxn                        ),

    .sfp1_txp                        ( sfp1_txp                        ),
    .sfp1_txn                        ( sfp1_txn                        ),
    .sfp1_rxp                        ( sfp1_rxp                        ),
    .sfp1_rxn                        ( sfp1_rxn                        ),

    .sfp2_txp                        ( sfp2_txp                        ),
    .sfp2_txn                        ( sfp2_txn                        ),
    .sfp2_rxp                        ( sfp2_rxp                        ),
    .sfp2_rxn                        ( sfp2_rxn                        ),

    .sfp3_txp                        ( sfp3_txp                        ),
    .sfp3_txn                        ( sfp3_txn                        ),
    .sfp3_rxp                        ( sfp3_rxp                        ),
    .sfp3_rxn                        ( sfp3_rxn                        ),
    
   //** SFP STATUS PIN
     .sfp0_rs0                        ( sfp0_rs0                        ),
     .sfp0_rs1                        ( sfp0_rs1                        ),
     .sfp0_tx_dis                     ( sfp0_tx_dis                     ),
     .sfp0_tx_fault                   ( sfp0_tx_fault                   ),
     .sfp0_mod_abs                    ( sfp0_mod_abs                    ),
     .sfp0_rx_los                     ( sfp0_rx_los                     ),

     .sfp1_rs0                        ( sfp1_rs0                        ),
     .sfp1_rs1                        ( sfp1_rs1                        ),
     .sfp1_tx_dis                     ( sfp1_tx_dis                     ),
     .sfp1_tx_fault                   ( sfp1_tx_fault                   ),
     .sfp1_mod_abs                    ( sfp1_mod_abs                    ),
     .sfp1_rx_los                     ( sfp1_rx_los                     ),

     .sfp2_rs0                        ( sfp2_rs0                        ),
     .sfp2_rs1                        ( sfp2_rs1                        ),
     .sfp2_tx_dis                     ( sfp2_tx_dis                     ),
     .sfp2_tx_fault                   ( sfp2_tx_fault                   ),
     .sfp2_mod_abs                    ( sfp2_mod_abs                    ),
     .sfp2_rx_los                     ( sfp2_rx_los                     ),

     .sfp3_rs0                        ( sfp3_rs0                        ),
     .sfp3_rs1                        ( sfp3_rs1                        ),
     .sfp3_tx_dis                     ( sfp3_tx_dis                     ),
     .sfp3_tx_fault                   ( sfp3_tx_fault                   ),
     .sfp3_mod_abs                    ( sfp3_mod_abs                    ),
     .sfp3_rx_los                     ( sfp3_rx_los                     ),
   //** IIC
     .iic_rtl_scl_io                  ( iic_rtl_scl_io                  ),
     .iic_rtl_sda_io                  ( iic_rtl_sda_io                  ),
   //** EEPROM PIN
     .iic_eeprom_scl                  ( iic_eeprom_scl                  ),
     .iic_eeprom_sda                  ( iic_eeprom_sda                  ),
   //** SFP IIC
     .x1100_sfp0_i2c_scl              ( x1100_sfp0_i2c_scl              ),
     .x1100_sfp0_i2c_sda              ( x1100_sfp0_i2c_sda              ),
     .x1100_sfp1_i2c_scl              ( x1100_sfp1_i2c_scl              ),
     .x1100_sfp1_i2c_sda              ( x1100_sfp1_i2c_sda              ),
     .x1100_sfp2_i2c_scl              ( x1100_sfp2_i2c_scl              ),
     .x1100_sfp2_i2c_sda              ( x1100_sfp2_i2c_sda              ),
     .x1100_sfp3_i2c_scl              ( x1100_sfp3_i2c_scl              ),
     .x1100_sfp3_i2c_sda              ( x1100_sfp3_i2c_sda              ),
   //** LED PIN
     .x1100_sfp0_link_led             ( x1100_sfp0_link_led             ),
     .x1100_sfp0_active_led           ( x1100_sfp0_active_led           ),
     .x1100_sfp1_link_led             ( x1100_sfp1_link_led             ),
     .x1100_sfp1_active_led           ( x1100_sfp1_active_led           ),
     .x1100_sfp2_link_led             ( x1100_sfp2_link_led             ),
     .x1100_sfp2_active_led           ( x1100_sfp2_active_led           ),
     .x1100_sfp3_link_led             ( x1100_sfp3_link_led             ),
     .x1100_sfp3_active_led           ( x1100_sfp3_active_led           ),
    
  //** CLOCK
    .pcie_axi_clk                    ( pcie_axi_aclk                   ),
    .pcie_axi_resetn                 ( pcie_axi_aresetn                ),

    .mac0tx_user_clk                 ( mac0tx_clk                      ),
    .mac0tx_user_resetn              ( mac0tx_user_resetn              ),
    .mac0rx_user_clk                 ( mac0rx_clk                      ),
    .mac0rx_user_resetn              ( mac0rx_user_resetn              ),

    .mac1tx_user_clk                 ( mac1tx_clk                      ),
    .mac1tx_user_resetn              ( mac1tx_user_resetn              ),
    .mac1rx_user_clk                 ( mac1rx_clk                      ),
    .mac1rx_user_resetn              ( mac1rx_user_resetn              ),

    .mac2tx_user_clk                 ( mac2tx_clk                      ),
    .mac2tx_user_resetn              ( mac2tx_user_resetn              ),
    .mac2rx_user_clk                 ( mac2rx_clk                      ),
    .mac2rx_user_resetn              ( mac2rx_user_resetn              ),

    .mac3tx_user_clk                 ( mac3tx_clk                      ),
    .mac3tx_user_resetn              ( mac3tx_user_resetn              ),
    .mac3rx_user_clk                 ( mac3rx_clk                      ),
    .mac3rx_user_resetn              ( mac3rx_user_resetn              ),
  //** AXI-LITE IF
    .user_bar1_axi_lite_awaddr       ( ndpp_bar1_axil_awaddr           ),
    .user_bar1_axi_lite_awprot       ( ndpp_bar1_axil_awprot           ),
    .user_bar1_axi_lite_awvalid      ( ndpp_bar1_axil_awvalid          ),
    .user_bar1_axi_lite_wdata        ( ndpp_bar1_axil_wdata            ),
    .user_bar1_axi_lite_wstrb        ( ndpp_bar1_axil_wstrb            ),
    .user_bar1_axi_lite_wvalid       ( ndpp_bar1_axil_wvalid           ),
    .user_bar1_axi_lite_bready       ( ndpp_bar1_axil_bready           ),
    .user_bar1_axi_lite_araddr       ( ndpp_bar1_axil_araddr           ),
    .user_bar1_axi_lite_arprot       ( ndpp_bar1_axil_arprot           ),
    .user_bar1_axi_lite_arvalid      ( ndpp_bar1_axil_arvalid          ),
    .user_bar1_axi_lite_rready       ( ndpp_bar1_axil_rready           ),
    .user_bar1_axi_lite_awready      ( ndpp_bar1_axil_awready          ),
    .user_bar1_axi_lite_wready       ( ndpp_bar1_axil_wready           ),
    .user_bar1_axi_lite_bvalid       ( ndpp_bar1_axil_bvalid           ),
    .user_bar1_axi_lite_bresp        ( ndpp_bar1_axil_bresp            ),
    .user_bar1_axi_lite_arready      ( ndpp_bar1_axil_arready          ),
    .user_bar1_axi_lite_rdata        ( ndpp_bar1_axil_rdata            ),
    .user_bar1_axi_lite_rresp        ( ndpp_bar1_axil_rresp            ),
    .user_bar1_axi_lite_rvalid       ( ndpp_bar1_axil_rvalid           ),
  //** MAC CONTROL && STATUS IF
    .lightning_mac0_enable           ( 1'b1                            ),   //! NOT USE
    .lightning_mac0_loopback         ( 1'b0                            ),   //! NOT USE
    .lightning_mac0_link_status      ( sfp0_link                       ),
    .lightning_mac0_active_status    ( sfp0_act                        ),

    .lightning_mac1_enable           ( 1'b1                            ),   //! NOT USE
    .lightning_mac1_loopback         ( 1'b0                            ),   //! NOT USE
    .lightning_mac1_link_status      ( sfp1_link                       ),
    .lightning_mac1_active_status    ( sfp1_act                        ),

    .lightning_mac2_enable           ( 1'b1                            ),
    .lightning_mac2_loopback         ( 1'b0                            ),
    .lightning_mac2_link_status      ( sfp2_link                       ),
    .lightning_mac2_active_status    ( sfp2_act                        ),

    .lightning_mac3_enable           ( 1'b1                            ),
    .lightning_mac3_loopback         ( 1'b0                            ),
    .lightning_mac3_link_status      ( sfp3_link                       ),
    .lightning_mac3_active_status    ( sfp3_act                        ),
  //** MAC AXI-STREAM IF
    .lightning_mac0_axi_st_tx_tvalid ( mac0tx_axis_tvalid              ),
    .lightning_mac0_axi_st_tx_tuser  ( mac0tx_axis_tuser               ),
    .lightning_mac0_axi_st_tx_tlast  ( mac0tx_axis_tlast               ),
    .lightning_mac0_axi_st_tx_tstrb  ( mac0tx_axis_tkeep               ),
    .lightning_mac0_axi_st_tx_tdata  ( mac0tx_axis_tdata               ),
    .lightning_mac0_axi_st_tx_tready ( mac0tx_axis_tready              ),

    .lightning_mac0_axi_st_rx_tvalid ( mac0rx_axis_tvalid              ),
    .lightning_mac0_axi_st_rx_tuser  ( mac0rx_axis_tuser               ),
    .lightning_mac0_axi_st_rx_tlast  ( mac0rx_axis_tlast               ),
    .lightning_mac0_axi_st_rx_tdata  ( mac0rx_axis_tdata               ),
    .lightning_mac0_axi_st_rx_tstrb  ( mac0rx_axis_tstrb               ),

    .lightning_mac1_axi_st_tx_tvalid ( mac1tx_axis_tvalid              ),
    .lightning_mac1_axi_st_tx_tuser  ( mac1tx_axis_tuser               ),
    .lightning_mac1_axi_st_tx_tlast  ( mac1tx_axis_tlast               ),
    .lightning_mac1_axi_st_tx_tstrb  ( mac1tx_axis_tkeep               ),
    .lightning_mac1_axi_st_tx_tdata  ( mac1tx_axis_tdata               ),
    .lightning_mac1_axi_st_tx_tready ( mac1tx_axis_tready              ),

    .lightning_mac1_axi_st_rx_tvalid ( mac1rx_axis_tvalid              ),
    .lightning_mac1_axi_st_rx_tuser  ( mac1rx_axis_tuser               ),
    .lightning_mac1_axi_st_rx_tlast  ( mac1rx_axis_tlast               ),
    .lightning_mac1_axi_st_rx_tdata  ( mac1rx_axis_tdata               ),
    .lightning_mac1_axi_st_rx_tstrb  ( mac1rx_axis_tstrb               ),

    .lightning_mac2_axi_st_tx_tvalid ( mac2tx_axis_tvalid              ),
    .lightning_mac2_axi_st_tx_tuser  ( mac2tx_axis_tuser               ),
    .lightning_mac2_axi_st_tx_tlast  ( mac2tx_axis_tlast               ),
    .lightning_mac2_axi_st_tx_tstrb  ( mac2tx_axis_tkeep               ),
    .lightning_mac2_axi_st_tx_tdata  ( mac2tx_axis_tdata               ),
    .lightning_mac2_axi_st_tx_tready ( mac2tx_axis_tready              ),

    .lightning_mac2_axi_st_rx_tvalid ( mac2rx_axis_tvalid              ),
    .lightning_mac2_axi_st_rx_tuser  ( mac2rx_axis_tuser               ),
    .lightning_mac2_axi_st_rx_tlast  ( mac2rx_axis_tlast               ),
    .lightning_mac2_axi_st_rx_tdata  ( mac2rx_axis_tdata               ),
    .lightning_mac2_axi_st_rx_tstrb  ( mac2rx_axis_tstrb               ),

    .lightning_mac3_axi_st_tx_tvalid ( mac3tx_axis_tvalid              ),
    .lightning_mac3_axi_st_tx_tuser  ( mac3tx_axis_tuser               ),
    .lightning_mac3_axi_st_tx_tlast  ( mac3tx_axis_tlast               ),
    .lightning_mac3_axi_st_tx_tstrb  ( mac3tx_axis_tkeep               ),
    .lightning_mac3_axi_st_tx_tdata  ( mac3tx_axis_tdata               ),
    .lightning_mac3_axi_st_tx_tready ( mac3tx_axis_tready              ),

    .lightning_mac3_axi_st_rx_tvalid ( mac3rx_axis_tvalid              ),
    .lightning_mac3_axi_st_rx_tuser  ( mac3rx_axis_tuser               ),
    .lightning_mac3_axi_st_rx_tlast  ( mac3rx_axis_tlast               ),
    .lightning_mac3_axi_st_rx_tdata  ( mac3rx_axis_tdata               ),
    .lightning_mac3_axi_st_rx_tstrb  ( mac3rx_axis_tstrb               ),

  //** BASE DMA
    //**** BASE DMA 0
    .base_dma0_axi_st_tx_tdata       ( base_dma0_axi_st_tx_tdata       ),
    .base_dma0_axi_st_tx_tvalid      ( base_dma0_axi_st_tx_tvalid      ),
    .base_dma0_axi_st_tx_tkeep       ( base_dma0_axi_st_tx_tkeep       ),
    .base_dma0_axi_st_tx_tlast       ( base_dma0_axi_st_tx_tlast       ),
    .base_dma0_axi_st_tx_tready      ( base_dma0_axi_st_tx_tready      ),

    .base_dma0_axi_st_rx_tdata       ( base_dma0_axi_st_rx_tdata       ),
    .base_dma0_axi_st_rx_tvalid      ( base_dma0_axi_st_rx_tvalid      ),
    .base_dma0_axi_st_rx_tuser       ( base_dma0_axi_st_rx_tuser       ),
    .base_dma0_axi_st_rx_tkeep       ( base_dma0_axi_st_rx_tkeep       ),
    .base_dma0_axi_st_rx_tlast       ( base_dma0_axi_st_rx_tlast       ),
//    .base_dma0_axi_st_rx_tready      ( base_dma0_axi_st_rx_tready      ),
//    .base_dma0_rx_ready_enable       ( base_dma0_rx_ready_enable       ),
//    .base_dma0_rx_channel_enable     ( base_dma0_rx_channel_enable     ),
    //**** BASE DMA 1
    .base_dma1_axi_st_tx_tdata       ( base_dma1_axi_st_tx_tdata       ),
    .base_dma1_axi_st_tx_tvalid      ( base_dma1_axi_st_tx_tvalid      ),
    .base_dma1_axi_st_tx_tkeep       ( base_dma1_axi_st_tx_tkeep       ),
    .base_dma1_axi_st_tx_tlast       ( base_dma1_axi_st_tx_tlast       ),
    .base_dma1_axi_st_tx_tready      ( base_dma1_axi_st_tx_tready      ),

    .base_dma1_axi_st_rx_tdata       ( base_dma1_axi_st_rx_tdata       ),
    .base_dma1_axi_st_rx_tvalid      ( base_dma1_axi_st_rx_tvalid      ),
    .base_dma1_axi_st_rx_tuser       ( base_dma1_axi_st_rx_tuser       ),
    .base_dma1_axi_st_rx_tkeep       ( base_dma1_axi_st_rx_tkeep       ),
    .base_dma1_axi_st_rx_tlast       ( base_dma1_axi_st_rx_tlast       ),
//    .base_dma1_axi_st_rx_tready      ( base_dma1_axi_st_rx_tready      ),
//    .base_dma1_rx_ready_enable       ( base_dma1_rx_ready_enable       ),
//    .base_dma1_rx_channel_enable     ( base_dma1_rx_channel_enable     ),

  //** USER DMA
    //**** CTRL SIGNAL
    .user_dma_tx_crossbar_ctrl_chan0    ( user_dma_tx_crossbar_ctrl_chan0    ),
    .user_dma_tx_crossbar_ctrl_chan1    ( user_dma_tx_crossbar_ctrl_chan1    ),
    .user_dma_tx_crossbar_ctrl_chan2    ( user_dma_tx_crossbar_ctrl_chan2    ),
    .user_dma_tx_crossbar_ctrl_chan3    ( user_dma_tx_crossbar_ctrl_chan3    ),
    .user_dma_tx_crossbar_ctrl_chan4    ( user_dma_tx_crossbar_ctrl_chan4    ),
    .user_dma_tx_crossbar_ctrl_chan5    ( user_dma_tx_crossbar_ctrl_chan5    ),
    .user_dma_tx_crossbar_ctrl_chan6    ( user_dma_tx_crossbar_ctrl_chan6    ),
    .user_dma_tx_crossbar_ctrl_chan7    ( user_dma_tx_crossbar_ctrl_chan7    ),
    .user_dma_tx_crossbar_ctrl_chan8    ( user_dma_tx_crossbar_ctrl_chan8    ),
    .user_dma_tx_crossbar_ctrl_chan9    ( user_dma_tx_crossbar_ctrl_chan9    ),
    .user_dma_tx_crossbar_ctrl_chan10   ( user_dma_tx_crossbar_ctrl_chan10   ),
    .user_dma_tx_crossbar_ctrl_chan11   ( user_dma_tx_crossbar_ctrl_chan11   ),
    .user_dma_tx_crossbar_ctrl_chan12   ( user_dma_tx_crossbar_ctrl_chan12   ),
    .user_dma_tx_crossbar_ctrl_chan13   ( user_dma_tx_crossbar_ctrl_chan13   ),
    .user_dma_tx_crossbar_ctrl_chan14   ( user_dma_tx_crossbar_ctrl_chan14   ),
    .user_dma_tx_crossbar_ctrl_chan15   ( user_dma_tx_crossbar_ctrl_chan15   ),
//    .user_dma_rx_chennel_enable         ( user_dma_rx_chennel_enable         ),
    
    .user_dma_rx_crossbar_ctrl_chan0    ( user_dma_rx_crossbar_ctrl_chan0    ),
    .user_dma_rx_crossbar_ctrl_chan1    ( user_dma_rx_crossbar_ctrl_chan1    ),
    .user_dma_rx_crossbar_ctrl_chan2    ( user_dma_rx_crossbar_ctrl_chan2    ),
    .user_dma_rx_crossbar_ctrl_chan3    ( user_dma_rx_crossbar_ctrl_chan3    ),
    .user_dma_rx_crossbar_ctrl_chan4    ( user_dma_rx_crossbar_ctrl_chan4    ),
    .user_dma_rx_crossbar_ctrl_chan5    ( user_dma_rx_crossbar_ctrl_chan5    ),
    .user_dma_rx_crossbar_ctrl_chan6    ( user_dma_rx_crossbar_ctrl_chan6    ),
    .user_dma_rx_crossbar_ctrl_chan7    ( user_dma_rx_crossbar_ctrl_chan7    ),
    .user_dma_rx_crossbar_ctrl_chan8    ( user_dma_rx_crossbar_ctrl_chan8    ),
    .user_dma_rx_crossbar_ctrl_chan9    ( user_dma_rx_crossbar_ctrl_chan9    ),
    .user_dma_rx_crossbar_ctrl_chan10   ( user_dma_rx_crossbar_ctrl_chan10   ),
    .user_dma_rx_crossbar_ctrl_chan11   ( user_dma_rx_crossbar_ctrl_chan11   ),
    .user_dma_rx_crossbar_ctrl_chan12   ( user_dma_rx_crossbar_ctrl_chan12   ),
    .user_dma_rx_crossbar_ctrl_chan13   ( user_dma_rx_crossbar_ctrl_chan13   ),
    .user_dma_rx_crossbar_ctrl_chan14   ( user_dma_rx_crossbar_ctrl_chan14   ),
    .user_dma_rx_crossbar_ctrl_chan15   ( user_dma_rx_crossbar_ctrl_chan15   ),

    //**** PORT 0
    .user_dma_axi_st_port0_tx_tvalid ( user_dma_axi_st_port0_tx_tvalid ),
    .user_dma_axi_st_port0_tx_tuser  ( user_dma_axi_st_port0_tx_tuser  ),
    .user_dma_axi_st_port0_tx_tlast  ( user_dma_axi_st_port0_tx_tlast  ),
    .user_dma_axi_st_port0_tx_tdata  ( user_dma_axi_st_port0_tx_tdata  ),
    .user_dma_axi_st_port0_tx_tstrb  ( user_dma_axi_st_port0_tx_tstrb  ),
    .user_dma_axi_st_port0_tx_tready ( user_dma_axi_st_port0_tx_tready ),
    .user_dma_axi_st_port0_rx_tvalid ( user_dma_axi_st_port0_rx_tvalid ),
    .user_dma_axi_st_port0_rx_tuser  ( user_dma_axi_st_port0_rx_tuser  ),
    .user_dma_axi_st_port0_rx_tlast  ( user_dma_axi_st_port0_rx_tlast  ),
    .user_dma_axi_st_port0_rx_tdata  ( user_dma_axi_st_port0_rx_tdata  ),
    .user_dma_axi_st_port0_rx_tstrb  ( user_dma_axi_st_port0_rx_tstrb  ),
    .user_dma_axi_st_port0_rx_tready ( user_dma_axi_st_port0_rx_tready ),
    //**** PORT 1
    .user_dma_axi_st_port1_tx_tvalid ( user_dma_axi_st_port1_tx_tvalid ),
    .user_dma_axi_st_port1_tx_tuser  ( user_dma_axi_st_port1_tx_tuser  ),
    .user_dma_axi_st_port1_tx_tlast  ( user_dma_axi_st_port1_tx_tlast  ),
    .user_dma_axi_st_port1_tx_tdata  ( user_dma_axi_st_port1_tx_tdata  ),
    .user_dma_axi_st_port1_tx_tstrb  ( user_dma_axi_st_port1_tx_tstrb  ),
    .user_dma_axi_st_port1_tx_tready ( user_dma_axi_st_port1_tx_tready ),
    .user_dma_axi_st_port1_rx_tvalid ( user_dma_axi_st_port1_rx_tvalid ),
    .user_dma_axi_st_port1_rx_tuser  ( user_dma_axi_st_port1_rx_tuser  ),
    .user_dma_axi_st_port1_rx_tlast  ( user_dma_axi_st_port1_rx_tlast  ),
    .user_dma_axi_st_port1_rx_tdata  ( user_dma_axi_st_port1_rx_tdata  ),
    .user_dma_axi_st_port1_rx_tstrb  ( user_dma_axi_st_port1_rx_tstrb  ),
    .user_dma_axi_st_port1_rx_tready ( user_dma_axi_st_port1_rx_tready ),
    //**** PORT 2
    .user_dma_axi_st_port2_tx_tvalid ( user_dma_axi_st_port2_tx_tvalid ),
    .user_dma_axi_st_port2_tx_tuser  ( user_dma_axi_st_port2_tx_tuser  ),
    .user_dma_axi_st_port2_tx_tlast  ( user_dma_axi_st_port2_tx_tlast  ),
    .user_dma_axi_st_port2_tx_tdata  ( user_dma_axi_st_port2_tx_tdata  ),
    .user_dma_axi_st_port2_tx_tstrb  ( user_dma_axi_st_port2_tx_tstrb  ),
    .user_dma_axi_st_port2_tx_tready ( user_dma_axi_st_port2_tx_tready ),
    .user_dma_axi_st_port2_rx_tvalid ( user_dma_axi_st_port2_rx_tvalid ),
    .user_dma_axi_st_port2_rx_tuser  ( user_dma_axi_st_port2_rx_tuser  ),
    .user_dma_axi_st_port2_rx_tlast  ( user_dma_axi_st_port2_rx_tlast  ),
    .user_dma_axi_st_port2_rx_tdata  ( user_dma_axi_st_port2_rx_tdata  ),
    .user_dma_axi_st_port2_rx_tstrb  ( user_dma_axi_st_port2_rx_tstrb  ),
    .user_dma_axi_st_port2_rx_tready ( user_dma_axi_st_port2_rx_tready ),
    //**** PORT 3
    .user_dma_axi_st_port3_tx_tvalid ( user_dma_axi_st_port3_tx_tvalid ),
    .user_dma_axi_st_port3_tx_tuser  ( user_dma_axi_st_port3_tx_tuser  ),
    .user_dma_axi_st_port3_tx_tlast  ( user_dma_axi_st_port3_tx_tlast  ),
    .user_dma_axi_st_port3_tx_tdata  ( user_dma_axi_st_port3_tx_tdata  ),
    .user_dma_axi_st_port3_tx_tstrb  ( user_dma_axi_st_port3_tx_tstrb  ),
    .user_dma_axi_st_port3_tx_tready ( user_dma_axi_st_port3_tx_tready ),
    .user_dma_axi_st_port3_rx_tvalid ( user_dma_axi_st_port3_rx_tvalid ),
    .user_dma_axi_st_port3_rx_tuser  ( user_dma_axi_st_port3_rx_tuser  ),
    .user_dma_axi_st_port3_rx_tlast  ( user_dma_axi_st_port3_rx_tlast  ),
    .user_dma_axi_st_port3_rx_tdata  ( user_dma_axi_st_port3_rx_tdata  ),
    .user_dma_axi_st_port3_rx_tstrb  ( user_dma_axi_st_port3_rx_tstrb  ),
    .user_dma_axi_st_port3_rx_tready ( user_dma_axi_st_port3_rx_tready  )
);
     

    //------------------------------------------------------------------------MAC0-RX
    reg                     mac0rx_axis_tvalid_reg1	            ;
    reg                     mac0rx_axis_tuser_reg1              ;
    reg                     mac0rx_axis_tlast_reg1              ;
    reg     [31:00]         mac0rx_axis_tdata_reg1              ;
    reg     [03:00]         mac0rx_axis_tstrb_reg1              ;
    reg                     mac0rx_axis_tvalid_reg2             ;
    reg                     mac0rx_axis_tuser_reg2		        ;
    reg                     mac0rx_axis_tlast_reg2		        ;
    reg     [31:00]         mac0rx_axis_tdata_reg2		        ;
    reg     [03:00]         mac0rx_axis_tstrb_reg2		        ;

    always@(posedge mac0rx_clk or negedge mac0rx_user_resetn)
    begin
        if(!mac0rx_user_resetn)begin
			mac0rx_axis_tvalid_reg1	 <= 0                       ;
			mac0rx_axis_tuser_reg1	 <= 0                       ;
			mac0rx_axis_tlast_reg1	 <= 0                       ;
			mac0rx_axis_tdata_reg1	 <= 0                       ;
			mac0rx_axis_tstrb_reg1	 <= 0                       ;

			mac0rx_axis_tvalid_reg2	 <= 0                       ;
			mac0rx_axis_tuser_reg2	 <= 0                       ;
			mac0rx_axis_tlast_reg2	 <= 0                       ;
			mac0rx_axis_tdata_reg2	 <= 0                       ;
			mac0rx_axis_tstrb_reg2	 <= 0                       ;
		end else begin
			mac0rx_axis_tvalid_reg1	 <= mac0rx_axis_tvalid	    ;
			mac0rx_axis_tuser_reg1	 <= mac0rx_axis_tuser	    ;
			mac0rx_axis_tlast_reg1	 <= mac0rx_axis_tlast	    ;
			mac0rx_axis_tdata_reg1	 <= mac0rx_axis_tdata	    ;
			mac0rx_axis_tstrb_reg1	 <= mac0rx_axis_tstrb	    ;

			mac0rx_axis_tvalid_reg2	 <= mac0rx_axis_tvalid_reg1	;
			mac0rx_axis_tuser_reg2	 <= mac0rx_axis_tuser_reg1	;
			mac0rx_axis_tlast_reg2	 <= mac0rx_axis_tlast_reg1	;
			mac0rx_axis_tdata_reg2	 <= mac0rx_axis_tdata_reg1	;
			mac0rx_axis_tstrb_reg2	 <= mac0rx_axis_tstrb_reg1	;
		end
    end

    //------------------------------------------------------------------------MAC1-RX
    reg                     mac1rx_axis_tvalid_reg1	            ;
    reg                     mac1rx_axis_tuser_reg1              ;
    reg                     mac1rx_axis_tlast_reg1              ;
    reg     [31:00]         mac1rx_axis_tdata_reg1              ;
    reg     [03:00]         mac1rx_axis_tstrb_reg1              ;
    reg                     mac1rx_axis_tvalid_reg2             ;
    reg                     mac1rx_axis_tuser_reg2		        ;
    reg                     mac1rx_axis_tlast_reg2		        ;
    reg     [31:00]         mac1rx_axis_tdata_reg2		        ;
    reg     [03:00]         mac1rx_axis_tstrb_reg2		        ;

    always@(posedge mac1rx_clk or negedge mac1rx_user_resetn)
    begin
        if(!mac1rx_user_resetn)begin
			mac1rx_axis_tvalid_reg1	 <= 0                       ;
			mac1rx_axis_tuser_reg1	 <= 0                       ;
			mac1rx_axis_tlast_reg1	 <= 0                       ;
			mac1rx_axis_tdata_reg1	 <= 0                       ;
			mac1rx_axis_tstrb_reg1	 <= 0                       ;

			mac1rx_axis_tvalid_reg2	 <= 0                       ;
			mac1rx_axis_tuser_reg2	 <= 0                       ;
			mac1rx_axis_tlast_reg2	 <= 0                       ;
			mac1rx_axis_tdata_reg2	 <= 0                       ;
			mac1rx_axis_tstrb_reg2	 <= 0                       ;
		end else begin
			mac1rx_axis_tvalid_reg1	 <= mac1rx_axis_tvalid	    ;
			mac1rx_axis_tuser_reg1	 <= mac1rx_axis_tuser	    ;
			mac1rx_axis_tlast_reg1	 <= mac1rx_axis_tlast	    ;
			mac1rx_axis_tdata_reg1	 <= mac1rx_axis_tdata	    ;
			mac1rx_axis_tstrb_reg1	 <= mac1rx_axis_tstrb	    ;

			mac1rx_axis_tvalid_reg2	 <= mac1rx_axis_tvalid_reg1	;
			mac1rx_axis_tuser_reg2	 <= mac1rx_axis_tuser_reg1	;
			mac1rx_axis_tlast_reg2	 <= mac1rx_axis_tlast_reg1	;
			mac1rx_axis_tdata_reg2	 <= mac1rx_axis_tdata_reg1	;
			mac1rx_axis_tstrb_reg2	 <= mac1rx_axis_tstrb_reg1	;
		end
    end
    //------------------------------------------------------------------------
    ndpp_wrapper        u_ndpp_wrapper(
    .pcie_axi_aclk                          ( pcie_axi_aclk                 ),
    .pcie_axi_aresetn                       ( pcie_axi_aresetn              ), 
    .ndpp_bar1_axil_awaddr                  ( ndpp_bar1_axil_awaddr         ),
    .ndpp_bar1_axil_awprot                  ( ndpp_bar1_axil_awprot         ),
    .ndpp_bar1_axil_awvalid                 ( ndpp_bar1_axil_awvalid        ),
    .ndpp_bar1_axil_wdata                   ( ndpp_bar1_axil_wdata          ),
    .ndpp_bar1_axil_wstrb                   ( ndpp_bar1_axil_wstrb          ),
    .ndpp_bar1_axil_wvalid                  ( ndpp_bar1_axil_wvalid         ),
    .ndpp_bar1_axil_bready                  ( ndpp_bar1_axil_bready         ),
    .ndpp_bar1_axil_araddr                  ( ndpp_bar1_axil_araddr         ),
    .ndpp_bar1_axil_arprot                  ( ndpp_bar1_axil_arprot         ),
    .ndpp_bar1_axil_arvalid                 ( ndpp_bar1_axil_arvalid        ),
    .ndpp_bar1_axil_rready                  ( ndpp_bar1_axil_rready         ),
    .ndpp_bar1_axil_awready                 ( ndpp_bar1_axil_awready        ),
    .ndpp_bar1_axil_wready                  ( ndpp_bar1_axil_wready         ),
    .ndpp_bar1_axil_bvalid                  ( ndpp_bar1_axil_bvalid         ),
    .ndpp_bar1_axil_bresp                   ( ndpp_bar1_axil_bresp          ),
    .ndpp_bar1_axil_arready                 ( ndpp_bar1_axil_arready        ),
    .ndpp_bar1_axil_rdata                   ( ndpp_bar1_axil_rdata          ),
    .ndpp_bar1_axil_rresp                   ( ndpp_bar1_axil_rresp          ),
    .ndpp_bar1_axil_rvalid                  ( ndpp_bar1_axil_rvalid         ),
    //------
    .soft_reset_req                         (soft_reset_req                 ),//O
    .soft_reset_ack                         (soft_reset_ack                 ),//I
   
    .soft_reset_n                           (soft_reset_n                   ),//I
    
    .mac1_rx_clk                            ( mac1rx_clk                    ),
    .mac1_rx_rstn                           ( mac1rx_user_resetn            ), 
    .mac1rx_axis_tvalid                     ( mac1rx_axis_tvalid_reg1       ),//I       //( mac1rx_axis_tvalid            ),
    .mac1rx_axis_tuser                      ( mac1rx_axis_tuser_reg1        ),//I       //( mac1rx_axis_tuser             ),
    .mac1rx_axis_tlast                      ( mac1rx_axis_tlast_reg1        ),//I       //( mac1rx_axis_tlast             ),
    .mac1rx_axis_tdata                      ( mac1rx_axis_tdata_reg1        ),//I       //( mac1rx_axis_tdata             ),
    .mac1rx_axis_tstrb                      ( mac1rx_axis_tstrb_reg1        ),//I       //( mac1rx_axis_tstrb             ),
    .mac1rx_axis_tready                     ( mac1rx_axis_tready            ),//O NC
  
    //---
    .sfp_status                             ( sfp_status                    ),
    .sfp_status_inner                       ( sfp_status_inner              ),
    
    .dma_p0_rx_axis_tdata                   ( user_dma_axi_st_port0_rx_tdata             ),
    .dma_p0_rx_axis_tvalid                  ( user_dma_axi_st_port0_rx_tvalid            ),
    .dma_p0_rx_axis_tuser                   ( user_dma_axi_st_port0_rx_tuser             ),
    .dma_p0_rx_axis_tkeep                   ( user_dma_axi_st_port0_rx_tstrb             ),
    .dma_p0_rx_axis_tlast                   ( user_dma_axi_st_port0_rx_tlast             ),
    .dma_p0_rx_axis_tready                  ( user_dma_axi_st_port0_rx_tready            ),
    ///*
    .dma_p1_rx_axis_tdata                   ( user_dma_axi_st_port1_rx_tdata             ),
    .dma_p1_rx_axis_tvalid                  ( user_dma_axi_st_port1_rx_tvalid            ),
    .dma_p1_rx_axis_tuser                   ( user_dma_axi_st_port1_rx_tuser             ),
    .dma_p1_rx_axis_tkeep                   ( user_dma_axi_st_port1_rx_tstrb             ),
    .dma_p1_rx_axis_tlast                   ( user_dma_axi_st_port1_rx_tlast             ),
    .dma_p1_rx_axis_tready                  ( user_dma_axi_st_port1_rx_tready            ),//I
    
    .dma_p2_rx_axis_tdata                   ( user_dma_axi_st_port2_rx_tdata             ),
    .dma_p2_rx_axis_tvalid                  ( user_dma_axi_st_port2_rx_tvalid            ),
    .dma_p2_rx_axis_tuser                   ( user_dma_axi_st_port2_rx_tuser             ),
    .dma_p2_rx_axis_tkeep                   ( user_dma_axi_st_port2_rx_tstrb             ),
    .dma_p2_rx_axis_tlast                   ( user_dma_axi_st_port2_rx_tlast             ),
    .dma_p2_rx_axis_tready                  ( user_dma_axi_st_port2_rx_tready            ), 
    ///*
    .dma_p3_rx_axis_tdata                   ( user_dma_axi_st_port3_rx_tdata             ),
    .dma_p3_rx_axis_tvalid                  ( user_dma_axi_st_port3_rx_tvalid            ),
    .dma_p3_rx_axis_tuser                   ( user_dma_axi_st_port3_rx_tuser             ),
    .dma_p3_rx_axis_tkeep                   ( user_dma_axi_st_port3_rx_tstrb             ),
    .dma_p3_rx_axis_tlast                   ( user_dma_axi_st_port3_rx_tlast             ),
    .dma_p3_rx_axis_tready                  ( user_dma_axi_st_port3_rx_tready            ),

    .dma_p0_tx_axis_tdata                   ( user_dma_axi_st_port0_tx_tdata             ),
    .dma_p0_tx_axis_tvalid                  ( user_dma_axi_st_port0_tx_tvalid            ),
    .dma_p0_tx_axis_tuser                   ( user_dma_axi_st_port0_tx_tuser             ),
    .dma_p0_tx_axis_tstrb                   ( user_dma_axi_st_port0_tx_tstrb             ),
    .dma_p0_tx_axis_tlast                   ( user_dma_axi_st_port0_tx_tlast             ),
    .dma_p0_tx_axis_tready                  ( user_dma_axi_st_port0_tx_tready            ),

    .dma_p1_tx_axis_tdata                   ( user_dma_axi_st_port1_tx_tdata             ),
    .dma_p1_tx_axis_tvalid                  ( user_dma_axi_st_port1_tx_tvalid            ),
    .dma_p1_tx_axis_tuser                   ( user_dma_axi_st_port1_tx_tuser             ),
    .dma_p1_tx_axis_tstrb                   ( user_dma_axi_st_port1_tx_tstrb             ),
    .dma_p1_tx_axis_tlast                   ( user_dma_axi_st_port1_tx_tlast             ),
    .dma_p1_tx_axis_tready                  ( user_dma_axi_st_port1_tx_tready            ),

    .dma_p2_tx_axis_tdata                   ( user_dma_axi_st_port2_tx_tdata             ),
    .dma_p2_tx_axis_tvalid                  ( user_dma_axi_st_port2_tx_tvalid            ),
    .dma_p2_tx_axis_tuser                   ( user_dma_axi_st_port2_tx_tuser             ),
    .dma_p2_tx_axis_tstrb                   ( user_dma_axi_st_port2_tx_tstrb             ),
    .dma_p2_tx_axis_tlast                   ( user_dma_axi_st_port2_tx_tlast             ),
    .dma_p2_tx_axis_tready                  ( user_dma_axi_st_port2_tx_tready            ),

    .dma_p3_tx_axis_tdata                   ( user_dma_axi_st_port3_tx_tdata             ),
    .dma_p3_tx_axis_tvalid                  ( user_dma_axi_st_port3_tx_tvalid            ),
    .dma_p3_tx_axis_tuser                   ( user_dma_axi_st_port3_tx_tuser             ),
    .dma_p3_tx_axis_tstrb                   ( user_dma_axi_st_port3_tx_tstrb             ),
    .dma_p3_tx_axis_tlast                   ( user_dma_axi_st_port3_tx_tlast             ),
    .dma_p3_tx_axis_tready                  ( user_dma_axi_st_port3_tx_tready            )
    //*/
    );
 
endmodule 