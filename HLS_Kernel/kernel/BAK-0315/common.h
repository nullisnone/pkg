#ifndef HCA_COMMON_H_
#define HCA_COMMON_H_

#ifndef __SYNTHESIS__
#include <iostream>
#endif

#include <stdint.h>
#include "ap_int.h"
#include "hls_stream.h"
#include "ap_axi_sdata.h"


#define GET_NUM_BIT(src, i, n) src(i* n + n - 1, i * n)

template <int IW, int OW>
void axi2Stream(uint64_t size, ap_uint<IW>* i_buf, hls::stream<ap_uint<OW> >& o_stream) {
    for (uint64_t i = 0; i < size; i++) {
#pragma HLS pipeline ii = 1

        o_stream.write(i_buf[i](OW-1, 0));
    }
}

template <int W>
void stream2Axi(uint64_t size, hls::stream<ap_uint<W> >& i_stream, ap_uint<W>* o_buf) {
    for (uint64_t i = 0; i < size; i++) {
#pragma HLS pipeline ii = 1
        o_buf[i] = i_stream.read();
    }
} 

template <int IW, int UW, int OW>
void stream2Axiu(uint64_t size, hls::stream<ap_axiu<IW, UW, 0, 0> >& i_stream, ap_uint<OW>* o_buf) {
    for (uint64_t i = 0; i < size; i++) {
#pragma HLS pipeline ii = 1 
        ap_axiu<IW, UW, 0, 0> rdata = i_stream.read();
        o_buf[i] = ((ap_uint<UW>)rdata.user, (ap_uint<IW>)rdata.data);
    }
} 

template <int W, int N>
void axi2MultiStream(ap_uint<N> channel_flag, uint64_t size, ap_uint<W>* i_buf, hls::stream<ap_uint<W>>  o_stream[N]) {
    for (uint64_t i = 0; i < size; i++) {
#pragma HLS pipeline ii = 1
        ap_uint<W> temp = i_buf[i];
        for (ap_uint<N> j = 0; j < N; j++){
        #pragma HLS unroll
            if(channel_flag[j]){ //send data to the one stream channel or more than one stream channel 
                o_stream[j].write(temp); 
            }
        }
    }
}

template <int W,int N>
void axi2MultiStream(uint64_t size, ap_uint<W>* i_buf, hls::stream<ap_uint<W> >  o_stream[N]) {
    for (uint64_t i = 0; i < size; i++) {
#pragma HLS pipeline ii = 1
        for (uint64_t j = 0; j < N; j++) 
        #pragma HLS unroll
            o_stream[j].write(i_buf[i]);
    }
}

/**
 * @brief data merge.The input data bit width must be an integer multiple of the output data bit width
 * @param size   input stream length
 * @param i_stream input stream data,bit width is "I_N_BIT"
 * @param o_stream output stream data,bit width is "O_M_BIT"  O_M_BIT = I_N_BIT*n(n is integer)
 */
template <int I_N_BIT, int O_M_BIT>
void streamNbitMergeMbit(ap_uint<64> size,
                         hls::stream<ap_uint<I_N_BIT> >& i_stream,
                         hls::stream<ap_uint<O_M_BIT> >& o_stream) {
    ap_uint<I_N_BIT> i_data = 0;
    ap_uint<O_M_BIT> o_data = 0;
    ap_uint<64> merge_cnt = (size + (O_M_BIT / I_N_BIT) - 1) / (O_M_BIT / I_N_BIT);
loop_streamNmergeM_1:
    for (uint64_t i = 0; i < merge_cnt; i++) {
    loop_streamNmergeM_2:
        for (uint64_t j = 0; j < (O_M_BIT / I_N_BIT); j++) {
#pragma HLS loop_flatten
#pragma HLS pipeline ii = 1
            if (size > j + (O_M_BIT / I_N_BIT) * i) {
                i_data = i_stream.read();
                o_data(j * I_N_BIT + I_N_BIT - 1, j * I_N_BIT) = i_data;
            } else {
                o_data(j * I_N_BIT + I_N_BIT - 1, j * I_N_BIT) = 0;
            }
        }
        o_stream.write(o_data);
    }
}

/**
 * @brief data Spilt.The bit width of the output data must be an integral multiple of the bit width of the input data.
 * @param size   output stream length.
 * @param i_stream input stream data,bit width is "I_N_BIT"
 * @param o_stream output stream data,bit width is "O_M_BIT"  I_N_BIT = O_M_BIT*n(n is integer)
 */
template <int I_N_BIT, int O_M_BIT>
void streamNbitSplitMbit(ap_uint<64> size,
                         hls::stream<ap_uint<I_N_BIT> >& i_stream,
                         hls::stream<ap_uint<O_M_BIT> >& o_stream) {
    ap_uint<64> merge_cnt = (size + (I_N_BIT / O_M_BIT) - 1) / (I_N_BIT / O_M_BIT);
loop_streamNtoM_1:
    for (uint64_t i = 0; i < merge_cnt; i++) {
        ap_uint<I_N_BIT> i_data = i_stream.read();
    loop_streamNtoM_2:
        for (uint64_t j = 0; j < I_N_BIT / O_M_BIT; j++) {
#pragma HLS loop_flatten
#pragma HLS pipeline ii = 1
            if (size > j + 64 * i) {
                ap_uint<O_M_BIT> o_data = i_data(j * O_M_BIT + O_M_BIT - 1, j * O_M_BIT);
                o_stream.write(o_data);
            }
        }
    }
}

template <int W>
ap_uint<7> compare(ap_uint<W> a, ap_uint<W> b) {
#pragma HLS inline
    ap_uint<7> res;
    if (a > b) {
        res = 0b0101101;
    } else if (a == b) {
        res = 0b1100011;
    } else {
        res = 0b1010101;
    }
    return res;
}

template <typename DT>
ap_uint<7> compare(DT i_compare, DT i_filter) {
#pragma HLS inline
    ap_uint<7> res;
    if (i_compare > i_filter) {
        res = 0b0101101;
    } else if (i_compare == i_filter) {
        res = 0b1100011;
    } else {
        res = 0b1010101;
    }
    return res;
}

template <int W>
ap_uint<W> reverseByteOrder(ap_uint<W> in, int n) {
    ap_uint<W> re = 0;
    for (int i = 0; i < (W / 8); i++) {
#pragma HLS unroll
        if (i < n)
            re(W - i * 8 - 1, W - i * 8 - 8) = in(i * 8 + 7, i * 8);
        else
            re(W - i * 8 - 1, W - i * 8 - 8) = 0x0;
    }
    return re;
}

#endif // HCA_COMMON_H_
