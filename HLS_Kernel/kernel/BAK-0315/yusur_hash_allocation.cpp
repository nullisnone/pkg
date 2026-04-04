#include "ap_axi_sdata.h"
#include "ap_int.h"
#include "hls_stream.h"
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <iomanip>

void yusur_hash_allocation(//hls::stream<ap_uint<80> >& i_axiu_key,                    
                           //hls::stream<ap_axiu<64, 0, 0, 0> >& i_axiu_stream_data,   
                           //hls::stream<ap_axiu<64, 0, 0, 0> >& i_axiu_user0_data,
                           hls::stream<ap_axiu<64, 0, 0, 0> >& o_axiu_user0_data,
                           ap_uint<1> user_logic_native_mem_valid,
                           ap_uint<64> user_logic_native_mem_address,
                           ap_uint<256> user_logic_native_mem_data,
                           ap_uint<32> user_logic_native_mem_strb) 
{

//#pragma HLS INTERFACE axis port = i_axiu_key
//#pragma HLS INTERFACE axis port = i_axiu_stream_data
//#pragma HLS INTERFACE axis port = i_axiu_user0_data
#pragma HLS INTERFACE axis port = o_axiu_user0_data

#pragma HLS INTERFACE ap_none port = user_logic_native_mem_valid
#pragma HLS INTERFACE ap_none port = user_logic_native_mem_address
#pragma HLS INTERFACE ap_none port = user_logic_native_mem_data
#pragma HLS INTERFACE ap_none  port = user_logic_native_mem_strb

#pragma HLS INTERFACE ap_ctrl_none port = return

    ap_axiu<64, 0, 0, 0> i_rdata;

    // Define matrices (256x256, 8-bit elements) - STATIC to persist across packets
    static ap_uint<8> A_MATRIX[256][256];
    static ap_uint<8> B_MATRIX[256][256];
    static uint32_t C_MATRIX[256][256];

    // Partition matrices for optimized access and timing
    // Use PARTITION instead of RESHAPE to avoid Read-Modify-Write timing penalties
    // A: Partition complete dim=2 (256 columns)
    #pragma HLS ARRAY_PARTITION variable=A_MATRIX complete dim=2
    
    #pragma HLS ARRAY_PARTITION variable=B_MATRIX complete dim=2
    // C: Partition complete dim=2 to allow writing individual elements and parallel reading
    #pragma HLS ARRAY_PARTITION variable=C_MATRIX complete dim=2
    
    // Header storage
    uint64_t header_val = 0;
    
    // Drain unused stream data if any (non-blocking)
    //if (!i_axiu_stream_data.empty()) {
    //    i_axiu_stream_data.read();
    //}
    //if (!i_axiu_key.empty()) {
    //    i_axiu_key.read();
    //}
    //if (!i_axiu_user0_data.empty()) {
    //    i_axiu_user0_data.read();
    //}

    ap_axiu<64, 0, 0, 0> in_val;
    bool calc_trigger = false;

    // Memory Write Logic (Non-blocking check)
    // mem_address increases by 1 for every DWORD (4 bytes).
    // mem_data is 256 bits (32 bytes). So each write increases mem_address by 8.
    // Matrix A is at 0x300000 ~ 0x303FFF (16384 DWORDs = 65536 bytes)
    // Matrix B is at 0x304000 ~ 0x307FFF
    if (user_logic_native_mem_valid == 1 && user_logic_native_mem_strb == 0xFFFFFFFF) {
        uint32_t addr_24 = user_logic_native_mem_address & 0xFFFFFF; // Extract last 24 bits
        
        if (addr_24 >= 0x300000 && addr_24 < 0x304000) {
            // Write to A_MATRIX
            uint32_t dword_offset = addr_24 - 0x300000;
            int start_idx = dword_offset * 4;

            for (int k = 0; k < 32; k++) {
                #pragma HLS UNROLL
                int current_idx = start_idx + k;
                int r = current_idx / 256;
                int c = current_idx % 256;
                
                if (r < 256) { // Bounds check
                    A_MATRIX[r][c] = user_logic_native_mem_data(8*k+7, 8*k);
                }
            }
        } else if (addr_24 >= 0x304000 && addr_24 < 0x308000) {
            // Write to B_MATRIX
            uint32_t dword_offset = addr_24 - 0x304000;
            int start_idx = dword_offset * 4;

            for (int k = 0; k < 32; k++) {
                #pragma HLS UNROLL
                int current_idx = start_idx + k;
                int r = current_idx / 256;
                int c = current_idx % 256;
                
                if (r < 256) { // Bounds check
                    B_MATRIX[r][c] = user_logic_native_mem_data(8*k+7, 8*k);
                }
            }
            
            // If this is the very last write of B_MATRIX (0x307FF8), trigger the calculation
            if (addr_24 == 0x307FF8) {
                calc_trigger = true;
            }
        }
    }
    
    // Conditional Calculation: Only execute when the last segment (0x22...22) is received
    if (calc_trigger) {
        LOOP_CALC:
        for(int i=0; i<256; i++) {
            for(int j=0; j<256; j++) {
                #pragma HLS PIPELINE II=1
                uint32_t sum = 0;
                for(int k=0; k<256; k++) {
                    #pragma HLS UNROLL 
                    sum += A_MATRIX[i][k] * B_MATRIX[j][k];
                }
                C_MATRIX[i][j] = sum;
            }
        }

        // ---------------------------------------------------------
        // Output Stage: Single Batch
        // Header (8 Bytes) + Data (256*256*4 Bytes = 262144 Bytes)
        // Total: 262152 Bytes
        // Beats: 1 Header + 32768 Data = 32769 Beats
        // ---------------------------------------------------------
        
        uint64_t output_header = 0x0101010101010101;

        LOOP_OUTPUT_BEATS:
        for(int i=0; i<32769; i++) {
            #pragma HLS PIPELINE II=1
            ap_axiu<64, 0, 0, 0> out_val;
            out_val.data = 0;
            out_val.keep = 0xFF;
            out_val.last = (i == 32768) ? 1 : 0; // TLAST at end of the single batch

            if (i == 0) {
                // Header
                out_val.data = output_header;
            } else {
                // Data: 256 Rows * 256 Cols * 4 Bytes = 262144 Bytes = 32768 Beats
                // Beat index 0..32767
                int data_idx = i - 1;
                
                // Calculate position in C_MATRIX
                // 1 Row = 256 elements = 256 * 4 bytes = 1024 bytes
                // 1 Beat = 8 bytes
                // Beats per row = 1024 / 8 = 128 beats
                
                int abs_row = data_idx / 128;      // 0..255
                int col_beat = data_idx % 128;     // 0..127
                
                int abs_col_start = col_beat * 2; // 2 elements per beat (64/32=2)
                
                for (int k = 0; k < 2; k++) {
                    #pragma HLS UNROLL
                    out_val.data |= ((ap_uint<64>)C_MATRIX[abs_row][abs_col_start + k]) << (k * 32);
                }
            }
            o_axiu_user0_data.write(out_val);
        }
    }
}

