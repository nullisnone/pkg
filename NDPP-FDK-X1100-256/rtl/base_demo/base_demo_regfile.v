module base_demo_regfile (
//** CLOCK DOMAIN
    input   wire                pcie_axi_clk,
    input   wire                pcie_axi_resetn,

//** AXI-LITE SIGNAL
    input   wire    [31:0]      user_bar1_axi_lite_awaddr,
    input   wire    [2:0]       user_bar1_axi_lite_awprot,
    input   wire                user_bar1_axi_lite_awvalid,
    input   wire    [31:0]      user_bar1_axi_lite_wdata,
    input   wire    [3:0]       user_bar1_axi_lite_wstrb,
    input   wire                user_bar1_axi_lite_wvalid,
    input   wire                user_bar1_axi_lite_bready,
    input   wire    [31:0]      user_bar1_axi_lite_araddr,
    input   wire    [2:0]       user_bar1_axi_lite_arprot,
    input   wire                user_bar1_axi_lite_arvalid,
    input   wire                user_bar1_axi_lite_rready,

    output  wire                user_bar1_axi_lite_awready,
    output  wire                user_bar1_axi_lite_wready,
    output  wire                user_bar1_axi_lite_bvalid,
    output  wire    [1:0]       user_bar1_axi_lite_bresp,
    output  wire                user_bar1_axi_lite_arready,
    output  reg     [31:0]      user_bar1_axi_lite_rdata,
    output  wire    [1:0]       user_bar1_axi_lite_rresp,
    output  reg                 user_bar1_axi_lite_rvalid,

//** MAC2USERDMA PACKET LOSS COUNT
    input   wire    [63:0]      udma_port0_rxloss_packet,
    input   wire    [63:0]      udma_port1_rxloss_packet,
    input   wire    [63:0]      udma_port2_rxloss_packet,
    input   wire    [63:0]      udma_port3_rxloss_packet,

//** MAC Control & Statistic
    output  wire                lightning_mac0_enable,
    output  wire                lightning_mac0_loopback,

    output  wire                lightning_mac1_enable,
    output  wire                lightning_mac1_loopback,

    output  wire                lightning_mac2_enable,
    output  wire                lightning_mac2_loopback,

    output  wire                lightning_mac3_enable,
    output  wire                lightning_mac3_loopback
    );

//*****************************************************************************************
//** axi lite signals 
//*****************************************************************************************
    reg [31:0]      awaddr_reg              ;
    wire[31:0]      awaddr_use              ;   
    reg             user_bar1_axi_lite_wvalid_1d          ;


    assign user_bar1_axi_lite_awready = 1'b1 ;
    assign user_bar1_axi_lite_wready  = 1'b1 ;
    assign user_bar1_axi_lite_arready = user_bar1_axi_lite_rvalid;//be care,use the signals to keep araddr.
    assign user_bar1_axi_lite_bvalid  = user_bar1_axi_lite_wvalid_1d;
    assign user_bar1_axi_lite_bresp   = (user_bar1_axi_lite_wvalid_1d)? 2'b00: 2'b10;
    assign user_bar1_axi_lite_rresp   = (user_bar1_axi_lite_rvalid )? 2'b00: 2'b10; 
    assign awaddr_use   = (user_bar1_axi_lite_awvalid) ? user_bar1_axi_lite_awaddr : awaddr_reg;

    always@(posedge pcie_axi_clk or negedge pcie_axi_resetn)begin//axi lite 
        if(!pcie_axi_resetn) begin
            awaddr_reg      <= 0;
            user_bar1_axi_lite_rvalid     <= 'd0 ;
            user_bar1_axi_lite_wvalid_1d  <= 'd0;
        end 
        else begin
            user_bar1_axi_lite_rvalid     <= (user_bar1_axi_lite_arvalid && (!user_bar1_axi_lite_rvalid)) ? 1'b1 :(user_bar1_axi_lite_rvalid&&user_bar1_axi_lite_rready) ? 1'b0 : user_bar1_axi_lite_rvalid;
            user_bar1_axi_lite_wvalid_1d  <= user_bar1_axi_lite_wvalid  ;
            if(user_bar1_axi_lite_awvalid)begin
                awaddr_reg  <= user_bar1_axi_lite_awaddr;
            end
        end
    end     
//******************************************end********************************************


//***********************************************************
//** BASE DEMO REGFILE
//***********************************************************
    localparam      DEMO_VERSION    =   32'h24110400;   // 2024/01 Version:4.0
    reg     [31:0]                      lightning_mac0_enable_reg;
    reg     [31:0]                      lightning_mac0_loopback_reg;
    reg     [31:0]                      lightning_mac1_enable_reg;
    reg     [31:0]                      lightning_mac1_loopback_reg;
    reg     [31:0]                      lightning_mac2_enable_reg;
    reg     [31:0]                      lightning_mac2_loopback_reg;
    reg     [31:0]                      lightning_mac3_enable_reg;
    reg     [31:0]                      lightning_mac3_loopback_reg;
    //** SIGNAL MAPPING
    assign  lightning_mac0_enable       =   lightning_mac0_enable_reg[0];
    assign  lightning_mac0_loopback     =   lightning_mac0_loopback_reg[0];
    assign  lightning_mac1_enable       =   lightning_mac1_enable_reg[0];
    assign  lightning_mac1_loopback     =   lightning_mac1_loopback_reg[0];
    assign  lightning_mac2_enable       =   lightning_mac2_enable_reg[0];
    assign  lightning_mac2_loopback     =   lightning_mac2_loopback_reg[0];
    assign  lightning_mac3_enable       =   lightning_mac3_enable_reg[0];
    assign  lightning_mac3_loopback     =   lightning_mac3_loopback_reg[0];
    //** REGFILE WRITE
    always @ (posedge pcie_axi_clk or negedge pcie_axi_resetn) begin
        if (!pcie_axi_resetn) begin
            lightning_mac0_enable_reg       <=  0;
            lightning_mac0_loopback_reg     <=  0;
            lightning_mac1_enable_reg       <=  0;
            lightning_mac1_loopback_reg     <=  0;
            lightning_mac2_enable_reg       <=  1;
            lightning_mac2_loopback_reg     <=  0;
            lightning_mac3_enable_reg       <=  1;
            lightning_mac3_loopback_reg     <=  0;
        end else begin
            if (user_bar1_axi_lite_wvalid && user_bar1_axi_lite_wready) begin
                case (awaddr_use[15:0])
                16'h0004 : lightning_mac0_enable_reg    <=  user_bar1_axi_lite_wdata;
                16'h0008 : lightning_mac0_loopback_reg  <=  user_bar1_axi_lite_wdata;
                16'h000C : lightning_mac1_enable_reg    <=  user_bar1_axi_lite_wdata;
                16'h0010 : lightning_mac1_loopback_reg  <=  user_bar1_axi_lite_wdata;
                16'h0014 : lightning_mac2_enable_reg    <=  user_bar1_axi_lite_wdata;
                16'h0018 : lightning_mac2_loopback_reg  <=  user_bar1_axi_lite_wdata;
                16'h001C : lightning_mac3_enable_reg    <=  user_bar1_axi_lite_wdata;
                16'h0020 : lightning_mac3_loopback_reg  <=  user_bar1_axi_lite_wdata;
                endcase
            end else begin
                lightning_mac0_enable_reg   <=  lightning_mac0_enable_reg;
                lightning_mac0_loopback_reg <=  lightning_mac0_loopback_reg;
                lightning_mac1_enable_reg   <=  lightning_mac1_enable_reg;
                lightning_mac1_loopback_reg <=  lightning_mac1_loopback_reg;
                lightning_mac2_enable_reg   <=  lightning_mac2_enable_reg;
                lightning_mac2_loopback_reg <=  lightning_mac2_loopback_reg;
                lightning_mac3_enable_reg   <=  lightning_mac3_enable_reg;
                lightning_mac3_loopback_reg <=  lightning_mac3_loopback_reg;
            end
        end
    end

    //** REGFILE READ
    always @ (posedge pcie_axi_clk or negedge pcie_axi_resetn) begin
        if (!pcie_axi_resetn) begin
            user_bar1_axi_lite_rdata    <=  0;
        end else begin
            if (user_bar1_axi_lite_arvalid) begin
                case (user_bar1_axi_lite_araddr[15:0])
                16'h0000 :  user_bar1_axi_lite_rdata    <=  DEMO_VERSION;
                16'h0004 :  user_bar1_axi_lite_rdata    <=  lightning_mac0_enable_reg;
                16'h0008 :  user_bar1_axi_lite_rdata    <=  lightning_mac0_loopback_reg;
                16'h000C :  user_bar1_axi_lite_rdata    <=  lightning_mac1_enable_reg;
                16'h0010 :  user_bar1_axi_lite_rdata    <=  lightning_mac1_loopback_reg;
                16'h0014 :  user_bar1_axi_lite_rdata    <=  lightning_mac2_enable_reg;
                16'h0018 :  user_bar1_axi_lite_rdata    <=  lightning_mac2_loopback_reg;
                16'h001C :  user_bar1_axi_lite_rdata    <=  lightning_mac3_enable_reg;
                16'h0020 :  user_bar1_axi_lite_rdata    <=  lightning_mac3_loopback_reg;
                16'h0024 :  user_bar1_axi_lite_rdata    <=  udma_port0_rxloss_packet[63:32];
                16'h0028 :  user_bar1_axi_lite_rdata    <=  udma_port0_rxloss_packet[31:0];
                16'h002C :  user_bar1_axi_lite_rdata    <=  udma_port1_rxloss_packet[63:32];
                16'h0030 :  user_bar1_axi_lite_rdata    <=  udma_port1_rxloss_packet[31:0];
                16'h0034 :  user_bar1_axi_lite_rdata    <=  udma_port2_rxloss_packet[63:32];
                16'h0038 :  user_bar1_axi_lite_rdata    <=  udma_port2_rxloss_packet[31:0];
                16'h003C :  user_bar1_axi_lite_rdata    <=  udma_port3_rxloss_packet[63:32];
                16'h0040 :  user_bar1_axi_lite_rdata    <=  udma_port3_rxloss_packet[31:0];
                endcase
            end else begin
                user_bar1_axi_lite_rdata    <=  32'hDEADBEEF;
            end
        end
    end
//************************ END ******************************

endmodule