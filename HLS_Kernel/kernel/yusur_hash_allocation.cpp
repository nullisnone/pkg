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

    // Define matrices (8x8 as per new format)
    uint8_t A_MATRIX[8][8];
    uint8_t B_MATRIX[8][8];
    uint16_t C_MATRIX[8][8];
    
    // Partition matrices for parallel access
    #pragma HLS ARRAY_PARTITION variable=A_MATRIX complete dim=0
    #pragma HLS ARRAY_PARTITION variable=B_MATRIX complete dim=0
    #pragma HLS ARRAY_PARTITION variable=C_MATRIX complete dim=0

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
            // Header
            for (int k = 0; k < 8; k++) {
                #pragma HLS UNROLL
                HEADER_INFO[k] = (in_val.data >> (k * 8)) & 0xFF;
            }
        } else if (batch_counter < 9) {
            // Matrix A (Row batch_counter-1)
            int row = batch_counter - 1;
            for (int k = 0; k < 8; k++) {
                #pragma HLS UNROLL
                A_MATRIX[row][k] = (in_val.data >> (k * 8)) & 0xFF;
            }
        } else if (batch_counter < 17) {
            // Matrix B (Row batch_counter-9)
            int row = batch_counter - 9;
            for (int k = 0; k < 8; k++) {
                #pragma HLS UNROLL
                B_MATRIX[row][k] = (in_val.data >> (k * 8)) & 0xFF;
            }
        } 
        // batch_counter >= 17: Just drain (do nothing with data)

        // Check TLAST
        if (in_val.last == 1) {
            // If TLAST happened at any index other than 16 (the 17th word), it's invalid length
            if (batch_counter != 16) {
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

    // Always perform calculation and output (regardless of validity)
    // Matrix Multiplication: C = A * B
    LOOP_CALC:
    for(int i=0; i<8; i++) {
        #pragma HLS UNROLL
        for(int j=0; j<8; j++) {
            #pragma HLS UNROLL
            uint16_t sum = 0;
            for(int k=0; k<8; k++) {
                #pragma HLS UNROLL
                sum += A_MATRIX[i][k] * B_MATRIX[k][j];
            }
            C_MATRIX[i][j] = sum;
        }
    }
            
    // Unified Output Loop: Header (1 word) + C_MATRIX (8 rows * 2 words/row) = 17 words
    LOOP_OUTPUT_ALL:
    for(int i=0; i<17; i++) {
        #pragma HLS PIPELINE
        ap_axiu<64, 0, 0, 0> out_val;
        out_val.data = 0;
        out_val.keep = 0xFF;
        out_val.last = (i == 16) ? 1 : 0; // Set TLAST on the 17th word (index 16)

        if (i == 0) {
            // Write Header (Prefix)
            for (int k = 0; k < 8; k++) {
                #pragma HLS UNROLL
                out_val.data |= ((ap_uint<64>)HEADER_INFO[k]) << (k * 8);
            }
        } else {
            // Write C_MATRIX Row
            // i=1..16.
            // i=1 -> row 0, part 0
            // i=2 -> row 0, part 1
            int matrix_idx = i - 1;
            int row_idx = matrix_idx / 2;
            int part_idx = matrix_idx % 2; // 0 for lower 4 cols, 1 for upper 4 cols
            
            int col_offset = part_idx * 4;
            
            for(int j=0; j<4; j++) {
                #pragma HLS UNROLL
                // Each item is 16-bit. 4 items fill 64 bits.
                out_val.data |= ((ap_uint<64>)C_MATRIX[row_idx][col_offset + j]) << (j * 16);
            }
        }
        o_axiu_user0_data.write(out_val);
    }
}

