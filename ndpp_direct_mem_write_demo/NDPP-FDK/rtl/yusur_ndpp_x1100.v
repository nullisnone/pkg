`default_nettype none
`include    "yusur_ndpp_fpga_header.vh"
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
    output  wire            pcie_active_led,
    
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

    //** BOARD PCB VERSION
    input   wire    [3:0]   board_pcb_version,

    //** FLASH SPI SIGNAL
    inout   wire            flash_1_qspi_dq4,
    inout   wire            flash_1_qspi_dq5,
    inout   wire            flash_1_qspi_dq6,
    inout   wire            flash_1_qspi_dq7,
    output  wire            flash_1_qspi_cs_b,
    
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
`ifdef USER_DMA_WIDTH_64
    localparam      USER_DMA_AXI_WIDTH      =   64;    // USER DMA Rx AXI Stream Width"64" / "256"
    localparam      USER_DMA_AXI_STRB       =   8;     // USER_DMA_AXI_WIDTH / 8
    localparam      PACKET_LOSS_FIFO_DEPTH  =   2048;
    localparam      PACKET_LOSS_FULL_THR    =   1108;
`endif
`ifdef USER_DMA_WIDTH_256
    localparam      USER_DMA_AXI_WIDTH      =   256;    // USER DMA Rx AXI Stream Width"64" / "256"
    localparam      USER_DMA_AXI_STRB       =   32;     // USER_DMA_AXI_WIDTH / 8
    localparam      PACKET_LOSS_FIFO_DEPTH  =   1024;
    localparam      PACKET_LOSS_FULL_THR    =   780;
`endif
//*****************************************************************
//*  SIGNAL DEFINITION
//*****************************************************************
    //** IIC INTERFACE
        wire            iic_rtl_scl_in;
        wire            iic_rtl_sda_in;
        wire            iic_rtl_scl_out;
        wire            iic_rtl_sda_out;

        wire            eeprom_iic_scl_in;
        wire            eeprom_iic_sda_in;
        wire            eeprom_iic_scl_out;
        wire            eeprom_iic_sda_out;

        wire            sfp0_iic_scl_in;
        wire            sfp0_iic_sda_in;
        wire            sfp0_iic_scl_out;
        wire            sfp0_iic_sda_out;
        wire            sfp1_iic_scl_in;
        wire            sfp1_iic_sda_in;
        wire            sfp1_iic_scl_out;
        wire            sfp1_iic_sda_out;
        wire            sfp2_iic_scl_in;
        wire            sfp2_iic_sda_in;
        wire            sfp2_iic_scl_out;
        wire            sfp2_iic_sda_out;
        wire            sfp3_iic_scl_in;
        wire            sfp3_iic_sda_in;
        wire            sfp3_iic_scl_out;
        wire            sfp3_iic_sda_out;
    
    //** FLASH QSPI SIGNAL
        wire            x1100_qspi_dq_out;
        wire            x1100_qspi_dq_in;
        wire            x1100_qspi_cs1_b;
        wire            x1100_qspi_dts;
    
    
    //** CLOCK DOMAIN
        //**** PCIE CLOCK DOMAIN
            wire                pcie_axi_clk;
            wire                pcie_axi_resetn;
        //**** MAC CLOCK DOMAIN
            //******** MAC-0 TX CLOCK
            wire                mac0tx_user_clk;
            wire                mac0tx_user_resetn;
            //******** MAC-0 RX CLOCK
            wire                mac0rx_user_clk;
            wire                mac0rx_user_resetn;
            //******** MAC-1 TX CLOCK
            wire                mac1tx_user_clk;
            wire                mac1tx_user_resetn;
            //******** MAC-1 RX CLOCK
            wire                mac1rx_user_clk;
            wire                mac1rx_user_resetn;
            //******** MAC-2 TX CLOCK
            wire                mac2tx_user_clk;
            wire                mac2tx_user_resetn;
            //******** MAC-2 RX CLOCK
            wire                mac2rx_user_clk;
            wire                mac2rx_user_resetn;
            //******** MAC-3 TX CLOCK
            wire                mac3tx_user_clk;
            wire                mac3tx_user_resetn;
            //******** MAC-3 RX CLOCK
            wire                mac3rx_user_clk;
            wire                mac3rx_user_resetn;
        //**** PTP-1588 CLOCK DOMAIN
            wire                ptp_1588_clk;
            wire                ptp_1588_rstn;

    //** AXI-LITE SIGNAL
        wire    [31:0]      user_bar1_axi_lite_awaddr;
        wire    [2:0]       user_bar1_axi_lite_awprot;
        wire                user_bar1_axi_lite_awvalid;
        wire    [31:0]      user_bar1_axi_lite_wdata;
        wire    [3:0]       user_bar1_axi_lite_wstrb;
        wire                user_bar1_axi_lite_wvalid;
        wire                user_bar1_axi_lite_bready;
        wire    [31:0]      user_bar1_axi_lite_araddr;
        wire    [2:0]       user_bar1_axi_lite_arprot;
        wire                user_bar1_axi_lite_arvalid;
        wire                user_bar1_axi_lite_rready;

        wire                user_bar1_axi_lite_awready;
        wire                user_bar1_axi_lite_wready;
        wire                user_bar1_axi_lite_bvalid;
        wire    [1:0]       user_bar1_axi_lite_bresp;
        wire                user_bar1_axi_lite_arready;
        wire    [31:0]      user_bar1_axi_lite_rdata;
        wire    [1:0]       user_bar1_axi_lite_rresp;
        wire                user_bar1_axi_lite_rvalid;

    //** MAC CONTROL && STATUS SIGNAL
        //****** MAC-0 CONTROL && STATUS
            wire                lightning_mac0_enable;
            wire                lightning_mac0_loopback;
            wire                lightning_mac0_link_status;
            wire                lightning_mac0_active_status;

        //****** MAC-1 CONTROL && STATUS
            wire                lightning_mac1_enable;
            wire                lightning_mac1_loopback;
            wire                lightning_mac1_link_status;
            wire                lightning_mac1_active_status;

        //****** MAC-2 CONTROL && STATUS
            wire                lightning_mac2_enable;
            wire                lightning_mac2_loopback;
            wire                lightning_mac2_link_status;
            wire                lightning_mac2_active_status;

        //****** MAC-3 CONTROL && STATUS
            wire                lightning_mac3_enable;
            wire                lightning_mac3_loopback;
            wire                lightning_mac3_link_status;
            wire                lightning_mac3_active_status;

    //** MAC AXI-STREAM INTERFACE
        //****** MAC-0 TX AXI-STREAM
            wire                lightning_mac0_axi_st_tx_tvalid;
            wire                lightning_mac0_axi_st_tx_tuser;
            wire                lightning_mac0_axi_st_tx_tlast;
            wire    [3:0]       lightning_mac0_axi_st_tx_tstrb;
            wire    [31:0]      lightning_mac0_axi_st_tx_tdata;
            wire                lightning_mac0_axi_st_tx_tready;

        //****** MAC-0 RX AXI-STREAM
            wire                lightning_mac0_axi_st_rx_tvalid;
            wire                lightning_mac0_axi_st_rx_tuser;
            wire                lightning_mac0_axi_st_rx_tlast;
            wire  [31:0]        lightning_mac0_axi_st_rx_tdata;
            wire  [3:0]         lightning_mac0_axi_st_rx_tstrb;

        //****** MAC-1 TX AXI-STREAM
            wire                lightning_mac1_axi_st_tx_tvalid;
            wire                lightning_mac1_axi_st_tx_tuser;
            wire                lightning_mac1_axi_st_tx_tlast;
            wire    [3:0]       lightning_mac1_axi_st_tx_tstrb;
            wire    [31:0]      lightning_mac1_axi_st_tx_tdata;
            wire                lightning_mac1_axi_st_tx_tready;

        //****** MAC-1 RX AXI-STREAM
            wire                lightning_mac1_axi_st_rx_tvalid;
            wire                lightning_mac1_axi_st_rx_tuser;
            wire                lightning_mac1_axi_st_rx_tlast;
            wire  [31:0]        lightning_mac1_axi_st_rx_tdata;
            wire  [3:0]         lightning_mac1_axi_st_rx_tstrb;

        //****** MAC-2 TX AXI-STREAM
            wire                lightning_mac2_axi_st_tx_tvalid;
            wire                lightning_mac2_axi_st_tx_tuser;
            wire                lightning_mac2_axi_st_tx_tlast;
            wire    [3:0]       lightning_mac2_axi_st_tx_tstrb;
            wire    [31:0]      lightning_mac2_axi_st_tx_tdata;
            wire                lightning_mac2_axi_st_tx_tready;

        //****** MAC-2 RX AXI-STREAM
            wire                lightning_mac2_axi_st_rx_tvalid;
            wire                lightning_mac2_axi_st_rx_tuser;
            wire                lightning_mac2_axi_st_rx_tlast;
            wire  [31:0]        lightning_mac2_axi_st_rx_tdata;
            wire  [3:0]         lightning_mac2_axi_st_rx_tstrb;

        //****** MAC-3 TX AXI-STREAM
            wire                lightning_mac3_axi_st_tx_tvalid;
            wire                lightning_mac3_axi_st_tx_tuser;
            wire                lightning_mac3_axi_st_tx_tlast;
            wire    [3:0]       lightning_mac3_axi_st_tx_tstrb;
            wire    [31:0]      lightning_mac3_axi_st_tx_tdata;
            wire                lightning_mac3_axi_st_tx_tready;

        //****** MAC-3 RX AXI-STREAM
            wire                lightning_mac3_axi_st_rx_tvalid;
            wire                lightning_mac3_axi_st_rx_tuser;
            wire                lightning_mac3_axi_st_rx_tlast;
            wire  [31:0]        lightning_mac3_axi_st_rx_tdata;
            wire  [3:0]         lightning_mac3_axi_st_rx_tstrb;

    //** DMA AXI-STREAM INTERFACE
        //**** BASE DMA #0
            //******** DMA 0 TX AXI-STREAM INTERFACE
                wire    [31:0]      base_dma0_axi_st_tx_tdata;
                wire                base_dma0_axi_st_tx_tvalid;
                wire                base_dma0_axi_st_tx_bypass;
                wire    [3:0]       base_dma0_axi_st_tx_tkeep;
                wire                base_dma0_axi_st_tx_tlast;
                wire                base_dma0_axi_st_tx_tready;
            //******** DMA 0 RX AXI-STREAM INTERFACE
                wire    [31:0]      base_dma0_axi_st_rx_tdata;
                wire                base_dma0_axi_st_rx_tvalid;
                wire    [2:0]       base_dma0_axi_st_rx_tuser;
                wire    [3:0]       base_dma0_axi_st_rx_tkeep;
                wire                base_dma0_axi_st_rx_tlast;

        //**** BASE DMA #1
            //******** DMA 1 TX AXI-STREAM INTERFACE
                wire    [31:0]      base_dma1_axi_st_tx_tdata;
                wire                base_dma1_axi_st_tx_tvalid;
                wire                base_dma1_axi_st_tx_bypass;
                wire    [3:0]       base_dma1_axi_st_tx_tkeep;
                wire                base_dma1_axi_st_tx_tlast;
                wire                base_dma1_axi_st_tx_tready;
            //******** DMA 1 RX AXI-STREAM INTERFACE
                wire    [31:0]      base_dma1_axi_st_rx_tdata;
                wire                base_dma1_axi_st_rx_tvalid;
                wire    [2:0]       base_dma1_axi_st_rx_tuser;
                wire    [3:0]       base_dma1_axi_st_rx_tkeep;
                wire                base_dma1_axi_st_rx_tlast;

        //**** USER DMA
            //******** USER DMA CTRL SIGNAL
                //******** TX CROSSBAR SIGNAL
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
                //******** RX CROSSBAR SIGNAL
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
                    wire    [15:0]      user_dma_rx_chennel_enable;
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
                    wire    [USER_DMA_AXI_WIDTH-1 :0]       user_dma_axi_st_port0_rx_tdata;
                    wire    [USER_DMA_AXI_STRB-1 :0]        user_dma_axi_st_port0_rx_tstrb;
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
                    wire    [USER_DMA_AXI_WIDTH-1 :0]       user_dma_axi_st_port1_rx_tdata;
                    wire    [USER_DMA_AXI_STRB-1 :0]        user_dma_axi_st_port1_rx_tstrb;
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
                    wire    [USER_DMA_AXI_WIDTH-1 :0]       user_dma_axi_st_port2_rx_tdata;
                    wire    [USER_DMA_AXI_STRB-1 :0]        user_dma_axi_st_port2_rx_tstrb;
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
                    wire    [USER_DMA_AXI_WIDTH-1 :0]       user_dma_axi_st_port3_rx_tdata;
                    wire    [USER_DMA_AXI_STRB-1 :0]        user_dma_axi_st_port3_rx_tstrb;
                    wire                user_dma_axi_st_port3_rx_tready;
    //** PTP-1588 SIGNAL
        wire    [47:0]          ptp_1588_timestamp_sec;
        wire    [31:0]          ptp_1588_timestamp_nsec;
    //** NATIVE MEM IF
        wire                    user_logic_native_mem_valid;
        wire    [63:0]          user_logic_native_mem_address;
        wire    [255:0]         user_logic_native_mem_data;
        wire    [31:0]          user_logic_native_mem_strb;

//*********************** END *************************************

//*****************************************************************
//*  NDPP-FDK IIC INTERFACE CONNECT
//*****************************************************************
    assign  eeprom_iic_scl_in   =  iic_eeprom_scl;
    assign  eeprom_iic_sda_in   =  iic_eeprom_sda;
    assign  iic_eeprom_scl      =  eeprom_iic_scl_out ? 1'b0 :1'bz;
    assign  iic_eeprom_sda      =  eeprom_iic_sda_out ? 1'b0:1'bz;

    assign  iic_rtl_scl_in      =  iic_rtl_scl_io;
    assign  iic_rtl_sda_in      =  iic_rtl_sda_io;
    assign  iic_rtl_scl_io      =  iic_rtl_scl_out ? 1'b0 :1'bz;
    assign  iic_rtl_sda_io      =  iic_rtl_sda_out ? 1'b0:1'bz;

    assign  sfp0_iic_scl_in     =  x1100_sfp0_i2c_scl;
    assign  sfp0_iic_sda_in     =  x1100_sfp0_i2c_sda;
    assign  x1100_sfp0_i2c_scl  =  sfp0_iic_scl_out ? 1'b0 :1'bz;
    assign  x1100_sfp0_i2c_sda  =  sfp0_iic_sda_out ? 1'b0:1'bz;

    assign  sfp1_iic_scl_in     =  x1100_sfp1_i2c_scl;
    assign  sfp1_iic_sda_in     =  x1100_sfp1_i2c_sda;
    assign  x1100_sfp1_i2c_scl  =  sfp1_iic_scl_out ? 1'b0 :1'bz;
    assign  x1100_sfp1_i2c_sda  =  sfp1_iic_sda_out ? 1'b0:1'bz;

    assign  sfp2_iic_scl_in     =  x1100_sfp2_i2c_scl;
    assign  sfp2_iic_sda_in     =  x1100_sfp2_i2c_sda;
    assign  x1100_sfp2_i2c_scl  =  sfp2_iic_scl_out ? 1'b0 :1'bz;
    assign  x1100_sfp2_i2c_sda  =  sfp2_iic_sda_out ? 1'b0:1'bz;

    assign  sfp3_iic_scl_in     =  x1100_sfp3_i2c_scl;
    assign  sfp3_iic_sda_in     =  x1100_sfp3_i2c_sda;
    assign  x1100_sfp3_i2c_scl  =  sfp3_iic_scl_out ? 1'b0 :1'bz;
    assign  x1100_sfp3_i2c_sda  =  sfp3_iic_sda_out ? 1'b0:1'bz;
//*********************** END *************************************

//*****************************************************************
//*  NDPP-FDK FLASH-1 QSPI INTERFACE CONNECT
//*****************************************************************
    assign  flash_1_qspi_cs_b   =   x1100_qspi_cs1_b;
  //** SPI X4
    // assign  x1100_qspi_dq_in[0] =   flash_1_qspi_dq4;
    // assign  x1100_qspi_dq_in[1] =   flash_1_qspi_dq5;
    // assign  x1100_qspi_dq_in[2] =   flash_1_qspi_dq6;
    // assign  x1100_qspi_dq_in[3] =   flash_1_qspi_dq7;

    // assign  flash_1_qspi_dq4    =   (x1100_qspi_dts[0] == 0) ? x1100_qspi_dq_out[0] : 1'bz;
    // assign  flash_1_qspi_dq5    =   (x1100_qspi_dts[1] == 0) ? x1100_qspi_dq_out[1] : 1'bz;
    // assign  flash_1_qspi_dq6    =   (x1100_qspi_dts[2] == 0) ? x1100_qspi_dq_out[2] : 1'bz;
    // assign  flash_1_qspi_dq7    =   (x1100_qspi_dts[3] == 0) ? x1100_qspi_dq_out[3] : 1'bz;
  
  //** SPI X1
    assign  x1100_qspi_dq_in    =   flash_1_qspi_dq5;
    assign  flash_1_qspi_dq4    =   x1100_qspi_dq_out;
    assign  flash_1_qspi_dq5    =   1'bz;
    assign  flash_1_qspi_dq6    =   1'bz;
    assign  flash_1_qspi_dq7    =   1'bz;
//*********************** END *************************************

//*****************************************************************
//*  NDPP-FDK DCP MODULE
//*****************************************************************
    `ifndef SIM_EN
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
        //  //! U50 PIN
        //    .u50_hbm_cattrip                 ( hbm_cattrip                     ),
        //    .u50_user_led                    ( user_led                        ),
        //    .u50_sfp_link_led                ( sfp_link                        ),
        //    .u50_sfp_active_led              ( sfp0_act                        ),
        //! X1100/X3000 PIN
            .pcie_active_led                 ( pcie_active_led                 ),
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
            .iic_rtl_scl_in                  ( iic_rtl_scl_in                  ),
            .iic_rtl_sda_in                  ( iic_rtl_sda_in                  ),
            .iic_rtl_scl_out                 ( iic_rtl_scl_out                 ),
            .iic_rtl_sda_out                 ( iic_rtl_sda_out                 ),
        //** EEPROM PIN
            .eeprom_iic_scl_in               ( eeprom_iic_scl_in               ),
            .eeprom_iic_sda_in               ( eeprom_iic_sda_in               ),
            .eeprom_iic_scl_out              ( eeprom_iic_scl_out              ),
            .eeprom_iic_sda_out              ( eeprom_iic_sda_out              ),
        //** PCB VERSION
            .board_pcb_version               ( board_pcb_version               ),
        //** SFP IIC
            .sfp0_iic_scl_in                 ( sfp0_iic_scl_in                 ),
            .sfp0_iic_sda_in                 ( sfp0_iic_sda_in                 ),
            .sfp0_iic_scl_out                ( sfp0_iic_scl_out                ),
            .sfp0_iic_sda_out                ( sfp0_iic_sda_out                ),

            .sfp1_iic_scl_in                 ( sfp1_iic_scl_in                 ),
            .sfp1_iic_sda_in                 ( sfp1_iic_sda_in                 ),
            .sfp1_iic_scl_out                ( sfp1_iic_scl_out                ),
            .sfp1_iic_sda_out                ( sfp1_iic_sda_out                ),

            .sfp2_iic_scl_in                 ( sfp2_iic_scl_in                 ),
            .sfp2_iic_sda_in                 ( sfp2_iic_sda_in                 ),
            .sfp2_iic_scl_out                ( sfp2_iic_scl_out                ),
            .sfp2_iic_sda_out                ( sfp2_iic_sda_out                ),

            .sfp3_iic_scl_in                 ( sfp3_iic_scl_in                 ),
            .sfp3_iic_sda_in                 ( sfp3_iic_sda_in                 ),
            .sfp3_iic_scl_out                ( sfp3_iic_scl_out                ),
            .sfp3_iic_sda_out                ( sfp3_iic_sda_out                ),
        //** LED PIN
            .x1100_sfp0_link_led             ( x1100_sfp0_link_led             ),
            .x1100_sfp0_active_led           ( x1100_sfp0_active_led           ),
            .x1100_sfp1_link_led             ( x1100_sfp1_link_led             ),
            .x1100_sfp1_active_led           ( x1100_sfp1_active_led           ),
            .x1100_sfp2_link_led             ( x1100_sfp2_link_led             ),
            .x1100_sfp2_active_led           ( x1100_sfp2_active_led           ),
            .x1100_sfp3_link_led             ( x1100_sfp3_link_led             ),
            .x1100_sfp3_active_led           ( x1100_sfp3_active_led           ),
        //** FLASH QSPI SIGNAL
            .x1100_qspi_dq_out               ( x1100_qspi_dq_out               ),
            .x1100_qspi_dq_in                ( x1100_qspi_dq_in                ),
            .x1100_qspi_cs1_b                ( x1100_qspi_cs1_b                ),
            .x1100_qspi_dts                  ( x1100_qspi_dts                  ),

        //     .x3000_sfp0_led                  ( x3000_sfp0_led                  ),
        //     .x3000_sfp1_led                  ( x3000_sfp1_led                  ),
        //     .x3000_sfp2_led                  ( x3000_sfp2_led                  ),
        //     .x3000_sfp3_led                  ( x3000_sfp3_led                  ),
        //! USER LOGIC IF
        //** CLOCK
            .pcie_axi_clk                    ( pcie_axi_clk                    ),
            .pcie_axi_resetn                 ( pcie_axi_resetn                 ),

            .mac0tx_user_clk                 ( mac0tx_user_clk                 ),
            .mac0tx_user_resetn              ( mac0tx_user_resetn              ),
            .mac0rx_user_clk                 ( mac0rx_user_clk                 ),
            .mac0rx_user_resetn              ( mac0rx_user_resetn              ),

            .mac1tx_user_clk                 ( mac1tx_user_clk                 ),
            .mac1tx_user_resetn              ( mac1tx_user_resetn              ),
            .mac1rx_user_clk                 ( mac1rx_user_clk                 ),
            .mac1rx_user_resetn              ( mac1rx_user_resetn              ),

            .mac2tx_user_clk                 ( mac2tx_user_clk                 ),
            .mac2tx_user_resetn              ( mac2tx_user_resetn              ),
            .mac2rx_user_clk                 ( mac2rx_user_clk                 ),
            .mac2rx_user_resetn              ( mac2rx_user_resetn              ),

            .mac3tx_user_clk                 ( mac3tx_user_clk                 ),
            .mac3tx_user_resetn              ( mac3tx_user_resetn              ),
            .mac3rx_user_clk                 ( mac3rx_user_clk                 ),
            .mac3rx_user_resetn              ( mac3rx_user_resetn              ),

            .ptp_1588_clk                    ( ptp_1588_clk                    ),
            .ptp_1588_rstn                   ( ptp_1588_rstn                   ),
        //** AXI-LITE IF
            .user_bar1_axi_lite_awaddr       ( user_bar1_axi_lite_awaddr       ),
            .user_bar1_axi_lite_awprot       ( user_bar1_axi_lite_awprot       ),
            .user_bar1_axi_lite_awvalid      ( user_bar1_axi_lite_awvalid      ),
            .user_bar1_axi_lite_wdata        ( user_bar1_axi_lite_wdata        ),
            .user_bar1_axi_lite_wstrb        ( user_bar1_axi_lite_wstrb        ),
            .user_bar1_axi_lite_wvalid       ( user_bar1_axi_lite_wvalid       ),
            .user_bar1_axi_lite_bready       ( user_bar1_axi_lite_bready       ),
            .user_bar1_axi_lite_araddr       ( user_bar1_axi_lite_araddr       ),
            .user_bar1_axi_lite_arprot       ( user_bar1_axi_lite_arprot       ),
            .user_bar1_axi_lite_arvalid      ( user_bar1_axi_lite_arvalid      ),
            .user_bar1_axi_lite_rready       ( user_bar1_axi_lite_rready       ),
            .user_bar1_axi_lite_awready      ( user_bar1_axi_lite_awready      ),
            .user_bar1_axi_lite_wready       ( user_bar1_axi_lite_wready       ),
            .user_bar1_axi_lite_bvalid       ( user_bar1_axi_lite_bvalid       ),
            .user_bar1_axi_lite_bresp        ( user_bar1_axi_lite_bresp        ),
            .user_bar1_axi_lite_arready      ( user_bar1_axi_lite_arready      ),
            .user_bar1_axi_lite_rdata        ( user_bar1_axi_lite_rdata        ),
            .user_bar1_axi_lite_rresp        ( user_bar1_axi_lite_rresp        ),
            .user_bar1_axi_lite_rvalid       ( user_bar1_axi_lite_rvalid       ),
        //** PTP-1588 IF
            .ptp_1588_timestamp_sec          ( ptp_1588_timestamp_sec          ),
            .ptp_1588_timestamp_nsec         ( ptp_1588_timestamp_nsec         ),
        //** MAC CONTROL && STATUS IF
            .lightning_mac0_enable           ( lightning_mac0_enable          ),
            .lightning_mac0_loopback         ( lightning_mac0_loopback         ),
            .lightning_mac0_link_status      ( lightning_mac0_link_status      ),
            .lightning_mac0_active_status    ( lightning_mac0_active_status    ),

            .lightning_mac1_enable           ( lightning_mac1_enable           ),
            .lightning_mac1_loopback         ( lightning_mac1_loopback         ),
            .lightning_mac1_link_status      ( lightning_mac1_link_status      ),
            .lightning_mac1_active_status    ( lightning_mac1_active_status    ),

            .lightning_mac2_enable           ( lightning_mac2_enable           ),
            .lightning_mac2_loopback         ( lightning_mac2_loopback         ),
            .lightning_mac2_link_status      ( lightning_mac2_link_status      ),
            .lightning_mac2_active_status    ( lightning_mac2_active_status    ),

            .lightning_mac3_enable           ( lightning_mac3_enable           ),
            .lightning_mac3_loopback         ( lightning_mac3_loopback         ),
            .lightning_mac3_link_status      ( lightning_mac3_link_status      ),
            .lightning_mac3_active_status    ( lightning_mac3_active_status    ),
        //** MAC AXI-STREAM IF
            .lightning_mac0_axi_st_tx_tvalid ( lightning_mac0_axi_st_tx_tvalid ),
            .lightning_mac0_axi_st_tx_tuser  ( lightning_mac0_axi_st_tx_tuser  ),
            .lightning_mac0_axi_st_tx_tlast  ( lightning_mac0_axi_st_tx_tlast  ),
            .lightning_mac0_axi_st_tx_tstrb  ( lightning_mac0_axi_st_tx_tstrb  ),
            .lightning_mac0_axi_st_tx_tdata  ( lightning_mac0_axi_st_tx_tdata  ),
            .lightning_mac0_axi_st_tx_tready ( lightning_mac0_axi_st_tx_tready ),

            .lightning_mac0_axi_st_rx_tvalid ( lightning_mac0_axi_st_rx_tvalid ),
            .lightning_mac0_axi_st_rx_tuser  ( lightning_mac0_axi_st_rx_tuser  ),
            .lightning_mac0_axi_st_rx_tlast  ( lightning_mac0_axi_st_rx_tlast  ),
            .lightning_mac0_axi_st_rx_tdata  ( lightning_mac0_axi_st_rx_tdata  ),
            .lightning_mac0_axi_st_rx_tstrb  ( lightning_mac0_axi_st_rx_tstrb  ),

            .lightning_mac1_axi_st_tx_tvalid ( lightning_mac1_axi_st_tx_tvalid ),
            .lightning_mac1_axi_st_tx_tuser  ( lightning_mac1_axi_st_tx_tuser  ),
            .lightning_mac1_axi_st_tx_tlast  ( lightning_mac1_axi_st_tx_tlast  ),
            .lightning_mac1_axi_st_tx_tstrb  ( lightning_mac1_axi_st_tx_tstrb  ),
            .lightning_mac1_axi_st_tx_tdata  ( lightning_mac1_axi_st_tx_tdata  ),
            .lightning_mac1_axi_st_tx_tready ( lightning_mac1_axi_st_tx_tready ),

            .lightning_mac1_axi_st_rx_tvalid ( lightning_mac1_axi_st_rx_tvalid ),
            .lightning_mac1_axi_st_rx_tuser  ( lightning_mac1_axi_st_rx_tuser  ),
            .lightning_mac1_axi_st_rx_tlast  ( lightning_mac1_axi_st_rx_tlast  ),
            .lightning_mac1_axi_st_rx_tdata  ( lightning_mac1_axi_st_rx_tdata  ),
            .lightning_mac1_axi_st_rx_tstrb  ( lightning_mac1_axi_st_rx_tstrb  ),

            .lightning_mac2_axi_st_tx_tvalid ( lightning_mac2_axi_st_tx_tvalid ),
            .lightning_mac2_axi_st_tx_tuser  ( lightning_mac2_axi_st_tx_tuser  ),
            .lightning_mac2_axi_st_tx_tlast  ( lightning_mac2_axi_st_tx_tlast  ),
            .lightning_mac2_axi_st_tx_tstrb  ( lightning_mac2_axi_st_tx_tstrb  ),
            .lightning_mac2_axi_st_tx_tdata  ( lightning_mac2_axi_st_tx_tdata  ),
            .lightning_mac2_axi_st_tx_tready ( lightning_mac2_axi_st_tx_tready ),

            .lightning_mac2_axi_st_rx_tvalid ( lightning_mac2_axi_st_rx_tvalid ),
            .lightning_mac2_axi_st_rx_tuser  ( lightning_mac2_axi_st_rx_tuser  ),
            .lightning_mac2_axi_st_rx_tlast  ( lightning_mac2_axi_st_rx_tlast  ),
            .lightning_mac2_axi_st_rx_tdata  ( lightning_mac2_axi_st_rx_tdata  ),
            .lightning_mac2_axi_st_rx_tstrb  ( lightning_mac2_axi_st_rx_tstrb  ),

            .lightning_mac3_axi_st_tx_tvalid ( lightning_mac3_axi_st_tx_tvalid ),
            .lightning_mac3_axi_st_tx_tuser  ( lightning_mac3_axi_st_tx_tuser  ),
            .lightning_mac3_axi_st_tx_tlast  ( lightning_mac3_axi_st_tx_tlast  ),
            .lightning_mac3_axi_st_tx_tstrb  ( lightning_mac3_axi_st_tx_tstrb  ),
            .lightning_mac3_axi_st_tx_tdata  ( lightning_mac3_axi_st_tx_tdata  ),
            .lightning_mac3_axi_st_tx_tready ( lightning_mac3_axi_st_tx_tready ),

            .lightning_mac3_axi_st_rx_tvalid ( lightning_mac3_axi_st_rx_tvalid ),
            .lightning_mac3_axi_st_rx_tuser  ( lightning_mac3_axi_st_rx_tuser  ),
            .lightning_mac3_axi_st_rx_tlast  ( lightning_mac3_axi_st_rx_tlast  ),
            .lightning_mac3_axi_st_rx_tdata  ( lightning_mac3_axi_st_rx_tdata  ),
            .lightning_mac3_axi_st_rx_tstrb  ( lightning_mac3_axi_st_rx_tstrb  ),

        //** BASE DMA
            //**** BASE DMA 0
            .base_dma0_axi_st_tx_tdata       ( base_dma0_axi_st_tx_tdata       ),
            .base_dma0_axi_st_tx_tvalid      ( base_dma0_axi_st_tx_tvalid      ),
            .base_dma0_axi_st_tx_bypass      ( base_dma0_axi_st_tx_bypass      ),
            .base_dma0_axi_st_tx_tkeep       ( base_dma0_axi_st_tx_tkeep       ),
            .base_dma0_axi_st_tx_tlast       ( base_dma0_axi_st_tx_tlast       ),
            .base_dma0_axi_st_tx_tready      ( base_dma0_axi_st_tx_tready      ),

            .base_dma0_axi_st_rx_tdata       ( base_dma0_axi_st_rx_tdata       ),
            .base_dma0_axi_st_rx_tvalid      ( base_dma0_axi_st_rx_tvalid      ),
            .base_dma0_axi_st_rx_tuser       ( base_dma0_axi_st_rx_tuser       ),
            .base_dma0_axi_st_rx_tkeep       ( base_dma0_axi_st_rx_tkeep       ),
            .base_dma0_axi_st_rx_tlast       ( base_dma0_axi_st_rx_tlast       ),

            //**** BASE DMA 1
            .base_dma1_axi_st_tx_tdata       ( base_dma1_axi_st_tx_tdata       ),
            .base_dma1_axi_st_tx_tvalid      ( base_dma1_axi_st_tx_tvalid      ),
            .base_dma1_axi_st_tx_bypass      ( base_dma1_axi_st_tx_bypass      ),
            .base_dma1_axi_st_tx_tkeep       ( base_dma1_axi_st_tx_tkeep       ),
            .base_dma1_axi_st_tx_tlast       ( base_dma1_axi_st_tx_tlast       ),
            .base_dma1_axi_st_tx_tready      ( base_dma1_axi_st_tx_tready      ),

            .base_dma1_axi_st_rx_tdata       ( base_dma1_axi_st_rx_tdata       ),
            .base_dma1_axi_st_rx_tvalid      ( base_dma1_axi_st_rx_tvalid      ),
            .base_dma1_axi_st_rx_tuser       ( base_dma1_axi_st_rx_tuser       ),
            .base_dma1_axi_st_rx_tkeep       ( base_dma1_axi_st_rx_tkeep       ),
            .base_dma1_axi_st_rx_tlast       ( base_dma1_axi_st_rx_tlast       ),


        //** USER DMA
            //**** CTRL SIGNAL
            //****** TX CROSSBAR CTRL
            .user_dma_tx_crossbar_ctrl_chan0 ( user_dma_tx_crossbar_ctrl_chan0 ),
            .user_dma_tx_crossbar_ctrl_chan1 ( user_dma_tx_crossbar_ctrl_chan1 ),
            .user_dma_tx_crossbar_ctrl_chan2 ( user_dma_tx_crossbar_ctrl_chan2 ),
            .user_dma_tx_crossbar_ctrl_chan3 ( user_dma_tx_crossbar_ctrl_chan3 ),
            .user_dma_tx_crossbar_ctrl_chan4 ( user_dma_tx_crossbar_ctrl_chan4 ),
            .user_dma_tx_crossbar_ctrl_chan5 ( user_dma_tx_crossbar_ctrl_chan5 ),
            .user_dma_tx_crossbar_ctrl_chan6 ( user_dma_tx_crossbar_ctrl_chan6 ),
            .user_dma_tx_crossbar_ctrl_chan7 ( user_dma_tx_crossbar_ctrl_chan7 ),
            .user_dma_tx_crossbar_ctrl_chan8 ( user_dma_tx_crossbar_ctrl_chan8 ),
            .user_dma_tx_crossbar_ctrl_chan9 ( user_dma_tx_crossbar_ctrl_chan9 ),
            .user_dma_tx_crossbar_ctrl_chan10( user_dma_tx_crossbar_ctrl_chan10),
            .user_dma_tx_crossbar_ctrl_chan11( user_dma_tx_crossbar_ctrl_chan11),
            .user_dma_tx_crossbar_ctrl_chan12( user_dma_tx_crossbar_ctrl_chan12),
            .user_dma_tx_crossbar_ctrl_chan13( user_dma_tx_crossbar_ctrl_chan13),
            .user_dma_tx_crossbar_ctrl_chan14( user_dma_tx_crossbar_ctrl_chan14),
            .user_dma_tx_crossbar_ctrl_chan15( user_dma_tx_crossbar_ctrl_chan15),
            //****** RX CROSSBAR CTRL
            .user_dma_rx_crossbar_ctrl_chan0 ( user_dma_rx_crossbar_ctrl_chan0 ),
            .user_dma_rx_crossbar_ctrl_chan1 ( user_dma_rx_crossbar_ctrl_chan1 ),
            .user_dma_rx_crossbar_ctrl_chan2 ( user_dma_rx_crossbar_ctrl_chan2 ),
            .user_dma_rx_crossbar_ctrl_chan3 ( user_dma_rx_crossbar_ctrl_chan3 ),
            .user_dma_rx_crossbar_ctrl_chan4 ( user_dma_rx_crossbar_ctrl_chan4 ),
            .user_dma_rx_crossbar_ctrl_chan5 ( user_dma_rx_crossbar_ctrl_chan5 ),
            .user_dma_rx_crossbar_ctrl_chan6 ( user_dma_rx_crossbar_ctrl_chan6 ),
            .user_dma_rx_crossbar_ctrl_chan7 ( user_dma_rx_crossbar_ctrl_chan7 ),
            .user_dma_rx_crossbar_ctrl_chan8 ( user_dma_rx_crossbar_ctrl_chan8 ),
            .user_dma_rx_crossbar_ctrl_chan9 ( user_dma_rx_crossbar_ctrl_chan9 ),
            .user_dma_rx_crossbar_ctrl_chan10( user_dma_rx_crossbar_ctrl_chan10),
            .user_dma_rx_crossbar_ctrl_chan11( user_dma_rx_crossbar_ctrl_chan11),
            .user_dma_rx_crossbar_ctrl_chan12( user_dma_rx_crossbar_ctrl_chan12),
            .user_dma_rx_crossbar_ctrl_chan13( user_dma_rx_crossbar_ctrl_chan13),
            .user_dma_rx_crossbar_ctrl_chan14( user_dma_rx_crossbar_ctrl_chan14),
            .user_dma_rx_crossbar_ctrl_chan15( user_dma_rx_crossbar_ctrl_chan15),
            //****** RX CHANNEL ENABLE
            // .user_dma_rx_chennel_enable      ( user_dma_rx_chennel_enable      ),
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
            .user_dma_port0_buffer_wr_cnt    (                                 ),
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
            .user_dma_port1_buffer_wr_cnt    (                                 ),
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
            .user_dma_port2_buffer_wr_cnt    (                                 ),
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
            .user_dma_axi_st_port3_rx_tready ( user_dma_axi_st_port3_rx_tready ),
            .user_dma_port3_buffer_wr_cnt    (                                 ),

            .user_logic_native_mem_valid     ( user_logic_native_mem_valid     ),
            .user_logic_native_mem_address   ( user_logic_native_mem_address   ),
            .user_logic_native_mem_data      ( user_logic_native_mem_data      ),
            .user_logic_native_mem_strb      ( user_logic_native_mem_strb      )

        );
    `endif
//*********************** END *************************************


//*****************************************************************
//*  NDPP-FDK USER LOGIC
//*****************************************************************
    base_demo#(
        .USER_DMA_AXI_WIDTH               ( USER_DMA_AXI_WIDTH ),
        .USER_DMA_AXI_STRB                ( USER_DMA_AXI_STRB ),
        .PACKET_LOSS_FIFO_DEPTH           ( PACKET_LOSS_FIFO_DEPTH ),
        .PACKET_LOSS_FULL_THR             ( PACKET_LOSS_FULL_THR )
    )u_base_demo(
        .pcie_axi_clk                     ( pcie_axi_clk                     ),
        .pcie_axi_resetn                  ( pcie_axi_resetn                  ),
        .mac0tx_user_clk                  ( mac0tx_user_clk                  ),
        .mac0tx_user_resetn               ( mac0tx_user_resetn               ),
        .mac0rx_user_clk                  ( mac0rx_user_clk                  ),
        .mac0rx_user_resetn               ( mac0rx_user_resetn               ),
        .mac1tx_user_clk                  ( mac1tx_user_clk                  ),
        .mac1tx_user_resetn               ( mac1tx_user_resetn               ),
        .mac1rx_user_clk                  ( mac1rx_user_clk                  ),
        .mac1rx_user_resetn               ( mac1rx_user_resetn               ),
        .mac2tx_user_clk                  ( mac2tx_user_clk                  ),
        .mac2tx_user_resetn               ( mac2tx_user_resetn               ),
        .mac2rx_user_clk                  ( mac2rx_user_clk                  ),
        .mac2rx_user_resetn               ( mac2rx_user_resetn               ),
        .mac3tx_user_clk                  ( mac3tx_user_clk                  ),
        .mac3tx_user_resetn               ( mac3tx_user_resetn               ),
        .mac3rx_user_clk                  ( mac3rx_user_clk                  ),
        .mac3rx_user_resetn               ( mac3rx_user_resetn               ),
        .user_bar1_axi_lite_awaddr        ( user_bar1_axi_lite_awaddr        ),
        .user_bar1_axi_lite_awprot        ( user_bar1_axi_lite_awprot        ),
        .user_bar1_axi_lite_awvalid       ( user_bar1_axi_lite_awvalid       ),
        .user_bar1_axi_lite_wdata         ( user_bar1_axi_lite_wdata         ),
        .user_bar1_axi_lite_wstrb         ( user_bar1_axi_lite_wstrb         ),
        .user_bar1_axi_lite_wvalid        ( user_bar1_axi_lite_wvalid        ),
        .user_bar1_axi_lite_bready        ( user_bar1_axi_lite_bready        ),
        .user_bar1_axi_lite_araddr        ( user_bar1_axi_lite_araddr        ),
        .user_bar1_axi_lite_arprot        ( user_bar1_axi_lite_arprot        ),
        .user_bar1_axi_lite_arvalid       ( user_bar1_axi_lite_arvalid       ),
        .user_bar1_axi_lite_rready        ( user_bar1_axi_lite_rready        ),
        .user_bar1_axi_lite_awready       ( user_bar1_axi_lite_awready       ),
        .user_bar1_axi_lite_wready        ( user_bar1_axi_lite_wready        ),
        .user_bar1_axi_lite_bvalid        ( user_bar1_axi_lite_bvalid        ),
        .user_bar1_axi_lite_bresp         ( user_bar1_axi_lite_bresp         ),
        .user_bar1_axi_lite_arready       ( user_bar1_axi_lite_arready       ),
        .user_bar1_axi_lite_rdata         ( user_bar1_axi_lite_rdata         ),
        .user_bar1_axi_lite_rresp         ( user_bar1_axi_lite_rresp         ),
        .user_bar1_axi_lite_rvalid        ( user_bar1_axi_lite_rvalid        ),
        .lightning_mac0_enable            ( lightning_mac0_enable            ),
        .lightning_mac0_loopback          ( lightning_mac0_loopback          ),
        .lightning_mac0_link_status       ( lightning_mac0_link_status       ),
        .lightning_mac0_active_status     ( lightning_mac0_active_status     ),
        .lightning_mac1_enable            ( lightning_mac1_enable            ),
        .lightning_mac1_loopback          ( lightning_mac1_loopback          ),
        .lightning_mac1_link_status       ( lightning_mac1_link_status       ),
        .lightning_mac1_active_status     ( lightning_mac1_active_status     ),
        .lightning_mac2_enable            ( lightning_mac2_enable            ),
        .lightning_mac2_loopback          ( lightning_mac2_loopback          ),
        .lightning_mac2_link_status       ( lightning_mac2_link_status       ),
        .lightning_mac2_active_status     ( lightning_mac2_active_status     ),
        .lightning_mac3_enable            ( lightning_mac3_enable            ),
        .lightning_mac3_loopback          ( lightning_mac3_loopback          ),
        .lightning_mac3_link_status       ( lightning_mac3_link_status       ),
        .lightning_mac3_active_status     ( lightning_mac3_active_status     ),
        .lightning_mac0_axi_st_tx_tvalid  ( lightning_mac0_axi_st_tx_tvalid  ),
        .lightning_mac0_axi_st_tx_tuser   ( lightning_mac0_axi_st_tx_tuser   ),
        .lightning_mac0_axi_st_tx_tlast   ( lightning_mac0_axi_st_tx_tlast   ),
        .lightning_mac0_axi_st_tx_tstrb   ( lightning_mac0_axi_st_tx_tstrb   ),
        .lightning_mac0_axi_st_tx_tdata   ( lightning_mac0_axi_st_tx_tdata   ),
        .lightning_mac0_axi_st_tx_tready  ( lightning_mac0_axi_st_tx_tready  ),
        .lightning_mac0_axi_st_rx_tvalid  ( lightning_mac0_axi_st_rx_tvalid  ),
        .lightning_mac0_axi_st_rx_tuser   ( lightning_mac0_axi_st_rx_tuser   ),
        .lightning_mac0_axi_st_rx_tlast   ( lightning_mac0_axi_st_rx_tlast   ),
        .lightning_mac0_axi_st_rx_tdata   ( lightning_mac0_axi_st_rx_tdata   ),
        .lightning_mac0_axi_st_rx_tstrb   ( lightning_mac0_axi_st_rx_tstrb   ),
        .lightning_mac1_axi_st_tx_tvalid  ( lightning_mac1_axi_st_tx_tvalid  ),
        .lightning_mac1_axi_st_tx_tuser   ( lightning_mac1_axi_st_tx_tuser   ),
        .lightning_mac1_axi_st_tx_tlast   ( lightning_mac1_axi_st_tx_tlast   ),
        .lightning_mac1_axi_st_tx_tstrb   ( lightning_mac1_axi_st_tx_tstrb   ),
        .lightning_mac1_axi_st_tx_tdata   ( lightning_mac1_axi_st_tx_tdata   ),
        .lightning_mac1_axi_st_tx_tready  ( lightning_mac1_axi_st_tx_tready  ),
        .lightning_mac1_axi_st_rx_tvalid  ( lightning_mac1_axi_st_rx_tvalid  ),
        .lightning_mac1_axi_st_rx_tuser   ( lightning_mac1_axi_st_rx_tuser   ),
        .lightning_mac1_axi_st_rx_tlast   ( lightning_mac1_axi_st_rx_tlast   ),
        .lightning_mac1_axi_st_rx_tdata   ( lightning_mac1_axi_st_rx_tdata   ),
        .lightning_mac1_axi_st_rx_tstrb   ( lightning_mac1_axi_st_rx_tstrb   ),
        .lightning_mac2_axi_st_tx_tvalid  ( lightning_mac2_axi_st_tx_tvalid  ),
        .lightning_mac2_axi_st_tx_tuser   ( lightning_mac2_axi_st_tx_tuser   ),
        .lightning_mac2_axi_st_tx_tlast   ( lightning_mac2_axi_st_tx_tlast   ),
        .lightning_mac2_axi_st_tx_tstrb   ( lightning_mac2_axi_st_tx_tstrb   ),
        .lightning_mac2_axi_st_tx_tdata   ( lightning_mac2_axi_st_tx_tdata   ),
        .lightning_mac2_axi_st_tx_tready  ( lightning_mac2_axi_st_tx_tready  ),
        .lightning_mac2_axi_st_rx_tvalid  ( lightning_mac2_axi_st_rx_tvalid  ),
        .lightning_mac2_axi_st_rx_tuser   ( lightning_mac2_axi_st_rx_tuser   ),
        .lightning_mac2_axi_st_rx_tlast   ( lightning_mac2_axi_st_rx_tlast   ),
        .lightning_mac2_axi_st_rx_tdata   ( lightning_mac2_axi_st_rx_tdata   ),
        .lightning_mac2_axi_st_rx_tstrb   ( lightning_mac2_axi_st_rx_tstrb   ),
        .lightning_mac3_axi_st_tx_tvalid  ( lightning_mac3_axi_st_tx_tvalid  ),
        .lightning_mac3_axi_st_tx_tuser   ( lightning_mac3_axi_st_tx_tuser   ),
        .lightning_mac3_axi_st_tx_tlast   ( lightning_mac3_axi_st_tx_tlast   ),
        .lightning_mac3_axi_st_tx_tstrb   ( lightning_mac3_axi_st_tx_tstrb   ),
        .lightning_mac3_axi_st_tx_tdata   ( lightning_mac3_axi_st_tx_tdata   ),
        .lightning_mac3_axi_st_tx_tready  ( lightning_mac3_axi_st_tx_tready  ),
        .lightning_mac3_axi_st_rx_tvalid  ( lightning_mac3_axi_st_rx_tvalid  ),
        .lightning_mac3_axi_st_rx_tuser   ( lightning_mac3_axi_st_rx_tuser   ),
        .lightning_mac3_axi_st_rx_tlast   ( lightning_mac3_axi_st_rx_tlast   ),
        .lightning_mac3_axi_st_rx_tdata   ( lightning_mac3_axi_st_rx_tdata   ),
        .lightning_mac3_axi_st_rx_tstrb   ( lightning_mac3_axi_st_rx_tstrb   ),
        .base_dma0_axi_st_tx_tdata        ( base_dma0_axi_st_tx_tdata        ),
        .base_dma0_axi_st_tx_tvalid       ( base_dma0_axi_st_tx_tvalid       ),
        .base_dma0_axi_st_tx_tkeep        ( base_dma0_axi_st_tx_tkeep        ),
        .base_dma0_axi_st_tx_tlast        ( base_dma0_axi_st_tx_tlast        ),
        .base_dma0_axi_st_tx_tready       ( base_dma0_axi_st_tx_tready       ),
        .base_dma0_axi_st_rx_tdata        ( base_dma0_axi_st_rx_tdata        ),
        .base_dma0_axi_st_rx_tvalid       ( base_dma0_axi_st_rx_tvalid       ),
        .base_dma0_axi_st_rx_tuser        ( base_dma0_axi_st_rx_tuser        ),
        .base_dma0_axi_st_rx_tkeep        ( base_dma0_axi_st_rx_tkeep        ),
        .base_dma0_axi_st_rx_tlast        ( base_dma0_axi_st_rx_tlast        ),
        .base_dma1_axi_st_tx_tdata        ( base_dma1_axi_st_tx_tdata        ),
        .base_dma1_axi_st_tx_tvalid       ( base_dma1_axi_st_tx_tvalid       ),
        .base_dma1_axi_st_tx_tkeep        ( base_dma1_axi_st_tx_tkeep        ),
        .base_dma1_axi_st_tx_tlast        ( base_dma1_axi_st_tx_tlast        ),
        .base_dma1_axi_st_tx_tready       ( base_dma1_axi_st_tx_tready       ),
        .base_dma1_axi_st_rx_tdata        ( base_dma1_axi_st_rx_tdata        ),
        .base_dma1_axi_st_rx_tvalid       ( base_dma1_axi_st_rx_tvalid       ),
        .base_dma1_axi_st_rx_tuser        ( base_dma1_axi_st_rx_tuser        ),
        .base_dma1_axi_st_rx_tkeep        ( base_dma1_axi_st_rx_tkeep        ),
        .base_dma1_axi_st_rx_tlast        ( base_dma1_axi_st_rx_tlast        ),
        .user_dma_tx_crossbar_ctrl_chan0  ( user_dma_tx_crossbar_ctrl_chan0  ),
        .user_dma_tx_crossbar_ctrl_chan1  ( user_dma_tx_crossbar_ctrl_chan1  ),
        .user_dma_tx_crossbar_ctrl_chan2  ( user_dma_tx_crossbar_ctrl_chan2  ),
        .user_dma_tx_crossbar_ctrl_chan3  ( user_dma_tx_crossbar_ctrl_chan3  ),
        .user_dma_tx_crossbar_ctrl_chan4  ( user_dma_tx_crossbar_ctrl_chan4  ),
        .user_dma_tx_crossbar_ctrl_chan5  ( user_dma_tx_crossbar_ctrl_chan5  ),
        .user_dma_tx_crossbar_ctrl_chan6  ( user_dma_tx_crossbar_ctrl_chan6  ),
        .user_dma_tx_crossbar_ctrl_chan7  ( user_dma_tx_crossbar_ctrl_chan7  ),
        .user_dma_tx_crossbar_ctrl_chan8  ( user_dma_tx_crossbar_ctrl_chan8  ),
        .user_dma_tx_crossbar_ctrl_chan9  ( user_dma_tx_crossbar_ctrl_chan9  ),
        .user_dma_tx_crossbar_ctrl_chan10 ( user_dma_tx_crossbar_ctrl_chan10 ),
        .user_dma_tx_crossbar_ctrl_chan11 ( user_dma_tx_crossbar_ctrl_chan11 ),
        .user_dma_tx_crossbar_ctrl_chan12 ( user_dma_tx_crossbar_ctrl_chan12 ),
        .user_dma_tx_crossbar_ctrl_chan13 ( user_dma_tx_crossbar_ctrl_chan13 ),
        .user_dma_tx_crossbar_ctrl_chan14 ( user_dma_tx_crossbar_ctrl_chan14 ),
        .user_dma_tx_crossbar_ctrl_chan15 ( user_dma_tx_crossbar_ctrl_chan15 ),
        .user_dma_rx_crossbar_ctrl_chan0  ( user_dma_rx_crossbar_ctrl_chan0  ),
        .user_dma_rx_crossbar_ctrl_chan1  ( user_dma_rx_crossbar_ctrl_chan1  ),
        .user_dma_rx_crossbar_ctrl_chan2  ( user_dma_rx_crossbar_ctrl_chan2  ),
        .user_dma_rx_crossbar_ctrl_chan3  ( user_dma_rx_crossbar_ctrl_chan3  ),
        .user_dma_rx_crossbar_ctrl_chan4  ( user_dma_rx_crossbar_ctrl_chan4  ),
        .user_dma_rx_crossbar_ctrl_chan5  ( user_dma_rx_crossbar_ctrl_chan5  ),
        .user_dma_rx_crossbar_ctrl_chan6  ( user_dma_rx_crossbar_ctrl_chan6  ),
        .user_dma_rx_crossbar_ctrl_chan7  ( user_dma_rx_crossbar_ctrl_chan7  ),
        .user_dma_rx_crossbar_ctrl_chan8  ( user_dma_rx_crossbar_ctrl_chan8  ),
        .user_dma_rx_crossbar_ctrl_chan9  ( user_dma_rx_crossbar_ctrl_chan9  ),
        .user_dma_rx_crossbar_ctrl_chan10 ( user_dma_rx_crossbar_ctrl_chan10 ),
        .user_dma_rx_crossbar_ctrl_chan11 ( user_dma_rx_crossbar_ctrl_chan11 ),
        .user_dma_rx_crossbar_ctrl_chan12 ( user_dma_rx_crossbar_ctrl_chan12 ),
        .user_dma_rx_crossbar_ctrl_chan13 ( user_dma_rx_crossbar_ctrl_chan13 ),
        .user_dma_rx_crossbar_ctrl_chan14 ( user_dma_rx_crossbar_ctrl_chan14 ),
        .user_dma_rx_crossbar_ctrl_chan15 ( user_dma_rx_crossbar_ctrl_chan15 ),
        .user_dma_axi_st_port0_tx_tvalid  ( user_dma_axi_st_port0_tx_tvalid  ),
        .user_dma_axi_st_port0_tx_tuser   ( user_dma_axi_st_port0_tx_tuser   ),
        .user_dma_axi_st_port0_tx_tlast   ( user_dma_axi_st_port0_tx_tlast   ),
        .user_dma_axi_st_port0_tx_tdata   ( user_dma_axi_st_port0_tx_tdata   ),
        .user_dma_axi_st_port0_tx_tstrb   ( user_dma_axi_st_port0_tx_tstrb   ),
        .user_dma_axi_st_port0_tx_tready  ( user_dma_axi_st_port0_tx_tready  ),
        .user_dma_axi_st_port0_rx_tvalid  ( user_dma_axi_st_port0_rx_tvalid  ),
        .user_dma_axi_st_port0_rx_tuser   ( user_dma_axi_st_port0_rx_tuser   ),
        .user_dma_axi_st_port0_rx_tlast   ( user_dma_axi_st_port0_rx_tlast   ),
        .user_dma_axi_st_port0_rx_tdata   ( user_dma_axi_st_port0_rx_tdata   ),
        .user_dma_axi_st_port0_rx_tstrb   ( user_dma_axi_st_port0_rx_tstrb   ),
        .user_dma_axi_st_port0_rx_tready  ( user_dma_axi_st_port0_rx_tready  ),
        .user_dma_axi_st_port1_tx_tvalid  ( user_dma_axi_st_port1_tx_tvalid  ),
        .user_dma_axi_st_port1_tx_tuser   ( user_dma_axi_st_port1_tx_tuser   ),
        .user_dma_axi_st_port1_tx_tlast   ( user_dma_axi_st_port1_tx_tlast   ),
        .user_dma_axi_st_port1_tx_tdata   ( user_dma_axi_st_port1_tx_tdata   ),
        .user_dma_axi_st_port1_tx_tstrb   ( user_dma_axi_st_port1_tx_tstrb   ),
        .user_dma_axi_st_port1_tx_tready  ( user_dma_axi_st_port1_tx_tready  ),
        .user_dma_axi_st_port1_rx_tvalid  ( user_dma_axi_st_port1_rx_tvalid  ),
        .user_dma_axi_st_port1_rx_tuser   ( user_dma_axi_st_port1_rx_tuser   ),
        .user_dma_axi_st_port1_rx_tlast   ( user_dma_axi_st_port1_rx_tlast   ),
        .user_dma_axi_st_port1_rx_tdata   ( user_dma_axi_st_port1_rx_tdata   ),
        .user_dma_axi_st_port1_rx_tstrb   ( user_dma_axi_st_port1_rx_tstrb   ),
        .user_dma_axi_st_port1_rx_tready  ( user_dma_axi_st_port1_rx_tready  ),
        .user_dma_axi_st_port2_tx_tvalid  ( user_dma_axi_st_port2_tx_tvalid  ),
        .user_dma_axi_st_port2_tx_tuser   ( user_dma_axi_st_port2_tx_tuser   ),
        .user_dma_axi_st_port2_tx_tlast   ( user_dma_axi_st_port2_tx_tlast   ),
        .user_dma_axi_st_port2_tx_tdata   ( user_dma_axi_st_port2_tx_tdata   ),
        .user_dma_axi_st_port2_tx_tstrb   ( user_dma_axi_st_port2_tx_tstrb   ),
        .user_dma_axi_st_port2_tx_tready  ( user_dma_axi_st_port2_tx_tready  ),
        .user_dma_axi_st_port2_rx_tvalid  ( user_dma_axi_st_port2_rx_tvalid  ),
        .user_dma_axi_st_port2_rx_tuser   ( user_dma_axi_st_port2_rx_tuser   ),
        .user_dma_axi_st_port2_rx_tlast   ( user_dma_axi_st_port2_rx_tlast   ),
        .user_dma_axi_st_port2_rx_tdata   ( user_dma_axi_st_port2_rx_tdata   ),
        .user_dma_axi_st_port2_rx_tstrb   ( user_dma_axi_st_port2_rx_tstrb   ),
        .user_dma_axi_st_port2_rx_tready  ( user_dma_axi_st_port2_rx_tready  ),
        .user_dma_axi_st_port3_tx_tvalid  ( user_dma_axi_st_port3_tx_tvalid  ),
        .user_dma_axi_st_port3_tx_tuser   ( user_dma_axi_st_port3_tx_tuser   ),
        .user_dma_axi_st_port3_tx_tlast   ( user_dma_axi_st_port3_tx_tlast   ),
        .user_dma_axi_st_port3_tx_tdata   ( user_dma_axi_st_port3_tx_tdata   ),
        .user_dma_axi_st_port3_tx_tstrb   ( user_dma_axi_st_port3_tx_tstrb   ),
        .user_dma_axi_st_port3_tx_tready  ( user_dma_axi_st_port3_tx_tready  ),
        .user_dma_axi_st_port3_rx_tvalid  ( user_dma_axi_st_port3_rx_tvalid  ),
        .user_dma_axi_st_port3_rx_tuser   ( user_dma_axi_st_port3_rx_tuser   ),
        .user_dma_axi_st_port3_rx_tlast   ( user_dma_axi_st_port3_rx_tlast   ),
        .user_dma_axi_st_port3_rx_tdata   ( user_dma_axi_st_port3_rx_tdata   ),
        .user_dma_axi_st_port3_rx_tstrb   ( user_dma_axi_st_port3_rx_tstrb   ),
        .user_dma_axi_st_port3_rx_tready  ( user_dma_axi_st_port3_rx_tready  )
    );

//*********************** END *************************************


//*****************************************************************
//*  NDPP-FDK SIMULATION MODULE
//*****************************************************************
    `ifdef  SIM_EN
        yusur_ndpp_fdk_sim u_yusur_ndpp_fdk_sim(
        .pcie_axi_clk                    ( pcie_axi_clk                    ),//O
        .pcie_axi_resetn                 ( pcie_axi_resetn                 ),//O
        
        .mac0tx_user_clk                 ( mac0tx_user_clk                 ),//O
        .mac0tx_user_resetn              ( mac0tx_user_resetn              ),//O
        .mac0rx_user_clk                 ( mac0rx_user_clk                 ),//O
        .mac0rx_user_resetn              ( mac0rx_user_resetn              ),//O
        
        .mac1tx_user_clk                 ( mac1tx_user_clk                 ),//O
        .mac1tx_user_resetn              ( mac1tx_user_resetn              ),//O
        .mac1rx_user_clk                 ( mac1rx_user_clk                 ),//O
        .mac1rx_user_resetn              ( mac1rx_user_resetn              ),//O
        
        .mac2tx_user_clk                 ( mac2tx_user_clk                 ),//O
        .mac2tx_user_resetn              ( mac2tx_user_resetn              ),//O
        .mac2rx_user_clk                 ( mac2rx_user_clk                 ),//O
        .mac2rx_user_resetn              ( mac2rx_user_resetn              ),//O
        
        .mac3tx_user_clk                 ( mac3tx_user_clk                 ),//O
        .mac3tx_user_resetn              ( mac3tx_user_resetn              ),//O
        .mac3rx_user_clk                 ( mac3rx_user_clk                 ),//O
        .mac3rx_user_resetn              ( mac3rx_user_resetn              ),//O
    //** AXI-LITE IF
        .user_bar1_axi_lite_awaddr       ( user_bar1_axi_lite_awaddr       ),//O  [31:00]
        .user_bar1_axi_lite_awprot       ( user_bar1_axi_lite_awprot       ),//O  [02:00]
        .user_bar1_axi_lite_awvalid      ( user_bar1_axi_lite_awvalid      ),//O
        .user_bar1_axi_lite_wdata        ( user_bar1_axi_lite_wdata        ),//O  [31:00]
        .user_bar1_axi_lite_wstrb        ( user_bar1_axi_lite_wstrb        ),//O  [03:00]
        .user_bar1_axi_lite_wvalid       ( user_bar1_axi_lite_wvalid       ),//O
        .user_bar1_axi_lite_bready       ( user_bar1_axi_lite_bready       ),//O
        .user_bar1_axi_lite_araddr       ( user_bar1_axi_lite_araddr       ),//O  [31:00]
        .user_bar1_axi_lite_arprot       ( user_bar1_axi_lite_arprot       ),//O  [02:00]
        .user_bar1_axi_lite_arvalid      ( user_bar1_axi_lite_arvalid      ),//O
        .user_bar1_axi_lite_rready       ( user_bar1_axi_lite_rready       ),//O
        .user_bar1_axi_lite_awready      ( user_bar1_axi_lite_awready      ),//I
        .user_bar1_axi_lite_wready       ( user_bar1_axi_lite_wready       ),//I
        .user_bar1_axi_lite_bvalid       ( user_bar1_axi_lite_bvalid       ),//I
        .user_bar1_axi_lite_bresp        ( user_bar1_axi_lite_bresp        ),//I  [01:00]
        .user_bar1_axi_lite_arready      ( user_bar1_axi_lite_arready      ),//I
        .user_bar1_axi_lite_rdata        ( user_bar1_axi_lite_rdata        ),//I  [31:00]
        .user_bar1_axi_lite_rresp        ( user_bar1_axi_lite_rresp        ),//I  [01:00]
        .user_bar1_axi_lite_rvalid       ( user_bar1_axi_lite_rvalid       ),//I
    //** MAC CONTROL && STATUS IF
        .lightning_mac0_enable           ( 1'b0                            ),//I Set 1'b0
        .lightning_mac0_loopback         ( 1'b0                            ),//I Set 1'b0
        .lightning_mac0_link_status      ( lightning_mac0_link_status      ),//O
        .lightning_mac0_active_status    ( lightning_mac0_active_status    ),//O

        .lightning_mac1_enable           ( 1'b0                            ),//I Set 1'b0
        .lightning_mac1_loopback         ( 1'b0                            ),//I Set 1'b0
        .lightning_mac1_link_status      ( lightning_mac1_link_status      ),//O
        .lightning_mac1_active_status    ( lightning_mac1_active_status    ),//O

        .lightning_mac2_enable           ( lightning_mac2_enable           ),//I
        .lightning_mac2_loopback         ( lightning_mac2_loopback         ),//I
        .lightning_mac2_link_status      ( lightning_mac2_link_status      ),//O
        .lightning_mac2_active_status    ( lightning_mac2_active_status    ),//O

        .lightning_mac3_enable           ( lightning_mac3_enable           ),//I
        .lightning_mac3_loopback         ( lightning_mac3_loopback         ),//I
        .lightning_mac3_link_status      ( lightning_mac3_link_status      ),//O
        .lightning_mac3_active_status    ( lightning_mac3_active_status    ),//O
    //** MAC AXI-STREAM IF
        .lightning_mac0_axi_st_tx_tvalid ( lightning_mac0_axi_st_tx_tvalid ),//I
        .lightning_mac0_axi_st_tx_tuser  ( lightning_mac0_axi_st_tx_tuser  ),//I
        .lightning_mac0_axi_st_tx_tlast  ( lightning_mac0_axi_st_tx_tlast  ),//I
        .lightning_mac0_axi_st_tx_tstrb  ( lightning_mac0_axi_st_tx_tstrb  ),//I
        .lightning_mac0_axi_st_tx_tdata  ( lightning_mac0_axi_st_tx_tdata  ),//I
        .lightning_mac0_axi_st_tx_tready ( lightning_mac0_axi_st_tx_tready ),//O

        .lightning_mac0_axi_st_rx_tvalid ( lightning_mac0_axi_st_rx_tvalid ),//O
        .lightning_mac0_axi_st_rx_tuser  ( lightning_mac0_axi_st_rx_tuser  ),//O
        .lightning_mac0_axi_st_rx_tlast  ( lightning_mac0_axi_st_rx_tlast  ),//O
        .lightning_mac0_axi_st_rx_tdata  ( lightning_mac0_axi_st_rx_tdata  ),//O
        .lightning_mac0_axi_st_rx_tstrb  ( lightning_mac0_axi_st_rx_tstrb  ),//O

        .lightning_mac1_axi_st_tx_tvalid ( lightning_mac1_axi_st_tx_tvalid ),//I
        .lightning_mac1_axi_st_tx_tuser  ( lightning_mac1_axi_st_tx_tuser  ),//I
        .lightning_mac1_axi_st_tx_tlast  ( lightning_mac1_axi_st_tx_tlast  ),//I
        .lightning_mac1_axi_st_tx_tstrb  ( lightning_mac1_axi_st_tx_tstrb  ),//I
        .lightning_mac1_axi_st_tx_tdata  ( lightning_mac1_axi_st_tx_tdata  ),//I
        .lightning_mac1_axi_st_tx_tready ( lightning_mac1_axi_st_tx_tready ),//O

        .lightning_mac1_axi_st_rx_tvalid ( lightning_mac1_axi_st_rx_tvalid ),//O
        .lightning_mac1_axi_st_rx_tuser  ( lightning_mac1_axi_st_rx_tuser  ),//O
        .lightning_mac1_axi_st_rx_tlast  ( lightning_mac1_axi_st_rx_tlast  ),//O
        .lightning_mac1_axi_st_rx_tdata  ( lightning_mac1_axi_st_rx_tdata  ),//O
        .lightning_mac1_axi_st_rx_tstrb  ( lightning_mac1_axi_st_rx_tstrb  ),//O

        .lightning_mac2_axi_st_tx_tvalid ( lightning_mac2_axi_st_tx_tvalid ),//I
        .lightning_mac2_axi_st_tx_tuser  ( lightning_mac2_axi_st_tx_tuser  ),//I
        .lightning_mac2_axi_st_tx_tlast  ( lightning_mac2_axi_st_tx_tlast  ),//I
        .lightning_mac2_axi_st_tx_tstrb  ( lightning_mac2_axi_st_tx_tstrb  ),//I
        .lightning_mac2_axi_st_tx_tdata  ( lightning_mac2_axi_st_tx_tdata  ),//I
        .lightning_mac2_axi_st_tx_tready ( lightning_mac2_axi_st_tx_tready ),//O

        .lightning_mac2_axi_st_rx_tvalid ( lightning_mac2_axi_st_rx_tvalid ),//O
        .lightning_mac2_axi_st_rx_tuser  ( lightning_mac2_axi_st_rx_tuser  ),//O
        .lightning_mac2_axi_st_rx_tlast  ( lightning_mac2_axi_st_rx_tlast  ),//O
        .lightning_mac2_axi_st_rx_tdata  ( lightning_mac2_axi_st_rx_tdata  ),//O
        .lightning_mac2_axi_st_rx_tstrb  ( lightning_mac2_axi_st_rx_tstrb  ),//O

        .lightning_mac3_axi_st_tx_tvalid ( lightning_mac3_axi_st_tx_tvalid ),//I
        .lightning_mac3_axi_st_tx_tuser  ( lightning_mac3_axi_st_tx_tuser  ),//I
        .lightning_mac3_axi_st_tx_tlast  ( lightning_mac3_axi_st_tx_tlast  ),//I
        .lightning_mac3_axi_st_tx_tstrb  ( lightning_mac3_axi_st_tx_tstrb  ),//I
        .lightning_mac3_axi_st_tx_tdata  ( lightning_mac3_axi_st_tx_tdata  ),//I
        .lightning_mac3_axi_st_tx_tready ( lightning_mac3_axi_st_tx_tready ),//O

        .lightning_mac3_axi_st_rx_tvalid ( lightning_mac3_axi_st_rx_tvalid ),//O
        .lightning_mac3_axi_st_rx_tuser  ( lightning_mac3_axi_st_rx_tuser  ),//O
        .lightning_mac3_axi_st_rx_tlast  ( lightning_mac3_axi_st_rx_tlast  ),//O
        .lightning_mac3_axi_st_rx_tdata  ( lightning_mac3_axi_st_rx_tdata  ),//O
        .lightning_mac3_axi_st_rx_tstrb  ( lightning_mac3_axi_st_rx_tstrb  ),//O

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


    //** USER DMA
        //**** CTRL SIGNAL
        .user_dma_tx_crossbar_ctrl_chan0    ( user_dma_tx_crossbar_ctrl_chan0    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan1    ( user_dma_tx_crossbar_ctrl_chan1    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan2    ( user_dma_tx_crossbar_ctrl_chan2    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan3    ( user_dma_tx_crossbar_ctrl_chan3    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan4    ( user_dma_tx_crossbar_ctrl_chan4    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan5    ( user_dma_tx_crossbar_ctrl_chan5    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan6    ( user_dma_tx_crossbar_ctrl_chan6    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan7    ( user_dma_tx_crossbar_ctrl_chan7    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan8    ( user_dma_tx_crossbar_ctrl_chan8    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan9    ( user_dma_tx_crossbar_ctrl_chan9    ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan10   ( user_dma_tx_crossbar_ctrl_chan10   ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan11   ( user_dma_tx_crossbar_ctrl_chan11   ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan12   ( user_dma_tx_crossbar_ctrl_chan12   ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan13   ( user_dma_tx_crossbar_ctrl_chan13   ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan14   ( user_dma_tx_crossbar_ctrl_chan14   ),//I    [01:00]
        .user_dma_tx_crossbar_ctrl_chan15   ( user_dma_tx_crossbar_ctrl_chan15   ),//I    [01:00]
        
        .user_dma_rx_crossbar_ctrl_chan0    ( user_dma_rx_crossbar_ctrl_chan0    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan1    ( user_dma_rx_crossbar_ctrl_chan1    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan2    ( user_dma_rx_crossbar_ctrl_chan2    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan3    ( user_dma_rx_crossbar_ctrl_chan3    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan4    ( user_dma_rx_crossbar_ctrl_chan4    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan5    ( user_dma_rx_crossbar_ctrl_chan5    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan6    ( user_dma_rx_crossbar_ctrl_chan6    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan7    ( user_dma_rx_crossbar_ctrl_chan7    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan8    ( user_dma_rx_crossbar_ctrl_chan8    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan9    ( user_dma_rx_crossbar_ctrl_chan9    ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan10   ( user_dma_rx_crossbar_ctrl_chan10   ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan11   ( user_dma_rx_crossbar_ctrl_chan11   ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan12   ( user_dma_rx_crossbar_ctrl_chan12   ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan13   ( user_dma_rx_crossbar_ctrl_chan13   ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan14   ( user_dma_rx_crossbar_ctrl_chan14   ),//I    [01:00]
        .user_dma_rx_crossbar_ctrl_chan15   ( user_dma_rx_crossbar_ctrl_chan15   ),//I    [01:00]
        
        // .user_dma_rx_chennel_enable         ( user_dma_rx_chennel_enable         ),//O    [15:00] status
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
    `endif
//*********************** END *************************************
    
    //------------------------------------------------------------------------
    `define USER_XC_INST_DEBUG_EN
    //------parameter
    parameter   XC_ARRAY_DEPTH          =   16'd16                              ;
    parameter   XC_GEAR_WIDTH           =   16'd3                               ;
    parameter   XC_STOCKS_WIDTH         =   16'd7                               ;
    //------NATIVE MEM IF
//  wire                                    user_logic_native_mem_valid         ;
//  wire [63:0]                             user_logic_native_mem_address       ;
//  wire [255:0]                            user_logic_native_mem_data          ;
//  wire [31:0]                             user_logic_native_mem_strb          ;
    //------xc_gear
    wire [XC_GEAR_WIDTH-1:0]                xc_gear_0 , xc_gear_1 , xc_gear_2 , xc_gear_3 ,
                                            xc_gear_4 , xc_gear_5 , xc_gear_6 , xc_gear_7 ,
                                            xc_gear_8 , xc_gear_9 , xc_gear_10, xc_gear_11,
                                            xc_gear_12, xc_gear_13, xc_gear_14, xc_gear_15;
    //------xc_stocks
    wire [XC_STOCKS_WIDTH-1:0]              xc_stocks_0 , xc_stocks_1 , xc_stocks_2 , xc_stocks_3 ,
                                            xc_stocks_4 , xc_stocks_5 , xc_stocks_6 , xc_stocks_7 ,
                                            xc_stocks_8 , xc_stocks_9 , xc_stocks_10, xc_stocks_11,
                                            xc_stocks_12, xc_stocks_13, xc_stocks_14, xc_stocks_15;
        
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
    //------
    `ifdef  USER_XC_INST_DEBUG_EN

    ila_user_xc_inst              u_ila_user_xc_inst(
    .clk                                    ( pcie_axi_clk                      ),
    //---
    .probe0                                 ( user_logic_native_mem_valid       ),//
    .probe1                                 ( user_logic_native_mem_address     ),//[63:0]
    .probe2                                 ( user_logic_native_mem_data        ),//[255:0]
    .probe3                                 ( user_logic_native_mem_strb        ),//[31:0]
    //---
    .probe4                                 ( xc_gear_15                        ),//[02:00]
    .probe5                                 ( xc_gear_14                        ),//[02:00]
    .probe6                                 ( xc_gear_13                        ),//[02:00]
    .probe7                                 ( xc_gear_12                        ),//[02:00]
    .probe8                                 ( xc_gear_11                        ),//[02:00]
    .probe9                                 ( xc_gear_10                        ),//[02:00]
    .probe10                                ( xc_gear_9                         ),//[02:00]
    .probe11                                ( xc_gear_8                         ),//[02:00]
    .probe12                                ( xc_gear_7                         ),//[02:00]
    .probe13                                ( xc_gear_6                         ),//[02:00]
    .probe14                                ( xc_gear_5                         ),//[02:00]
    .probe15                                ( xc_gear_4                         ),//[02:00]
    .probe16                                ( xc_gear_3                         ),//[02:00]
    .probe17                                ( xc_gear_2                         ),//[02:00]
    .probe18                                ( xc_gear_1                         ),//[02:00]
    .probe19                                ( xc_gear_0                         ),//[02:00]
    //---
    .probe20                                ( xc_stocks_15                      ),//[06:00]
    .probe21                                ( xc_stocks_14                      ),//[06:00]
    .probe22                                ( xc_stocks_13                      ),//[06:00]
    .probe23                                ( xc_stocks_12                      ),//[06:00]
    .probe24                                ( xc_stocks_11                      ),//[06:00]
    .probe25                                ( xc_stocks_10                      ),//[06:00]
    .probe26                                ( xc_stocks_9                       ),//[06:00]
    .probe27                                ( xc_stocks_8                       ),//[06:00]
    .probe28                                ( xc_stocks_7                       ),//[06:00]
    .probe29                                ( xc_stocks_6                       ),//[06:00]
    .probe30                                ( xc_stocks_5                       ),//[06:00]
    .probe31                                ( xc_stocks_4                       ),//[06:00]
    .probe32                                ( xc_stocks_3                       ),//[06:00]
    .probe33                                ( xc_stocks_2                       ),//[06:00]
    .probe34                                ( xc_stocks_1                       ),//[06:00]
    .probe35                                ( xc_stocks_0                       ),//[06:00]
    //---
    .probe36                                ( u_user_xc_inst.user_cmd           ) //[15:00]
    );

    `endif
    //------------------------------------------------------------------------

endmodule
`default_nettype wire