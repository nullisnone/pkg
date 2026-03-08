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

    // Define matrices (32x32)
    uint8_t A_MATRIX[32][32];
    uint8_t B_MATRIX[32][32];
    uint16_t C_MATRIX[32][32];

    // Partition matrices for parallel access
    // A needs parallel column access (dim=2) for Row * Col
    #pragma HLS ARRAY_PARTITION variable=A_MATRIX complete dim=2
    // B needs complete partitioning for full parallel access
    #pragma HLS ARRAY_PARTITION variable=B_MATRIX complete dim=0
    // C needs parallel column access (dim=2) for parallel write in each row
    #pragma HLS ARRAY_PARTITION variable=C_MATRIX complete dim=2

    // Header storage
    uint8_t HEADER_INFO[8];
    #pragma HLS ARRAY_PARTITION variable=HEADER_INFO complete

    // Output buffer removed (streaming directly)

#pragma HLS DATAFLOW
    
    // Drain unused stream data if any (non-blocking)
    if (!i_axiu_stream_data.empty()) {
        i_axiu_stream_data.read();
    }
    if (!i_axiu_key.empty()) {
        i_axiu_key.read();
    }

    ap_axiu<64, 0, 0, 0> in_val;
    int batch_counter = 0;
    bool read_done = false;
    
    // Unified Loop: Read until TLAST is found
    // Handles reading Header, Matrices, and draining excess data in one go
    LOOP_READ_AND_DRAIN:
    while (!read_done) {
        #pragma HLS PIPELINE
        in_val = i_axiu_user0_data.read();
        
        if (batch_counter == 0) {
            // Header (1 word)
            for (int k = 0; k < 8; k++) {
                #pragma HLS UNROLL
                HEADER_INFO[k] = (in_val.data >> (k * 8)) & 0xFF;
            }
        } else if (batch_counter <= 128) {
            // Matrix A (128 words, 4 words per row)
            // batch_counter 1..128 -> 32 rows
            int idx = batch_counter - 1;
            int row = idx / 4;
            int col_offset = (idx % 4) * 8;
            for (int k = 0; k < 8; k++) {
                #pragma HLS UNROLL
                A_MATRIX[row][col_offset + k] = (in_val.data >> (k * 8)) & 0xFF;
            }
        } else if (batch_counter <= 256) {
            // Matrix B (128 words, 4 words per row)
            // batch_counter 129..256 -> 32 rows
            int idx = batch_counter - 129;
            int row = idx / 4;
            int col_offset = (idx % 4) * 8;
            for (int k = 0; k < 8; k++) {
                #pragma HLS UNROLL
                B_MATRIX[row][col_offset + k] = (in_val.data >> (k * 8)) & 0xFF;
            }
        } 
        // batch_counter > 256: Just drain (do nothing with data)

        // Check TLAST
        if (in_val.last == 1) {
            // If TLAST happened at any index other than 256 (the 257th word), it's invalid length
            if (batch_counter != 256) {
                // Invalid length: Overwrite Header with 0xFF
                for(int k=0; k<8; k++) {
                    #pragma HLS UNROLL
                    HEADER_INFO[k] = 0xFF;
                }
            }
            read_done = true; // Signal to exit loop
        }
        
        batch_counter++;
    }

    // Matrix Multiplication: C = A x B (True Matrix Multiplication)
    // Optimized for latency: Compute one element C[i][j] every 2 clock cycles
    // This avoids memory port conflicts and timing violations.
    LOOP_CALC:
    for(int i=0; i<32; i++) {
        #pragma HLS PIPELINE II=1
        for(int j=0; j<32; j++) {
            #pragma HLS UNROLL
            uint32_t sum = 0;
            for(int k=0; k<32; k++) {
                #pragma HLS UNROLL
                sum += A_MATRIX[i][k] * B_MATRIX[k][j];
            }
            C_MATRIX[i][j] = (uint16_t)sum;
        }
    }

    // ---------------------------------------------------------
    // Output Stage: Stream directly to o_axiu_user0_data
    // ---------------------------------------------------------
    
    // Unified Output Loop: Header (1 word) + C_MATRIX (256 words) = 257 words
    // C_MATRIX is 32x32 uint16_t. 
    // Each row: 32 * 2 bytes = 64 bytes = 8 words.
    // Total words for C: 32 * 8 = 256 words.
    LOOP_OUTPUT_ALL:
    for(int i=0; i<257; i++) {
        #pragma HLS PIPELINE
        ap_axiu<64, 0, 0, 0> out_val;
        out_val.data = 0;
        out_val.keep = 0xFF;
        out_val.last = (i == 256) ? 1 : 0; // Set TLAST on the 257th word (index 256)

        if (i == 0) {
            // Write Header (Prefix)
            for (int k = 0; k < 8; k++) {
                #pragma HLS UNROLL
                out_val.data |= ((ap_uint<64>)HEADER_INFO[k]) << (k * 8);
            }
        } else {
            // Write C_MATRIX Data
            int idx = i - 1;
            int row_idx = idx / 8;       // 8 words per row
            int word_in_row = idx % 8;   // 0..7
            int col_start = word_in_row * 4; // Each word holds 4 elements (4 * 16bit = 64bit)

            for(int j=0; j<4; j++) {
                #pragma HLS UNROLL
                // Pack 4 uint16_t elements
                out_val.data |= ((ap_uint<64>)C_MATRIX[row_idx][col_start + j]) << (j * 16);
            }
        }
        o_axiu_user0_data.write(out_val);
    }
}

