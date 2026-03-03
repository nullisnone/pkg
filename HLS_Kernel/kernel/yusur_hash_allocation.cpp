#include "ap_axi_sdata.h"
#include "ap_int.h"
#include "hls_stream.h"
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <iomanip>


template <int CUR_KW, int CUR_HW>
void hashmurmur3(ap_uint<CUR_KW> key_strm,
                 ap_uint<CUR_HW> &hash_strm)
{

#ifdef __SYNTHESIS__
#pragma HLS PIPELINE II = 1
#endif
    const int nblocks = CUR_KW / CUR_HW;

    // keyBlen is the BYTE len of the key.
    const ap_uint<CUR_HW> keyBlen = CUR_KW / 8;
    const uint32_t c1 = 0xcc9e2d51;
    const uint32_t c2 = 0x1b873593;
    const uint32_t c3 = 0xe6546b64;
    const uint32_t c4 = 0x85ebca6b;
    const uint32_t c5 = 0xc2b2ae35;
    //----------
    // body

    // hash is the output/return value. use magic word(seed) to initial the output
    ap_uint<CUR_HW> hash = 42; // seed;

    ap_uint<32> kt;        // temp32
    ap_uint<CUR_KW> key_t; // temp512
    key_t = key_strm;
#ifdef ENABLE_MURMUR3_REDUCE
    int j = 0;
    kt = key_t(32 * j + 31, 32 * j);
    kt *= c1;
    kt = (kt << 15) | (kt >> (32 - 15)); // ROTL32(kt,15);//
    kt *= c2;
    hash_strm = kt;

#else
LOOP_MURMUR3_MAIN:
    for (int j = 0; j < nblocks; ++j)
    {
        kt = key_t(32 * j + 31, 32 * j);
        kt *= c1;
        kt = (kt << 15) | (kt >> (32 - 15)); // ROTL32(kt,15);//
        kt *= c2;

        hash ^= kt;
        hash = (hash << 13) | (hash >> (32 - 13)); // ROTL32(hash,13);//
        hash = hash * 5 + c3;
    }

    // finalization
    hash ^= keyBlen;
    hash ^= hash >> 16;
    hash *= c4;
    hash ^= hash >> 13;
    hash *= c5;
    hash ^= hash >> 16;

    // output hash stream width in 32bit.
    hash_strm = hash;
#endif
} // murmur3


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


    ap_uint<80> hash_key;
    ap_uint<32> out_hash;
    ap_uint<1> end_flag = 0;
    ap_axiu<64, 0, 0, 0> i_rdata;
    ap_axiu<64, 0, 0, 0> i_rdata_unused;

    // Use arrays (BRAM/LUTRAM) instead of huge registers
    ap_uint<64> batch_data[256];
    ap_uint<8>  keep_data[256];
    ap_uint<1>  last_data[256];
    int pkt_len = 0;

#pragma HLS DATAFLOW
    hash_key = i_axiu_key.read();
    hashmurmur3<80, 32>(hash_key, out_hash);
    
    // Store stage: Read i_axiu_user0_data into array
    LOOP_STORE:
    pkt_len = 0;
    do {
        i_axiu_stream_data.read_nb(i_rdata_unused); // Discard stream data
        i_rdata = i_axiu_user0_data.read();
        
        if (pkt_len < 256) {
            batch_data[pkt_len] = i_rdata.data;
            keep_data[pkt_len] = i_rdata.keep;
            last_data[pkt_len] = i_rdata.last;
            pkt_len++;
        }
    } while (!i_rdata.last);

    // Forward stage: Read array to output
    LOOP_FORWARD:
    for (int i = 0; i < pkt_len; ++i)
    {
        ap_axiu<64, 0, 0, 0> o_wdata;
        o_wdata.data = batch_data[i];
        o_wdata.keep = keep_data[i];
        o_wdata.last = last_data[i];
        o_axiu_user0_data.write(o_wdata);    
    }
}
