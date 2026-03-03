
#include "hls_math.h"
#include "ap_int.h"
#include "hls_stream.h"
#include "ap_fixed.h"
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "ap_axi_sdata.h"
 



void yusur_udp_filter(hls::stream<ap_uint<128> >& i_axiu_udp_param,             //五元组
                      hls::stream<ap_axiu<64, 0, 0, 0> >& i_axiu_stream_data,   //UDP data
                      hls::stream<ap_uint<80> >& o_axiu_key,                    //hash key 
                      hls::stream<ap_axiu<64, 0, 0, 0> >& o_axiu_stream_data);  //udp data after filter