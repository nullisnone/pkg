module yusur_hash_allocation (
    input  wire          ap_clk,
    input  wire          ap_rst_n,

    // User Logic Native Memory Interface (Write Slave)
    input  wire          user_logic_native_mem_valid,
    input  wire [63:0]   user_logic_native_mem_address,
    input  wire [255:0]  user_logic_native_mem_data,
    input  wire [31:0]   user_logic_native_mem_strb,

    // AXI Stream Master Interface (Output)
    output reg  [63:0]   o_axiu_user0_data_TDATA,
    output reg           o_axiu_user0_data_TVALID,
    input  wire          o_axiu_user0_data_TREADY,
    output reg  [7:0]    o_axiu_user0_data_TKEEP,
    output reg           o_axiu_user0_data_TLAST,

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

    localparam OUT_STATE_IDLE   = 1'b0;
    localparam OUT_STATE_OUTPUT = 1'b1;

    // -------------------------------------------------------------------------
    // Signals & Registers
    // -------------------------------------------------------------------------
    reg [2:0] state = 0;
    reg [2:0] state_d = 0;
    reg [2:0] state_dd = 0;
    reg [2:0] state_ddd = 0;
    reg [2:0] state_4d = 0;
    reg [2:0] state_5d = 0;
    reg [2:0] state_6d = 0;
    reg [2:0] state_7d = 0;
    
    reg out_state = OUT_STATE_IDLE;
    
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
     
    wire [7:0] col_addr_a = addr_16[15:8];
    wire [7:0] row_base_a = {addr_16[7:5], 5'b0};
    
    // col_addr_b should address 32 rows (5 bits), row_base_b should address 2048 bytes (11 bits)
    wire [4:0] col_addr_b = addr_16[15:11];
    wire [10:0] row_base_b = {addr_16[10:5], 5'b0};
    
    // integer byte_idx_a; // Unused
    // integer byte_idx_b; // Unused
    integer loop_mul_idx;
    integer i,j,k,n,m;

    //calc loop 
    reg [15:0] calc_loop = 0;
    reg [15:0] calc_loop_d = 0;
    reg [15:0] calc_loop_dd = 0;
    reg [15:0] calc_loop_ddd = 0;
    reg [15:0] calc_loop_4d = 0;
    reg [15:0] calc_loop_5d = 0;
    reg [15:0] calc_loop_6d = 0;
    
    // -------------------------------------------------------------------------
    // RAM Instantiation (Wide Words for Parallel BRAM Inference)
    // -------------------------------------------------------------------------
    // To access all 256 elements in a single clock cycle, we pack them into 
    // a single 2048-bit wide word per row. Vivado will infer multiple BRAMs 
    // in parallel to create this wide memory.
    // 256 elements * 8 bits = 2048 bits wide. 256 rows deep.
    // mem_C: Flat 1D array, 64-bits wide (stores 2x 32-bit results per word)
    // Total depth = (256 * 256) / 2 = 32768
    (* ram_style = "distributed" *) reg [2047:0] mem_A [0:255];
    (* ram_style = "distributed" *) reg [16383:0] mem_B [0:31];
    (* ram_style = "distributed" *) reg [63:0] mem_C_0 [0:8191]; 
    (* ram_style = "distributed" *) reg [63:0] mem_C_1 [0:8191]; 
    (* ram_style = "distributed" *) reg [63:0] mem_C_2 [0:8191]; 
    (* ram_style = "distributed" *) reg [63:0] mem_C_3 [0:8191]; 
    //store temporary result for 4-tier adder
    (* use_dsp = "yes" *) reg [31:0] packed_P [0:3][0:255];
    reg [17:0] sum_t1 [0:7][0:63];
    reg [19:0] sum_t2 [0:7][0:15];
    reg [21:0] sum_t3 [0:7][0:3];
    reg [31:0] sum_result [0:7];
  
    reg [63:0] th0_result = 0;

    // Initialize memories
    integer init_i;
    integer init_j;
    integer init_k;
    integer init_m;
    integer init_n;
    initial begin
        for (init_i = 0; init_i < 256; init_i = init_i + 1) begin
            mem_A[init_i] = 0;
        end
        for (init_j = 0; init_j < 32; init_j = init_j + 1) begin
             mem_B[init_j] = 0;
        end
        for (init_k = 0; init_k < 8192; init_k = init_k + 1) begin
             mem_C_0[init_k] = 0;
             mem_C_1[init_k] = 0;
             mem_C_2[init_k] = 0;
             mem_C_3[init_k] = 0;
        end
        for (init_m = 0; init_m < 4; init_m = init_m + 1) begin
            for (init_n = 0; init_n < 256; init_n = init_n + 1) begin
                 packed_P[init_m][init_n] = 0;
            end
        end
    end

    integer byte_idx_a;
    integer byte_idx_b;
    
    always @(posedge ap_clk) begin
        if (write_enable && addr_20<20'h10000) begin 
            for (byte_idx_a = 0; byte_idx_a < 32; byte_idx_a = byte_idx_a + 1) begin
                mem_A[col_addr_a][(row_base_a + byte_idx_a)*8 +: 8] <= user_logic_native_mem_data[byte_idx_a*8 +: 8];
            end
            //mem_A[col_addr_a][(row_base_a*8) +: 256] <= user_logic_native_mem_data;
        end
    end

    always @(posedge ap_clk) begin
        if (write_enable && addr_20>=20'h10000 && addr_20<20'h20000) begin 
            for (byte_idx_b = 0; byte_idx_b < 32; byte_idx_b = byte_idx_b + 1) begin
                mem_B[col_addr_b][(row_base_b + byte_idx_b)*8 +: 8] <= user_logic_native_mem_data[byte_idx_b*8 +: 8];
            end
            //mem_B[col_addr_b][(row_base_b*8) +: 256] <= user_logic_native_mem_data;
        end
    end

    reg [2047:0] mem_A_read;
    reg [16383:0] mem_B_read;

    // -------------------------------------------------------------------------
    // Main FSM & Logic
    // -------------------------------------------------------------------------
    always @(posedge ap_clk or negedge ap_rst_n) begin
        if (!ap_rst_n) begin
            state <= STATE_RECEIVE;
            write_counter <= 0;
            write_counter_increase <= 0;
            trigger_counter <= 0;
            calc_loop <= 0;
        end else begin
            case (state)
                STATE_RECEIVE: begin
                    // ---------------------------------------------------------
                    // Write Phase
                    // ---------------------------------------------------------
                    if (write_enable) begin
                        if (addr_20 < 20'h20000) begin
                            // Write Matrix 
                            if(write_counter >= 4095) begin
                                state <= STATE_CALC;
                                trigger_counter <= trigger_counter + 1;
                            end else begin
                                state <= STATE_RECEIVE;
                            end

                            write_counter <= write_counter + 1;
                            write_counter_increase[15:0] <= write_counter_increase[15:0] + 1;
                        end else if (addr_20 >= 20'h20000 && addr_20 < 20'h20020) begin
                            // Trigger Address
                            state <= STATE_CALC;
                            trigger_counter <= trigger_counter + 1;
                        end else begin
                            state <= STATE_RECEIVE;
                            write_counter_increase[31:16] <= write_counter_increase[31:16] + 1;
                        end
                    end else begin
                        state <= STATE_RECEIVE;
                    end
                end

                STATE_CALC: begin
                    mem_A_read <= mem_A[calc_loop[12:5]];
                    mem_B_read <= mem_B[calc_loop[4:0]];

                    if(calc_loop==16'h1fff) begin
                        state <= STATE_OUTPUT;
                    end else begin
                        state <= STATE_CALC;
                        calc_loop <= calc_loop + 1;
                    end
                end

                STATE_OUTPUT: begin
                    // Main FSM waits here until the separate Output FSM completes
                    if (out_state == OUT_STATE_IDLE) begin
                        state <= STATE_END;
                    end
                end

                STATE_END: begin
                    state <= STATE_RECEIVE;
                    write_counter <= 0;
                    calc_loop <= 0;
                end
            endcase
        end
    end

    // -------------------------------------------------------------------------
    // Output FSM
    // -------------------------------------------------------------------------
    wire [14:0] next_out_idx = out_idx + 1;

    always @(posedge ap_clk or negedge ap_rst_n) begin
        if (!ap_rst_n) begin
            out_state <= OUT_STATE_IDLE;
            out_idx <= 0;
            o_axiu_user0_data_TVALID <= 0;
            o_axiu_user0_data_TLAST <= 0;
            o_axiu_user0_data_TKEEP <= 8'h00;
            o_axiu_user0_data_TDATA <= 0;
        end else begin
            case (out_state)
                OUT_STATE_IDLE: begin
                    out_idx <= 0;
                    o_axiu_user0_data_TLAST <= 1'b0;
                    
                    if (state_7d == STATE_CALC) begin // Triggers after 6-stage adder pipeline + write
                        out_state <= OUT_STATE_OUTPUT;
                        o_axiu_user0_data_TVALID <= 1'b1;
                        o_axiu_user0_data_TKEEP <= 8'hff;
                        o_axiu_user0_data_TDATA <= th0_result;
                    end else begin
                        out_state <= OUT_STATE_IDLE;
                        o_axiu_user0_data_TVALID <= 1'b0;
                        o_axiu_user0_data_TKEEP <= 8'h00;
                    end
                end

                OUT_STATE_OUTPUT: begin
                    // Only advance pipeline when host is ready to accept current word
                    if (o_axiu_user0_data_TREADY) begin
                        if (out_idx == 15'h7fff) begin // 32767
                            out_state <= OUT_STATE_IDLE;
                            o_axiu_user0_data_TVALID <= 1'b0;
                            o_axiu_user0_data_TKEEP <= 8'h00;
                            o_axiu_user0_data_TLAST <= 1'b0;
                        end else begin
                            out_state <= OUT_STATE_OUTPUT;
                            out_idx <= next_out_idx;
                            o_axiu_user0_data_TVALID <= 1'b1;
                            o_axiu_user0_data_TKEEP <= 8'hff;
                            o_axiu_user0_data_TLAST <= (next_out_idx == 15'h7fff) ? 1'b1 : 1'b0;
                            case (next_out_idx[1:0])
                                2'b00: o_axiu_user0_data_TDATA <= mem_C_0[next_out_idx[14:2]];
                                2'b01: o_axiu_user0_data_TDATA <= mem_C_1[next_out_idx[14:2]];
                                2'b10: o_axiu_user0_data_TDATA <= mem_C_2[next_out_idx[14:2]];
                                2'b11: o_axiu_user0_data_TDATA <= mem_C_3[next_out_idx[14:2]];
                            endcase
                        end
                    end
                end
            endcase
        end
    end

    always @(posedge ap_clk or negedge ap_rst_n) begin
        if (!ap_rst_n) begin
            state_d <= 0;
            state_dd <= 0;
            state_ddd <= 0;
            state_4d <= 0;
            state_5d <= 0;
            state_6d <= 0;
            calc_loop_d <= 0;
            calc_loop_dd <= 0;
            calc_loop_ddd <= 0;
            calc_loop_4d <= 0;
            calc_loop_5d <= 0;
        end else begin    
            state_d <= state;
            state_dd <= state_d;
            state_ddd <= state_dd;
            state_4d <= state_ddd;
            state_5d <= state_4d;
            state_6d <= state_5d;
            state_7d <= state_6d;
            calc_loop_d <= calc_loop;
            calc_loop_dd <= calc_loop_d;
            calc_loop_ddd <= calc_loop_dd;
            calc_loop_4d <= calc_loop_ddd;
            calc_loop_5d <= calc_loop_4d;
            calc_loop_6d <= calc_loop_5d;
        end
    end
    
    // Tier 0: Multiply mem_A and mem_B (Packed into DSPs)
    always @(posedge ap_clk) begin
        if(state_d==STATE_CALC) begin    
            for (loop_mul_idx = 0; loop_mul_idx < 256; loop_mul_idx = loop_mul_idx + 1) begin
                packed_P[0][loop_mul_idx] <= mem_A_read[loop_mul_idx*8 +: 8] * {mem_B_read[(loop_mul_idx*8)+(2048*1) +: 8], 8'h00, mem_B_read[(loop_mul_idx*8)+(2048*0) +: 8]};
                packed_P[1][loop_mul_idx] <= mem_A_read[loop_mul_idx*8 +: 8] * {mem_B_read[(loop_mul_idx*8)+(2048*3) +: 8], 8'h00, mem_B_read[(loop_mul_idx*8)+(2048*2) +: 8]};
                packed_P[2][loop_mul_idx] <= mem_A_read[loop_mul_idx*8 +: 8] * {mem_B_read[(loop_mul_idx*8)+(2048*5) +: 8], 8'h00, mem_B_read[(loop_mul_idx*8)+(2048*4) +: 8]};
                packed_P[3][loop_mul_idx] <= mem_A_read[loop_mul_idx*8 +: 8] * {mem_B_read[(loop_mul_idx*8)+(2048*7) +: 8], 8'h00, mem_B_read[(loop_mul_idx*8)+(2048*6) +: 8]};
            end
        end
    end

    // Tier 1: sum 4 temp_AB items (256 -> 64)
    always @(posedge ap_clk) begin
        if(state_dd==STATE_CALC) begin    
            for (k = 0; k < 4; k = k + 1) begin
                for (j = 0; j < 64; j = j + 1) begin
                    sum_t1[k*2][j] <= packed_P[k][j*4][15:0] + packed_P[k][j*4+1][15:0] + packed_P[k][j*4+2][15:0] + packed_P[k][j*4+3][15:0];
                    sum_t1[k*2+1][j] <= packed_P[k][j*4][31:16] + packed_P[k][j*4+1][31:16] + packed_P[k][j*4+2][31:16] + packed_P[k][j*4+3][31:16];
                end
            end
        end
    end

    // Tier 2: sum 4 sum_t1 items (64 -> 16)
    always @(posedge ap_clk) begin
        if(state_ddd==STATE_CALC) begin    
            for (k = 0; k < 8; k = k + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    sum_t2[k][j] <= sum_t1[k][j*4] + sum_t1[k][j*4+1] + sum_t1[k][j*4+2] + sum_t1[k][j*4+3];
                end
            end
       end
    end

    // Tier 3: sum 4 sum_t2 items (16 -> 4)
    always @(posedge ap_clk) begin
        if(state_4d==STATE_CALC) begin    
            for (k = 0; k < 8; k = k + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    sum_t3[k][j] <= sum_t2[k][j*4] + sum_t2[k][j*4+1] + sum_t2[k][j*4+2] + sum_t2[k][j*4+3];
                end
            end
       end
    end

    // Tier 4: sum 4 sum_t3 items (4 -> 1)
    always @(posedge ap_clk) begin
        if(state_5d==STATE_CALC) begin    
            for (k = 0; k < 8; k = k + 1) begin
                sum_result[k] <= sum_t3[k][0] + sum_t3[k][1] + sum_t3[k][2] + sum_t3[k][3];
            end
       end
    end

    // Write all 8 results into mem_C banks
    always @(posedge ap_clk) begin
        if(state_6d==STATE_CALC) begin    
            mem_C_3[calc_loop_6d[12:0]] <= {sum_result[7], sum_result[6]};
            mem_C_2[calc_loop_6d[12:0]] <= {sum_result[5], sum_result[4]};
            mem_C_1[calc_loop_6d[12:0]] <= {sum_result[3], sum_result[2]};
            mem_C_0[calc_loop_6d[12:0]] <= {sum_result[1], sum_result[0]};
        end
    end        
    
    // Write 1st result to 1st result
    always @(posedge ap_clk) begin
        if(state_6d==STATE_CALC && calc_loop_6d == 0) begin    
            th0_result <= {sum_result[1], sum_result[0]};
        end
    end        

    always @(posedge ap_clk or negedge ap_rst_n) begin
        if (!ap_rst_n) begin
            write_counter_out <= 0;
            trigger_counter_out <= 0;
        end else begin    
            write_counter_out <= write_counter_increase;
            trigger_counter_out <= trigger_counter;
        end
    end

endmodule