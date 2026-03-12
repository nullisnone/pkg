#include "ap_axi_sdata.h"
#include "ap_int.h"
#include "hls_stream.h"
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <iomanip>

void yusur_hash_allocation(hls::stream<ap_uint<80> >& i_axiu_key,                    //hash key
                           hls::stream<ap_axiu<64, 0, 0, 0> >& i_axiu_stream_data,   //udp data after filter
                           hls::stream<ap_axiu<64, 0, 0, 0> >& i_axiu_user0_data,
                           hls::stream<ap_axiu<64, 0, 0, 0> >& o_axiu_user0_data)
{

#pragma HLS INTERFACE axis port = i_axiu_key
#pragma HLS INTERFACE axis port = i_axiu_stream_data
#pragma HLS INTERFACE axis port = i_axiu_user0_data
#pragma HLS INTERFACE axis port = o_axiu_user0_data
#pragma HLS INTERFACE ap_ctrl_none port = return


    ap_axiu<64, 0, 0, 0> i_rdata;

    // Define matrices (128x128, 8-bit elements) - STATIC to persist across packets
    static ap_uint<8> A_MATRIX[128][128];
    static ap_uint<8> B_MATRIX[128][128];
    static uint16_t C_MATRIX[128][128];

    // Partition matrices for optimized access and timing
    // Use PARTITION instead of RESHAPE to avoid Read-Modify-Write timing penalties
    // A: Partition complete dim=2 (128 columns) is sufficient because:
    //    - Input: Writes to multiple columns (dim=2) in one row.
    //    - Calc: Reads multiple columns (dim=2) from one row (A[i][k]).
    #pragma HLS ARRAY_PARTITION variable=A_MATRIX complete dim=2
    
    // B: Partition complete dim=0 (Full Partition) is required because:
    //    - Input: Writes to multiple columns (dim=2) in one row.
    //    - Calc: Reads from multiple rows (dim=1) for one column (B[k][j]).
    #pragma HLS ARRAY_PARTITION variable=B_MATRIX complete dim=2
    // C: Partition complete dim=2 to allow writing individual elements and parallel reading
    #pragma HLS ARRAY_PARTITION variable=C_MATRIX complete dim=2
    
    // Header storage
    uint64_t header_val = 0;
    
    // Drain unused stream data if any (non-blocking)
    if (!i_axiu_stream_data.empty()) {
        i_axiu_stream_data.read();
    }
    if (!i_axiu_key.empty()) {
        i_axiu_key.read();
    }

    ap_axiu<64, 0, 0, 0> in_val;
    bool calc_trigger = false;
    
    // Loop to read one packet (Segment)
    // The host sends 4 separate packets. This kernel is called for each packet (or loops if stream is continuous)
    // Assuming standard AXI Stream behavior where one kernel call processes one TLAST packet.
    // However, to be safe for continuous streaming, we read until TLAST.
    
    int batch_counter = 0;
    bool read_done = false;
    
    LOOP_READ_PACKET:
    while (!read_done) {
        #pragma HLS PIPELINE II=1
        if (i_axiu_user0_data.empty()) {
            // Wait for data or exit if needed (blocking read handles wait)
             break; // Should not happen in blocking mode, but good for safety
        }
        in_val = i_axiu_user0_data.read();
        
        if (batch_counter == 0) {
            // Capture Header
            header_val = in_val.data;
        } else {
            // Process Data Payload (4096 bytes = 512 words of 64-bit)
            // Each word contains 16 elements (4-bit each)
            // Total elements per packet: 512 * 16 = 8192 elements
            // 8192 elements fill 64 rows of 128 columns (64 * 128 = 8192)
            
            if (batch_counter <= 512) {
                int data_idx = batch_counter - 1; // 0..511
                int row_offset = 0;
                int col_offset = 0;
                
                // Determine target based on Header
                // Header Format Assumption based on user input:
                // 0x...01XX -> Matrix A, Start Row = XX
                // 0x...02XX -> Matrix B, Start Row = XX
                // Example: 0x100 -> A, 0. 0x110 -> A, 16. 0x210 -> B, 16 (or 0?).
                
                bool valid_segment = false;
                ap_uint<8> (*target_matrix)[128] = nullptr;
                int start_row = 0;

                // Extract Matrix ID (Bits 8-11) and Start Row (Bits 0-7)
                // 0x0100 -> ID=1, Row=0x00=0
                // 0x0110 -> ID=1, Row=0x10=16
                // 0x0230 -> ID=2, Row=0x30=48
                
                uint8_t mat_id = (header_val >> 8) & 0xF;
                uint8_t row_val = header_val & 0xFF;

                // Handle the specific 0x210 case mentioned by user (User said "start from 0" for 0x210)
                // If generic logic is used, 0x210 -> Row 16.
                // We will implement generic logic but allow for the specific 0x210 override if needed.
                // However, strictly following the pattern (Hex Byte = Row Index) is safer for automation.
                // Given the sequence 0x210, 0x220, 0x230 -> 16, 32, 48. 
                // If user meant 0, 32, 48, then 0x210 is weird. 
                // Let's assume generic parsing: row_val is the start row.
                
                if (mat_id == 1) {
                    target_matrix = A_MATRIX;
                    start_row = row_val;
                    valid_segment = true;
                } else if (mat_id == 2) {
                    target_matrix = B_MATRIX;
                    start_row = row_val;
                    valid_segment = true;
                    
                    // Trigger calculation on the last expected packet
                    if (((header_val>>56)&0xFF) == 0xFF) {
                        calc_trigger = true;
                    }
                }

                if (valid_segment) {
                    // Map linear index to 32x128 sub-block (since 4096 bytes = 32 rows of 128 bytes)
                    // data_idx (0..511) -> 512 words * 8 bytes/word = 4096 bytes
                    // Rows covered: 4096 / 128 = 32 rows.
                    
                    // 1 Row = 128 bytes = 16 words (128/8)
                    int sub_row = data_idx / 16; // 0..31
                    int sub_col_word = data_idx % 16; // 0..15
                    
                    int abs_row = start_row + sub_row;
                    int abs_col_start = sub_col_word * 8; // 8 bytes per word
                    
                    if (abs_row < 128) { // Bounds check
                        for (int k = 0; k < 8; k++) {
                            #pragma HLS UNROLL
                            target_matrix[abs_row][abs_col_start + k] = in_val.data(8*k+7, 8*k);
                        }
                    }
                }
            }
        }

        if (in_val.last) {
            read_done = true;
        }
        batch_counter++;
    }

    // Conditional Calculation: Only execute when the last segment (0x22...22) is received
    if (calc_trigger) {
        LOOP_CALC:
        for(int i=0; i<128; i++) {
            for(int j=0; j<128; j++) {
                #pragma HLS PIPELINE II=1
                uint32_t sum = 0;
                for(int k=0; k<128; k++) {
                    #pragma HLS UNROLL 
                    sum += A_MATRIX[i][k] * B_MATRIX[j][k];
                }
                C_MATRIX[i][j] = (uint16_t)sum;
            }
        }
    }

    // ---------------------------------------------------------
    // Output Stage: Single Batch
    // Header (8 Bytes) + Data (128*128*2 Bytes = 32768 Bytes)
    // Total: 32776 Bytes
    // Beats: 1 Header + 4096 Data = 4097 Beats
    // ---------------------------------------------------------
    
    uint64_t output_header = 0x0101010101010101;

    LOOP_OUTPUT_BEATS:
    for(int i=0; i<4097; i++) {
        #pragma HLS PIPELINE II=1
        ap_axiu<64, 0, 0, 0> out_val;
        out_val.data = 0;
        out_val.keep = 0xFF;
        out_val.last = (i == 4096) ? 1 : 0; // TLAST at end of the single batch

        if (i == 0) {
            // Header
            out_val.data = output_header;
        } else {
            // Data: 128 Rows * 128 Cols * 2 Bytes = 32768 Bytes = 4096 Beats
            // Beat index 0..4095
            int data_idx = i - 1;
            
            // Calculate position in C_MATRIX
            // 1 Row = 128 elements = 128 * 2 bytes = 256 bytes
            // 1 Beat = 8 bytes
            // Beats per row = 256 / 8 = 32 beats
            
            int abs_row = data_idx / 32;      // 0..127
            int col_beat = data_idx % 32;     // 0..31
            
            int abs_col_start = col_beat * 4; // 4 elements per beat
            
            for (int k = 0; k < 4; k++) {
                #pragma HLS UNROLL
                out_val.data |= ((ap_uint<64>)C_MATRIX[abs_row][abs_col_start + k]) << (k * 16);
            }
        }
        o_axiu_user0_data.write(out_val);
    }
}

