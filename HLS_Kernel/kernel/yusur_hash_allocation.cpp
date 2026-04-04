#include "ap_axi_sdata.h"
#include "ap_int.h"
#include "hls_stream.h"
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <iomanip>

void yusur_hash_allocation(ap_uint<1> user_logic_native_mem_valid,
                           ap_uint<64> user_logic_native_mem_address,
                           ap_uint<256> user_logic_native_mem_data,
                           ap_uint<32> user_logic_native_mem_strb,
                           hls::stream<ap_axiu<64, 0, 0, 0> >& o_axiu_user0_data,
                           ap_uint<16>& write_counter_out,
                           ap_uint<8>& trigger_counter_out
                           ) 
{
#pragma HLS INTERFACE ap_none port = user_logic_native_mem_valid
#pragma HLS INTERFACE ap_none port = user_logic_native_mem_address
#pragma HLS INTERFACE ap_none port = user_logic_native_mem_data
#pragma HLS INTERFACE ap_none  port = user_logic_native_mem_strb


#pragma HLS INTERFACE axis port = o_axiu_user0_data
#pragma HLS INTERFACE ap_none port = trigger_counter_out
#pragma HLS INTERFACE ap_none port = write_counter_out

#pragma HLS INTERFACE ap_ctrl_none port = return

    // Define matrices (256x256, 8-bit elements) - STATIC to persist across packets
    static ap_uint<8> A_MATRIX[256][256];
    static ap_uint<8> B_MATRIX[256][256];
    static uint32_t C_MATRIX[256][256];
    static ap_uint<1> trigger = 0;

    // Partition matrices for optimized access and timing
    // Use PARTITION instead of RESHAPE to avoid Read-Modify-Write timing penalties
    // A: Partition complete dim=2 (256 columns)
    #pragma HLS ARRAY_PARTITION variable=A_MATRIX complete dim=2
    #pragma HLS ARRAY_PARTITION variable=B_MATRIX complete dim=2
    #pragma HLS ARRAY_PARTITION variable=C_MATRIX complete dim=2
    
    static uint8_t trigger_counter = 0;
    static uint16_t write_counter = 0;
    static uint16_t write_counter_increase = 0;
        
    uint32_t addr_22 = user_logic_native_mem_address & 0x3FFFFF;
    uint8_t top_2_bits = (addr_22 >> 20) & 0x3;
    uint32_t addr_20 = addr_22 & 0xFFFFF;
    uint16_t addr_16 = addr_22 & 0xFFFF;
    
    //send these two counters to upper layer
    trigger_counter_out = trigger_counter;
    write_counter_out = write_counter_increase;

    // FSM State 0: RECEIVE DATA
    if (trigger == 0) {
        if (user_logic_native_mem_valid==1 && top_2_bits == 0x3) {
            #pragma HLS PIPELINE II=1
            uint8_t r = addr_16 / 256;
            uint8_t c_base = addr_16 % 256;
            
            if (addr_20 < 0x10000) {
                // Write to A_MATRIX
                    for (uint8_t k = 0; k < 32; k++) {
                        #pragma HLS UNROLL
                        if (user_logic_native_mem_strb[k]) {
                            A_MATRIX[r][c_base + k] = user_logic_native_mem_data(8*k+7, 8*k);
                        }
                    }
                    write_counter++;
                    write_counter_increase ++;
            } else if (addr_20 >= 0x10000 && addr_20 < 0x20000) {
                // Write to B_MATRIX
                    for (uint8_t k = 0; k < 32; k++) {
                        #pragma HLS UNROLL
                        if (user_logic_native_mem_strb[k]) {
                            B_MATRIX[r][c_base + k] = user_logic_native_mem_data(8*k+7, 8*k);
                        }
                    }

                    if(write_counter >= 4095) {
                        trigger = 1;
                        trigger_counter ++;
                        write_counter = 0;
                        write_counter_increase++;
                    } else {
                        write_counter++;
                        write_counter_increase++;
                    }
            } else if (addr_20 >= 0x20000 && addr_20 < 0x20020) {
                trigger = 1;
                trigger_counter ++;
            } 
        }
    }
    // FSM State 1: CALC AND OUTPUT
    else {
        LOOP_CALC:
        for(uint16_t i=0; i<256; i++) {
            for(uint16_t j=0; j<256; j++) {
                #pragma HLS PIPELINE II=1
                uint32_t sum = 0;
                for(uint16_t k=0; k<256; k++) {
                    #pragma HLS UNROLL 
                    sum += A_MATRIX[i][k] * B_MATRIX[j][k];
                }
                C_MATRIX[i][j] = sum;
            }
        }
        
        // ---------------------------------------------------------
        // Output Stage: Single Batch
        // Data (256*256*4 Bytes = 262144 Bytes)
        // ---------------------------------------------------------
        LOOP_OUTPUT_BEATS:
        for(uint16_t i=0; i<32768; i++) {
            #pragma HLS PIPELINE II=1
            ap_axiu<64, 0, 0, 0> out_val;
            out_val.data = 0;
            out_val.keep = 0xFF;
            out_val.last = (i == 32767) ? 1 : 0; // TLAST at end of the single batch

            uint8_t abs_row = i / 128;      // (i*8)/(256*4)
            uint8_t col_beat = i % 128;     
            uint8_t abs_col_start = col_beat * 2; // 2 elements per beat (64/32=2)
               
            out_val.data = (ap_uint<64>)C_MATRIX[abs_row][abs_col_start];
            out_val.data |= ((ap_uint<64>)C_MATRIX[abs_row][abs_col_start + 1]) << 32;
            o_axiu_user0_data.write(out_val);
        }

        //reset trigger
        trigger = 0;
    }
}