module yusur_axil2mem (

    input  wire                 sys_clk  ,
    input  wire                 sys_rstn ,

    // AXI4-Lite
    //axil m2s/s2m,slave
    input   wire    [31:0]      axil_awaddr  ,
    input   wire    [2:0]       axil_awprot  ,
    input   wire                axil_awvalid ,
    input   wire    [31:0]      axil_wdata   ,
    input   wire    [3:0]       axil_wstrb   ,
    input   wire                axil_wvalid  ,
    input   wire                axil_bready  ,
    input   wire    [31:0]      axil_araddr  ,
    input   wire    [2:0]       axil_arprot  ,
    input   wire                axil_arvalid ,
    input   wire                axil_rready  ,

    output  wire                axil_awready ,
    output  wire                axil_wready  ,
    output  reg                 axil_bvalid  ,
    output  reg     [1:0]       axil_bresp   ,
    output  reg                 axil_arready ,
    output  reg     [31:0]      axil_rdata   ,
    output  reg     [1:0]       axil_rresp   ,
    output  reg                 axil_rvalid  ,

    // Memory Interface
    output  reg     [15:0]      ram_addr   ,
    output  reg                 ram_en     ,       // Write Enable
    output  reg     [31:0]      ram_wdata  ,       // Write Data
    output  wire                ram_we     ,       // Read Enable
    input   wire    [31:0]      ram_rdata  ,       // Read Data
    input   wire                ram_rd_done

);
    
//--------------- Signal define ---------------
// Ctl Signal
wire         slv_reg_wren  ;
reg  [31:0] axil_awaddr_r ;
reg         aw_en ;
//reg  axil_wdata_r  ;


// AXI Write Ctl
assign axil_awready = 1'b1 ;
assign axil_wready  = 1'b1 ;
always @(posedge sys_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        axil_bresp  <= 2'b10 ;
        axil_bvalid <= 1'b0 ;
    end else begin
        if (axil_wready && axil_wvalid) begin
            axil_bresp  <= 2'b00 ;
            axil_bvalid <= 1'b1  ;
        end else if(axil_bvalid && axil_bready)begin
            axil_bresp  <= 2'b10 ;
            axil_bvalid <= 1'b0  ;
        end else begin
            axil_bresp  <= axil_bresp;
            axil_bvalid <= axil_bvalid ;
        end
    end
end

// Keep the axi write address
// if the address and data not the same times
always @(posedge sys_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        axil_awaddr_r <= 'h0 ;
    end else begin
        if(axil_awready && axil_awvalid) begin
            axil_awaddr_r <= axil_awaddr ;
        end else begin
            axil_awaddr_r <= axil_awaddr_r ;
        end
    end
end
// awaddress enable signal
always @(posedge sys_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        aw_en      <= 'h0 ;
    end else begin
        if(axil_awready && axil_awvalid) begin
            aw_en  <= 1'b1;
        end else if (axil_wready && axil_wvalid) begin
            aw_en  <= 1'b0;
        end else begin
            aw_en <= aw_en ;
        end
    end
end

// always @(posedge sys_clk or negedge sys_rstn) begin
//     if (!sys_rstn) begin
//         axil_wdata_r <= 'h0 ;
//     end else begin
//         if(axil_wready && axil_wvalid) begin
//             axil_wdata_r <= axil_wdata ;
//         end else begin
//             axil_wdata_r <= axil_wdata_r ;
//         end
//     end
// end

// Ram write enable
// if the address and data not the same times
assign  slv_reg_wren = aw_en && axil_wready && axil_wvalid ;
// always @(posedge sys_clk or negedge sys_rstn) begin
//     if (!sys_rstn) begin
//         slv_reg_wren <= 1'b0 ;
//     end else begin
//         if (axil_wready && axil_wvalid && axil_awready && axil_awvalid) begin
//             slv_reg_wren    <= 1'b1 ;
//         end else begin
//             slv_reg_wren    <= 2'b0 ;
//         end
//     end
// end

// Ram Write Ctl
always @(posedge sys_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        ram_en <= 1'b0 ;
        ram_wdata <= 'h0 ;
    end else begin
        if (axil_wready && axil_wvalid && axil_awready && axil_awvalid) begin
            ram_en    <= 2'b1 ;
            ram_wdata <= axil_wdata ;
        end else if (slv_reg_wren) begin
            ram_en    <= 2'b1 ;
            ram_wdata <= axil_wdata ;
        end else begin
            ram_en    <= 2'b0 ;
            ram_wdata <= ram_wdata ;
        end
    end
end

// Ram Write/Read Addess Ctl
always @(posedge sys_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        ram_addr <= 'h0 ;
    end else begin
        // Write
        if (axil_wready && axil_wvalid && axil_awready && axil_awvalid) begin
            ram_addr <= axil_awaddr   ;
        end else if (slv_reg_wren) begin
            ram_addr  <= axil_awaddr_r ;
        // Read
        end else if (axil_arvalid && ~axil_arready) begin
            ram_addr  <= axil_araddr ;
        end else begin
            ram_addr  <= ram_addr ;
        end
    end
end

// AXI Read Ctl
// AXI Read Addess Ctl
always @(posedge sys_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        axil_arready <= 1'b0 ;
    end else begin
        if (~axil_arready && axil_arvalid) begin
            axil_arready <= 1'b1 ;
        end else begin
            axil_arready <= 1'b0 ;
        end
    end
end

// Ram Read Ctl
// always @(posedge sys_clk or negedge sys_rstn) begin
//     if (!sys_rstn) begin
//         ram_we    <= 1'b0 ;
//     end else begin
//         if(axil_arvalid && ~axil_arready) begin
//             ram_we    <= 1'b1 ;
//         end else begin
//             ram_we    <= 1'b0 ;
//         end
//     end
// end
assign ram_we = axil_arready ;

// AXI Read Data Ctl
always @(posedge sys_clk or negedge sys_rstn) begin
    if (!sys_rstn) begin
        axil_rdata   <= 'h0   ;
        axil_rresp   <= 2'b10 ;
        axil_rvalid  <= 1'b0  ;
    end else begin
        if (ram_rd_done) begin
            axil_rdata   <= ram_rdata ;
            axil_rresp   <= 2'b00 ;
            axil_rvalid  <= 1'b1  ;
        end else if (axil_rvalid && axil_rready) begin
            axil_rdata   <= 'h0   ;
            axil_rresp   <= 2'b10 ;
            axil_rvalid  <= 1'b0  ;
        end else begin
            axil_rdata   <= axil_rdata  ;
            axil_rresp   <= axil_rresp  ;
            axil_rvalid  <= axil_rvalid ;
        end
    end
end





endmodule