module yusur_hash_allocation (
    input  wire          clk,
    input  wire          rst_n,

    // User Logic Native Memory Interface (Write Slave)
    input  wire          user_logic_native_mem_valid,
    input  wire [63:0]   user_logic_native_mem_address,
    input  wire [255:0]  user_logic_native_mem_data,
    input  wire [31:0]   user_logic_native_mem_strb,

    // AXI Stream Master Interface (Output)
    output reg  [63:0]   o_axiu_user0_data_tdata,
    output reg           o_axiu_user0_data_tvalid,
    input  wire          o_axiu_user0_data_tready,
    output reg  [7:0]    o_axiu_user0_data_tkeep,
    output reg           o_axiu_user0_data_tlast,

    // Debug / Status Counters
    output reg  [31:0]   write_counter_out,
    output reg  [31:0]   trigger_counter_out
);

    // -------------------------------------------------------------------------
    // Parameters & Constants
    // -------------------------------------------------------------------------
    localparam STATE_RECEIVE   = 2'd0;
    localparam STATE_CALC      = 2'd1;
    localparam STATE_OUTPUT    = 2'd2;
    localparam STATE_END       = 2'd3;

    // -------------------------------------------------------------------------
    // Signals & Registers
    // -------------------------------------------------------------------------
    reg [2:0] state = 0;
    reg [2:0] state_d = 0;
    reg [2:0] state_dd = 0;
    
    // Counters
    reg [31:0] write_counter = 0;
    reg [31:0] write_counter_increase = 0;
    reg [31:0] trigger_counter = 0;

    // Address Decoding
    wire [21:0] addr_22 = user_logic_native_mem_address[21:0];
    wire [1:0]  top_2_bits = addr_22[21:20];
    wire [19:0] addr_20 = addr_22[19:0];
    wire [15:0] addr_16 = addr_22[15:0]; // 64KB range
    
    wire write_enable = user_logic_native_mem_valid && (top_2_bits == 2'b11);
    
    // Output Loop Counters
    reg [14:0] out_idx = 0;
    wire [15:0] out_idx_even = {out_idx,1'b0}
    wire [15:0] out_idx_odd = {out_idx,1'b1}
     
    wire [7:0] col_addr_a = addr_16[15:8];
    wire [7:0] row_base_a = {addr_16[7:5], 5'b0};
    
    wire [7:0] col_addr_b = addr_16[15:8];
    wire [7:0] row_base_b = {addr_16[7:5], 5'b0};
    
    integer byte_idx_a;
    integer byte_idx_b;
    integer loop_mul_idx;
    integer i;

    //calc loop 
    reg [15:0] calc_loop = 0;
    reg [15:0] calc_loop_d = 0;
    reg [15:0] calc_loop_dd = 0;
    
    // -------------------------------------------------------------------------
    // RAM Instantiation (Wide Words for Parallel BRAM Inference)
    // -------------------------------------------------------------------------
    // To access all 256 elements in a single clock cycle, we pack them into 
    // a single 2048-bit wide word per row. Vivado will infer multiple BRAMs 
    // in parallel to create this wide memory.
    // 256 elements * 8 bits = 2048 bits wide. 256 rows deep.
    
    (* ram_style = "block" *) reg [2047:0] mem_A [0:255];
    (* ram_style = "block" *) reg [2047:0] mem_B [0:255];
    
    // mem_C: Flat 1D array, 64-bits wide (stores 2x 32-bit results per word)
    // Total depth = (256 * 256) / 2 = 32768
    (* ram_style = "block" *) reg [63:0]  mem_C [0:32767]; 
    reg [15:0]  temp_AB [0:255];
    
    // Initialize memories
    integer init_i;
    integer init_j;
    initial begin
        for (init_i = 0; init_i < 256; init_i = init_i + 1) begin
            mem_A[init_i] = 0;
            mem_B[init_i] = 0;
            temp_AB[init_i] = 0;
        end
        for (init_j = 0; init_j < 32768; init_j = init_j + 1) begin
             mem_C[init_j] = 0;
        end
    end

    reg [24:0]  sum_temp0 = 0;
    reg [24:0]  sum_temp1 = 0;
    reg [24:0]  sum_temp2 = 0;
    reg [24:0]  sum_temp3 = 0;
    reg [24:0]  sum_temp4 = 0;
    reg [24:0]  sum_temp5 = 0;
    reg [24:0]  sum_temp6 = 0;
    reg [24:0]  sum_temp7 = 0;
    reg [24:0]  sum_temp8 = 0;
    reg [24:0]  sum_temp9 = 0;
    reg [24:0]  sum_temp10 = 0;
    reg [24:0]  sum_temp11 = 0;
    reg [24:0]  sum_temp12 = 0;
    reg [24:0]  sum_temp13 = 0;
    reg [24:0]  sum_temp14 = 0;
    reg [24:0]  sum_temp15 = 0;
    
    always @(posedge clk) begin
        if (write_enable && addr_20<20'h10000) begin 
            for (byte_idx_a = 0; byte_idx_a < 32; byte_idx_a = byte_idx_a + 1) begin
                mem_A[col_addr_a][(row_base_a + byte_idx_a)*8 +: 8] <= user_logic_native_mem_data[byte_idx_a*8 +: 8];
            end
        end
    end

    always @(posedge clk) begin
        if (write_enable && addr_20>=20'h10000 && addr_20<20'h20000) begin 
            for (byte_idx_b = 0; byte_idx_b < 32; byte_idx_b = byte_idx_b + 1) begin
                mem_B[col_addr_b][(row_base_b + byte_idx_b)*8 +: 8] <= user_logic_native_mem_data[byte_idx_b*8 +: 8];
            end
        end
    end

    // -------------------------------------------------------------------------
    // Main FSM & Logic
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= STATE_RECEIVE;
            write_counter <= 0;
            write_counter_increase <= 0;
            trigger_counter <= 0;
            calc_loop <= 0;
            out_idx <= 0;
            
            o_axiu_user0_data_tvalid <= 0;
            o_axiu_user0_data_tlast <= 0;
            o_axiu_user0_data_tkeep <= 8'h00;
            o_axiu_user0_data_tdata <= 0;

        end else begin
            case (state)
                STATE_RECEIVE: begin
                    // ---------------------------------------------------------
                    // Write Phase
                    // ---------------------------------------------------------
                    if (write_enable) begin
                        if (addr_20 < 20'h10000) begin
                            // Write Matrix A
                            write_counter <= write_counter + 1;
                            write_counter_increase <= write_counter_increase + 1;
                        end else if (addr_20 >= 20'h10000 && addr_20 < 20'h20000) begin
                            // Write Matrix B
                            if(write_counter >= 4095) begin
                                state <= STATE_TRIGGER;
                            end
                            write_counter <= write_counter + 1;
                            write_counter_increase <= write_counter_increase + 1;
                        end else if (addr_20 >= 20'h20000 && addr_20 < 20'h20020) begin
                            // Trigger Address
                            state <= STATE_TRIGGER;
                        end else begin
                            state <= STATE_RECEIVE;
                        end
                    end else begin
                        state <= STATE_RECEIVE;
                    end
                end

                STATE_CALC: begin
                    for (loop_mul_idx = 0; loop_mul_idx < 256; loop_mul_idx = loop_mul_idx + 1) begin
                        temp_AB[loop_mul_idx] <= mem_A[calc_loop[15:8]][loop_mul_idx*8 +: 8] * mem_B[calc_loop[7:0]][loop_mul_idx*8 +: 8];
                    end
                    
                    if(calc_loop==16'hffff) begin
                        state <= STATE_OUTPUT;
                    end else begin
                        state <= STATE_CALC;
                        calc_loop <= calc_loop + 1;
                    end
                end

                STATE_OUTPUT: begin
                    o_axiu_user0_data_tvalid <= 1;
                    o_axiu_user0_data_tkeep <= 8'hff;
                    
                    if (o_axiu_user0_data_tready) begin
                        // Read 64-bit word directly (contains 2x 32-bit results)
                        // out_idx counts from 0 to 32767 linearly
                        o_axiu_user0_data_tdata <= mem_C[out_idx];
                        
                        if (out_idx == 15'h7fff) begin // 32767
                            o_axiu_user0_data_tlast <= 1;
                            state <= STATE_END;
                        end else begin
                            o_axiu_user0_data_tlast <= 0;
                            out_idx <= out_idx + 1;
                            state <= STATE_OUTPUT;
                        end
                    end
                end

                STATE_END: begin
                    o_axiu_user0_data_tvalid <= 0;
                    o_axiu_user0_data_tlast <= 0;
                    o_axiu_user0_data_tkeep <= 8'h00;
                    state <= STATE_RECEIVE;
                    write_counter <= 0;
                    calc_loop <= 0;
                    out_idx <= 0;
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            state_d <= 0;
            state_dd <= 0;
            calc_loop_d <= 0;
            calc_loop_dd <= 0;
        end else begin    
            state_d <= state;
            state_dd <= state_d;
            calc_loop_d <= calc_loop;
            calc_loop_dd <= calc_loop_d;
        end
    end
    
    always @(posedge clk) begin
        if(state_d==STATE_CALC) begin    
            // 1. Initialize the temporary accumulator to 0
            sum_temp0 = 0; 
            sum_temp1 = 0; 
            sum_temp1 = 0; 
            sum_temp1 = 0; 
            sum_temp2 = 0; 
            sum_temp3 = 0; 
            sum_temp4 = 0; 
            sum_temp5 = 0; 
            sum_temp6 = 0; 
            sum_temp7 = 0; 
            sum_temp8 = 0; 
            sum_temp9 = 0; 
            sum_temp10 = 0; 
            sum_temp11 = 0; 
            sum_temp12 = 0; 
            sum_temp13 = 0; 
            sum_temp14 = 0; 
            sum_temp15 = 0;

            // 2. Accumulate all 256 values using a blocking assignment (=)
            for (i = 0; i < 16; i = i + 1) begin
                sum_temp0 = sum_temp0 + temp_AB[i];
                sum_temp1 = sum_temp1 + temp_AB[i+16];
                sum_temp2 = sum_temp2 + temp_AB[i+32];
                sum_temp3 = sum_temp3 + temp_AB[i+48];
                sum_temp4 = sum_temp4 + temp_AB[i+64];
                sum_temp5 = sum_temp5 + temp_AB[i+80];
                sum_temp6 = sum_temp6 + temp_AB[i+96];
                sum_temp7 = sum_temp7 + temp_AB[i+112];
                sum_temp8 = sum_temp8 + temp_AB[i+128];
                sum_temp9 = sum_temp9 + temp_AB[i+144];
                sum_temp10 = sum_temp10 + temp_AB[i+160];
                sum_temp11 = sum_temp11 + temp_AB[i+176];
                sum_temp12 = sum_temp12 + temp_AB[i+192];
                sum_temp13 = sum_temp13 + temp_AB[i+208];
                sum_temp14 = sum_temp14 + temp_AB[i+224];
                sum_temp15 = sum_temp15 + temp_AB[i+240];
            end
        end
    end

    always @(posedge clk) begin
        if(state_dd==STATE_CALC) begin    
            // Write to mem_C with byte/word enables
            // Calculate linear index: (row * 128) + (col / 2)
            // effective index = calc_loop_dd[15:1]
            
            if (calc_loop_dd[0] == 1'b0) begin
                // Even index: Write Lower 32 bits
                mem_C[calc_loop_dd[15:1]][31:0] 
                    <= sum_temp0 + sum_temp1 + sum_temp2 + sum_temp3 
                        + sum_temp4 + sum_temp5 + sum_temp6 + sum_temp7 
                            + sum_temp8 + sum_temp9 + sum_temp10 + sum_temp11 
                                + sum_temp12 + sum_temp13 + sum_temp14 + sum_temp15;
            end else begin
                // Odd index: Write Upper 32 bits
                mem_C[calc_loop_dd[15:1]][63:32] 
                    <= sum_temp0 + sum_temp1 + sum_temp2 + sum_temp3 
                        + sum_temp4 + sum_temp5 + sum_temp6 + sum_temp7 
                            + sum_temp8 + sum_temp9 + sum_temp10 + sum_temp11 
                                + sum_temp12 + sum_temp13 + sum_temp14 + sum_temp15;
            end
       end
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            write_counter_out <= 0;
            trigger_counter_out <= 0;
        end else begin    
            write_counter_out <= write_counter;
            trigger_counter_out <= trigger_counter;
        end
    end

endmodule