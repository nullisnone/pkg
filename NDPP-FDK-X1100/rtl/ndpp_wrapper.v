    
//------
module ndpp_wrapper (
    //---SYS CLOCK
    input   wire                    pcie_axi_aclk               ,
    input   wire                    pcie_axi_aresetn            ,

    input   wire    [31:0]          ndpp_bar1_axil_awaddr       ,
    input   wire    [2:0]           ndpp_bar1_axil_awprot       ,
    input   wire                    ndpp_bar1_axil_awvalid      ,
    input   wire    [31:0]          ndpp_bar1_axil_wdata        ,
    input   wire    [3:0]           ndpp_bar1_axil_wstrb        ,
    input   wire                    ndpp_bar1_axil_wvalid       ,
    input   wire                    ndpp_bar1_axil_bready       ,
    input   wire    [31:0]          ndpp_bar1_axil_araddr       ,
    input   wire    [2:0]           ndpp_bar1_axil_arprot       ,
    input   wire                    ndpp_bar1_axil_arvalid      ,
    input   wire                    ndpp_bar1_axil_rready       ,

    output  wire                    ndpp_bar1_axil_awready      ,
    output  wire                    ndpp_bar1_axil_wready       ,
    output  wire                    ndpp_bar1_axil_bvalid       ,
    output  wire    [1:0]           ndpp_bar1_axil_bresp        ,
    output  wire                    ndpp_bar1_axil_arready      ,
    output  wire    [31:0]          ndpp_bar1_axil_rdata        ,
    output  wire    [1:0]           ndpp_bar1_axil_rresp        ,
    output  wire                    ndpp_bar1_axil_rvalid       ,
    //------
    output  wire    [31:00]         soft_reset_req              ,
    input           [31:00]         soft_reset_ack              ,
    
    input           [00:00]         soft_reset_n                ,
     
    input    wire                   mac1_rx_clk                 ,
    input    wire                   mac1_rx_rstn                , 
    // MAC1 RX PORT
    input   wire                    mac1rx_axis_tvalid          ,
    input   wire                    mac1rx_axis_tuser           ,
    input   wire                    mac1rx_axis_tlast           ,
    input   wire[31:0]              mac1rx_axis_tdata           ,
    input   wire[3:0]               mac1rx_axis_tstrb           ,
    output  wire                    mac1rx_axis_tready          ,//NC 

    input       [31:00]             sfp_status                  ,
    input       [31:00]             sfp_status_inner            ,
 
    // DMA 0 RX
    //---DMA0 RX PORT 0 (Buffer 0)
    output  wire[63:0]              dma_p0_rx_axis_tdata        ,
    output  wire                    dma_p0_rx_axis_tvalid       ,
    output  wire[4:0]               dma_p0_rx_axis_tuser        ,
    output  wire[7:0]               dma_p0_rx_axis_tkeep        ,
    output  wire                    dma_p0_rx_axis_tlast        ,
    input   wire                    dma_p0_rx_axis_tready       ,
    
    // DMA0 RX PORT 1 (Buffer 1 ~ Buffer 16)
    output  wire[63:0]              dma_p1_rx_axis_tdata        ,
    output  wire                    dma_p1_rx_axis_tvalid       ,
    output  wire[4:0]               dma_p1_rx_axis_tuser        ,
    output  wire[7:0]               dma_p1_rx_axis_tkeep        ,
    output  wire                    dma_p1_rx_axis_tlast        ,
    input   wire                    dma_p1_rx_axis_tready       ,
    
    // DMA0 RX PORT 2 (Buffer 17 ~ Buffer 32)
    output  wire[63:0]              dma_p2_rx_axis_tdata        ,
    output  wire                    dma_p2_rx_axis_tvalid       ,
    output  wire[4:0]               dma_p2_rx_axis_tuser        ,
    output  wire[7:0]               dma_p2_rx_axis_tkeep        ,
    output  wire                    dma_p2_rx_axis_tlast        ,
    input   wire                    dma_p2_rx_axis_tready       ,

    // DMA 1 RX
    //---DMA1 RX PORT 0 (Buffer 0)
    output  wire[63:0]              dma_p3_rx_axis_tdata        ,
    output  wire                    dma_p3_rx_axis_tvalid       ,
    output  wire[4:0]               dma_p3_rx_axis_tuser        ,
    output  wire[7:0]               dma_p3_rx_axis_tkeep        ,
    output  wire                    dma_p3_rx_axis_tlast        ,
    input   wire                    dma_p3_rx_axis_tready       ,

    // DMA 0 TX
    //---DMA0 TX PORT 0
    input   wire[63:0]              dma_p0_tx_axis_tdata        ,
    input   wire                    dma_p0_tx_axis_tvalid       ,
    input   wire[3:0]               dma_p0_tx_axis_tuser        ,
    input   wire[7:0]               dma_p0_tx_axis_tstrb        ,
    input   wire                    dma_p0_tx_axis_tlast        ,
    output  wire                    dma_p0_tx_axis_tready       ,

    // DMA0 TX PORT 1
    input   wire[63:0]              dma_p1_tx_axis_tdata        ,
    input   wire                    dma_p1_tx_axis_tvalid       ,
    input   wire[3:0]               dma_p1_tx_axis_tuser        ,
    input   wire[7:0]               dma_p1_tx_axis_tstrb        ,
    input   wire                    dma_p1_tx_axis_tlast        ,
    output  wire                    dma_p1_tx_axis_tready       ,

    // DMA0 TX PORT 2
    input   wire[63:0]              dma_p2_tx_axis_tdata        ,
    input   wire                    dma_p2_tx_axis_tvalid       ,
    input   wire[3:0]               dma_p2_tx_axis_tuser        ,
    input   wire[7:0]               dma_p2_tx_axis_tstrb        ,
    input   wire                    dma_p2_tx_axis_tlast        ,
    output  wire                    dma_p2_tx_axis_tready       ,

    // DMA 1 TX
    //---DMA1 TX PORT 0
    input   wire[63:0]              dma_p3_tx_axis_tdata        ,
    input   wire                    dma_p3_tx_axis_tvalid       ,
    input   wire[3:0]               dma_p3_tx_axis_tuser        ,
    input   wire[7:0]               dma_p3_tx_axis_tstrb        ,
    input   wire                    dma_p3_tx_axis_tlast        ,
    output  wire                    dma_p3_tx_axis_tready,

    // Interface: user_logic_native_mem (Slave)
    input  wire [0:0]               user_logic_native_mem_valid,
    input  wire [63:0]              user_logic_native_mem_address,
    input  wire [255:0]             user_logic_native_mem_data,
    input  wire [31:0]              user_logic_native_mem_strb
);
   //generate two sychronized reset
   wire pcie_user_rstn;
   wire mac1_user_rstn;
   //------------------------------------------------------------------------- 
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF           (4                          ), // DECIMAL; range: 2-10
        .INIT_SYNC_FF           (0                          ), // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .RST_ACTIVE_HIGH        (0                          )  // DECIMAL; 0=active low reset, 1=active high reset
    )
    pcie_user_rstn_0 (
        .dest_arst              (pcie_user_rstn             ),  
        .dest_clk               (pcie_axi_aclk              ), // 1-bit input: Destination clock.
        .src_arst               (soft_reset_n               )  // 1-bit input: Source asynchronous reset signal.
    );

    xpm_cdc_async_rst #(
        .DEST_SYNC_FF           (4                          ), // DECIMAL; range: 2-10
        .INIT_SYNC_FF           (0                          ), // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
        .RST_ACTIVE_HIGH        (0                          )  // DECIMAL; 0=active low reset, 1=active high reset
    )
    mac1_user_rstn_0 (
        .dest_arst              (mac1_user_rstn             ),  
        .dest_clk               (mac1_rx_clk                ), // 1-bit input: Destination clock.
        .src_arst               (soft_reset_n               )  // 1-bit input: Source asynchronous reset signal.
    );

    //------------------------------------------------------------------------ 
    reg    [ 31:00]         mac1rx_cnt_reg                      ; 
    reg    [ 31:00]         mac1rx_cnt                          ; 
    reg    [ 31:00]         user0_rx_cnt                        ; 
    reg    [ 31:00]         user1_rx_cnt                        ; 
    reg    [ 31:00]         user2_rx_cnt                        ; 
    reg    [ 31:00]         user3_rx_cnt                        ; 
    wire   [127:0]          udp_param_0_tdata                   ;
    wire                    udp_param_0_tvalid                  ;
    
    always @ (posedge mac1_rx_clk or negedge mac1_rx_rstn)
    begin
        if(!mac1_rx_rstn | !mac1_user_rstn)begin
            mac1rx_cnt_reg <= 0;
        end else if((mac1rx_axis_tlast) && (mac1rx_axis_tvalid) && (mac1rx_axis_tready))begin
            mac1rx_cnt_reg <= mac1rx_cnt_reg + 1;
        end else begin
            mac1rx_cnt_reg <= mac1rx_cnt_reg;
        end 
    end
    
    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn)
    begin
        if(!pcie_axi_aresetn | !pcie_user_rstn)begin 
            mac1rx_cnt <= 0; 
        end else begin 
            mac1rx_cnt <= mac1rx_cnt_reg; 
        end
    end

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn)
    begin
        if(!pcie_axi_aresetn | !pcie_user_rstn)begin 
            user0_rx_cnt <= 0; 
        end else begin 
            if(dma_p0_rx_axis_tready & dma_p0_rx_axis_tvalid & dma_p0_rx_axis_tlast)
                user0_rx_cnt <= user0_rx_cnt + 1;
            else 
                user0_rx_cnt <= user0_rx_cnt;
        end
    end

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn)
    begin
        if(!pcie_axi_aresetn | !pcie_user_rstn)begin 
            user1_rx_cnt <= 0; 
        end else begin 
            if(dma_p1_rx_axis_tready & dma_p1_rx_axis_tvalid & dma_p1_rx_axis_tlast)
                user1_rx_cnt <= user1_rx_cnt + 1;
            else 
                user1_rx_cnt <= user1_rx_cnt;
        end
    end

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn)
    begin
        if(!pcie_axi_aresetn | !pcie_user_rstn)begin 
            user2_rx_cnt <= 0; 
        end else begin 
            if(dma_p2_rx_axis_tready & dma_p2_rx_axis_tvalid & dma_p2_rx_axis_tlast)
                user2_rx_cnt <= user2_rx_cnt + 1;
            else 
                user2_rx_cnt <= user2_rx_cnt;
        end
    end

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn)
    begin
        if(!pcie_axi_aresetn | !pcie_user_rstn)begin 
            user3_rx_cnt <= 0; 
        end else begin 
            if(dma_p3_rx_axis_tready & dma_p3_rx_axis_tvalid & dma_p3_rx_axis_tlast)
                user3_rx_cnt <= user3_rx_cnt + 1;
            else 
                user3_rx_cnt <= user3_rx_cnt;
        end
    end


    //------------------------------------------------------------------------BAR-1
    reg  [31:0] trigger_counter;
    wire [31:0] write_counter_out;
    wire [31:0] trigger_counter_out;
    reg         trigger_cond_d1;
    reg  [31:0]  trigger_counter_vld;
    reg  [31:0]  trigger_counter_vld_full;
    reg  [31:0]  trigger_counter_vld_b;
    reg  [31:0]  trigger_counter_vld_notab;
    reg  [31:0]  trigger_counter_vld_a;
    

    wire trigger_cond = user_logic_native_mem_valid && 
                        (user_logic_native_mem_address[21:0] == 22'h31FFE0);

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn) begin
        if(!pcie_axi_aresetn | !pcie_user_rstn) begin 
            trigger_counter <= 0;
            trigger_cond_d1 <= 0;
        end else begin 
            trigger_cond_d1 <= trigger_cond;
            if (trigger_cond && !trigger_cond_d1) // Rising edge detection
                trigger_counter <= trigger_counter + 1;
        end
    end

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn) begin
        if(!pcie_axi_aresetn | !pcie_user_rstn) begin 
            trigger_counter_vld <= 0;
        end else begin 
            if (user_logic_native_mem_valid) // Rising edge detection
                trigger_counter_vld <= trigger_counter_vld + 1;
        end
    end
    
    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn) begin
        if(!pcie_axi_aresetn | !pcie_user_rstn) begin 
            trigger_counter_vld_full <= 0;
        end else begin 
            if (user_logic_native_mem_valid && user_logic_native_mem_strb==32'hffff_ffff && ((user_logic_native_mem_address&22'h300000)==22'h300000) && user_logic_native_mem_address[19:0]<20'h20000) // Rising edge detection
                trigger_counter_vld_full <= trigger_counter_vld_full + 1;
        end
    end

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn) begin
        if(!pcie_axi_aresetn | !pcie_user_rstn) begin 
            trigger_counter_vld_a <= 0;
        end else begin 
            if (user_logic_native_mem_valid && user_logic_native_mem_strb==32'hffff_ffff && ((user_logic_native_mem_address&22'h300000)==22'h300000) && user_logic_native_mem_address[19:0]<20'h10000) // Rising edge detection
                trigger_counter_vld_a <= trigger_counter_vld_a + 1;
        end
    end
    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn) begin
        if(!pcie_axi_aresetn | !pcie_user_rstn) begin 
            trigger_counter_vld_b <= 0;
        end else begin 
            if (user_logic_native_mem_valid && user_logic_native_mem_strb==32'hffff_ffff && ((user_logic_native_mem_address&22'h300000)==22'h300000) && user_logic_native_mem_address[19:0]>=20'h10000) // Rising edge detection
                trigger_counter_vld_b <= trigger_counter_vld_b + 1;
        end
    end

    always@(posedge pcie_axi_aclk or negedge pcie_axi_aresetn) begin
        if(!pcie_axi_aresetn | !pcie_user_rstn) begin 
            trigger_counter_vld_notab <= 0;
        end else begin 
            if (user_logic_native_mem_valid && user_logic_native_mem_strb==32'hffff_ffff && ((user_logic_native_mem_address&22'h300000)==22'h300000) && user_logic_native_mem_address[19:0]>=20'h20000) // Rising edge detection
                trigger_counter_vld_notab <= trigger_counter_vld_notab + 1;
        end
    end

    ndpp_regfile    u_ndpp_regfile(
        .sys_clk                            ( pcie_axi_aclk                 ),
        .sys_rstn                           ( pcie_axi_aresetn              ),
        //---sfp_status
        .sfp_status                         ( sfp_status                    ),
        .sfp_status_inner                   ( sfp_status_inner              ),
    
        //---soft_reset
        .soft_reset_req                     ( soft_reset_req                ),
        .soft_reset_ack                     ( soft_reset_ack                ),
        .soft_reset_n                       ( soft_reset_n                  ),

        .udp_param_0_tdata                  ( udp_param_0_tdata             ),
        .udp_param_0_tvalid                 ( udp_param_0_tvalid            ),
    
        .mac1rx_cnt                         ( mac1rx_cnt                    ),
        .user0_rx_cnt                       ( user0_rx_cnt                  ),
        .user1_rx_cnt                       ( user1_rx_cnt                  ),
        .user2_rx_cnt                       ( user2_rx_cnt                  ),
        .user3_rx_cnt                       ( user3_rx_cnt                  ),
        .trigger_counter                    ( trigger_counter               ),
        .write_counter_out                  ( write_counter_out             ),
        .trigger_counter_out                ( trigger_counter_out           ),
        .trigger_counter_vld                ( trigger_counter_vld           ),
        .trigger_counter_vld_full           ( trigger_counter_vld_full      ),
        .trigger_counter_vld_b              ( trigger_counter_vld_b         ),
        .trigger_counter_vld_notab          ( trigger_counter_vld_notab     ),
        .trigger_counter_vld_a              ( trigger_counter_vld_a         ),
        //---NDPP
        .axil_awaddr                        ( ndpp_bar1_axil_awaddr         ),
        .axil_awprot                        ( ndpp_bar1_axil_awprot         ),
        .axil_awvalid                       ( ndpp_bar1_axil_awvalid        ),
        .axil_wdata                         ( ndpp_bar1_axil_wdata          ),
        .axil_wstrb                         ( ndpp_bar1_axil_wstrb          ),
        .axil_wvalid                        ( ndpp_bar1_axil_wvalid         ),
        .axil_bready                        ( ndpp_bar1_axil_bready         ),
        .axil_araddr                        ( ndpp_bar1_axil_araddr         ),
        .axil_arprot                        ( ndpp_bar1_axil_arprot         ),
        .axil_arvalid                       ( ndpp_bar1_axil_arvalid        ),
        .axil_rready                        ( ndpp_bar1_axil_rready         ),
        .axil_awready                       ( ndpp_bar1_axil_awready        ),
        .axil_wready                        ( ndpp_bar1_axil_wready         ),
        .axil_bvalid                        ( ndpp_bar1_axil_bvalid         ),
        .axil_bresp                         ( ndpp_bar1_axil_bresp          ),
        .axil_arready                       ( ndpp_bar1_axil_arready        ),
        .axil_rdata                         ( ndpp_bar1_axil_rdata          ),
        .axil_rresp                         ( ndpp_bar1_axil_rresp          ),
        .axil_rvalid                        ( ndpp_bar1_axil_rvalid         )
    );
    

    design_1_wrapper u_design_1_wrapper(
        .ETH_RX_AXIS_tdata                  (mac1rx_axis_tdata              ),
        .ETH_RX_AXIS_tkeep                  (mac1rx_axis_tstrb              ),
        .ETH_RX_AXIS_tlast                  (mac1rx_axis_tlast              ),
        .ETH_RX_AXIS_tready                 (mac1rx_axis_tready             ),
        .ETH_RX_AXIS_tvalid                 (mac1rx_axis_tvalid             ),
        .mac_rx_clk                         (mac1_rx_clk                    ),
        .mac_rx_rstn                        (mac1_rx_rstn & mac1_user_rstn  ),
        .pcie_aclk                          (pcie_axi_aclk                  ),
        .pcie_arstn                         (pcie_axi_aresetn & pcie_user_rstn  ),

        .udp_param_0_tdata                  (udp_param_0_tdata              ),
        .udp_param_0_tready                 (                               ),
        .udp_param_0_tvalid                 (udp_param_0_tvalid             ),

        .user_dma_rx_0_tdata                (dma_p0_rx_axis_tdata           ),
        .user_dma_rx_0_tkeep                (dma_p0_rx_axis_tkeep           ),
        .user_dma_rx_0_tlast                (dma_p0_rx_axis_tlast           ),
        .user_dma_rx_0_tready               (dma_p0_rx_axis_tready_temp     ),
        .user_dma_rx_0_tstrb                (                               ),
        .user_dma_rx_0_tvalid               (dma_p0_rx_axis_tvalid_temp     ),

        .user_dma_rx_1_tdata                (dma_p1_rx_axis_tdata           ),
        .user_dma_rx_1_tkeep                (dma_p1_rx_axis_tkeep           ),
        .user_dma_rx_1_tlast                (dma_p1_rx_axis_tlast           ),
        .user_dma_rx_1_tready               (dma_p1_rx_axis_tready_temp     ),
        .user_dma_rx_1_tstrb                (                               ),
        .user_dma_rx_1_tvalid               (dma_p1_rx_axis_tvalid_temp     ),

        .user_dma_rx_2_tdata                (dma_p2_rx_axis_tdata           ),
        .user_dma_rx_2_tkeep                (dma_p2_rx_axis_tkeep           ),
        .user_dma_rx_2_tlast                (dma_p2_rx_axis_tlast           ),
        .user_dma_rx_2_tready               (dma_p2_rx_axis_tready_temp     ),
        .user_dma_rx_2_tstrb                (                               ),
        .user_dma_rx_2_tvalid               (dma_p2_rx_axis_tvalid_temp     ),

        .user_dma_rx_3_tdata                (dma_p3_rx_axis_tdata           ),
        .user_dma_rx_3_tkeep                (dma_p3_rx_axis_tkeep           ),
        .user_dma_rx_3_tlast                (dma_p3_rx_axis_tlast           ),
        .user_dma_rx_3_tready               (dma_p3_rx_axis_tready_temp     ),
        .user_dma_rx_3_tstrb                (                               ),
        .user_dma_rx_3_tvalid               (dma_p3_rx_axis_tvalid_temp     ),

        .user_dma_tx_0_tdata                (dma_p0_tx_axis_tdata           ),
        .user_dma_tx_0_tkeep                (dma_p0_tx_axis_tstrb           ),
        .user_dma_tx_0_tlast                (dma_p0_tx_axis_tlast           ),
        .user_dma_tx_0_tready               (dma_p0_tx_axis_tready          ),
        .user_dma_tx_0_tstrb                (dma_p0_tx_axis_tstrb           ),
        .user_dma_tx_0_tvalid               (dma_p0_tx_axis_tvalid          ),
        .user_dma_tx_0_tuser                (dma_p0_tx_axis_tuser           ),
        .user_logic_native_mem_valid        (user_logic_native_mem_valid    ),
        .user_logic_native_mem_address      (user_logic_native_mem_address  ),
        .user_logic_native_mem_data         (user_logic_native_mem_data     ),
        .user_logic_native_mem_strb         (user_logic_native_mem_strb     ),
        .write_counter_out                  (write_counter_out              ),
        .trigger_counter_out                (trigger_counter_out            )
    );

    assign dma_p0_rx_axis_tuser = {4'd0, 1'b0};
    assign dma_p1_rx_axis_tuser = {4'd1, 1'b0};
    assign dma_p2_rx_axis_tuser = {4'd2, 1'b0};
    assign dma_p3_rx_axis_tuser = {4'd3, 1'b0};

    assign dma_p0_rx_axis_tvalid = dma_p0_rx_axis_tvalid_temp;
    assign dma_p1_rx_axis_tvalid = dma_p1_rx_axis_tvalid_temp;
    assign dma_p2_rx_axis_tvalid = dma_p2_rx_axis_tvalid_temp;
    assign dma_p3_rx_axis_tvalid = dma_p3_rx_axis_tvalid_temp;

    assign dma_p0_rx_axis_tready_temp = dma_p0_rx_axis_tready;
    assign dma_p1_rx_axis_tready_temp = dma_p1_rx_axis_tready;
    assign dma_p2_rx_axis_tready_temp = dma_p2_rx_axis_tready;
    assign dma_p3_rx_axis_tready_temp = dma_p3_rx_axis_tready;

    // assign dma_p0_tx_axis_tready = 1'b0; // Driven by u_design_1_wrapper
    assign dma_p1_tx_axis_tready = 1'b0;
    assign dma_p2_tx_axis_tready = 1'b0;
    assign dma_p3_tx_axis_tready = 1'b0;

/*
    ila_0 u_design_1_system_ila_0_0 (
        .clk(pcie_axi_aclk),
        .probe0(user_logic_native_mem_valid),  // 1bit
        .probe1(dma_p0_rx_axis_tvalid_temp),  // 1bit
        .probe2(user_logic_native_mem_strb[7:0]),   
        .probe3(user_logic_native_mem_address[7:0]),
        .probe4(user_logic_native_mem_data[7:0]),
        .probe5(trigger_counter[7:0]),
        .probe6(trigger_counter_out[7:0]),
        .probe7(write_counter_out[7:0]),
        .probe8(dma_p0_rx_axis_tready_temp), // 1bit
        .probe9(dma_p0_rx_axis_tdata[7:0])
    );
*/

endmodule